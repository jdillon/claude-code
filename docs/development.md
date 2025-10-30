# Development Guide

This guide covers how to develop, test, and contribute to Claude Code plugins in this repository.

## Setup

### Clone and Install Locally

1. Clone or fork the repository:
   ```bash
   git clone https://github.com/jdillon/claude-code.git
   cd claude-code
   ```

2. Add the local marketplace to Claude Code:
   ```bash
   /plugin marketplace add /path/to/your/clone/marketplace.json
   ```

3. Install the plugin:
   ```bash
   /plugin install stash
   ```

4. Restart Claude Code for the plugin to take effect

### Getting Plugin Updates

**For end users**:
- There is no `/plugin update` command currently
- To get newer versions: uninstall and reinstall the plugin
- Use `/plugin marketplace update` to refresh marketplace listings (shows new versions available)

## Plugin Architecture

### Directory Structure

```
claude-code/
├── marketplace.json              # Marketplace metadata
├── stash/                        # Plugin directory
│   ├── .claude-plugin/
│   │   └── plugin.json          # Plugin metadata
│   ├── commands/                # Slash commands (markdown files)
│   │   ├── save.md
│   │   ├── resume.md
│   │   └── ...
│   ├── docs/                    # Design and planning docs
│   └── README.md                # Plugin documentation
└── docs/                        # Repository-wide documentation
```

### How Commands Work

- Commands are markdown files in `{plugin}/commands/*.md`
- Each command file contains:
  - YAML frontmatter with `description` field
  - Prompt content that Claude executes when the command is run
- Commands use namespace syntax: `/stash:save`, `/stash:resume`
  - **Correct**: `/stash:save` (colon separator)
  - **Incorrect**: `/stash-save` (hyphen separator)

### Metadata Files

Three metadata files must stay in sync:

1. **`marketplace.json`** - Top-level marketplace definition
   ```json
   {
     "name": "jdillon-claude-code-plugins",
     "plugins": [
       {
         "name": "stash",
         "version": "1.0.0",
         ...
       }
     ]
   }
   ```

2. **`{plugin}/.claude-plugin/plugin.json`** - Plugin metadata
   ```json
   {
     "name": "stash",
     "version": "1.0.0",
     ...
   }
   ```

3. **`CHANGELOG.md`** - Version history and release notes

## Development Workflow

### Testing Changes

After making changes:

1. Uninstall the plugin:
   ```bash
   /plugin uninstall stash
   ```

2. Reinstall the plugin:
   ```bash
   /plugin install stash
   ```

3. Restart Claude Code if changes don't take effect

### Adding a New Command

1. Create `{plugin}/commands/{name}.md` with YAML frontmatter:
   ```markdown
   ---
   description: Brief description of what the command does
   ---

   Detailed prompt for Claude to execute...
   ```

2. Update `{plugin}/README.md` with command documentation

3. Add entry to `CHANGELOG.md` under `[Unreleased]` section

4. Test locally using the uninstall/reinstall cycle

### Adding a New Plugin

1. Create directory structure:
   ```
   {plugin}/
   ├── .claude-plugin/
   │   └── plugin.json
   ├── commands/
   │   └── *.md
   └── README.md
   ```

2. Add plugin entry to `marketplace.json` plugins array

3. Create plugin documentation in `{plugin}/README.md`

4. Update root `README.md` to list the new plugin

5. Add entry to `CHANGELOG.md`

6. Ensure Apache 2.0 license is specified in plugin metadata

## Release Process

Follow semantic versioning (MAJOR.MINOR.PATCH):
- **MAJOR** - Breaking changes (e.g., command renames, removed features)
- **MINOR** - New features (backwards compatible)
- **PATCH** - Bug fixes (backwards compatible)

### Steps to Release

1. Update `CHANGELOG.md`:
   - Move items from `[Unreleased]` to new version section
   - Add release date
   - Follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format

2. Update version numbers in **all three** metadata files:
   - `CHANGELOG.md`
   - `marketplace.json` (marketplace version and plugin version)
   - `{plugin}/.claude-plugin/plugin.json`

3. Commit changes:
   ```bash
   git add .
   git commit -m "Release v{version}"
   ```

4. Tag the release:
   ```bash
   git tag v{version}
   ```

5. Push to GitHub:
   ```bash
   git push origin main --tags
   ```

## Contributing

### Guidelines

- Commands must use namespace syntax: `/plugin:command`
- Keep documentation in sync across all README files
- Update CHANGELOG.md for all user-facing changes
- Test changes locally before submitting PRs
- Follow existing code and documentation style
- Include Apache 2.0 license in all plugin metadata

### Documentation Standards

- Reference official docs: https://docs.claude.com/en/docs/claude-code/plugin-marketplaces
- Use correct GitHub shorthand: `jdillon/claude-code`
- Keep installation instructions consistent across READMEs

## Troubleshooting

### Plugin Changes Not Taking Effect

**Solution**: Try the uninstall/reinstall cycle:
1. Uninstall: `/plugin uninstall stash`
2. Reinstall: `/plugin install stash`
3. If still not working, restart Claude Code

Also verify:
- Version numbers match across all metadata files
- YAML frontmatter syntax is correct in command files
- No syntax errors in JSON metadata files

### Command Not Found

Check:
- Command file exists in `{plugin}/commands/` directory
- Plugin is installed: `/plugin list`
- Using correct syntax: `/stash:save` not `/stash-save`

### Marketplace Not Loading

Verify:
- `marketplace.json` has valid JSON syntax
- File path in `/plugin marketplace add` command is correct
- Using either GitHub shorthand (`jdillon/claude-code`) or absolute path

## Plugin-Specific Notes

### Stash Plugin

**Storage Locations**:
- Project stashes: `.claude/stashes/` (when in a git repo)
- Global stashes: `~/.claude/stashes/` (fallback)
- Latest tracker: `.claude/stashes/.latest`
- Filename format: `stash-{name-or-timestamp}.md`

**Future Enhancements**:
See `stash/docs/stash-design.md` for planned features including stack-based indexing, named stashes, auto-pruning, and context window monitoring.

## Additional Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Plugin Marketplaces Guide](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)
- [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
- [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
