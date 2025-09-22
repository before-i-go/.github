#!/usr/bin/env python3
"""
Final script to fix ALL task formatting consistency in tasks.md file.

This script ensures consistent numbering format across all task files:
- Main tasks: "- [ ] X. Analyze filename"
- Sub-tasks: "  - [ ] X.Y Lines A-B: Content analysis needed" (2 spaces)
- Nested sub-tasks: "    - [ ] X.Y Lines A-B: Content analysis needed" (4 spaces)

Usage: python3 fix_task_formatting_final.py
(Run from the directory containing .kiro/specs/rust-library-discovery-system/tasks.md)
"""

import re

def fix_all_formatting(content):
    lines = content.split('\n')
    result = []
    current_main_task = 0
    in_file_analysis = False
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # Check if we're in the file analysis section
        if "## File Analysis Tasks" in line:
            in_file_analysis = True
            result.append(line)
            i += 1
            continue
            
        if not in_file_analysis:
            result.append(line)
            i += 1
            continue
            
        # Match main task pattern: "- [ ] X. Analyze filename"
        main_task_match = re.match(r'^- \[ \] (\d+)\. Analyze (.+)$', line)
        if main_task_match:
            current_main_task = int(main_task_match.group(1))
            result.append(line)
            
            # Now process all the subtasks for this main task
            i += 1
            subtask_counter = 0
            
            # Continue processing lines until we hit the next main task or end
            while i < len(lines):
                next_line = lines[i]
                
                # Check if this is the start of the next main task
                if re.match(r'^- \[ \] \d+\. Analyze', next_line):
                    break
                    
                # Check if this is a subtask line that needs numbering (2 spaces)
                subtask_match = re.match(r'^  - \[ \] (?:\d+\.\d+ )?(Lines \d+-\d+: Content analysis needed)$', next_line)
                if subtask_match:
                    subtask_counter += 1
                    new_line = f"  - [ ] {current_main_task}.{subtask_counter} {subtask_match.group(1)}"
                    result.append(new_line)
                    i += 1
                    continue
                    
                # Check for nested subtasks (4 spaces)
                nested_subtask_match = re.match(r'^    - \[ \] (?:\d+\.\d+ )?(Lines \d+-\d+: Content analysis needed)$', next_line)
                if nested_subtask_match:
                    subtask_counter += 1
                    new_line = f"    - [ ] {current_main_task}.{subtask_counter} {nested_subtask_match.group(1)}"
                    result.append(new_line)
                    i += 1
                    continue
                    
                # Check for deeply nested subtasks (6 spaces) - for complex hierarchies
                deep_nested_match = re.match(r'^      - \[ \] (?:\d+\.\d+ )?(Lines \d+-\d+: Content analysis needed)$', next_line)
                if deep_nested_match:
                    subtask_counter += 1
                    new_line = f"      - [ ] {current_main_task}.{subtask_counter} {deep_nested_match.group(1)}"
                    result.append(new_line)
                    i += 1
                    continue
                    
                # Check for extra deep nested subtasks (8 spaces) - for very complex hierarchies
                extra_deep_match = re.match(r'^        - \[ \] (?:\d+\.\d+ )?(Lines \d+-\d+: Content analysis needed)$', next_line)
                if extra_deep_match:
                    subtask_counter += 1
                    new_line = f"        - [ ] {current_main_task}.{subtask_counter} {extra_deep_match.group(1)}"
                    result.append(new_line)
                    i += 1
                    continue
                    
                # For any other line, just add it as-is
                result.append(next_line)
                i += 1
            continue
            
        # If we get here, just add the line as-is
        result.append(line)
        i += 1
    
    return '\n'.join(result)

def main():
    # Read the current tasks.md file
    try:
        with open('.kiro/specs/rust-library-discovery-system/tasks.md', 'r') as f:
            content = f.read()
    except FileNotFoundError:
        print("Error: Could not find .kiro/specs/rust-library-discovery-system/tasks.md")
        print("Make sure you're running this script from the correct directory.")
        return
    
    # Apply fixes
    fixed_content = fix_all_formatting(content)
    
    # Write back the fixed content
    with open('.kiro/specs/rust-library-discovery-system/tasks.md', 'w') as f:
        f.write(fixed_content)
    
    print("All task formatting fixed successfully!")
    print("✅ Main tasks: - [ ] X. Analyze filename")
    print("✅ Sub-tasks: - [ ] X.Y Lines A-B: Content analysis needed")
    print("✅ Nested sub-tasks: - [ ] X.Y Lines A-B: Content analysis needed")

if __name__ == "__main__":
    main()