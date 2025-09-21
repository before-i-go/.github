#!/bin/bash

# auto-tracker.sh - Automated processing with real-time checklist updates
# Updates the tracking document automatically as you process chunks

set -e

# Usage function
usage() {
    echo "Usage: $0 <file_path> <tracking_document>"
    echo "  file_path: Full path to the file to process"
    echo "  tracking_document: Path to the Markdown file with checklist"
    echo ""
    echo "Example: $0 ./research/rust-async.md A01SummaryProgress20250920.md"
    exit 1
}

# Check arguments
if [ $# -ne 2 ]; then
    usage
fi

FILE_PATH="$1"
TRACKING_DOC="$2"

# Validate files exist
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File '$FILE_PATH' not found"
    exit 1
fi

if [ ! -f "$TRACKING_DOC" ]; then
    echo "Error: Tracking document '$TRACKING_DOC' not found"
    exit 1
fi

# Get filename for display
FILENAME=$(basename "$FILE_PATH")
FILE_EXT="${FILENAME##*.}"

# Get total line count
TOTAL_LINES=0
if [[ "$FILE_EXT" =~ ^(md|txt|sh|log|json)$ ]]; then
    TOTAL_LINES=$(wc -l < "$FILE_PATH" | tr -d ' ')
fi

# Calculate number of chunks
CHUNKS=1
if [ "$TOTAL_LINES" -gt 0 ]; then
    CHUNKS=$(((TOTAL_LINES + 999) / 1000))
fi

echo "=== Auto-Tracking Processing: $FILENAME ==="
echo "Tracking Document: $TRACKING_DOC"
echo "File Type: $FILE_EXT"
if [ "$TOTAL_LINES" -gt 0 ]; then
    echo "Total Lines: $TOTAL_LINES"
    echo "Chunks to process: $CHUNKS"
fi
echo ""

# Function to update checkbox in tracking document
update_checkbox() {
    local chunk_num=$1
    local filename=$2
    local temp_file=$(mktemp)

    # Find and update the checkbox for this chunk
    # Pattern: - [ ] X.XX.N Read filename lines XXX-XXX - description
    awk -v chunk="$chunk_num" -v fname="$filename" '
    BEGIN { updated = 0 }
    {
        if (index($0, "- [ ]") && index($0, fname) && index($0, "Read " fname " lines")) {
            # Extract chunk number from the line
            if (match($0, /([0-9]+\.[0-9]+\.)([0-9]+)/, arr)) {
                if (arr[2] == chunk) {
                    # Replace [ ] with [x] and add completion timestamp
                    sub(/\[ \]/, "[x]")
                    sub(/- Add task description here/, "- Auto-completed " strftime("%Y-%m-%d %H:%M:%S"))
                    updated = 1
                    print "✓ Updated chunk " chunk " checkbox"
                }
            }
        }
        print
    }
    END {
        if (!updated) print "! Warning: Could not find checkbox for chunk " chunk " in tracking document" > "/dev/stderr"
    }' "$TRACKING_DOC" > "$temp_file"

    if [ $? -eq 0 ]; then
        mv "$temp_file" "$TRACKING_DOC"
        echo "  ✓ Tracking document updated"
    else
        rm -f "$temp_file"
        echo "  ✗ Failed to update tracking document"
    fi
}

# Function to display chunk based on file type
display_chunk() {
    local chunk_num=$1
    local file_ext=$2
    local file_path=$3

    case "$file_ext" in
        md|txt|sh|log)
            # Text files - use sed
            local start_line=$(((chunk_num-1) * 1000 + 1))
            local end_line=$((chunk_num * 1000))

            echo "--- Chunk $chunk_num (Lines $start_line-$end_line) ---"
            sed -n "${start_line},${end_line}p" "$file_path"
            ;;

        json)
            # JSON files - use jq for safe pretty-printing
            echo "--- Chunk $chunk_num (JSON Content) ---"
            if command -v jq >/dev/null 2>&1; then
                jq '.' "$file_path" 2>/dev/null || cat "$file_path"
            else
                echo "Warning: jq not found, using cat"
                cat "$file_path"
            fi
            ;;

        ipynb)
            # Jupyter notebooks - use jq for structured display
            echo "--- Chunk $chunk_num (Jupyter Notebook) ---"
            if command -v jq >/dev/null 2>&1; then
                jq '.cells[] | {cell_type: .cell_type, source: .source[0:5]}' "$file_path" 2>/dev/null || {
                    echo "Warning: jq processing failed, showing raw content"
                    head -50 "$file_path"
                }
            else
                echo "Warning: jq not found, showing first 50 lines"
                head -50 "$file_path"
            fi
            ;;

        db)
            # Database files - use sqlite3 for schema and sample data
            echo "--- Chunk $chunk_num (Database Schema) ---"
            if command -v sqlite3 >/dev/null 2>&1; then
                echo "Database schema:"
                sqlite3 "$file_path" ".schema" 2>/dev/null || {
                    echo "Warning: Cannot read as SQLite database, showing file info"
                    file "$file_path"
                    head -20 "$file_path"
                }
            else
                echo "Warning: sqlite3 not found, showing file info"
                file "$file_path"
                head -20 "$file_path"
            fi
            ;;

        *)
            # Unknown file types - safe fallback to head/tail
            echo "--- Chunk $chunk_num (File type: $file_ext) ---"
            echo "Unknown file type, showing first 1000 bytes:"
            head -c 1000 "$file_path" || echo "Cannot read file content"
            ;;
    esac
}

# Interactive processing loop
for ((chunk=1; chunk<=CHUNKS; chunk++)); do
    echo "Processing chunk $chunk of $CHUNKS..."
    display_chunk "$chunk" "$FILE_EXT" "$FILE_PATH"

    echo ""
    echo "--- End of Chunk $chunk ---"
    echo ""

    # Ask user what they want to do
    while true; do
        echo "Choose action:"
        echo "1. Mark as complete and continue"
        echo "2. Skip this chunk (no update)"
        echo "3. Review again"
        echo "4. Exit processing"
        read -p "Enter choice (1-4): " choice

        case $choice in
            1)
                echo "Updating tracking document..."
                update_checkbox "$chunk" "$FILENAME"
                break
                ;;
            2)
                echo "Skipping chunk $chunk (no update)"
                break
                ;;
            3)
                echo "Re-displaying chunk $chunk..."
                display_chunk "$chunk" "$FILE_EXT" "$FILE_PATH"
                echo ""
                echo "--- End of Chunk $chunk ---"
                echo ""
                continue
                ;;
            4)
                echo "Exiting processing..."
                echo "Use the script again to resume from chunk $chunk"
                exit 0
                ;;
            *)
                echo "Invalid choice. Please enter 1-4."
                ;;
        esac
    done

    if [ "$chunk" -lt "$CHUNKS" ]; then
        echo ""
        echo "Moving to next chunk in 2 seconds..."
        sleep 2
        echo ""
    else
        echo "Reached end of file processing."
    fi
done

echo ""
echo "=== Processing Complete for $FILENAME ==="
echo "All chunks processed and tracking document updated automatically."