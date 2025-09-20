#!/bin/bash

# Document Processing Snapshot Generator Script
# Automatically generates comprehensive repository snapshots with delta tracking for document processing workflow

set -e

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S IST')
SNAPSHOT_DIR=".github/file-snapshots"
CURRENT_SNAPSHOT="$SNAPSHOT_DIR/current-snapshot.md"
PREVIOUS_SNAPSHOT="$SNAPSHOT_DIR/previous-snapshot.md"
CHANGE_LOG="$SNAPSHOT_DIR/change-log.md"
TEMP_SNAPSHOT="/tmp/doc_processing_snapshot_$$.md"

# Ensure snapshot directory exists
mkdir -p "$SNAPSHOT_DIR"

echo "Generating document processing snapshot at $TIMESTAMP..."

# Generate file inventory with line and word counts
echo "# Document Processing Snapshot - $TIMESTAMP" > "$TEMP_SNAPSHOT"
echo "" >> "$TEMP_SNAPSHOT"

# Count all relevant files (exclude .git, target, node_modules)
TOTAL_FILES=$(find . -type f ! -path "./.git/*" ! -path "./target/*" ! -path "./node_modules/*" | wc -l)
TOTAL_LINES=$(find . -type f ! -path "./.git/*" ! -path "./target/*" ! -path "./node_modules/*" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")
TOTAL_WORDS=$(find . -type f ! -path "./.git/*" ! -path "./target/*" ! -path "./node_modules/*" -exec wc -w {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo "0")

echo "## Summary Statistics" >> "$TEMP_SNAPSHOT"
echo "- Total Files: $TOTAL_FILES" >> "$TEMP_SNAPSHOT"
echo "- Total Lines: $(printf "%'d" $TOTAL_LINES)" >> "$TEMP_SNAPSHOT"
echo "- Total Words: $(printf "%'d" $TOTAL_WORDS)" >> "$TEMP_SNAPSHOT"
echo "- Snapshot Time: $TIMESTAMP" >> "$TEMP_SNAPSHOT"
echo "" >> "$TEMP_SNAPSHOT"

echo "## File Inventory by Type" >> "$TEMP_SNAPSHOT"
echo "" >> "$TEMP_SNAPSHOT"

# Generate file listing by type with counts
echo "### Markdown Files (.md)" >> "$TEMP_SNAPSHOT"
echo "" >> "$TEMP_SNAPSHOT"
echo "| File Path | Lines | Words | Status |" >> "$TEMP_SNAPSHOT"
echo "|-----------|-------|-------|--------|" >> "$TEMP_SNAPSHOT"

find . -name "*.md" -type f ! -path "./.git/*" | sort | while read -r file; do
    if [ -f "$file" ]; then
        lines=$(wc -l < "$file" 2>/dev/null || echo "0")
        words=$(wc -w < "$file" 2>/dev/null || echo "0")
        # Check if file is in our checklist
        if grep -q "$file" .github/A01SummaryProgress20250920.md 2>/dev/null; then
            status="✅ Tracked"
        else
            status="📋 Untracked"
        fi
        echo "| $file | $lines | $words | $status |" >> "$TEMP_SNAPSHOT"
    fi
done

echo "" >> "$TEMP_SNAPSHOT"
echo "### JSON Files (.json)" >> "$TEMP_SNAPSHOT"
echo "" >> "$TEMP_SNAPSHOT"
echo "| File Path | Lines | Words | Status |" >> "$TEMP_SNAPSHOT"
echo "|-----------|-------|-------|--------|" >> "$TEMP_SNAPSHOT"

find . -name "*.json" -type f ! -path "./.git/*" | sort | while read -r file; do
    if [ -f "$file" ]; then
        lines=$(wc -l < "$file" 2>/dev/null || echo "0")
        words=$(wc -w < "$file" 2>/dev/null || echo "0")
        # Check if file is in our checklist
        if grep -q "$file" .github/A01SummaryProgress20250920.md 2>/dev/null; then
            status="✅ Tracked"
        else
            status="📋 Untracked"
        fi
        echo "| $file | $lines | $words | $status |" >> "$TEMP_SNAPSHOT"
    fi
done

echo "" >> "$TEMP_SNAPSHOT"
echo "### Other Files (.txt, .sh, .ipynb, .log, .db)" >> "$TEMP_SNAPSHOT"
echo "" >> "$TEMP_SNAPSHOT"
echo "| File Path | Lines | Words | Type |" >> "$TEMP_SNAPSHOT"
echo "|-----------|-------|-------|------|" >> "$TEMP_SNAPSHOT"

find . -type f \( -name "*.txt" -o -name "*.sh" -o -name "*.ipynb" -o -name "*.log" -o -name "*.db" \) ! -path "./.git/*" | sort | while read -r file; do
    if [ -f "$file" ]; then
        lines=$(wc -l < "$file" 2>/dev/null || echo "0")
        words=$(wc -w < "$file" 2>/dev/null || echo "0")
        filetype=$(echo "$file" | sed 's/.*\.//')
        echo "| $file | $lines | $words | $filetype |" >> "$TEMP_SNAPSHOT"
    fi
done

# Move previous snapshot if it exists
if [ -f "$CURRENT_SNAPSHOT" ]; then
    cp "$CURRENT_SNAPSHOT" "$PREVIOUS_SNAPSHOT"

    # Generate delta report
    echo "" >> "$TEMP_SNAPSHOT"
    echo "## Changes Since Previous Snapshot" >> "$TEMP_SNAPSHOT"

    # Extract previous stats
    if [ -f "$PREVIOUS_SNAPSHOT" ]; then
        PREV_FILES=$(grep "Total Files:" "$PREVIOUS_SNAPSHOT" | sed 's/.*: //' | tr -d ',')
        PREV_LINES=$(grep "Total Lines:" "$PREVIOUS_SNAPSHOT" | sed 's/.*: //' | tr -d ',')
        PREV_WORDS=$(grep "Total Words:" "$PREVIOUS_SNAPSHOT" | sed 's/.*: //' | tr -d ',')

        FILE_DIFF=$((TOTAL_FILES - PREV_FILES))
        LINE_DIFF=$((TOTAL_LINES - PREV_LINES))
        WORD_DIFF=$((TOTAL_WORDS - PREV_WORDS))

        echo "- File Count Change: $FILE_DIFF" >> "$TEMP_SNAPSHOT"
        echo "- Line Count Change: $(printf "%'d" $LINE_DIFF)" >> "$TEMP_SNAPSHOT"
        echo "- Word Count Change: $(printf "%'d" $WORD_DIFF)" >> "$TEMP_SNAPSHOT"

        # Calculate processing progress
        COMPLETED_FILES=$(grep -c "\[x\]" .github/A01SummaryProgress20250920.md 2>/dev/null || echo "0")
        TOTAL_TRACKED=$(grep -c "\[.\]" .github/A01SummaryProgress20250920.md 2>/dev/null || echo "0")

        if [ "$TOTAL_TRACKED" -gt 0 ]; then
            PROGRESS=$((COMPLETED_FILES * 100 / TOTAL_TRACKED))
            echo "- Processing Progress: $PROGRESS% ($COMPLETED_FILES/$TOTAL_TRACKED files)" >> "$TEMP_SNAPSHOT"
        fi
    fi
fi

# Move temp snapshot to current
mv "$TEMP_SNAPSHOT" "$CURRENT_SNAPSHOT"

# Update change log
if [ ! -f "$CHANGE_LOG" ]; then
    echo "# Document Processing Change Log" > "$CHANGE_LOG"
    echo "" >> "$CHANGE_LOG"
fi

echo "## $TIMESTAMP - Automated Snapshot" >> "$CHANGE_LOG"
echo "**Type**: automated-snapshot" >> "$CHANGE_LOG"
echo "" >> "$CHANGE_LOG"
echo "### Summary" >> "$CHANGE_LOG"
echo "- **Total Files**: $TOTAL_FILES" >> "$CHANGE_LOG"
echo "- **Total Lines**: $(printf "%'d" $TOTAL_LINES)" >> "$CHANGE_LOG"
echo "- **Total Words**: $(printf "%'d" $TOTAL_WORDS)" >> "$CHANGE_LOG"

# Add processing progress to change log
COMPLETED_FILES=$(grep -c "\[x\]" .github/A01SummaryProgress20250920.md 2>/dev/null || echo "0")
TOTAL_TRACKED=$(grep -c "\[.\]" .github/A01SummaryProgress20250920.md 2>/dev/null || echo "0")

if [ "$TOTAL_TRACKED" -gt 0 ]; then
    PROGRESS=$((COMPLETED_FILES * 100 / TOTAL_TRACKED))
    echo "- **Processing Progress**: $PROGRESS% ($COMPLETED_FILES/$TOTAL_TRACKED files)" >> "$CHANGE_LOG"
fi

if [ -f "$PREVIOUS_SNAPSHOT" ]; then
    echo "- **File Change**: $FILE_DIFF" >> "$CHANGE_LOG"
    echo "- **Line Change**: $(printf "%'d" $LINE_DIFF)" >> "$CHANGE_LOG"
    echo "- **Word Change**: $(printf "%'d" $WORD_DIFF)" >> "$CHANGE_LOG"
fi

echo "" >> "$CHANGE_LOG"
echo "---" >> "$CHANGE_LOG"
echo "" >> "$CHANGE_LOG"

# Commit changes to git (only .github directory)
if git diff --quiet .github/ && git diff --cached --quiet .github/; then
    echo "ℹ️  No .github changes to commit"
else
    git add .github/file-snapshots/

    # Calculate progress for commit message
    if [ "$TOTAL_TRACKED" -gt 0 ]; then
        PROGRESS=$((COMPLETED_FILES * 100 / TOTAL_TRACKED))
        COMMIT_MSG="document-processing-snapshot progress-${PROGRESS}% ${TIMESTAMP}"
    else
        COMMIT_MSG="document-processing-snapshot ${TIMESTAMP}"
    fi

    if ! git diff --cached --quiet .github/; then
        git commit -m "$COMMIT_MSG"
        echo "✅ Document processing snapshot committed"
        echo "📝 Commit: $COMMIT_MSG"
    fi
fi

echo "Document processing snapshot generated successfully!"
echo "- Current snapshot: $CURRENT_SNAPSHOT"
echo "- Change log updated: $CHANGE_LOG"
echo "- Files tracked: $TOTAL_FILES"
echo "- Total lines: $(printf "%'d" $TOTAL_LINES)"
echo "- Total words: $(printf "%'d" $TOTAL_WORDS)"

if [ "$TOTAL_TRACKED" -gt 0 ]; then
    echo "- Processing progress: $PROGRESS% ($COMPLETED_FILES/$TOTAL_TRACKED files)"
fi