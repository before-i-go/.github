#!/bin/bash

# auto-discover.sh - Intelligent file discovery for zero-effort processing
# Automatically finds, prioritizes, and generates processing plans for the best files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Intelligent File Discovery ===${NC}"
echo ""

# Configuration
MAX_SUGGESTIONS=5
MIN_FILE_SIZE=100  # Skip files smaller than 100 bytes
MAX_FILE_SIZE=10485760  # Warn about files larger than 10MB

# Function to calculate file priority score
calculate_priority() {
    local file="$1"
    local filename=$(basename "$file")
    local ext="${filename##*.}"
    local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")

    local score=0

    # File type scoring
    case "$ext" in
        md)  score=$((score + 30)) ;;  # Markdown is high value
        json) score=$((score + 25)) ;; # JSON often contains structured insights
        txt)  score=$((score + 15)) ;;  # Text files can be valuable
        ipynb) score=$((score + 20)) ;; # Notebooks often have analysis
        sh)   score=$((score + 5)) ;;   # Scripts are lower priority
        log)  score=$((score + 5)) ;;   # Logs are lowest priority
    esac

    # Filename keyword scoring
    local filename_lower=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
    case "$filename_lower" in
        *rust*)         score=$((score + 40)) ;;
        *async*)        score=$((score + 35)) ;;
        *architecture*)  score=$((score + 35)) ;;
        *performance*)   score=$((score + 30)) ;;
        *pattern*)       score=$((score + 25)) ;;
        *insight*)       score=$((score + 25)) ;;
        *concept*)       score=$((score + 20)) ;;
        *guide*)         score=$((score + 20)) ;;
        *best*)          score=$((score + 15)) ;;
        *practice*)      score=$((score + 15)) ;;
        *warp*)          score=$((score + 10)) ;;
        *ai*)            score=$((score + 10)) ;;
    esac

    # Size scoring (prefer moderate sizes)
    if [ "$size" -gt "$MIN_FILE_SIZE" ] && [ "$size" -lt 1048576 ]; then
        score=$((score + 10))  # Good size
    elif [ "$size" -gt 10485760 ]; then
        score=$((score - 5))   # Too large, slight penalty
    fi

    # Path scoring (prefer certain directories)
    case "$file" in
        *RawInput*research*) score=$((score + 15)) ;;
        *RawInput*interview*) score=$((score + 15)) ;;
        *research*) score=$((score + 10)) ;;
        *docs*) score=$((score + 5)) ;;
    esac

    echo "$score"
}

# Function to format file size
format_size() {
    local size=$1
    if [ "$size" -lt 1024 ]; then
        echo "${size}B"
    elif [ "$size" -lt 1048576 ]; then
        echo "$((size / 1024))KB"
    else
        echo "$((size / 1048576))MB"
    fi
}

# Function to suggest next file ID
suggest_next_id() {
    local tracking_file="$1"
    if [[ -f "$tracking_file" ]]; then
        # Find the highest existing ID in the tracking file
        local last_id=$(grep -o '[0-9]\+\.[0-9]\+' "$tracking_file" | sort -V | tail -1 | cut -d'.' -f1)
        if [[ -n "$last_id" ]]; then
            echo "$((last_id + 1)).01"
        else
            echo "2.01"
        fi
    else
        echo "2.01"
    fi
}

# Find candidate files
echo -e "${YELLOW}Scanning repository for high-value files...${NC}"
echo ""

# Get all relevant files, excluding documentation and system files
candidate_files=$(find .. -name "*.md" -o -name "*.json" -o -name "*.txt" -o -name "*.ipynb" | \
    grep -v "WIP202509" | \
    grep -v "file-snapshots" | \
    grep -v ".git" | \
    head -20)

# Score and sort files
echo "Evaluating files by priority..."
echo ""

file_scores=""
for file in $candidate_files; do
    if [[ -f "$file" ]]; then
        size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")
        if [ "$size" -ge "$MIN_FILE_SIZE" ]; then
            score=$(calculate_priority "$file")
            file_scores="${file_scores}${score}|${file}|${size}\n"
        fi
    fi
done

# Sort by score (highest first) and take top suggestions
top_files=$(echo -e "$file_scores" | sort -nr | head -n "$MAX_SUGGESTIONS")

if [[ -z "$top_files" ]]; then
    echo -e "${RED}No suitable files found for processing.${NC}"
    exit 1
fi

# Display results
echo -e "${GREEN}=== Top File Recommendations ===${NC}"
echo ""

suggestion_num=1
tracking_file="../A01SummaryProgress20250920.md"  # Default location
next_id=$(suggest_next_id "$tracking_file")

echo "$top_files" | while IFS='|' read -r score file size; do
    if [[ -n "$file" ]]; then
        filename=$(basename "$file")
        ext="${filename##*.}"
        size_fmt=$(format_size "$size")

        echo -e "${GREEN}Suggestion $suggestion_num:${NC} ${BLUE}$filename${NC} (${YELLOW}$size_fmt${NC})"
        echo -e "  Path: ${file}"
        echo -e "  Priority Score: ${score}/100"
        echo -e "  Type: ${ext}"

        # Generate command
        echo -e "  ${BLUE}Command:${NC} ./tracker.sh $next_id \"$file\""

        # Size warning
        if [ "$size" -gt "$MAX_FILE_SIZE" ]; then
            echo -e "  ${YELLOW}⚠️  Large file - may take longer to process${NC}"
        fi

        echo ""

        next_id="$(( $(echo "$next_id" | cut -d'.' -f1) + 1 )).01"
        suggestion_num=$((suggestion_num + 1))
    fi
done

echo -e "${BLUE}=== Quick Start Command ===${NC}"
echo -e "Choose any file above and run:"
echo -e "${YELLOW}./tracker.sh [ID] [file-path]${NC}"
echo ""
echo -e "${BLUE}=== Fully Automated Option ===${NC}"
echo -e "To process the top file automatically:"
echo -e "${YELLOW}./auto-discover.sh --auto${NC}"
echo ""

# Auto-process if requested
if [[ "$1" == "--auto" ]]; then
    echo -e "${GREEN}Auto-processing top file...${NC}"
    top_file=$(echo "$top_files" | head -n 1 | cut -d'|' -f2)
    auto_id=$(suggest_next_id "$tracking_file")

    if [[ -n "$top_file" ]]; then
        echo -e "${BLUE}Running: ./tracker.sh $auto_id \"$top_file\"${NC}"
        ./tracker.sh "$auto_id" "$top_file"

        echo ""
        echo -e "${GREEN}✅ Plan generated!${NC}"
        echo -e "${YELLOW}Next step: ./auto-tracker.sh \"$top_file\" \"$tracking_file\"${NC}"
    fi
fi