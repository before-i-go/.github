# Requirement-Design Steering Document

## Critical Rules

### DO NOT TOUCH THE REQUIREMENTS DOCUMENT UNTIL USE CASE ANALYSIS IS COMPLETE

**IMPORTANT**: The requirements.md file must NOT be modified until the complete use case analysis is finished. This ensures we have a comprehensive understanding of all potential use cases before finalizing requirements.

## Use Case Analysis Process

### File Analysis Methodology

1. **Break down ALL files into 1000-line chunks** for systematic analysis
2. **Track progress meticulously** in use-case-analysis.md
3. **Mark irrelevant files as completed** with clear reasoning (e.g., "ADHD treatment - not relevant for programming libraries")
4. **Extract concrete use cases** from each relevant chunk with:
   - PMF Probability score (1-10)
   - Ease of Testing score (1-10) 
   - 5-line use case description
   - Parallel/similar tools for context

### File Relevance Criteria

**RELEVANT FILES** (analyze fully):
- Programming languages and frameworks
- Software development tools and practices
- Performance optimization and benchmarking
- System programming and runtime analysis
- Web development patterns and architectures
- Database and data processing systems
- Security and compliance tools
- Developer tooling and automation

**IRRELEVANT FILES** (mark as completed with reason):
- Medical/health treatments (ADHD, trauma, yoga, etc.)
- Movie analysis and entertainment content
- Non-technical academic research
- Personal development and lifestyle content

### Progress Tracking Requirements

- Update use-case-analysis.md after each 1000-line chunk
- Maintain accurate chunk completion counts
- Calculate and display overall progress percentage
- Group related use cases by domain/technology

### Completion Criteria

The use case analysis is complete when:
1. All 19 files have been processed (either analyzed or marked irrelevant)
2. All ~300 chunks have been reviewed
3. A comprehensive list of use cases has been compiled
4. Use cases have been ranked and categorized

**ONLY THEN** can the requirements document be updated and the design phase begin.