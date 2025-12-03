# Global project settings

These are project-wide settings that apply to all agents unless overridden by specific agent configurations.

## Coding conventions

When planning changes or applying changes, all changes and plans should be created considering how to do things in a step-wise fashion where each change is discrete and atomic.
Commits should be easily undoable and should be ensured that they will build on their own unless it is generally accepted that a series of commits will be needed to achieve a goal.

## Agent Delegation Rules

1. **Commit Operations**:
   - IF the user asks to "commit", "save changes", or "push", you MUST NOT do this yourself.
   - INSTEAD, strictly call the `@commit` sub-agent.
   - REASON: The `@commit` agent is faster and follows strict formatting rules that you do not need to worry about.
