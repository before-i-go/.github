#!/bin/bash

# process-folder.sh - One-command folder processing
# Usage: ./process-folder.sh <folder-name> [tracking-document]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check arguments
if [ $# -lt 1 ]; then
    echo -e "${RED}Usage: $0 <folder-name> [tracking-document]${NC}"
    echo -e "${BLUE}Example: $0 RawInput202509${NC}"
    echo -e "${BLUE}Example: $0 research A01SummaryProgress20250920.md${NC}"
    exit 1
fi

FOLDER_NAME="$1"
TRACKING_DOC="${2:-A01SummaryProgress20250920.md}"

# Validate folder exists
if [ ! -d "../$FOLDER_NAME" ]; then
    echo -e "${RED}Error: Folder '../$FOLDER_NAME' not found${NC}"
    echo -e "${YELLOW}Available folders:${NC}"
    ls -d ../*/ 2>/dev/null | sed 's|../||' | sed 's|/||' | head -10
    exit 1
fi

echo -e "${BLUE}=== Folder Processing System ===${NC}"
echo -e "${GREEN}Target Folder: ${YELLOW}$FOLDER_NAME${NC}"
echo -e "${GREEN}Tracking Document: ${YELLOW}$TRACKING_DOC${NC}"
echo ""

# Find all files in the folder recursively
echo -e "${YELLOW}Scanning for files in ../$FOLDER_NAME...${NC}"
echo ""

ALL_FILES=$(find "../$FOLDER_NAME" -type f \( -name "*.md" -o -name "*.json" -o -name "*.txt" -o -name "*.ipynb" -o -name "*.sh" -o -name "*.log" \) 2>/dev/null | sort)

FILE_COUNT=$(echo "$ALL_FILES" | wc -l | tr -d ' ')

if [ "$FILE_COUNT" -eq 0 ]; then
    echo -e "${RED}No supported files found in ../$FOLDER_NAME${NC}"
    exit 1
fi

echo -e "${GREEN}Found $FILE_COUNT files to process${NC}"
echo ""

# Show sample of files to be processed
echo -e "${BLUE}First 10 files:${NC}"
echo "$ALL_FILES" | head -10 | sed 's|..||' | nl -n ln
echo ""

# Calculate next file ID
NEXT_ID="2.01"
if [[ -f "$TRACKING_DOC" ]]; then
    LAST_ID=$(grep -o '[0-9]\+\.[0-9]\+' "$TRACKING_DOC" 2>/dev/null | sort -V | tail -1 | cut -d'.' -f1)
    if [[ -n "$LAST_ID" ]] && [[ "$LAST_ID" -gt 0 ]]; then
        NEXT_ID="$((LAST_ID + 1)).01"
    fi
fi

echo -e "${BLUE}=== Processing Plan ===${NC}"
echo -e "${GREEN}Starting File ID: ${YELLOW}$NEXT_ID${NC}"
echo -e "${GREEN}Total Files: ${YELLOW}$FILE_COUNT${NC}"
echo ""

# Ask for confirmation
echo -e "${YELLOW}This will process all $FILE_COUNT files in the folder. Continue? (y/N)${NC}"
read -r response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo -e "${RED}Cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${GREEN}=== Starting Processing ===${NC}"
echo ""

# Process each file
PROCESSED=0
SKIPPED=0
ERRORS=0

CURRENT_ID="$NEXT_ID"
BASE_NUM=$(echo "$NEXT_ID" | cut -d'.' -f1)

for file in $ALL_FILES; do
    FILENAME=$(basename "$file")
    REL_PATH=${file#../}  # Remove ../ prefix

    echo -e "${BLUE}Processing: ${YELLOW}$REL_PATH${NC}"

    # Check if file already exists in tracking document
    if grep -q "$FILENAME" "$TRACKING_DOC" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  File already in tracking document - skipping${NC}"
        SKIPPED=$((SKIPPED + 1))
        echo ""
        continue
    fi

    # Generate checklist for this file
    echo -e "${GREEN}Generating processing plan...${NC}"

    if ! ./tracker.sh "$CURRENT_ID" "$file" > /dev/null; then
        echo -e "${RED}❌ Failed to generate plan for $FILENAME${NC}"
        ERRORS=$((ERRORS + 1))
        echo ""
        continue
    fi

    # Get the checklist output
    CHECKLIST=$(./tracker.sh "$CURRENT_ID" "$file" 2>/dev/null)

    # Add to tracking document
    echo "" >> "$TRACKING_DOC"
    echo "## $FOLDER_NAME - $FILENAME" >> "$TRACKING_DOC"
    echo "$CHECKLIST" >> "$TRACKING_DOC"

    echo -e "${GREEN}✅ Added to tracking document${NC}"
    echo -e "${BLUE}File ID: $CURRENT_ID${NC}"

    # Option to start processing immediately
    echo -e "${YELLOW}Start processing this file now? (y/N)${NC}"
    read -r process_response

    if [[ "$process_response" =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}Starting guided processing...${NC}"
        ./auto-tracker.sh "$file" "$TRACKING_DOC"
        echo -e "${GREEN}✅ Processing complete${NC}"
    else
        echo -e "${BLUE}Skipped immediate processing (will be in tracking document)${NC}"
    fi

    PROCESSED=$((PROCESSED + 1))

    # Increment ID for next file
    BASE_NUM=$((BASE_NUM + 1))
    CURRENT_ID="${BASE_NUM}.01"

    echo ""
    echo -e "${BLUE}=== Next File ===${NC}"
    echo ""

    # Small pause between files
    sleep 1
done

# Summary
echo ""
echo -e "${BLUE}=== Processing Complete ===${NC}"
echo -e "${GREEN}Files Processed: ${YELLOW}$PROCESSED${NC}"
echo -e "${YELLOW}Files Skipped: $SKIPPED${NC}"
echo -e "${RED}Errors: $ERRORS${NC}"
echo ""

# Show next steps
echo -e "${BLUE}=== Next Steps ===${NC}"
echo -e "${GREEN}1. Review your tracking document: ${YELLOW}$TRACKING_DOC${NC}"
echo -e "${GREEN}2. Process remaining files: ${YELLOW}./auto-tracker.sh [file] $TRACKING_DOC${NC}"
echo -e "${GREEN}3. Or process another folder: ${YELLOW}./process-folder.sh [folder-name]${NC}"
echo ""

echo -e "${GREEN}🎉 Folder processing complete!${NC}"