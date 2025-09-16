#!/bin/bash

# A script to find a string in various file types within a specific
# directory tree, combine the content, and split it into 1MB chunks.

# --- Configuration ---
MAX_SIZE="1M"
FILE_TYPES_TO_SEARCH="txt docx md json pdf"

# --- Functions ---
# Checks if required command-line tools are installed.
check_dependencies() {
    for cmd in pdftotext pandoc; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "Error: Required command '$cmd' is not installed." >&2
            echo "Please install it to proceed." >&2
            exit 1
        fi
    done
}

# --- Main Script ---

# 1. Validate Input (Now expects 2 arguments)
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 \"/path/to/folder\" \"<search_string>\""
    echo "Example: $0 \"/home/user/documents\" \"Project Gemini\""
    exit 1
fi

SEARCH_DIR="$1"
SEARCH_STRING="$2"

# Check if the first argument is a valid directory
if [ ! -d "$SEARCH_DIR" ]; then
    echo "Error: The specified path is not a directory: $SEARCH_DIR" >&2
    exit 1
fi

# Sanitize the search string to create a safe filename prefix.
FILENAME_PREFIX=$(echo "$SEARCH_STRING" | tr -c '[:alnum:]' '_')

# 2. Check for Dependencies
check_dependencies

# 3. Initialize Temporary Files & Logging
TEMP_CONTENT_FILE=$(mktemp)
COMBINED_OUTPUT_FILE=$(mktemp)
LOG_FILE="found_files.log"

# Set up a trap to automatically clean up temp files when the script exits.
trap 'rm -f "$TEMP_CONTENT_FILE" "$COMBINED_OUTPUT_FILE"' EXIT

# Clear the log file from any previous runs.
> "$LOG_FILE"

echo "🔎 Searching for: \"$SEARCH_STRING\" in '$SEARCH_DIR' and all its subfolders..."
echo "Matching file names will be logged in '$LOG_FILE'."
echo "-----------------------------------------"

found_count=0

# 4. Build the 'find' command's name patterns
# This creates a list of patterns like: -iname "*.txt" -o -iname "*.docx" ...
find_patterns=()
for ext in $FILE_TYPES_TO_SEARCH; do
    find_patterns+=(-o -iname "*.$ext")
done
unset find_patterns[0] # Remove the first '-o'

# 5. Use 'find' to locate files and pipe them into a 'while' loop for processing
# This is the safest way to handle filenames with special characters.
find "$SEARCH_DIR" -type f \( "${find_patterns[@]}" \) -print0 | while IFS= read -r -d '' file; do
    echo "Processing: $file"
    > "$TEMP_CONTENT_FILE"

    case "${file##*.}" in
        txt|md|json)
            cat "$file" > "$TEMP_CONTENT_FILE"
            ;;
        pdf)
            if ! pdftotext "$file" "$TEMP_CONTENT_FILE"; then
                echo "  -> ⚠️ Warning: Failed to extract text from PDF '$file'." >&2
                continue
            fi
            ;;
        docx)
            if ! pandoc "$file" -t plain -o "$TEMP_CONTENT_FILE"; then
                echo "  -> ⚠️ Warning: Failed to extract text from DOCX '$file'." >&2
                continue
            fi
            ;;
    esac

    if grep -q -F -- "$SEARCH_STRING" "$TEMP_CONTENT_FILE"; then
        echo "  -> ✅ Found string in '$file'. Appending its content."
        echo "$file" >> "$LOG_FILE"
        cat "$TEMP_CONTENT_FILE" >> "$COMBINED_OUTPUT_FILE"
        ((found_count++))
    else
        echo "  -> ❌ String not found."
    fi
done

# 6. Split the Combined Content into Final Files
if [ "$found_count" -gt 0 ]; then
    echo "-----------------------------------------"
    echo "Found string in $found_count file(s). Now splitting the combined content..."
    
    SPLIT_DIR=$(mktemp -d)
    split -b "$MAX_SIZE" -d -a 3 "$COMBINED_OUTPUT_FILE" "${SPLIT_DIR}/${FILENAME_PREFIX}-part"

    for part_file in "${SPLIT_DIR}"/*; do
        suffix=$(basename "$part_file" | sed "s/.*-part//")
        new_suffix_num=$((10#$suffix + 1))
        new_suffix=$(printf "%03d" "$new_suffix_num")
        mv "$part_file" "${FILENAME_PREFIX}-part${new_suffix}.txt"
        echo "Created: ${FILENAME_PREFIX}-part${new_suffix}.txt"
    done
    rmdir "$SPLIT_DIR"

    echo "-----------------------------------------"
    echo "🎉 Script finished successfully!"
else
    echo "-----------------------------------------"
    echo "Search complete. The string was not found in any files."
fi

exit 0

# ./search_and_split.sh "/Users/yourname/Desktop/Project Files" "confidential report"