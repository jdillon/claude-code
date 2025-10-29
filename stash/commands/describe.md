---
description: Show summary of a stash without fully resuming
---

Display a brief summary of what a stash contains without fully resuming from it.

**Argument**: $ARGUMENTS (stash name, filename, or path - required)

## Resolution Strategy

Same as `/stash-resume`:
1. **If full path**: Use directly
2. **If name**: Look for `stash-<name>.md` in `.claude/stashes/` or `~/.claude/stashes/`
3. **If no argument**: Show error - "Usage: /stash-describe <name>"

## Process

1. Locate and read the stash file
2. Extract and display:
   - Stash name and creation time
   - Summary section (first paragraph or Summary header)
   - Pending items (what was left to do)
   - File count (how many files mentioned, approximately)

## Output Format

```
📋 Stash: dns-work
📅 Created: 2025-10-29 03:45

Summary:
Working on DNS provider migration from GoDaddy to Route53.
Created deep-reload playbook for DNS stack.

Pending:
• Test deep-reload playbook
• Update documentation
• Commit and push changes

Files: ~5 files mentioned

💡 Resume with: /stash-resume dns-work
```

Keep it concise - 5-10 lines max. User can run `/stash-resume` for full details.
