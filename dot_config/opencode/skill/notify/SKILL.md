---
name: notify
description: Use when a long-running task completes, a session finishes, or a critical milestone is reached and the user should be informed via a system notification. Examples: "Task agent finished", "All requested work is done", "Build completed"
---

# Notify Skill

Use the `notify` tool to send the user a system notification via Apprise.

## When to notify

1. **Long-running tasks complete** — after a Task tool invocation finishes, especially those taking more than a few minutes
2. **Sessions finish** — when all requested work in a conversation is complete
3. **Critical milestones** — when significant phases of multi-step operations are reached

Do **not** notify for trivial or quick operations.

## How to invoke

```
notify({ title: "Task Complete", body: "Optional description of what finished" })
```

- `title` (required) — short, clear description of what completed
- `body` (optional) — relevant context such as task name, outcome, or duration

## Guidelines

- Send notifications **after** the work is done, not before
- Keep titles concise (e.g. "Build Complete", "Agent Finished", "Tests Passed")
- Include context in the body when it adds value (e.g. which repo, how many errors fixed)
- Do not spam — one notification per logical unit of work is sufficient
