#!/bin/bash

# ---
# A script to generate a structured Markdown task plan for analyzing files or folders.
# It breaks down files into main tasks and subtasks based on line numbers.
# For folders, it creates tasks for each file within the folder structure.
#
# Usage: ./generate_plan.sh <source_path> <topics_file> <output_md_file>
#
# Arguments:
#   <source_path>     : The path to the file or folder you want to analyze.
#   <topics_file>     : A text file containing a topic for each main task, one topic per line.
#   <output_md_file>  : The name of the Markdown file to be created.
# ---

# --- Configuration ---
# You can change these values to adjust the task breakdown.
MAIN_TASK_CHUNK_SIZE=1000
SUB_TASK_CHUNK_SIZE=100

# --- Argument Validation ---
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <source_path> <topics_file> <output_md_file>"
    exit 1
fi

SOURCE_PATH="$1"
TOPICS_FILE="$2"
OUTPUT_FILE="$3"

if [ ! -e "$SOURCE_PATH" ]; then
    echo "Error: Source path '$SOURCE_PATH' not found."
    exit 1
fi

if [ ! -f "$TOPICS_FILE" ]; then
    echo "Error: Topics file '$TOPICS_FILE' not found."
    exit 1
fi

# --- Helper Functions ---
get_file_list() {
    local path="$1"
    if [ -f "$path" ]; then
        echo "$path"
    elif [ -d "$path" ]; then
        find "$path" -type f \( -name "*.txt" -o -name "*.md" -o -name "*.py" -o -name "*.js" -o -name "*.sh" -o -name "*.c" -o -name "*.cpp" -o -name "*.java" -o -name "*.html" -o -name "*.css" \) | sort
    fi
}

calculate_total_tasks() {
    local files=("$@")
    local total_tasks=0
    
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            local lines=$(wc -l < "$file" 2>/dev/null || echo 0)
            local file_tasks=$(( (lines + MAIN_TASK_CHUNK_SIZE - 1) / MAIN_TASK_CHUNK_SIZE ))
            total_tasks=$((total_tasks + file_tasks))
        fi
    done

    echo $total_tasks
}

# --- Get File List ---
mapfile -t FILES < <(get_file_list "$SOURCE_PATH")

if [ ${#FILES[@]} -eq 0 ]; then
    echo "Error: No analyzable files found in '$SOURCE_PATH'."
    exit 1
fi

# --- Calculations ---
TOTAL_TASKS=$(calculate_total_tasks "${FILES[@]}")

# Read topics from the topics file into an array
mapfile -t TOPICS < "$TOPICS_FILE"
NUM_TOPICS=${#TOPICS[@]}

if [ "$NUM_TOPICS" -lt "$TOTAL_TASKS" ]; then
    echo "Error: Not enough topics in '$TOPICS_FILE'."
    echo "Found $NUM_TOPICS topics, but need $TOTAL_TASKS for the files in '$SOURCE_PATH'."
    exit 1
fi

# --- File Generation ---

# Create or overwrite the output file
# Write the static header content using a 'here document'
cat > "$OUTPUT_FILE" << EOF
# Implementation Plan

## Overview

This implementation plan provides $TOTAL_TASKS main tasks to systematically analyze the path '$SOURCE_PATH'. Each main task covers approximately $MAIN_TASK_CHUNK_SIZE lines with subtasks of $SUB_TASK_CHUNK_SIZE lines each.

### Files to Analyze:
EOF

for file in "${FILES[@]}"; do
    LINES=$(wc -l < "$file" 2>/dev/null || echo 0)
    echo "- \`$file\` ($LINES lines)" >> "$OUTPUT_FILE"
done

cat >> "$OUTPUT_FILE" << EOF

## Task Execution Guidelines

### For Each Task:
1. **Read the assigned line range** from the specified file
2. **Analyze content** for key concepts, logic, or sections.
3. **Create diagrams/notes** (if needed) in a dedicated directory.
4. **Update this file** - Mark tasks complete with \`[x]\`.
5. **Document findings** - Note important details and observations.

### Quality Standards:
- Cross-reference with original source text for accuracy.
- Update progress tracking after every single task completion.
- Maintain consistent and clear documentation.

### Success Criteria:
- All $TOTAL_TASKS main tasks are completed and tracked in this file.
- Key sections of all source files are well-documented.
- A comprehensive understanding of the codebase/content is achieved.

## File Analysis Tasks

EOF

# --- Main Loop for Tasks ---
TASK_COUNTER=1
TOPIC_INDEX=0

for file in "${FILES[@]}"; do
    if [ ! -f "$file" ]; then
        continue
    fi
    
    TOTAL_LINES=$(wc -l < "$file" 2>/dev/null || echo 0)
    
    if [ $TOTAL_LINES -eq 0 ]; then
        continue
    fi
    
    NUM_MAIN_TASKS=$(( (TOTAL_LINES + MAIN_TASK_CHUNK_SIZE - 1) / MAIN_TASK_CHUNK_SIZE ))
    
    echo "### File: \`$file\` ($TOTAL_LINES lines)" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    CURRENT_LINE=1
    for i in $(seq 1 $NUM_MAIN_TASKS); do
        MAIN_TASK_START=$CURRENT_LINE
        MAIN_TASK_END=$((CURRENT_LINE + MAIN_TASK_CHUNK_SIZE - 1))

        # Adjust the end line for the very last task
        if [ $MAIN_TASK_END -gt $TOTAL_LINES ]; then
            MAIN_TASK_END=$TOTAL_LINES
        fi

        # Get the corresponding topic from the array
        TOPIC="${TOPICS[$TOPIC_INDEX]}"

        # Write main task to the markdown file
        echo "- [ ] $TASK_COUNTER. Analyze Lines $MAIN_TASK_START-$MAIN_TASK_END in \`$file\` ($TOPIC)" >> "$OUTPUT_FILE"

        # --- Nested Loop for Sub-Tasks ---
        SUB_TASK_LINE_START=$MAIN_TASK_START
        for j in $(seq 1 $((MAIN_TASK_CHUNK_SIZE / SUB_TASK_CHUNK_SIZE))); do
            # Stop creating sub-tasks if we've passed the end of the file
            if [ $SUB_TASK_LINE_START -gt $MAIN_TASK_END ]; then
                break
            fi

            SUB_TASK_LINE_END=$((SUB_TASK_LINE_START + SUB_TASK_CHUNK_SIZE - 1))

            # Adjust sub-task end line if it goes past the main task's end
            if [ $SUB_TASK_LINE_END -gt $MAIN_TASK_END ]; then
                SUB_TASK_LINE_END=$MAIN_TASK_END
            fi

            echo "  - [ ] $TASK_COUNTER.$j Lines $SUB_TASK_LINE_START-$SUB_TASK_LINE_END" >> "$OUTPUT_FILE"

            SUB_TASK_LINE_START=$((SUB_TASK_LINE_END + 1))
        done

        echo "" >> "$OUTPUT_FILE" # Add a blank line for readability
        CURRENT_LINE=$((MAIN_TASK_END + 1))
        TASK_COUNTER=$((TASK_COUNTER + 1))
        TOPIC_INDEX=$((TOPIC_INDEX + 1))
    done
done

echo "✅ Successfully generated task plan in '$OUTPUT_FILE'."