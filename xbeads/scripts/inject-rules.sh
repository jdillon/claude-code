#!/bin/bash
# Inject beads behavioral rules into Claude Code context
# Only runs if .beads/ directory exists in current project

[ -d .beads ] || exit 0

cat "${CLAUDE_PLUGIN_ROOT}/scripts/rules.md"
