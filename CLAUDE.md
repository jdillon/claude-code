# Claude Notes

Private notes for Claude Code to help maintain this project.

## Project Overview

This is a public GitHub repository hosting Claude Code plugins. The primary plugin is **stash**, which provides git-stash-inspired session state management.

## Changelog Maintenance

When making changes to this project, update `CHANGELOG.md` following these guidelines:

### Format
- Follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format
- Use [Semantic Versioning](https://semver.org/spec/v2.0.0.html)

### Categories
- **Added** - New features
- **Changed** - Changes in existing functionality
- **Deprecated** - Soon-to-be removed features
- **Removed** - Removed features
- **Fixed** - Bug fixes
- **Security** - Security fixes

### Version Numbers
- **MAJOR** - Breaking changes (e.g., command renames, removed features)
- **MINOR** - New features (backwards compatible)
- **PATCH** - Bug fixes (backwards compatible)

### When to Update
1. Add entries to `[Unreleased]` section as you work
2. When ready to release, move `[Unreleased]` items to a new version section
3. Update version in:
   - `CHANGELOG.md`
   - `marketplace.json` (marketplace version and plugin version)
   - `stash/.claude-plugin/plugin.json`

### Release Process
1. Update CHANGELOG.md with new version and date
2. Update version numbers in metadata files
3. Commit changes with message: "Release v{version}"
4. Tag the release: `git tag v{version}`
5. Push: `git push origin main --tags`

## Plugin Structure

```
claude-code/
├── marketplace.json          # Marketplace metadata
├── stash/                    # Stash plugin
│   ├── .claude-plugin/
│   │   └── plugin.json      # Plugin metadata
│   ├── commands/            # Slash commands (markdown)
│   ├── docs/                # Design docs
│   └── README.md            # Plugin documentation
├── CHANGELOG.md             # Public changelog
├── CLAUDE.md                # This file (private notes)
├── README.md                # Top-level documentation
└── LICENSE                  # Apache 2.0
```

## Command Syntax

**Important:** Commands use plugin namespace syntax:
- Correct: `/stash:save`, `/stash:resume`
- Incorrect: `/stash-save`, `/stash-resume`

When updating docs, ensure consistency with the `:` separator.

## License

All code is Apache License 2.0. Ensure new plugins include license in metadata.

## Testing Changes

After modifying plugin files:
```bash
/plugin uninstall stash
/plugin install stash
# Restart Claude Code
```

No hot reload - always restart after plugin changes.

## Common Tasks

### Adding a New Command
1. Create `stash/commands/{name}.md`
2. Update `stash/README.md` with command documentation
3. Update `CHANGELOG.md` under `[Unreleased]`
4. Test locally before committing

### Adding a New Plugin
1. Create new directory with `.claude-plugin/plugin.json`
2. Add to `marketplace.json` plugins array
3. Create plugin README.md
4. Update top-level README.md
5. Update CHANGELOG.md
6. Ensure license is in metadata

### Documentation Standards
- Keep installation instructions in sync across READMEs
- Reference official docs: https://docs.claude.com/en/docs/claude-code/plugin-marketplaces
- Use correct GitHub shorthand: `jdillon/claude-code`
- Include restart reminders (no hot reload)

## Stash Storage Locations

- Project: `.claude/stashes/`
- Global: `~/.claude/stashes/`
- Latest tracker: `.claude/stashes/.latest`

Files named: `stash-{name-or-timestamp}.md`

## Future Enhancements

See `stash/docs/stash-design.md` for planned features:
- Stack-based indexing (stash@{0}, stash@{1}, etc.)
- Named stashes (branch-like workflow)
- Auto-pruning old stashes
- Stash diff functionality
- Context window monitoring

Track implementation in CHANGELOG.md as features are added.
