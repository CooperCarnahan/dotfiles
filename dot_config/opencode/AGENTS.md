# Global project settings

These are project-wide settings that apply to all agents unless overridden by specific agent configurations.

## Coding conventions

When planning changes or applying changes, all changes and plans should be created considering how to do things in a step-wise fashion where each change is discrete and atomic.
Commits should be easily undoable and should be ensured that they will build on their own unless it is generally accepted that a series of commits will be needed to achieve a goal.
Do not create a commit until I have had a chance to test the changes myself, but the question immediately following any completed change should be whether I would like for you to create a commit for the change using the commit conventions below.

## Git conventions

When creating git commits, follow these steps:

    Run git status to review changed files.
    Run git diff or git diff --cached to inspect changes.
    Stage your changes with git add <file>.
    Construct your commit message using the following XML structure.
    After generating your commit message, Copilot will automatically run the following command in your integrated terminal (no confirmation needed):

git commit -m "type(scope): description"

    Just execute this prompt and Copilot will handle the commit for you in the terminal.

Commit Message Structure

<commit-message>
 <type>feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert</type>
 <scope>()</scope>
 <description>A short, imperative summary of the change</description>
 <body>(optional: more detailed explanation)</body>
 <footer>(optional: e.g. BREAKING CHANGE: details, or issue references)</footer>
</commit-message>

Examples

<examples>
 <example>feat(parser): add ability to parse arrays</example>
 <example>fix(ui): correct button alignment</example>
 <example>docs: update README with usage instructions</example>
 <example>refactor: improve performance of data processing</example>
 <example>chore: update dependencies</example>
 <example>feat!: send email on registration (BREAKING CHANGE: email service required)</example>
</examples>

Validation

<validation>
 <type>Must be one of the allowed types. See <reference>https://www.conventionalcommits.org/en/v1.0.0/#specification</reference></type>
 <scope>Optional, but recommended for clarity.</scope>
 <description>Required. Use the imperative mood (e.g., "add", not "added").</description>
 <body>Optional. Use for additional context.</body>
 <footer>Use for breaking changes or issue references.</footer>
</validation>

Final Step

<final-step>
 <cmd>git commit -m "type(scope): description"</cmd>
 <note>Replace with your constructed message. Include body and footer if needed.</note>
</final-step>
