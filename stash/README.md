# Stash Plugin for Claude Code

Git-style stash system for saving and resuming Claude Code sessions.

## Overview

The Stash plugin provides a set of commands inspired by `git stash` for managing Claude Code session state. Save your current work, switch contexts, and resume later without losing progress.

## Commands

- `/stash:save [name]` - Save current session state
- `/stash:resume [name]` - Resume from a saved stash
- `/stash:list` - List available stashes
- `/stash:describe <name>` - Preview a stash without resuming
- `/stash:mark [label]` - Mark important points in session
- `/stash:quick` - Emergency minimal stash (low context)

## Usage

### Basic workflow

```bash
# Save your current work
/stash:save "working on DNS migration"

# Switch to something else
/stash:save "urgent bug fix"

# List your stashes
/stash:list

# Resume previous work
/stash:resume "working on DNS migration"
```

### When context is running low

```bash
# Quick save before /clear
/stash:quick

# Clear the session
/clear

# Resume from latest stash
/stash:resume
```

## Installation

### From GitHub

1. Add the marketplace to Claude Code:
   ```bash
   /plugin marketplace add jdillon/claude-code
   ```

2. Install the stash plugin:
   ```bash
   /plugin install stash
   ```

3. Restart Claude Code for the plugin to take effect

For more information about plugin marketplaces, see the [Claude Code Plugin Marketplaces documentation](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces).

### For Development

When developing or testing changes to the plugin:

```bash
# After making changes
/plugin uninstall stash
/plugin install stash
# Restart Claude Code
```

**Note**: The plugin system requires a restart to load new or updated plugins. There is no hot reload available.

## Documentation

See the `docs/` directory for:
- `stash-design.md` - Complete design document
- `long-session-management-ideas.md` - Future enhancements

## License

Apache License 2.0 - see [LICENSE](../LICENSE) file for details
