---
description: Create a stash marker with timestamp and optional label
---

Create a stash marker for the current point in the session.

**Label**: $ARGUMENTS

The marker should include:
- Timestamp
- Optional label/description from arguments
- Brief context of what we're working on (1-2 sentences)

Store markers in memory to reference later during `/stash:save`. Markers help identify important sections of work to preserve when creating stashes.

If no label provided, use a generic marker like "Mark at <time>".

Show confirmation: "✓ Marked: [label] at [time]"
