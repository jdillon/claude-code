# Git Stash-Inspired Stash Management

**Author**: Claude
**Date**: 2025-10-29
**Status**: Proposal for review

---

## Motivation

The current stash system provides basic save/resume functionality, but managing multiple stashes across different contexts can become cumbersome. Git's stash system offers an elegant model for managing multiple work-in-progress states that we can adapt for context window and memory management.

---

## Core Concepts from Git Stash

### What Makes Git Stash Powerful

1. **Automatic naming with descriptions** - `git stash save "WIP: fixing auth bug"`
2. **Stack-based management** - Most recent stash is `stash@{0}`, older ones increment
3. **List with context** - `git stash list` shows all stashes with descriptions
4. **Apply vs Pop** - Apply keeps the stash, pop removes it after applying
5. **Selective application** - Can apply specific stashes by index
6. **Branch from stash** - Create a new branch from stashed state
7. **Partial stashing** - Can stash only certain files or hunks

### How This Maps to Stashes

| Git Stash Concept | Stash Equivalent | Benefit |
|-------------------|----------------------|---------|
| Stash stack | Stash stack with indices | Quick access to recent states |
| `stash@{0}` | `stash@{0}` (latest) | No need to remember names/timestamps |
| `stash save "msg"` | `/stash-save "msg"` | Descriptive without full filename |
| `stash list` | `/stash-list` (enhanced) | See descriptions, not just files |
| `stash apply` | `/stash-resume --keep` | Resume without deleting stash |
| `stash pop` | `/stash-resume --pop` | Resume and clean up old stash |
| `stash drop` | `/stash-drop` | Delete unwanted stashes |
| `stash clear` | `/stash-clear` | Clean up all old stashes |

---

## Proposed Enhanced Design

### 1. Stack-Based Indexing

Instead of requiring filenames, use a stack:

```bash
# Save creates stash@{0}
/stash-save "working on DNS migration"

# Save again, previous becomes @{1}
/stash-save "added terraform module"

# List shows stack
/stash-list
  stash@{0}: added terraform module (5 minutes ago)
  stash@{1}: working on DNS migration (2 hours ago)
  stash@{2}: kubernetes deployment fixes (yesterday)

# Resume by index
/stash-resume 0      # Latest
/stash-resume 1      # DNS migration
/stash-resume        # Defaults to @{0}
```

### 2. Metadata File for Stack Management

**Location**: `.claude/stashes/.stack` (JSON)

```json
{
  "stashes": [
    {
      "index": 0,
      "file": "stash-20251029-034500.md",
      "message": "added terraform module",
      "timestamp": "2025-10-29T03:45:00Z",
      "project": "/Users/jason/ws/void/admin",
      "branch": "main",
      "wordCount": 847
    },
    {
      "index": 1,
      "file": "stash-20251029-014523.md",
      "message": "working on DNS migration",
      "timestamp": "2025-10-29T01:45:23Z",
      "project": "/Users/jason/ws/void/admin",
      "branch": "main",
      "wordCount": 1024
    }
  ],
  "maxStackSize": 20
}
```

### 3. Enhanced Commands

#### `/stash-save [message]`
- Creates stash with descriptive message (not filename)
- Auto-generates filename with timestamp
- Adds to top of stack (becomes @{0})
- Previous stashes increment indices
- Optional: Auto-prune if stack exceeds `maxStackSize`

#### `/stash-list [--all]`
```bash
# Default: Show last 10
/stash-list

# Show all stashes
/stash-list --all

# Output format:
stash@{0}: added terraform module (5 min ago) [847 words]
stash@{1}: working on DNS migration (2 hrs ago) [1024 words]
stash@{2}: kubernetes deployment fixes (1 day ago) [623 words]
```

#### `/stash-resume [index|name] [--keep|--pop]`
- `index`: Resume by stack index (0, 1, 2...)
- `name`: Resume by searching message/filename
- `--keep`: Resume but keep stash (default)
- `--pop`: Resume and delete stash from stack

#### `/stash-drop [index|name]`
Delete specific stash without resuming

#### `/stash-clear [--older-than=7d]`
Clean up old stashes
- `--older-than=7d`: Keep only last 7 days
- `--keep=10`: Keep only last 10 stashes
- Interactive confirmation before deletion

#### `/stash-diff [index1] [index2]`
Show what changed between two stashes (experimental)

### 4. Named Stashes (Branches)

Like git branches, allow naming important stashes:

```bash
# Create named stash (doesn't go on stack)
/stash-save --name dns-migration "working on DNS"

# List shows both stack and named
/stash-list
  Stack:
    stash@{0}: added terraform (5 min ago)
    stash@{1}: fixed ansible (2 hrs ago)

  Named:
    dns-migration: working on DNS (2 hrs ago)
    k8s-upgrade: kubernetes deployment (yesterday)

# Resume named stash
/stash-resume dns-migration
```

Named stashes don't participate in stack rotation - they persist until explicitly deleted.

---

## Context Window Management Strategy

### Problem: Context Windows Fill Up

As conversations grow, we hit token limits. Stashes help, but we can be smarter about what to keep.

### Tiered Stash Strategy

**Tier 1: Quick Marks** (in-memory, minimal)
- Created with `/stash-mark`
- Just timestamps + labels
- Used to segment work within a session
- Cleared after stash save or /clear

**Tier 2: Session Stashes** (stack, detailed)
- Created with `/stash-save`
- Stack-based, auto-rotated
- 500-1000 words
- Kept for recent work (last 20)

**Tier 3: Named Stashes** (persistent, curated)
- Created with `/stash-save --name`
- Important states worth preserving
- No auto-deletion
- Think: git branches

**Tier 4: Archived Stashes** (compressed, searchable)
- Older than 30 days
- Compressed/summarized
- Searchable by keyword
- Think: git reflog

### Auto-Stash on Context Pressure

**Trigger**: When context window reaches 80% capacity
**Action**: Automatically suggest `/stash-quick` to user

```
⚠️ Context window at 80% (160k/200k tokens)
💡 Consider running /stash-quick to save state before /clear
```

### Smart Resume with Context Budget

When resuming, be intelligent about what to load:

```bash
# Resume with full context
/stash-resume 0

# Resume with summary only (saves tokens)
/stash-resume 0 --summary

# Resume with specific sections
/stash-resume 0 --sections=pending,context
```

---

## Implementation Phases

### Phase 1: Stack Management (Foundation)
- [ ] Implement `.stack` metadata file
- [ ] Modify `/stash-save` to use stack
- [ ] Update `/stash-list` to show stack view
- [ ] Update `/stash-resume` to accept indices
- [ ] Add `/stash-drop` command

**Effort**: Medium (1-2 sessions)
**Value**: High - Immediately improves UX

### Phase 2: Enhanced List & Describe
- [ ] Add word counts to metadata
- [ ] Show relative timestamps ("5 min ago")
- [ ] Improve `/stash-describe` to use metadata
- [ ] Add search/filter to `/stash-list`

**Effort**: Low (1 session)
**Value**: Medium - Quality of life

### Phase 3: Named Stashes
- [ ] Add `--name` flag to `/stash-save`
- [ ] Track named stashes separately in `.stack`
- [ ] Update list/resume to handle names
- [ ] Add `/stash-rename` command

**Effort**: Medium (1-2 sessions)
**Value**: High - Enables branch-like workflow

### Phase 4: Auto-management
- [ ] Implement stack size limits with auto-prune
- [ ] Add `/stash-clear` with age filters
- [ ] Context window monitoring and suggestions
- [ ] Auto-stash on context pressure

**Effort**: Medium (1-2 sessions)
**Value**: High - Reduces manual management

### Phase 5: Advanced Features (Future)
- [ ] `/stash-diff` between two stashes
- [ ] Archive old stashes (compression)
- [ ] Stash search by keyword
- [ ] Resume with section selection
- [ ] Stash export/import for sharing

**Effort**: High (3-4 sessions)
**Value**: Medium - Nice to have, not critical

---

## Example Workflow

### Scenario: Working on Multiple Features

```bash
# Start working on DNS migration
/stash-mark "starting DNS work"
# ... do work ...
/stash-save "DNS migration - added playbooks"

# Switch to urgent bug fix
/stash-save "WIP: DNS migration incomplete"
# ... fix bug ...
/stash-save "fixed auth bug in FreeIPA"

# Context getting full, need to clear
/stash-list
  stash@{0}: fixed auth bug (10 min ago)
  stash@{1}: WIP: DNS migration incomplete (1 hr ago)
  stash@{2}: DNS migration - added playbooks (2 hrs ago)

# Clear and resume DNS work
/clear
/stash-resume 1    # Resume "WIP: DNS migration"

# Later, want to review what we did on auth bug
/stash-describe 0

# Done with DNS work, save as named stash
/stash-save --name dns-complete "DNS migration finished"

# Clean up old stack stashes
/stash-clear --keep=5
```

---

## Questions for Review

1. **Stack size**: Is 20 a good default max? Configurable?
2. **Auto-prune**: Should we auto-delete old stashes or always ask?
3. **Named vs Stack**: Should named stashes be completely separate or part of same system?
4. **Context monitoring**: Should Claude auto-suggest stashes at 80% context, or wait for user?
5. **Diff functionality**: Is comparing stashes useful or too complex?
6. **Archive strategy**: Should old stashes be compressed/summarized, or just deleted?

---

## Compatibility with Current System

### Migration Path

All existing stash commands remain compatible:

- `/stash-save mywork` → Creates stash with message "mywork"
- `/stash-resume mywork` → Searches for "mywork" in messages/filenames
- Current `.latest` file still works for `/stash-resume` with no args

New stack system is additive - old stashes continue to work, just don't have stack indices until `.stack` file is created.

---

## Alternative: Simpler Approach

If full stack system feels too complex, a lighter version:

**Keep it simple**:
- Just add descriptions to stash saves
- Track last 10 in a simple `.recent` file
- Allow resume by partial name match
- Skip indices, named stashes, diffing

**Trade-offs**:
- Less powerful than stack approach
- Still improves UX over current system
- Easier to implement and maintain
- Good middle ground

---

## Recommendation

**Start with Phase 1 (Stack Management)** and see how it feels in practice. The stack-based approach solves the immediate pain point of managing multiple stashes without requiring filenames.

**Then evaluate** whether named stashes (Phase 3) and auto-management (Phase 4) add enough value to justify the complexity.

**Hold off** on Phase 5 (advanced features) until we have real-world usage patterns to guide design.

---

## Notes

- This design heavily borrows from git stash/reflog UX patterns
- Focuses on reducing friction: less typing, less remembering filenames
- Stack metaphor is familiar to developers
- Metadata file enables rich features without parsing stash content
- Backwards compatible with current stash system

---

**Ready for feedback!** Let me know what resonates, what feels over-engineered, and what's missing.

Sweet dreams! 😴
