# Testing Research: Claude Code Plugins

Research findings on how other Claude Code plugin marketplaces handle testing.

## Research Date

2025-10-29

## Marketplaces Reviewed

1. **anthropics/claude-code** (Official Anthropic marketplace)
   - URL: https://github.com/anthropics/claude-code
   - Plugins: 8 official plugins (agent-sdk-dev, code-review, commit-commands, etc.)

2. **kivilaid/plugin-marketplace** (Popular community marketplace)
   - URL: https://github.com/kivilaid/plugin-marketplace
   - Plugins: 100+ community plugins

3. **jeremylongshore/claude-code-plugins-plus**
   - URL: https://github.com/jeremylongshore/claude-code-plugins-plus
   - Plugins: 227+ plugins

## Key Findings

### Testing Approaches

#### 1. No Automated Tests (Most Common)

**Official Anthropic Marketplace:**
- ❌ No test suite found
- ❌ No CI/CD configuration
- ❌ No test scripts or frameworks
- ✅ Well-documented plugins with examples
- ✅ Comprehensive README files

**Finding:** Even the official marketplace doesn't have automated tests for plugins. Focus is on documentation and manual validation.

#### 2. Basic Shell Script Testing (Rare)

**Example: davila7-claude-code-templates CLI**
- ✅ Has `test-commands.sh` script
- Tests CLI tool functionality, not slash commands
- Approach:
  - Create temp directory
  - Run CLI commands
  - Verify files created
  - Check JSON structure with `jq`
  - Clean up

**Code pattern:**
```bash
#!/bin/bash
set -e

TEST_DIR="/tmp/claude-test-$(date +%s)"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Test file creation
if [ -f "expected-file.md" ]; then
    echo "✅ Test passed"
else
    echo "❌ Test failed"
fi

rm -rf "$TEST_DIR"
```

#### 3. Validation Scripts (Common)

**Example: kubernetes-operations plugin**
- Has `validate-chart.sh` for Helm chart validation
- Purpose: Validate generated artifacts, not test commands
- Pattern: Post-generation validation rather than test automation

### Testing Constraints

**Why plugins aren't heavily tested:**

1. **Slash commands require interactive sessions**
   - Can't run in headless mode
   - No programmatic API for slash command execution

2. **Commands depend on conversation context**
   - Need actual Claude conversation state
   - Hard to mock or simulate

3. **Commands are prompts, not code**
   - Markdown files with instructions for Claude
   - Behavior depends on Claude's interpretation
   - Non-deterministic by nature

4. **Focus on documentation over testing**
   - Plugins emphasize clear usage examples
   - READMEs serve as specifications
   - Manual validation during development

## Recommendations for Stash Plugin

Based on this research, our testing approach should be:

### ✅ What We Should Do

1. **File-based assertions**
   - Test that stash files are created
   - Verify file structure and required sections
   - Check `.latest` file updates
   - Validate markdown format

2. **Shell script testing** (like davila7 example)
   - Simple bash scripts with assertions
   - Create test projects in `/tmp`
   - Check file existence and content
   - Use `grep` for content verification

3. **Manual test scenarios**
   - Document common usage patterns
   - Provide test scripts that guide manual validation
   - Focus on smoke tests, not comprehensive coverage

4. **Documentation as specification**
   - Clear examples in README
   - Expected behavior documented
   - Manual verification steps

### ❌ What We Shouldn't Do

1. **Complex test frameworks**
   - No need for Jest/Mocha/RSpec
   - Avoid heavy dependencies

2. **Mock conversation state**
   - Too complex to maintain
   - Fragile and doesn't match reality

3. **Comprehensive unit tests**
   - Diminishing returns for prompt-based plugins
   - Better to have good manual test process

4. **Headless automation of slash commands**
   - Not supported by Claude Code
   - Would require hacks/workarounds

## Recommended Test Suite Structure

```
tests/
├── README.md                 # Test documentation
├── run-tests.sh              # Main test runner
├── lib/
│   └── test-helpers.sh       # Common assertions
└── cases/
    ├── test-basic-save.sh    # File creation tests
    ├── test-resume.sh        # Resume functionality
    └── test-list.sh          # List command
```

**Test pattern:**
1. Create isolated test project
2. Generate expected files/state
3. Run validation checks
4. Clean up

**Assertions:**
- File exists
- Directory structure correct
- File contains expected text
- File doesn't contain unexpected text
- `.latest` points to correct stash

## Example Test (Simplified)

```bash
#!/bin/bash
set -euo pipefail

# Setup
TEST_DIR="/tmp/stash-test-$(date +%s)"
mkdir -p "$TEST_DIR/.claude/stashes"
cd "$TEST_DIR"

# Simulate stash creation
cat > ".claude/stashes/stash-test.md" << 'EOF'
# Stash: test
Created: 2025-10-29
## Summary
Test stash
EOF

# Assertions
if [ -f ".claude/stashes/stash-test.md" ]; then
    echo "✅ Stash file exists"
else
    echo "❌ Stash file missing"
    exit 1
fi

if grep -q "Test stash" ".claude/stashes/stash-test.md"; then
    echo "✅ Stash has expected content"
else
    echo "❌ Stash content incorrect"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"
```

## Conclusion

**Simple is better than comprehensive:**
- Basic file-based assertions
- Shell scripts with clear pass/fail
- Focus on smoke tests
- Good documentation trumps complex tests

This aligns with how the broader Claude Code plugin ecosystem approaches quality assurance.
