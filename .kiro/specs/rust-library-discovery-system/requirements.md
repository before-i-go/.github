# Requirements Document

## Introduction

This feature implements the SOPv1 methodology for systematic discovery of high-PMF (Product-Market Fit), easy-to-test Rust libraries. The system transforms raw research content into prioritized Rust library concepts through automated analysis, targeting libraries with 8-10/10 scores in Testing Ease, PMF Probability, and Differentiation Potential. The core mission is to create a ranked list of Rust library concepts that developers actively seek, use, and contribute to - enabling sustainable open source projects with real-world impact.

## Requirements

### Requirement 1: Research Lot Organization System

**User Story:** As a researcher, I want to organize raw research content into structured research lots, so that I can systematically analyze large volumes of content without losing track of progress or duplicating work.

#### Acceptance Criteria

1. WHEN a new research lot is created THEN the system SHALL create the standard directory structure (TxtInput##/, NonTxtInput##/, Progress##/, Output##/, Duplicates##/)
2. WHEN files are added to a research lot THEN the system SHALL automatically categorize them by file type (txt, docx, pdf, html, json, md)
3. WHEN duplicate files are detected THEN the system SHALL move duplicates to Duplicates##/ directory and keep the file with the shortest name
4. WHEN file conversion is needed THEN the system SHALL convert non-txt files to standardized .txt format with clear naming convention (filename_from_extension.txt)
5. WHEN organization is complete THEN the system SHALL generate accurate file counts and repository statistics

### Requirement 2: Duplicate Detection and Deduplication

**User Story:** As a researcher, I want to automatically detect and handle duplicate content, so that I don't waste time analyzing the same information multiple times.

#### Acceptance Criteria

1. WHEN duplicate detection runs THEN the system SHALL generate MD5 hashes for all files in the research lot
2. WHEN duplicate hashes are found THEN the system SHALL identify all files with matching content
3. WHEN handling duplicates THEN the system SHALL keep the file with the shortest filename and move others to Duplicates##/
4. WHEN deduplication is complete THEN the system SHALL report the number of duplicates removed and files retained
5. WHEN verification is needed THEN the system SHALL provide commands to validate the deduplication results

### Requirement 3: Content Analysis Task Generation

**User Story:** As a researcher, I want to automatically generate systematic analysis tasks for large content files, so that I can process content in manageable chunks without missing any sections.

#### Acceptance Criteria

1. WHEN task generation runs THEN the system SHALL create 1000-line chunk analysis tasks for each file
2. WHEN a file has more than 1000 lines THEN the system SHALL break it into sequential 1000-line segments
3. WHEN the final chunk is less than 1000 lines THEN the system SHALL create a task for the remaining lines
4. WHEN tasks are generated THEN the system SHALL create checkboxes for progress tracking
5. WHEN task list is complete THEN the system SHALL verify file counts match between directory and task list

### Requirement 4: Progress Tracking System

**User Story:** As a researcher, I want to track my analysis progress across all files and chunks, so that I can see completion status and resume work efficiently.

#### Acceptance Criteria

1. WHEN progress is updated THEN the system SHALL use terminal commands to update tracking files
2. WHEN chunk analysis is completed THEN the system SHALL mark the corresponding checkbox as complete
3. WHEN progress is queried THEN the system SHALL report completed chunks, remaining chunks, and overall percentage
4. WHEN monitoring is needed THEN the system SHALL provide repository status through tree-with-wc.sh script
5. WHEN manual editing is attempted THEN the system SHALL prevent direct editing of tracking files

### Requirement 5: Content Analysis and Scoring

**User Story:** As a researcher, I want to analyze content chunks and score library concepts on three dimensions, so that I can identify the most promising Rust library opportunities.

#### Acceptance Criteria

1. WHEN analyzing content THEN the system SHALL filter for programming-relevant content and skip non-technical material
2. WHEN a library concept is identified THEN the system SHALL score it on PMF Probability (1-10 scale)
3. WHEN a library concept is identified THEN the system SHALL score it on Ease of Testing (1-10 scale)
4. WHEN a library concept is identified THEN the system SHALL score it on Differentiation Potential (1-10 scale)
5. WHEN scoring is complete THEN the system SHALL append findings to the research lot output file

### Requirement 6: Results Compilation and Ranking

**User Story:** As a researcher, I want to compile and rank all discovered library concepts, so that I can prioritize development efforts on the most promising opportunities.

#### Acceptance Criteria

1. WHEN analysis is complete THEN the system SHALL compile all use cases into a comprehensive list
2. WHEN compilation runs THEN the system SHALL rank concepts by their combined scores across all three dimensions
3. WHEN ranking is complete THEN the system SHALL categorize concepts by score ranges (8-10, 7-8, 5-6, 1-4)
4. WHEN results are generated THEN the system SHALL create a final ranked list in the Output##/ directory
5. WHEN synthesis is needed THEN the system SHALL provide summary statistics and top recommendations

### Requirement 7: Repository Monitoring and Validation

**User Story:** As a researcher, I want to monitor repository status and validate data integrity, so that I can ensure the analysis process is working correctly and no data is lost.

#### Acceptance Criteria

1. WHEN monitoring is requested THEN the system SHALL provide accurate file counts across all directories
2. WHEN validation runs THEN the system SHALL verify file accessibility and readability
3. WHEN checking integrity THEN the system SHALL identify empty files and report their status
4. WHEN verification is needed THEN the system SHALL confirm task list accuracy against actual file structure
5. WHEN status is queried THEN the system SHALL provide comprehensive repository statistics

### Requirement 8: Scalable Research Lot System

**User Story:** As a researcher, I want to create multiple research lots using the same methodology, so that I can analyze different content batches while maintaining consistency and learning from previous iterations.

#### Acceptance Criteria

1. WHEN a new research lot is created THEN the system SHALL follow the established SOPv1 methodology
2. WHEN multiple research lots exist THEN the system SHALL maintain separate progress tracking for each
3. WHEN methodology evolves THEN the system SHALL support SOPv2, SOPv3 iterations while preserving previous work
4. WHEN scaling up THEN the system SHALL handle increasing volumes of content without performance degradation
5. WHEN lessons are learned THEN the system SHALL capture insights for methodology refinement