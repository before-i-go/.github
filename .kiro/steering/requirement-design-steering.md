# Requirement-Design Steering Document

## Overall Objective

**PRIMARY GOAL**: Ideate on high-quality open source Rust libraries and tools with:
- **High Ease of Testing Scores** (8-10/10): Clear input/output validation, deterministic behavior, comprehensive testability
- **High PMF Probability** (8-10/10): Strong product-market fit, addressing real pain points in developer ecosystem
- **High Differentiation Potential** (8-10/10): Unique value proposition, clear competitive advantages, innovative approaches

**Success Criteria**: Identify and prioritize Rust library/tool concepts that developers will actively seek out, use, and contribute to - creating sustainable open source projects with real-world impact.

## Critical Rules

### DO NOT TOUCH THE REQUIREMENTS DOCUMENT UNTIL USE CASE ANALYSIS IS COMPLETE

**IMPORTANT**: The requirements.md file must NOT be modified until the complete use case analysis is finished. This ensures we have a comprehensive understanding of all potential use cases before finalizing requirements.

## Use Case Analysis Process



### File Analysis Methodology

1. **Break down ALL files into 1000-line chunks** for systematic analysis
   - **Note**: Due to token limits, read in 250-500 line segments but process 1000 lines at a time
2. **Track progress meticulously** in use-case-analysis.md
3. **Mark irrelevant files as completed** with clear reasoning (e.g., "ADHD treatment - not relevant for programming libraries")
4. **Extract concrete use cases** from each relevant chunk with:
   - PMF Probability score (1-10)
   - Ease of Testing score (1-10)
   - Differentiation Potential score (1-10)
   - 5-line use case description
   - Parallel/similar tools for context
   AND Update it in use-case-202509.md via terminal command: `echo "[USE CASE]" >> use-case-202509.md`

### Use Case Evaluation Framework

**Scoring Criteria (1-10 scale):**

**PMF Probability:**
- 9-10: Solves critical, widespread pain points; developers actively searching for solutions
- 7-8: Addresses common problems with clear market demand
- 5-6: Nice-to-have solutions for niche audiences
- 1-4: Limited market need or novelty

**Ease of Testing:**
- 9-10: Deterministic behavior, clear inputs/outputs, easy to mock, comprehensive test coverage possible
- 7-8: Testable with some setup, manageable complexity
- 5-6: Testing possible but complex or integration-heavy
- 1-4: Difficult to test reliably, non-deterministic, complex dependencies

**Differentiation Potential:**
- 9-10: Truly innovative approach, no direct competitors, 10x improvement
- 7-8: Clear advantages over existing tools, unique features or approaches
- 5-6: Incremental improvements over existing solutions
- 1-4: Me-too products, crowded space with little differentiation

 

### File Relevance Criteria

**RELEVANT FILES** (analyze fully):
- Programming languages and frameworks (especially Rust, systems programming)
- Software development tools and practices (testing, linting, analysis)
- Performance optimization and benchmarking tools
- System programming and runtime analysis
- Web development patterns and architectures
- Database and data processing systems
- Security and compliance tools
- Developer tooling and automation
- Build systems and compilation optimization
- Memory safety and analysis tools
- Concurrency and parallel programming
- Cross-language integration and FFI

**IRRELEVANT FILES** (mark as completed with reason):
- Medical/health treatments (ADHD, trauma, yoga, etc.)
- Movie analysis and entertainment content
- Non-technical academic research
- Personal development and lifestyle content
- Non-programming related content

### Progress Tracking Requirements

- Update use-case-analysis.md after each 1000-line chunk
- Maintain accurate chunk completion counts
- Calculate and display overall progress percentage

### Completion Criteria

The use case analysis is complete when:
1. ALL the checklists in use-case-analysis.md are marked as completed
2. A comprehensive list of use cases has been compiled
3. Use cases have been ranked and categorized


**IMPORTANT**: DO NOT STOP until ALL checklists in use-case-analysis.md are completed. This is a systematic process that requires completion before any pause or final requirements definition.

**MINDSET**: Treat this as a continuous, focused analysis session. Each 1000-line chunk brings us closer to comprehensive use case identification. Maintain momentum and progress through all files systematically.

**ONLY THEN** can you pause.