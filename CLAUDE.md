# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Public GitHub repository hosting Claude Code plugins.

## Plugin Architecture

See official docs:
- [Plugins](https://docs.claude.com/en/docs/claude-code/plugins.md) - Structure and creation
- [Slash Commands](https://docs.claude.com/en/docs/claude-code/slash-commands.md) - Command format and YAML frontmatter
- [Plugin Marketplaces](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces.md) - Distribution

**Key project-specific rules**:
- Command namespace: `/plugin:command` (colon separator, not hyphen)
- Three metadata files must stay in sync: `marketplace.json`, `{plugin}/.claude-plugin/plugin.json`, `CHANGELOG.md`

## Development Workflow

**See [docs/development.md](docs/development.md) for complete development guide.**

### Quick Reference

**Testing changes** (no build required):
```bash
/plugin uninstall stash
/plugin install stash
```
Restart may be needed if changes don't take effect.

**Adding a command**:
1. Create `stash/commands/{name}.md` with YAML frontmatter
2. Update `stash/README.md` and `CHANGELOG.md`
3. Test with uninstall/reinstall cycle

**Adding a plugin**:
1. Create `{plugin}/.claude-plugin/plugin.json` structure
2. Update `marketplace.json`, root `README.md`, and `CHANGELOG.md`
3. Include Apache 2.0 license in metadata

## Changelog and Releases

- Follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
- Update `[Unreleased]` section as you work
- On release: Update all three metadata files, commit as "Release v{version}", tag, and push with tags

## Documentation Standards

- Keep installation instructions in sync across READMEs
- Command syntax: `/plugin:command` (colon, not hyphen)
- GitHub shorthand: `jdillon/claude-code`

## Troubleshooting

**Changes not taking effect**: Try uninstall/reinstall cycle; restart if still not working

**Version mismatch**: Verify all three metadata files have matching version numbers

**Command syntax**: Use colon separator (`/plugin:command`), not hyphen
