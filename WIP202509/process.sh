#!/bin/bash

# process.sh - Interactive file processing with tool-aware chunking
# Part of the Rust OSS Knowledge Extraction System

set -e

# Usage function
usage() {
    echo "Usage: $0 <file_path>"
    echo "  file_path: Full path to the file to process"
    echo ""
    echo "Example: $0 /path/to/your/file.md"
    exit 1
}

# Check arguments
if [ $# -ne 1 ]; then
    usage
fi

FILE_PATH="$1"

# Validate file exists
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File '$FILE_PATH' not found"
    exit 1
fi

# Get filename for display
FILENAME=$(basename "$FILE_PATH")
FILE_EXT="${FILENAME##*.}"

# Get total line count (for text-based files)
TOTAL_LINES=0
if [[ "$FILE_EXT" =~ ^(md|txt|sh|log|json)$ ]]; then
    TOTAL_LINES=$(wc -l < "$FILE_PATH" | tr -d ' ')
fi

# Calculate number of chunks
CHUNKS=1
if [ "$TOTAL_LINES" -gt 0 ]; then
    CHUNKS=$(((TOTAL_LINES + 999) / 1000))
fi

echo "=== Processing: $FILENAME ==="
echo "File Type: $FILE_EXT"
if [ "$TOTAL_LINES" -gt 0 ]; then
    echo "Total Lines: $TOTAL_LINES"
    echo "Chunks to process: $CHUNKS"
fi
echo ""

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
    display_chunk "$chunk" "$FILE_EXT" "$FILE_PATH"

    echo ""
    echo "--- End of Chunk $chunk ---"

    if [ "$chunk" -lt "$CHUNKS" ]; then
        echo "Press Enter to continue to next chunk..."
        read -r
    else
        echo "Reached end of file processing."
    fi

    echo ""
done

echo "=== Processing Complete for $FILENAME ==="