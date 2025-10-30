# Stash Plugin Tests

Automated tests for the stash plugin commands.

## Test Strategy

Since Claude Code slash commands only work in interactive sessions, we use a **hook-based testing approach**:

1. Tests run in actual Claude Code sessions
2. Hooks automatically verify command behavior
3. Test runner orchestrates the session and checks results

## Running Tests

```bash
# Run all tests
./tests/run-tests.sh

# Run a specific test
./tests/run-tests.sh mark-and-save
```

## Test Structure

```
tests/
├── README.md              # This file
├── run-tests.sh           # Main test runner
├── lib/
│   ├── test-helpers.sh    # Common test functions
│   └── verify-stash.sh    # Stash file verification
├── fixtures/
│   └── test-project/      # Isolated test project
└── cases/
    ├── test-mark-save.sh
    ├── test-resume.sh
    └── test-list.sh
```

## How Tests Work

1. **Setup**: Create isolated test project with clean `.claude/` state
2. **Execute**: Run Claude Code session with scripted interactions
3. **Verify**: Check stash files, command outputs, and side effects
4. **Cleanup**: Remove test artifacts

Each test:
- Uses `claude -p` for headless execution
- Simulates multi-turn conversations
- Runs actual `/stash:*` commands via prompts
- Verifies outputs match expectations

## Writing New Tests

Example test structure:

```bash
#!/bin/bash
source "$(dirname "$0")/../lib/test-helpers.sh"

test_name="my-new-test"
setup_test_project "$test_name"

# Simulate conversation and run command
run_conversation \
  "Talk about topic FOO" \
  "Now run /stash:mark" \
  "Talk about topic BAR" \
  "Now run /stash:save test-bar"

# Verify results
assert_stash_exists "test-bar"
assert_stash_contains "test-bar" "BAR"
assert_stash_not_contains "test-bar" "FOO"

cleanup_test_project
```

## CI Integration

Tests can run in CI/CD:

```yaml
# .github/workflows/test.yml
- name: Run stash tests
  run: ./tests/run-tests.sh
```

## Limitations

- Requires Claude Code CLI installed
- Consumes API tokens (minimal, ~1-2 cents per test run)
- Takes ~30-60 seconds per test
- Not true unit tests (integration tests)

These are **smoke tests** to catch regressions, not comprehensive coverage.
