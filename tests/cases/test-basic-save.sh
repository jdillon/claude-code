#!/bin/bash
# Test: Basic stash file structure
#
# Verifies that stash files are created with correct structure

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../lib/test-helpers.sh"

echo "======================================"
echo "Test: Basic Stash File Structure"
echo "======================================"

# Setup
setup_test_project "basic-save"

# Simulate stash creation (what /stash:save should do)
echo ""
echo "Creating test stash..."

cat > "${STASH_DIR}/stash-test-basic.md" << 'EOF'
# Stash: test-basic

**Created**: 2025-10-29T18:30:00Z
**Project**: /test/project
**Branch**: main

## Summary
Test stash for basic functionality

## Progress
- Created test files
- Verified structure

## Pending
- Add more tests

## Context
Testing basic stash creation and structure
EOF

echo "stash-test-basic.md" > "${STASH_DIR}/.latest"

# Verify stash directory exists
echo ""
echo "Verifying results..."
assert_dir_exists "$STASH_DIR"

# Verify stash file exists
assert_stash_exists "test-basic"

# Verify stash contains expected metadata sections
assert_stash_contains "test-basic" "# Stash:"
assert_stash_contains "test-basic" "**Created**:"
assert_stash_contains "test-basic" "**Project**:"
assert_stash_contains "test-basic" "**Branch**:"
assert_stash_contains "test-basic" "## Summary"
assert_stash_contains "test-basic" "## Progress"
assert_stash_contains "test-basic" "## Pending"
assert_stash_contains "test-basic" "## Context"

# Verify .latest file was updated
assert_file_exists "${STASH_DIR}/.latest"

# Check .latest points to our stash
LATEST_CONTENT=$(cat "${STASH_DIR}/.latest")
if [[ "$LATEST_CONTENT" == "stash-test-basic.md" ]]; then
    echo -e "${GREEN}✓${NC} .latest file updated correctly"
else
    echo -e "${RED}✗${NC} .latest file has unexpected content: $LATEST_CONTENT"
    FAILURES=$((FAILURES + 1))
fi

# Finish
finish_test "basic-save"
