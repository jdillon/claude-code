# Claude Code Session Transcripts

This document explains where and how Claude Code stores conversation transcripts.

## Location

Claude Code stores full conversation transcripts as JSONL (JSON Lines) files:

```
~/.claude/projects/<project-slug>/<session-id>.jsonl
```

**Example:**
```
~/.claude/projects/-Users-jason-ws-jdillon-claude-code/4df56b2e-881a-4718-840f-8ad508c578f4.jsonl
```

**Finding current session:**
```bash
# List sessions for current project (most recent first)
ls -lt ~/.claude/projects/-Users-jason-ws-jdillon-claude-code/*.jsonl | head -5
```

## File Format

Each line in the `.jsonl` file is a separate JSON object representing one message or event in the conversation.

### Entry Types

The file contains three types of entries:

1. **`"type": "user"`** - Tool results (outputs from Read, Bash, Edit, etc.)
2. **`"type": "assistant"`** - Claude's responses and tool calls
3. **`"type": "file-history-snapshot"`** - File change tracking

### Entry Structure

Each entry contains:

```json
{
  "type": "user" | "assistant" | "file-history-snapshot",
  "uuid": "unique-message-id",
  "timestamp": "2025-10-30T00:27:08.353Z",
  "sessionId": "4df56b2e-881a-4718-840f-8ad508c578f4",
  "parentUuid": "previous-message-id",
  "cwd": "/Users/jason/ws/jdillon/claude-code",
  "gitBranch": "main",
  "version": "2.0.29",
  "message": {
    "role": "user" | "assistant",
    "content": [ /* ... */ ]
  }
}
```

### Message Content Format

The `message.content` field follows the Anthropic API format:

**User messages (tool results):**
```json
{
  "role": "user",
  "content": [
    {
      "type": "tool_result",
      "tool_use_id": "toolu_...",
      "content": "output from tool",
      "is_error": false
    }
  ]
}
```

**Assistant messages (responses + tool calls):**
```json
{
  "role": "assistant",
  "content": [
    {
      "type": "text",
      "text": "Claude's response text..."
    },
    {
      "type": "tool_use",
      "id": "toolu_...",
      "name": "Bash",
      "input": {
        "command": "ls -la"
      }
    }
  ]
}
```

## Inspecting Transcripts

### Count messages in current session

```bash
wc -l ~/.claude/projects/-Users-jason-ws-jdillon-claude-code/<session-id>.jsonl
```

### View message types

```bash
jq -r '.type' ~/.claude/projects/-Users-jason-ws-jdillon-claude-code/<session-id>.jsonl | sort | uniq -c
```

### Extract all user prompts (your actual typed messages)

User prompts are stored separately in `~/.claude.json` under `projects[path].history`:

```bash
jq '.projects["/Users/jason/ws/jdillon/claude-code"].history[].display' ~/.claude.json
```

### View assistant text responses (excluding tool calls)

```bash
jq -r 'select(.type == "assistant") | .message.content[] | select(.type == "text") | .text' \
  ~/.claude/projects/-Users-jason-ws-jdillon-claude-code/<session-id>.jsonl
```

### View all tool calls

```bash
jq 'select(.type == "assistant") | .message.content[] | select(.type == "tool_use") | {tool: .name, id: .id}' \
  ~/.claude/projects/-Users-jason-ws-jdillon-claude-code/<session-id>.jsonl
```

### View all tool results

```bash
jq 'select(.type == "user") | .message.content[] | select(.type == "tool_result") | {tool_id: .tool_use_id, preview: .content[0:100]}' \
  ~/.claude/projects/-Users-jason-ws-jdillon-claude-code/<session-id>.jsonl
```

## Other Storage Locations

### User Prompt History

**Global prompt history:**
```
~/.claude/history.jsonl
```

Contains all user prompts across all sessions:
```bash
tail -10 ~/.claude/history.jsonl | jq -r '.display'
```

**Per-project prompt history:**
```
~/.claude.json → projects[path].history[]
```

### Session Metadata

**Current session info:**
```bash
jq '.projects["/path/to/project"]' ~/.claude.json
```

Contains:
- `history` - Recent user prompts for this project
- `allowedTools` - Tool permissions
- `mcpServers` - MCP server configuration
- Various onboarding/settings flags

## Using Transcripts with Hooks

Hooks receive the transcript path via environment variable `$TRANSCRIPT_PATH`. See [Claude Code Hooks documentation](https://docs.claude.com/en/docs/claude-code/hooks).

Example hook to copy transcript after each response:

```json
{
  "hooks": [
    {
      "event": "Stop",
      "command": "cp \"$TRANSCRIPT_PATH\" \"/tmp/claude-transcript-$(date +%s).jsonl\""
    }
  ]
}
```

## Relevance to Stash Plugin

When `/stash:save` is executed, Claude has access to the full conversation transcript from the `.jsonl` file. This is what allows it to:

1. Identify `/stash:mark` markers in the conversation
2. Analyze context before/after marks
3. Ask users which sections to preserve
4. Create accurate summaries of session state

The transcript is the **source of truth** for what happened in the session, making it possible to create accurate stashes for resumption later.

## Privacy Note

These transcript files contain:
- All your prompts and messages
- All of Claude's responses
- All tool inputs and outputs (file contents, command results, etc.)
- File change history

They are stored **locally only** in `~/.claude/` and are not uploaded anywhere by default (unless you have cloud sync enabled on that directory).
