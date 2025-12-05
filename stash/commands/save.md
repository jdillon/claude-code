---
description: Save session stash for later resumption
---

Analyze the current session and create a concise stash document for resumption after `/clear`.

**Optional name**: $ARGUMENTS (if provided, save as `stash-<name>.md`, otherwise use timestamp)

## What to KEEP

- **Current task/goal** and progress summary
- **Key decisions** made and rationale
- **Pending work items** and next steps
- **Important file paths** and locations
- **Session marks** created with `/stash:mark`
- **Critical context** needed to resume work
- **Unresolved issues** or blockers
- **Environment state** (branch, working directory, etc.)

## What to EXCLUDE

- Tool output (diffs, file contents, command outputs)
- Verbose logs or stack traces
- Resolved/completed tasks (unless context for pending work)
- Exploratory dead-ends or abandoned approaches
- Repetitive information

## Save Location

**Project stashes**: If in a git repository, save to `.claude/stashes/stash-<name-or-timestamp>.md`

**Global stashes**: Otherwise save to `~/.claude/stashes/stash-<name-or-timestamp>.md`

Create stash directory if it doesn't exist. Create `.gitignore` file in stash directory if it doesn't exist with content: `*` (to prevent stash files from being committed).  Force add this new file, so it does not ignore itself.

## Process

1. Review any `/stash:mark` markers created during session
2. If marks exist, ask user which sections between marks are critical to preserve
3. Create concise stash document (aim for 500-1000 words)
4. Save to appropriate location
5. Update `.claude/stashes/.latest` file with the stash filename
6. Show confirmation with file path

**Format stash as**:
```markdown
# Stash: <name or timestamp>

**Created**: <ISO timestamp>
**Project**: <path or "global">
**Branch**: <if applicable>

## Summary
<1-2 sentence overview>

## Progress
<what's been done>

## Pending
<what's next>

## Context
<critical details needed to resume>

## Marks
<if any marks were created, list them here>
```
