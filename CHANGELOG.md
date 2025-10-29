# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-10-29

### Added
- Initial release of stash plugin for Claude Code
- Six commands for session state management:
  - `/stash:save` - Save current session state
  - `/stash:resume` - Resume from saved stash
  - `/stash:list` - List available stashes
  - `/stash:describe` - Preview stash without resuming
  - `/stash:mark` - Mark important session points
  - `/stash:quick` - Emergency minimal stash
- Project and global stash storage locations
- Automatic latest stash tracking
- Apache License 2.0
- GitHub marketplace support via `jdillon/claude-code`
- Comprehensive documentation and design docs

### Changed
- N/A (initial release)

### Deprecated
- N/A

### Removed
- N/A

### Fixed
- N/A

### Security
- N/A

---

## Release Notes

### v1.0.0 - Initial Public Release

The stash plugin provides a git-stash-inspired workflow for managing Claude Code session state. Perfect for:
- Saving work before context window fills up
- Switching between different tasks
- Resuming work after `/clear` without losing context
- Marking important session milestones

**Installation:**
```bash
/plugin marketplace add jdillon/claude-code
/plugin install stash
```

See [README.md](README.md) for full documentation.
