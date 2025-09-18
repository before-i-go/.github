# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a personal knowledge repository containing research notes, documentation, and learning materials. The repository is organized as a documentation archive with structured folders containing:

- **RawNotes202508/**: Original notes and research documents
- **JsonFiles202508/**: JSON data files and extracted content from various sources
- **Prana20250913/**: NSDR (Non-Sleep Deep Rest) and wellness documentation
- **InterviewPrep202509/**: Technical interview preparation materials, particularly Rust-focused
- **searchSplitQueries202509/**: Scripts and tools for text processing and content extraction

The repository represents a comprehensive knowledge base with a focus on Rust programming language research, systems programming concepts, and personal development materials.

## Common Development Tasks

### Text Processing and Content Extraction

**Search and combine files with content splitting:**
```bash
# Use the main search script to find content and split into manageable chunks
./searchSplit202509.sh "/path/to/search" "search term"

# This script will:
# - Search through txt, docx, md, json, pdf files
# - Extract text content using pandoc/pdftotext
# - Combine matching content and split into 1MB chunks
# - Log found files to found_files.log
```

**Copy unique Rust-related content:**
```bash
# Extract and deduplicate Rust-related files
bash -c '
dest="/home/amuldotexe/Desktop/before-I-go/.github/JsonFiles202508"
user="${SUDO_USER:-$USER}"
mkdir -p "$dest"
declare -A seen
while IFS= read -r -d "" f; do
  [[ -r "$f" ]] || continue
  h=$(sha256sum -- "$f" | cut -d" " -f1) || continue
  [[ ${seen[$h]+x} ]] && continue
  seen[$h]=1
  base=$(basename -- "$f")
  ext="${base##*.}"
  name="${base%.*}"
  target="$dest/$base"
  [[ -e "$target" ]] && target="$dest/${name}__${h:0:12}.$ext"
  cp --preserve=timestamps -- "$f" "$target"
done < <(
  find / \( -path "$dest" -o -path "$dest/*" \) -prune -o \
           -type f \( -iname "*Rust*.md" -o -name "*trun*.json" \) -print0 2>/dev/null
)
chown -R "$user":"$user" "$dest"
'
```

### Working with Research Content

**Analyze content structure:**
```bash
# Count lines in large files before processing
wc -l path/to/file.txt

# Read specific line ranges for systematic analysis
sed -n '1,250p' path/to/file.txt  # Read first 250 lines
sed -n '251,500p' path/to/file.txt  # Read next 250 lines

# Search for specific patterns in JSON files
rg -n -o -P '"(pattern_name|strategy_name|technique_name)"\s*:\s*"[^"]+"' file.json
```

## Repository Architecture

### Directory Structure Philosophy

The repository follows a date-based organizational system with semantic prefixes:

- **Date suffixes (202508, 202509, etc.)**: Indicate when content was collected/created
- **Semantic prefixes**: Indicate content type (Raw, Json, Prana, InterviewPrep, etc.)
- **Mixed content types**: Each directory may contain various formats (.md, .json, .txt, .ipynb, etc.)

### Content Processing Methodology

The repository implements a "Minto Pyramid + Chunked Streaming" approach for handling large documents:

1. **Streaming Processing**: Read files in 250-line windows to manage terminal output limits
2. **MECE Structure**: Organize content with Mutually Exclusive, Collectively Exhaustive categories
3. **Synthesis**: Extract concepts, patterns, and key information systematically
4. **Deduplication**: Normalize names and merge synonyms to avoid content repetition

### Key Content Areas

**Rust Programming Research:**
- Comprehensive coverage from language foundations to advanced systems programming
- Memory management concepts (ownership, borrowing, lifetimes)
- Trait system and generics
- Collections, error handling, and async programming
- Systems programming and embedded development
- Comparison with other languages (C++, Go, Python)

**Wellness and Personal Development:**
- NSDR (Non-Sleep Deep Rest) research and techniques
- Scientific hypotheses about meditation and deep rest practices
- Neuroplasticity and stress management concepts

**Technical Interview Preparation:**
- Rust-specific interview questions and concepts
- Systems design patterns and architectural concepts
- Anti-patterns and best practices

### Git Workflow

The repository uses a simple commit pattern with generic commit messages ("Avengers Assemble! Placeholder message"). Content is organized by date and topic rather than traditional software development branches.

## Key Dependencies

### Required Tools for Content Processing

- **pandoc**: For converting DOCX files to plain text
- **pdftotext**: For extracting text from PDF files  
- **jq**: For processing JSON files (optional but recommended)
- **rg (ripgrep)**: For efficient text searching across files

### Installation Commands

```bash
# Ubuntu/Debian
sudo apt install pandoc poppler-utils jq ripgrep

# macOS (via Homebrew)
brew install pandoc poppler jq ripgrep
```

## Working with Large Files

When processing large research documents:

1. Always read in fixed 250-line windows to respect terminal limits
2. Track progress with line range markers (e.g., "processed 1-250, next: 251-500")
3. Use the systematic extraction approach defined in `Summarization_Method.md`
4. Maintain state in memory/editor rather than creating per-chunk notes
5. Generate consolidated output tables rather than fragmented notes

## Content Extraction Patterns

Look for these key patterns when analyzing research content:

- **JSON-like structures**: `pattern_name`, `strategy_name`, `technique_name`
- **Technical concepts**: Architecture, Data, Distributed Systems, Reliability, Security
- **Rust-specific terms**: ownership, borrowing, traits, lifetimes, async/await
- **Research methodologies**: Hypotheses, known science, speculative mechanisms

This repository serves as a comprehensive knowledge base that combines technical learning with personal development research, optimized for systematic content extraction and analysis.