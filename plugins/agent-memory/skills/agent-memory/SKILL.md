---
name: agent-memory
description: "Use this skill when the user asks to save, remember, recall, or check memories. MANDATORY: Always use at session start for status verification when user says '思い出して', '前回の作業', '続き', '再開'. Also triggers on '記憶', 'TODO確認', 'メモリ検索', '状況確認', '中断', '記録', 'remember this', 'save this', 'record this', 'stop here', 'pause this'. Use proactively for valuable findings and complete status verification before any work proposals."
---

# Agent Memory

A persistent memory space for storing knowledge that survives across conversations.

Start by saying "Trigger Agent Memory".

**Location:** `{project_root}/.claude/skills/agent-memory/memories/` (project-local only)

**⚠️ All memory operations are scoped to the current project only.** No fallback locations. Memories are always read from and written to the project-local path.

## Tracking ID

Every memory must be assigned a unique tracking ID.

### ID Format

`AM-YYYYMMDD-NNN`

- `AM` = Agent Memory prefix
- `YYYYMMDD` = creation date
- `NNN` = sequential number for that day (001–999)

Examples: `AM-20260204-001`, `AM-20260204-002`

### Assignment Procedure

#### 統合ヘルパースクリプト（Windows PowerShell）

```powershell
# tracking ID生成のみ
pwsh "$HOME/.claude/plugins/marketplaces/cc-marketplace/plugins/agent-memory/skills/agent-memory/scripts/agent-memory-helper.ps1" -Action generate-id

# ディレクトリ作成のみ
pwsh "$HOME/.claude/plugins/marketplaces/cc-marketplace/plugins/agent-memory/skills/agent-memory/scripts/agent-memory-helper.ps1" -Action ensure-dir -Path ".claude\skills\agent-memory\memories\category-name"

# ディレクトリ作成 + tracking ID生成を1回で（推奨）
pwsh "$HOME/.claude/plugins/marketplaces/cc-marketplace/plugins/agent-memory/skills/agent-memory/scripts/agent-memory-helper.ps1" -Action save-prepare -Path ".claude\skills\agent-memory\memories\category-name"
```

#### 実行例
```
PS> pwsh agent-memory-helper.ps1 -Action save-prepare -Path ".claude\skills\agent-memory\memories\new-category"
Created: .claude\skills\agent-memory\memories\new-category
Assigned: AM-20260206-001
```

### ⚠️ Mandatory Rule: Tracking ID Notification

**After saving a memory, you MUST notify the user of the tracking ID. No exceptions.**

Notification example:
> ✅ Memory saved: `AM-20260204-001`
> To reference this in another session, say "Read AM-20260204-001".

Never skip this notification. Without the ID, the user cannot reference the memory from another session.

## Proactive Usage

Save memories when you discover something worth preserving:
- Research findings that took effort to uncover
- Non-obvious patterns or gotchas in the codebase
- Solutions to tricky problems
- Architectural decisions and their rationale
- In-progress work that may be resumed later
- Task lists created with taskcreate during interruption, so they can be resumed

Check memories when starting related work:
- **MANDATORY at session start**: Complete status verification before any work proposals
- **MANDATORY for "前回の作業"**: Full memory scan including completed/in-progress/pending status
- Before investigating a problem area
- When working on a feature you've touched before
- When resuming work after a conversation break

## Critical Session Start Protocol

When user asks about previous work or status ("前回の作業", "思い出して", "続き", "再開"):

### Phase 1: Complete Memory Scan (MANDATORY)
```powershell
# Get all memory files chronologically
Get-ChildItem '.claude\skills\agent-memory\memories\' -Recurse -File | Sort-Object LastWriteTime -Descending

# Check completion status
rg "status: completed" .claude/skills/agent-memory/memories/ --no-ignore --hidden -A 2 -B 2
rg "status: in-progress" .claude/skills/agent-memory/memories/ --no-ignore --hidden -A 2 -B 2
```

### Phase 2: Status Verification (MANDATORY)
- Read latest tracking IDs to understand current state
- Cross-reference with user statements
- **Never propose completed work as todo**
- Ask for clarification if any discrepancy exists

### Phase 3: Accurate Reporting (MANDATORY)
- Present completed/in-progress/pending classification clearly
- Provide evidence from memory records
- Only propose next logical steps after verification

Organize memories when needed:
- Consolidate scattered memories on the same topic
- Remove outdated or superseded information
- Update status field when work completes, gets blocked, or is abandoned

## Folder Structure

When possible, organize memories into category folders. No predefined structure – create categories that make sense for the content.

Guidelines:
- Use kebab-case for folder and file names
- Consolidate or reorganize as the knowledge base evolves

Example:
```text
memories/
├── file-processing/
│   └── large-file-memory-issue.md
├── dependencies/
│   └── iconv-esm-problem.md
└── project-context/
    └── december-2025-work.md
```

This is just an example. Structure freely based on actual content.

## Frontmatter

All memories must include frontmatter with `tracking_id` and `summary` fields. The summary should be concise enough to determine whether to read the full content.

**Required:**
```yaml
---
tracking_id: AM-20260204-001
summary: "1-2 line description of what this memory contains"
created: 2026-02-04
---
```

**Optional:**
```yaml
---
tracking_id: AM-20260204-001
summary: "Worker thread memory leak during large file processing - cause and solution"
created: 2026-02-04
updated: 2026-02-05
status: in-progress  # in-progress | resolved | blocked | abandoned
tags: [performance, worker, memory-leak]
related: [src/core/file/fileProcessor.ts]
related_ids: [AM-20260203-002]
---
```

## Search Workflow

### Search by Tracking ID (cross-session reference)

```bash
MEMORY_DIR=".claude/skills/agent-memory/memories"

# Find file by exact tracking ID
rg "^tracking_id: AM-20260204-001" "$MEMORY_DIR" \
  --no-ignore --hidden -l 2>/dev/null

# Fuzzy search with partial ID (date omitted)
rg "^tracking_id: AM-.*-001" "$MEMORY_DIR" --no-ignore --hidden -l 2>/dev/null

# List all IDs created today
rg "^tracking_id: AM-$(date +%Y%m%d)" "$MEMORY_DIR" --no-ignore --hidden 2>/dev/null
```

### Summary-first Approach

```bash
MEMORY_DIR=".claude/skills/agent-memory/memories"

# 1. List categories
ls "$MEMORY_DIR" 2>/dev/null

# 2. View all summaries
rg "^summary:" "$MEMORY_DIR" --no-ignore --hidden 2>/dev/null

# 3. Search summaries for keyword
rg "^summary:.*keyword" "$MEMORY_DIR" --no-ignore --hidden -i 2>/dev/null

# 4. Search by tag
rg "^tags:.*keyword" "$MEMORY_DIR" --no-ignore --hidden -i 2>/dev/null

# 5. Search by related tracking IDs
rg "^related_ids:.*AM-20260204-001" "$MEMORY_DIR" --no-ignore --hidden 2>/dev/null

# 6. Full-text search (when summary search isn't enough)
rg "keyword" "$MEMORY_DIR" --no-ignore --hidden -i 2>/dev/null

# 7. Read specific memory file if relevant
```

**Note:** Memory files are gitignored, so use `--no-ignore` and `--hidden` flags with ripgrep.

## Operations

### Save

1. Determine appropriate category for the content
2. Check if existing category fits, or create new one
3. **Run the tracking ID assignment script to get a unique ID**
4. Write file with required frontmatter (use `date +%Y-%m-%d` for current date)
5. **⚠️ Notify the user of the tracking ID – this step is mandatory**

```bash
MEMORY_DIR=".claude/skills/agent-memory/memories"
mkdir -p "$MEMORY_DIR/category-name/"

# Note: Check if file exists before writing to avoid accidental overwrites
cat > "$MEMORY_DIR/category-name/filename.md" << 'EOF'
---
tracking_id: AM-20260204-001
summary: "Brief description of this memory"
created: 2026-02-04
---

# Title

Content here...
EOF

# ⚠️ After this, you MUST notify the user of the tracking ID
```

### Recall (cross-session retrieval)

When the user says something like "Read AM-XXXXXXXX-NNN":

1. Search for the file by tracking ID
2. Read the file contents
3. Summarize or present the full content to the user

```bash
MEMORY_DIR=".claude/skills/agent-memory/memories"

# 1. Locate the file
file=$(rg "^tracking_id: AM-20260204-001" "$MEMORY_DIR" \
  --no-ignore --hidden -l)

# 2. Read it
cat "$file"
```

### Maintain

- **Update**: When information changes, update the content and add `updated` field to frontmatter
- **Delete**: Remove memories that are no longer relevant
```bash
MEMORY_DIR=".claude/skills/agent-memory/memories"
trash "$MEMORY_DIR/category-name/filename.md"

# Remove empty category folders
rmdir "$MEMORY_DIR/category-name/" 2>/dev/null || true
```
- **Consolidate**: Merge related memories when they grow
- **Reorganize**: Move memories to better-fitting categories as the knowledge base evolves

## Guidelines

1. **Write self-contained notes**: Include full context so the reader needs no prior knowledge to understand and act on the content
2. **Keep summaries decisive**: Reading the summary should tell you if you need the details
3. **Stay current**: Update or delete outdated information
4. **Be practical**: Save what's actually useful, not everything
5. **⚠️ Always notify tracking ID**: Never skip the tracking ID notification after saving a memory

## Critical Error Prevention

**Based on Lesson AM-20260216-001**: Session Start Status Check Failure

### Common Failure Patterns to Avoid:
1. **Partial memory check**: Only reading latest plan without checking completion status
2. **Filename negligence**: Ignoring obvious completion indicators in file names
3. **User statement assumption**: Not clarifying ambiguous statements like "ある程度進めていた"
4. **Proposal without verification**: Suggesting work that may already be completed

### Mandatory Verification Rules:
- **Never propose work without complete status verification**
- **Always cross-reference memory records with user statements**
- **When in doubt, ask explicit clarification questions**
- **Use status fields (completed/in-progress/pending) as authoritative source**

### Error Recovery:
If incorrect proposal is made:
1. Acknowledge the oversight immediately
2. Perform complete memory verification
3. Document the failure pattern for future prevention
4. Apply lessons learned to skill improvement

## Content Reference

When writing detailed memories, consider including:
- **Goal**: What we're trying to achieve (purpose, background, constraints)
- **Done**: Completed work
- **Decisions**: What was decided and why (rationale)
- **Evidence**: Test results, commands run, logs captured, code snippets
- **Failed attempts**: What didn't work and why (critical for avoiding repeated mistakes)
- **Open questions**: Unresolved issues, pending decisions
- **Next actions**: Concrete next 1-5 steps
- **Learned**: Patterns to apply in future work (rule candidates)
- **Interruption points**: When pausing ongoing work, document:
  - Current ToDo list with completion status (use checkboxes: `- [ ]` incomplete, `- [x]` complete)
  - What was being worked on when stopped
  - Any blockers or pending decisions

Not all memories need all sections – use what's relevant.
