---
description: Show beads dashboard with in-progress tasks and ready-to-work items
allowed-tools: mcp__plugin_beads_beads
---

Show a beads work dashboard with two sections:

## 1. In Progress

Use the beads MCP `list` tool with `status: "in_progress"` to get current work items.

Display as a table:
| Type | ID | Title | Priority |
|------|-----|-------|----------|

If empty, note "No tasks in progress."

## 2. Ready to Work

Use the beads MCP `ready` tool to get unblocked tasks.

Display as a table:
| Type | ID | Title | Priority |
|------|-----|-------|----------|

If empty, suggest checking `blocked` issues or creating new work.

## Output Format

Keep it concise. After showing both sections, ask which task the user wants to work on (if any ready tasks exist).
