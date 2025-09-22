# Standard Operating Procedures (SOP)

This folder contains scripts and documentation for maintaining consistent formatting and processes.

## Task Formatting

### fix_task_formatting_final.py

**Purpose**: Ensures consistent numbering format across all task files in the rust-library-discovery-system spec.

**What it fixes**:
- Main tasks: `- [ ] X. Analyze filename`
- Sub-tasks: `  - [ ] X.Y Lines A-B: Content analysis needed` (2 spaces indentation)
- Nested sub-tasks: `    - [ ] X.Y Lines A-B: Content analysis needed` (4 spaces indentation)

**Usage**:
```bash
cd /path/to/project/root
python3 SOP/fix_task_formatting_final.py
```

**When to use**:
- After manually editing tasks.md file
- When task numbering becomes inconsistent
- Before executing automated task processing

**Example output**:
```
- [ ] 1. Analyze RustConcepts20250909.txt (52,171 lines - 53 chunks)
  - [ ] 1.1 Lines 1-1000: Content analysis needed
  - [ ] 1.2 Lines 1001-2000: Content analysis needed
  - [ ] 1.3 Lines 2001-3000: Content analysis needed

- [ ] 2. Analyze trun_7335e17607c24192bb54abdd78a1cd59_from_json.txt (31,209 lines - 32 chunks)
  - [ ] 2.1 Lines 1-1000: Content analysis needed
  - [ ] 2.2 Lines 1001-2000: Content analysis needed
```