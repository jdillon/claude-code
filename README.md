# Claude Code Plugins

A collection of plugins for [Claude Code](https://claude.com/claude-code).

## Available Plugins

### Stash

Git-style stash system for saving and resuming Claude Code sessions.

[View Documentation](stash/README.md)

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

If you're developing plugins and want to test changes:

1. Clone/fork the repository
2. Add the local marketplace:
   ```bash
   /plugin marketplace add /path/to/your/clone/marketplace.json
   ```
3. After making changes to plugin files, you'll need to:
   - Uninstall the plugin: `/plugin uninstall stash`
   - Reinstall: `/plugin install stash`
   - Restart Claude Code for changes to take effect

**Note**: The Claude Code plugin system does not support hot reloading. You must restart after installing, uninstalling, or updating plugins.

## Contributing

Contributions welcome! Please ensure:
- Commands follow the `/plugin:command` naming convention
- Documentation is updated with correct command syntax
- Test changes locally before submitting PRs

## License

Apache License 2.0 - see [LICENSE](LICENSE) file for details
