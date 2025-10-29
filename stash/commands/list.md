---
description: List recent stashes for current project or globally
---

List available stashes to help find one to resume from.

## Display Strategy

1. **If in git repository**: Show project stashes from `.claude/stashes/`
2. **Also show global stashes** from `~/.claude/stashes/`
3. **Show most recent first** (sorted by timestamp)
4. **Limit to last 10** by default (configurable if needed)

## Output Format

```
📦 Project Stashes (.claude/stashes/):
  • stash-dns-work.md          2025-10-29 03:45  (latest)
  • stash-20251029-022314.md   2025-10-29 02:23
  • stash-terraform.md         2025-10-28 18:30

🌍 Global Stashes (~/.claude/stashes/):
  • stash-quick-20251027.md    2025-10-27 14:22

💡 Resume with: /stash-resume <name>
   Examples: /stash-resume dns-work
             /stash-resume
             /stash-resume ~/.claude/stashes/stash-quick-20251027.md
```

## Implementation

Use bash to:
1. Check if `.claude/stashes/` exists
2. List files matching `stash-*.md`
3. Sort by modification time (newest first)
4. Format with timestamps
5. Indicate which is latest (from `.latest` file if exists)

## Bash Command

```bash
! if [ -d .claude/stashes ]; then
    echo "📦 Project Stashes (.claude/stashes/):"
    ls -t .claude/stashes/stash-*.md 2>/dev/null | head -10 | while read f; do
      echo "  • $(basename "$f")  $(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$f")"
    done
  fi
  if [ -d ~/.claude/stashes ]; then
    echo ""
    echo "🌍 Global Stashes (~/.claude/stashes/):"
    ls -t ~/.claude/stashes/stash-*.md 2>/dev/null | head -10 | while read f; do
      echo "  • $(basename "$f")  $(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$f")"
    done
  fi
  echo ""
  echo "💡 Resume with: /stash-resume <name>"
```

If no stashes found, show helpful message: "No stashes found. Create one with /stash-save"
