---
description: Resume from a saved stash file
---

Resume work from a previously saved stash.

**Argument**: $ARGUMENTS (optional - stash name, filename, or path)

## Resolution Strategy

1. **If argument is a full path** (starts with `/` or `./` or `../`): Use it directly
2. **If argument is a name**: Look for `stash-<name>.md` in:
   - `.claude/stashes/` (project, if in git repo)
   - `~/.claude/stashes/` (global fallback)
3. **If no argument**: Read `.claude/stashes/.latest` to find most recent stash

## Process

1. Locate and read the stash file
2. Summarize the stash:
   - What we were working on
   - What was completed
   - What's pending
   - Critical context
3. Display summary in clear, organized format
4. Ask: "Ready to continue? Any updates or changes since this stash?"

## Error Handling

- If file not found, show available stashes (run `/stash:list` logic)
- If `.latest` doesn't exist and no arg given, show error and list available stashes
- Show helpful error messages with suggestions

## Output Format

```
📂 Resuming from: <stash-name>
📅 Created: <timestamp>
🎯 Project: <path>

## Summary
<brief overview>

## Completed
<bullet points>

## Pending
<bullet points>

## Context
<critical details>

---
Ready to continue? Any updates since this stash?
```
