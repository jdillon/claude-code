#!/bin/bash
# Test runner for stash plugin
#
# Usage:
#   ./run-tests.sh              # Run all tests
#   ./run-tests.sh test-name    # Run specific test

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CASES_DIR="${SCRIPT_DIR}/cases"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check Claude Code is installed
if ! command -v claude &> /dev/null; then
    echo -e "${RED}Error: claude command not found${NC}"
    echo "Please install Claude Code CLI first"
    exit 1
fi

# Get list of tests
if [[ $# -eq 0 ]]; then
    TESTS=("$CASES_DIR"/test-*.sh)
else
    TEST_NAME="$1"
    TESTS=("$CASES_DIR/test-${TEST_NAME}.sh")

    if [[ ! -f "${TESTS[0]}" ]]; then
        echo -e "${RED}Error: Test not found: ${TEST_NAME}${NC}"
        echo "Available tests:"
        for test in "$CASES_DIR"/test-*.sh; do
            basename "$test" .sh | sed 's/test-/  - /'
        done
        exit 1
    fi
fi

# Run tests
TOTAL=0
PASSED=0
FAILED=0
FAILED_TESTS=()

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}     Stash Plugin Test Suite${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

for test in "${TESTS[@]}"; do
    if [[ ! -f "$test" ]]; then
        continue
    fi

    TOTAL=$((TOTAL + 1))
    TEST_NAME=$(basename "$test" .sh | sed 's/test-//')

    echo ""
    echo -e "${YELLOW}Running: ${TEST_NAME}${NC}"
    echo "--------------------------------------"

    if bash "$test"; then
        PASSED=$((PASSED + 1))
    else
        FAILED=$((FAILED + 1))
        FAILED_TESTS+=("$TEST_NAME")
    fi

    echo ""
done

# Summary
echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}     Test Summary${NC}"
echo -e "${BLUE}============================================${NC}"
echo "Total:  $TOTAL"
echo -e "${GREEN}Passed: $PASSED${NC}"

if [[ $FAILED -gt 0 ]]; then
    echo -e "${RED}Failed: $FAILED${NC}"
    echo ""
    echo "Failed tests:"
    for failed_test in "${FAILED_TESTS[@]}"; do
        echo -e "  ${RED}✗${NC} $failed_test"
    done
    echo ""
    exit 1
else
    echo ""
    echo -e "${GREEN}All tests passed!${NC}"
    echo ""
    exit 0
fi
