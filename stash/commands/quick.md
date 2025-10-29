---
description: Emergency minimal stash (low context usage)
---

⚠️ **Context window critically low** - Create minimal stash for resumption.

**Maximum 300 words. Be extremely concise.**

## Include ONLY

1. Current task (one sentence)
2. What's done vs pending (bullet points)
3. Critical file paths (if any)
4. Immediate next steps (2-3 items max)
5. Any blockers

## Save Location

**Project**: `.claude/stashes/stash-quick-<timestamp>.md`
**Global**: `~/.claude/stashes/stash-quick-<timestamp>.md`

Create directory if needed, update `.latest` file, show confirmation.

**Format**:
```markdown
# Quick Stash

**Created**: <timestamp>
**Task**: <one sentence>

**Done**: <bullets>
**Pending**: <bullets>
**Next**: <bullets>
**Files**: <if any>
**Blockers**: <if any>
```

Do NOT ask questions, do NOT be verbose. Just save and confirm.
