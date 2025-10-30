#!/bin/bash
# Test helper functions for stash plugin tests

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test state
TEST_DIR=""
TEST_PROJECT=""
STASH_DIR=""
FAILURES=0

# Setup isolated test environment
setup_test_project() {
    local test_name="$1"
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local tests_root="$(cd "${script_dir}/.." && pwd)"
    local build_dir="${tests_root}/build"

    TEST_DIR="${build_dir}/stash-test-${test_name}"
    TEST_PROJECT="${TEST_DIR}/project"
    STASH_DIR="${TEST_PROJECT}/.claude/stashes"

    # Clean up if exists
    if [[ -d "$TEST_DIR" ]]; then
        rm -rf "$TEST_DIR"
    fi

    mkdir -p "$TEST_PROJECT"
    mkdir -p "$STASH_DIR"
    cd "$TEST_PROJECT"
    git init -q

    echo "✓ Setup test project: $TEST_PROJECT"
}

# Cleanup test environment
cleanup_test_project() {
    if [[ -n "$TEST_DIR" ]] && [[ -d "$TEST_DIR" ]]; then
        rm -rf "$TEST_DIR"
        echo "✓ Cleaned up test project"
    fi
}

# Run Claude Code with a prompt and capture output
run_claude() {
    local prompt="$1"
    local output_file="${TEST_DIR}/claude-output-$(date +%s).txt"

    cd "$TEST_PROJECT"
    claude -p "$prompt" --output-format text > "$output_file" 2>&1 || true

    cat "$output_file"
}

# Simulate a multi-turn conversation
# Usage: run_conversation "prompt 1" "prompt 2" "prompt 3"
run_conversation() {
    local session_file="${TEST_DIR}/conversation.txt"

    for prompt in "$@"; do
        echo "→ $prompt"
        run_claude "$prompt" >> "$session_file"
        sleep 1  # Avoid rate limiting
    done

    cat "$session_file"
}

# Assert stash file exists
assert_stash_exists() {
    local stash_name="$1"
    local stash_file="${STASH_DIR}/stash-${stash_name}.md"

    if [[ -f "$stash_file" ]]; then
        echo -e "${GREEN}✓${NC} Stash exists: $stash_name"
        return 0
    else
        echo -e "${RED}✗${NC} Stash does not exist: $stash_name"
        FAILURES=$((FAILURES + 1))
        return 1
    fi
}

# Assert stash file does not exist
assert_stash_not_exists() {
    local stash_name="$1"
    local stash_file="${STASH_DIR}/stash-${stash_name}.md"

    if [[ ! -f "$stash_file" ]]; then
        echo -e "${GREEN}✓${NC} Stash does not exist: $stash_name"
        return 0
    else
        echo -e "${RED}✗${NC} Stash exists (should not): $stash_name"
        FAILURES=$((FAILURES + 1))
        return 1
    fi
}

# Assert stash contains a string
assert_stash_contains() {
    local stash_name="$1"
    local expected="$2"
    local stash_file="${STASH_DIR}/stash-${stash_name}.md"

    if [[ ! -f "$stash_file" ]]; then
        echo -e "${RED}✗${NC} Stash file not found: $stash_name"
        FAILURES=$((FAILURES + 1))
        return 1
    fi

    if grep -F -q "$expected" "$stash_file"; then
        echo -e "${GREEN}✓${NC} Stash contains: $expected"
        return 0
    else
        echo -e "${RED}✗${NC} Stash does not contain: $expected"
        echo "  File: $stash_file"
        FAILURES=$((FAILURES + 1))
        return 1
    fi
}

# Assert stash does not contain a string
assert_stash_not_contains() {
    local stash_name="$1"
    local unexpected="$2"
    local stash_file="${STASH_DIR}/stash-${stash_name}.md"

    if [[ ! -f "$stash_file" ]]; then
        echo -e "${RED}✗${NC} Stash file not found: $stash_name"
        FAILURES=$((FAILURES + 1))
        return 1
    fi

    if ! grep -F -q "$unexpected" "$stash_file"; then
        echo -e "${GREEN}✓${NC} Stash does not contain: $unexpected"
        return 0
    else
        echo -e "${RED}✗${NC} Stash contains (should not): $unexpected"
        echo "  File: $stash_file"
        FAILURES=$((FAILURES + 1))
        return 1
    fi
}

# Assert file exists
assert_file_exists() {
    local file="$1"

    if [[ -f "$file" ]]; then
        echo -e "${GREEN}✓${NC} File exists: $file"
        return 0
    else
        echo -e "${RED}✗${NC} File does not exist: $file"
        FAILURES=$((FAILURES + 1))
        return 1
    fi
}

# Assert directory exists
assert_dir_exists() {
    local dir="$1"

    if [[ -d "$dir" ]]; then
        echo -e "${GREEN}✓${NC} Directory exists: $dir"
        return 0
    else
        echo -e "${RED}✗${NC} Directory does not exist: $dir"
        FAILURES=$((FAILURES + 1))
        return 1
    fi
}

# Print test summary and exit with appropriate code
finish_test() {
    local test_name="$1"

    echo ""
    echo "======================================"
    if [[ $FAILURES -eq 0 ]]; then
        echo -e "${GREEN}✓ $test_name PASSED${NC}"
        exit 0
    else
        echo -e "${RED}✗ $test_name FAILED${NC} ($FAILURES assertion(s) failed)"
        exit 1
    fi
}

# Trap errors and cleanup
trap cleanup_test_project EXIT
