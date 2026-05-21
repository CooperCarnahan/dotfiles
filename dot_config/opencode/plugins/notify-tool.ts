import type { Plugin } from "@opencode-ai/plugin";
import { tool } from "@opencode-ai/plugin/tool";
import { readFileSync } from "node:fs";
import { homedir, platform } from "node:os";
import { join } from "node:path";

const MIN_BUSY_MS = 20_000;
const LONG_BUSY_MS = 5 * 60_000;
const PERM_WAIT_MS = 2 * 60_000;
const RETRY_COOLDOWN_MS = 5 * 60_000;
const PHONE_FLOOR_MS = 30_000;
const LOCK_CACHE_MS = 3_000;

const IS_LINUX = platform() === "linux";
const SESSION_DIR = join(homedir(), ".local/share/opencode/storage/session/global");
const DESK_ICON = join(homedir(), ".local/share/icons/notifications/opencode.png");

type Channels = { desk: boolean; phone: boolean };

export default (async (ctx) => {
  const busySince = new Map<string, number>();
  const lastPhonePush = new Map<string, number>();

  let lockCache: { locked: boolean; at: number } | null = null;

  const isLocked = async (): Promise<boolean> => {
    if (!IS_LINUX) return false;
    const now = Date.now();
    if (lockCache && now - lockCache.at < LOCK_CACHE_MS) return lockCache.locked;
    let locked = false;
    try {
      const out = await ctx.$`loginctl show-session ${process.env.XDG_SESSION_ID ?? ""} -p LockedHint`.text();
      locked = /LockedHint=yes/i.test(out);
    } catch {
      locked = false;
    }
    lockCache = { locked, at: now };
    return locked;
  };

  const sessionTitle = (sessionID: string): string => {
    try {
      const raw = readFileSync(join(SESSION_DIR, `${sessionID}.json`), "utf8");
      const parsed = JSON.parse(raw);
      if (typeof parsed?.title === "string" && parsed.title.trim()) return parsed.title.trim();
    } catch {
      // fall through to short id
    }
    return sessionID.slice(-6);
  };

  const withSession = (body: string | undefined, sessionID: string): string => {
    const tag = sessionTitle(sessionID);
    return body ? `[${tag}] ${body}` : `[${tag}]`;
  };

  const sendDesk = async (title: string, body: string | undefined) => {
    try {
      if (IS_LINUX) {
        const args = ["-a", "opencode", "-i", DESK_ICON, title];
        if (body) args.push(body);
        await ctx.$`notify-send ${args}`.quiet();
      } else {
        const args = ["--tag", "desk", "-t", title];
        if (body) args.push("-b", body);
        await ctx.$`apprise ${args}`.quiet();
      }
    } catch {
      // swallow — never let notification failure break opencode
    }
  };

  const sendPhone = async (title: string, body: string | undefined): Promise<boolean> => {
    const args = ["--tag", "phone", "-t", title];
    if (body) args.push("-b", body);
    try {
      await ctx.$`apprise ${args}`.quiet();
      return true;
    } catch {
      return false;
    }
  };

  const send = async (title: string, body: string | undefined, channels: Channels, sessionID?: string) => {
    if (!channels.desk && !channels.phone) return;

    if (channels.phone && sessionID) {
      const last = lastPhonePush.get(sessionID) ?? 0;
      if (Date.now() - last < PHONE_FLOOR_MS) channels.phone = false;
    }

    if (channels.desk) await sendDesk(title, body);

    if (channels.phone) {
      const ok = await sendPhone(title, body);
      if (ok && sessionID) lastPhonePush.set(sessionID, Date.now());
    }
  };

  return {
    tool: {
      notify: tool({
        description:
          "Send a notification using Apprise. Use this to notify the user when long-running tasks complete, sessions finish, or important milestones are reached.",
        args: {
          title: tool.schema.string().describe("The notification title (required)"),
          body: tool.schema.string().optional().describe("The notification message body (optional)"),
        },
        async execute({ title, body }) {
          await send(title, body, { desk: true, phone: true });
          return `Notification sent: "${title}"`;
        },
      }),
    },

    event: async ({ event }) => {
      if (event.type === "session.status") {
        const { sessionID, status } = event.properties;
        if (status.type === "busy") {
          if (!busySince.has(sessionID)) busySince.set(sessionID, Date.now());
        } else if (status.type === "retry") {
          const locked = await isLocked();
          const last = lastPhonePush.get(sessionID) ?? 0;
          const phone = locked && Date.now() - last >= RETRY_COOLDOWN_MS;
          await send("opencode retrying", withSession(status.message, sessionID), { desk: true, phone }, sessionID);
        }
        return;
      }

      if (event.type === "session.idle") {
        const { sessionID } = event.properties;
        const started = busySince.get(sessionID);
        busySince.delete(sessionID);
        if (started === undefined) return;
        const elapsed = Date.now() - started;
        if (elapsed < MIN_BUSY_MS) return;
        const seconds = Math.round(elapsed / 1000);
        const long = elapsed >= LONG_BUSY_MS;
        const phone = long || (await isLocked());
        await send(
          "opencode ready",
          withSession(`Finished after ${seconds}s — your turn.`, sessionID),
          { desk: true, phone },
          sessionID,
        );
        return;
      }

      if (event.type === "session.error") {
        const sessionID = event.properties.sessionID;
        const body = "A session error occurred — check the TUI.";
        await send(
          "opencode error",
          sessionID ? withSession(body, sessionID) : body,
          { desk: true, phone: true },
          sessionID,
        );
        return;
      }
    },

    "permission.ask": async (input, _output) => {
      const sessionID = input.sessionID;
      const started = sessionID ? busySince.get(sessionID) : undefined;
      const busyFor = started ? Date.now() - started : 0;
      const phone = (await isLocked()) || busyFor >= PERM_WAIT_MS;
      const body = sessionID ? withSession(input.title || input.type, sessionID) : input.title || input.type;
      await send("opencode needs approval", body, { desk: true, phone }, sessionID);
    },
  };
}) satisfies Plugin;
