import type { Plugin } from "@opencode-ai/plugin";
import { tool } from "@opencode-ai/plugin/tool";

const MIN_BUSY_MS = 8_000;

export default (async (ctx) => {
  const busySince = new Map<string, number>();

  const send = async (title: string, body?: string) => {
    const args = ["-t", title];
    if (body) args.push("-b", body);
    try {
      await ctx.$`apprise ${args}`.quiet();
    } catch {
      // swallow — never let notification failure break opencode
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
          await send(title, body);
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
          await send("opencode retrying", status.message);
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
        await send("opencode ready", `Finished after ${seconds}s — your turn.`);
        return;
      }

      if (event.type === "session.error") {
        await send("opencode error", "A session error occurred — check the TUI.");
        return;
      }
    },

    "permission.ask": async (input, _output) => {
      await send("opencode needs approval", input.title || input.type);
    },
  };
}) satisfies Plugin;
