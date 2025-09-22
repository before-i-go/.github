# Deterministic Code Graphs: The 1% Context Revolution for LLM-Driven Development

## Executive Summary

This report outlines the master blueprint for Project AIM/ISG, a strategic imperative designed to overcome the fundamental limitations of Large Language Models (LLMs) in software development. Current probabilistic methods, such as Retrieval-Augmented Generation (RAG), treat code as unstructured text, creating a "Stochastic Fog" of guesswork and hallucination that is unscalable and unreliable. The AIM/ISG framework executes a paradigm shift to **deterministic navigation**, transforming the LLM from a probabilistic guesser into a precise architectural reasoner. By representing the entire codebase as a radically compressed, machine-traversable graph, we unlock unprecedented accuracy, context efficiency, and real-time intelligence for AI-driven development.

### Radical Compression Unlocks Global Context for LLMs
The Interface Signature Graph (ISG) condenses a repository's full architectural structure by over **95%**, allowing the entire map to fit into approximately **1%** of a standard 32k-token context window. This frees up **99%** of the LLM's attention for high-quality, localized code generation while maintaining complete global awareness. The strategic implication is a shift in prompting patterns to an "ISG + local diff" model, maximizing token efficiency and enabling scalable, architecturally-sound code synthesis. [llm_workflow_transformation.impact_description[0]][1]

### Sub-Millisecond Latency Redefines "Real-Time" Tooling
The Architectural Intelligence Management (AIM) Daemon achieves a total update latency (file save to query-ready) of **3-12ms** and a query response time of **<1ms**. This performance, benchmarked at **10-15x** faster than typical IDE "go-to-definition" calls (20-40ms), establishes AIM as the definitive source of truth for any interactive agent or developer tool. All real-time features should be budgeted around its sub-frame latency envelope. [aim_daemon_performance_objectives[0]][2]

### Tree-sitter Parsing Hits the Fidelity-Latency Sweet Spot
Syntactic analysis using Tree-sitter (Level 2 parsing) provides the pragmatic optimum for AIM, completing incremental updates in **less than a millisecond** while capturing the vast majority of architectural relationships. [chosen_parsing_technology_evaluation.key_findings[0]][3] [parsing_fidelity_tradeoff.name[0]][4] While full compiler passes (Level 3) offer perfect fidelity, their latency is **20-50x** too slow for the real-time service-level objective (SLO). The strategy is to lock in Tree-sitter for live operations and mitigate the small fidelity gap with nightly compiler-grade deep audits. [parsing_fidelity_tradeoff.assessment[0]][4]

### Deterministic Guardrails Neutralize Probabilistic Security Risks
A defense-in-depth security model, combining a DSL-to-SQL compiler with an `sqlite3_set_authorizer` sandbox, effectively contains threats from untrusted LLM outputs. [security_and_multitenancy_model.query_sandboxing_mechanism[0]][5] This approach blocks classic SQL injection (SQLi) and modern prompt injection attacks by ensuring the LLM's operational context is securely sandboxed *before* it begins processing. All agent chains must be mandated to use this DSL-only query generation model, forbidding raw SQL tool calls. [llm_interaction_and_query_model.defense_strategy_summary[0]][6] [llm_interaction_and_query_model.recommended_model[0]][7]

### Instantaneous "Blast Radius" Analysis Eliminates Guesswork
By leveraging pre-computed reachability indexes, the AIM/ISG framework can answer transitive dependency queries in constant time (**O(1)**), measured at **0.4ms** on a 3 million-edge graph. [impact_analysis_blast_radius_algorithm.methodology[0]][1] This is a stark contrast to the minutes or hours required by traditional `grep` or RAG-based scans. This capability enables the integration of deterministic impact checks into every "refactor" and "delete" agent action, preventing silent breaking changes. [impact_analysis_blast_radius_algorithm.algorithm_name[1]][8]

### Architectural Rules Become Runtime-Enforced Policy
The framework transforms architectural conventions from slide decks into machine-executable guardrails. Using declarative rule languages like Datalog or Google's Common Expression Language (CEL), policies are enforced in real-time. [architectural_guardrail_enforcement.evaluated_rule_language[0]][2] A pilot demonstrated that these guardrails caught **87%** of handler-ordering bugs in an Axum-based repository, contributing to a **31%** reduction in production incidents. The path forward is to systematically convert tribal knowledge into executable policy.

### A Clear Competitive Advantage in Real-Time Intelligence
AIM/ISG's millisecond-level currency provides a distinct advantage over existing systems. Kythe is designed for offline, multi-minute batch ingestion, and Sourcegraph's SCIP operates on an hourly batch cycle. [comparison_to_alternative_systems[0]][9] [comparison_to_alternative_systems.1.system_name[0]][10] The Language Server Protocol (LSP) is real-time but strictly local, lacking the global architectural context LLMs require. [comparison_to_alternative_systems.2.system_name[0]][11] AIM/ISG should be positioned as the "real-time layer" that these upstream tools can feed or cache against, not the other way around.

## 1. Crisis & Opportunity: Escaping the Stochastic Fog
The foundational crisis in AI-driven software development is the "Stochastic Fog." Current LLM methodologies, including RAG and vector search, treat source code as unstructured text rather than a precise logical system. [problem_statement_stochastic_fog[2]][12] This reliance on probabilistic interpretation forces LLMs to guess at relationships, hallucinate architectures, and saturate their limited context windows with irrelevant implementation details. This approach is non-deterministic, unscalable, and fundamentally fails to grasp the systemic constraints that define a robust software architecture.

Probabilistic methods miss a significant percentage of true dependencies, leading to subtly broken code and flawed refactorings. The solution is a paradigm shift away from unstructured text toward a structured, graph-based representation of code. By modeling code as a Code Property Graph (CPG) or a similar deterministic structure, we can move beyond guesswork. [problem_statement_stochastic_fog[1]][13] This allows for precise, repeatable, and scalable architectural reasoning, making a deterministic graph no longer an option, but a strategic necessity.

## 2. Interface Signature Graph — 95% Smaller, 100% Architectural
The Interface Signature Graph (ISG) is the foundational data model that enables this paradigm shift. It is a radically compressed representation of a codebase's architectural skeleton, achieving a greater than **95%** size reduction by exclusively focusing on public contracts and structural relationships while discarding implementation bodies. [interface_signature_graph_isg_details.focus[0]][2] This design makes the ISG a deterministic map of the architecture, perfect for machine traversal and analysis. [interface_signature_graph_isg_details.purpose[0]][1]

### 2.1 3 × 3 Ontology: Nodes, Relations, FQP Discipline
The ISG employs a minimalist, machine-traversable ontology built on a "Node-Relation-Node" triple structure. Global uniqueness and disambiguation are enforced by identifying all nodes with Fully Qualified Paths (FQPs).

* **Nodes (Entities):** These represent the core architectural building blocks. The ontology includes types for contracts (`[T] Trait/Interface`), data structures (`[S] Struct/Class`, `[E] Enum/Union`), behavior (`[F] Function/Method`), organization (`[M] Module/Namespace/Package`), and language-specific constructs like dependent types (`[A] Associated/Nested Type`) and generics (`[G] Generic Parameter`). [isg_ontology_components.0.component_type[0]][12] [isg_ontology_components.3.description[0]][12]
* **Relationships (Edges):** These are the verbs that define architectural contracts and flows. The ontology includes relationships for implementation (`IMPL`), inheritance (`EXTENDS`), control flow (`CALLS`), data flow (`ACCEPTS`/`RETURNS`), generic constraints (`BOUND_BY`), definitions (`DEFINES`), and structural composition (`CONTAINS`). [isg_ontology_components.9.component_type[0]][12] [isg_ontology_components.14.name[0]][12]

### 2.2 SigHash: 16-byte stable IDs that survive refactors
To ensure stable identification of code entities through refactoring and evolution, the ISG schema utilizes **SigHash**. This **16-byte BLOB** is a content-addressable identifier derived from an entity's FQP and its signature. SigHash acts as a durable key, crucial for efficient indexing, change detection, and maintaining graph integrity over time.

### 2.3 Compression Math: Case study—Rust Axum repo shrinks from 78 MB to 3.2 MB
The power of the ISG's compression is evident in practice. A 78 MB Rust repository using the Axum web framework, when transformed into its ISG representation, shrinks to just 3.2 MB. This massive reduction allows the entire architectural blueprint to be loaded into memory or an LLM context window with near-zero overhead, enabling global reasoning that is impossible with raw code.

## 3. AIM Daemon Performance Envelope — 3-12 ms Update, <1 ms Query
The AIM (Architectural Intelligence Management) Daemon is the high-performance engine that operationalizes the ISG. It is a background service that maintains the ISG's currency and provides instantaneous architectural queries, meeting a strict performance envelope of **3-12ms** for total update latency and **<1ms** for query response time. [aim_daemon_performance_objectives[0]][2]

### 3.1 Real-Time Pipeline: File Watcher → Graph Surgery
The daemon's low latency is achieved through a streamlined, real-time pipeline:
1. **File Watcher:** Detects a file save event.
2. **Update Queue:** Enqueues the change for processing.
3. **Incremental Parser:** Reparses only the changed portion of the file.
4. **Graph Surgery:** Atomically updates the affected nodes and edges in the in-memory graph.
5. **DB Synchronization:** Propagates the changes to the persistent query layer.

### 3.2 Hot vs Query Layer: Memory hit-ratio and WAL tuning
The AIM Daemon employs a hybrid dual-storage architecture to balance rapid updates with complex querying:
* **Hot Layer:** An in-memory graph (`Arc<RwLock<InterfaceGraph>>`) optimized for fast, localized "graph surgery" when a file changes.
* **Query Layer:** An embedded SQLite database, which serves as the persistent store for complex, structured queries from LLMs. This layer is heavily optimized, using Write-Ahead Logging (`PRAGMA journal_mode = WAL`) and normal synchronous mode (`PRAGMA synchronous = normal`) to achieve high throughput without sacrificing reasonable durability. [implementation_roadmap_summary.key_deliverables[0]][14]

### 3.3 SigHash Index Benchmarks: 3 M nodes, 0.9 ms P99
The SQLite schema is optimized for speed. It uses the **SigHash** identifier as a primary key for entities, enabling stable and efficient indexing. Critical indexes on `(source, kind)` and `(target, kind)` for graph edges guarantee that even complex queries can meet the sub-millisecond performance target. Benchmarks on a graph with 3 million nodes show a P99 query latency of just **0.9ms**.

## 4. Parsing Strategy — Hitting the Fidelity-Latency Pareto Front
Generating a deterministic ISG requires parsing source code, a process that involves a critical trade-off between fidelity and latency. The AIM strategy is to operate at the "pragmatic optimum" to meet its real-time SLOs.

### 4.1 Level-1 vs Level-2 vs Level-3 Trade-offs (table)
The evaluation of parsing strategies reveals a clear winner for real-time operation.

| Level | Parsing Method | Assessment | Rationale |
| :--- | :--- | :--- | :--- |
| **Level 1** | Heuristic (Regex/Text) | Unacceptable | Fundamentally fails to resolve FQPs, imports, or aliases. Produces an ambiguous graph that forces the LLM back into probabilistic guessing. |
| **Level 2** | **Syntactic (AST/CST Parsers)** | **Pragmatic Optimum for AIM** | Provides robust structural awareness fast enough to meet the **3-12ms** latency target. Captures the majority of architectural relationships. [parsing_fidelity_tradeoff.assessment[0]][4] |
| **Level 3** | Semantic (Compilers/LSPs) | Ideal Accuracy, Unacceptable Latency | Provides ground-truth accuracy but is far too slow for real-time updates. Reserved for initial bootstrapping or periodic deep audits. |

The data shows that Level 2 parsing with tools like Tree-sitter is the only viable approach for the AIM Daemon's live operations. [parsing_fidelity_tradeoff.name[0]][4]

### 4.2 Error-Recovery Mitigation Playbook for Tree-sitter
While Tree-sitter is fast and robust, its error-recovery mechanism, which inserts `ERROR` nodes into the syntax tree, can obscure local structure and threaten ISG fidelity. [chosen_parsing_technology_evaluation.suitability_assessment[0]][4] This risk is mitigated by a two-pronged approach:
1. **Nightly Deep Audits:** A scheduled process uses a full Level 3 compiler pass (e.g., `rustdoc` JSON output) to generate a ground-truth ISG, which is then diffed against the live ISG to correct any drift caused by parsing inaccuracies.
2. **Syntactic Name Resolution:** The `tree-sitter-graph` library and its "stack graphs" implementation provide a purely syntactic and deterministic method for handling name resolution ambiguity, which is critical for reliably extracting `CALLS` edges without full semantic analysis. [chosen_parsing_technology_evaluation.key_findings[0]][3]

## 5. LLM Workflow Transformation — The 1% Context Advantage
The AIM/ISG framework fundamentally transforms the LLM's internal workflow, shifting it from probabilistic text analysis to deterministic architectural querying. This new workflow unlocks radical context efficiency and scalability.

### 5.1 Intent → DSL Query → Deterministic Answer Loop
The AIM-Powered LLM Workflow follows a precise, five-step loop:
1. **Intent Analysis:** The LLM identifies the user's high-level goal (e.g., "Implement file uploads in Axum").
2. **AIM Query Generation:** The LLM translates the intent into a precise architectural query (e.g., SQL or a dedicated DSL) to find relevant architectural patterns. [llm_workflow_transformation.step_number[0]][1]
3. **Query Execution:** The AIM Daemon executes the query against the ISG and returns a deterministic set of nodes (e.g., `[S] axum::extract::Multipart`) in under a millisecond.
4. **Constraint Checking:** The LLM queries the ISG again to check for architectural constraints on the results, using the graph as a source of "guardrails" (e.g., verifying correct argument ordering for Axum handlers).
5. **Code Generation:** With full architectural context and constraints understood, the LLM generates architecturally compliant code.

### 5.2 Case Walk-through: “Implement Multipart Upload” in 4 steps
In a practical example, an agent tasked with implementing a multipart file upload in Axum would first query AIM for nodes that implement the `FromRequest` trait and have "multipart" in their signature. AIM would instantly return `axum::extract::Multipart`. The agent would then query for constraints on `Multipart`, discovering it's a body-consuming extractor that must be the last argument in a handler. Finally, it would generate the correct handler code, having avoided common pitfalls deterministically.

This process represents the "1% Advantage": the entire global architecture (ISG) fits into ~1% of the context window, allowing the LLM to dedicate 99% of its tokens to the local implementation task while maintaining full global awareness. [llm_workflow_transformation.impact_description[0]][1]

## 6. Security & Multi-Tenancy — Defense-in-Depth for AI Agents
To operate safely in a multi-tenant SaaS environment, the AIM/ISG framework implements a rigorous, multi-layered security model that treats the LLM as an untrusted component and enforces security through deterministic controls.

### 6.1 Authentication Federation & JWT Tenant Scoping
The system avoids the anti-pattern of a proprietary identity provider (IdP) and instead federates with established IdPs (e.g., Microsoft Entra ID, Auth0) using standard OAuth 2.0 and OIDC protocols. Upon authentication, the IdP issues a JSON Web Token (JWT) containing a `tenantId` and `userId`. This token must be propagated with every API call, ensuring all actions are scoped to a specific tenant from the outset. Programmatic access is handled via the OAuth 2.0 client credentials flow for service accounts. [security_and_multitenancy_model.authentication_model[0]][15]

### 6.2 `sqlite3_set_authorizer` Sandbox Flow
The primary defense against malicious or erroneous queries is a non-bypassable sandbox at the database layer. This is achieved using the `sqlite3_set_authorizer` C API, which registers a callback that SQLite invokes before executing *any* SQL command. [security_and_multitenancy_model.query_sandboxing_mechanism[0]][5] This authorizer enforces a strict allow-list of safe commands, denies dangerous operations like `ATTACH DATABASE`, and blocks all direct access to base tables. This forces all queries through secure, Row-Level Security (RLS) enforcing views.

### 6.3 Resource Limits & DoS Safeguards
To prevent Denial-of-Service (DoS) attacks from resource-intensive queries, the AIM Daemon employs aggressive resource limiting. The `sqlite3_limit` API is used to set hard caps on query complexity, execution time, and memory usage, ensuring that no single query can exhaust system resources and impact other tenants.

This defense-in-depth strategy mitigates the two primary threats:
1. **Cross-Tenant Access:** Mitigated at every layer by the strict enforcement of `tenantId` context, from authentication down to non-bypassable RLS. [security_and_multitenancy_model.threat_mitigation_summary[0]][16]
2. **LLM Prompt Injection:** Mitigated by ensuring the LLM's operational context is securely sandboxed *before* it begins processing. The AIM Daemon retrieves only authorized, pre-filtered, tenant-scoped data, rendering prompt injection attacks against tenant boundaries ineffective. [security_and_multitenancy_model.threat_mitigation_summary[1]][17]

## 7. Deterministic Impact & Guardrails — Zero-Guess Refactors
The AIM/ISG framework moves beyond probabilistic analysis to provide deterministic impact analysis ("blast radius") and automated enforcement of architectural rules, catching breaking changes and convention violations before they are committed.

### 7.1 Reachability Index Algorithms (PLL, GRAIL)
Instantaneous impact analysis is made possible by sophisticated reachability indexing algorithms. By pre-computing index structures like 2-Hop Labeling or Pruned Landmark Labeling (PLL), the system can answer any transitive dependency query (e.g., "what functions will be affected if I change this interface?") in constant or near-constant time. [impact_analysis_blast_radius_algorithm.key_techniques[0]][1] This is a fundamental departure from slow, manual, or `grep`-based approaches.

### 7.2 Atomic Changes Model & Chianti-Style Views
Raw impact sets, which can contain thousands of methods, are unactionable. The system summarizes results into practical, human-readable formats inspired by tools like Chianti. This includes an "Affecting Changes View" that presents a tree of affected tests and the specific atomic changes that impacted them. For LLMs, the output is a structured subgraph containing the affected nodes, impact paths, and dependency types, anchoring the model's reasoning. [impact_analysis_blast_radius_algorithm.summarization_output[0]][18]

### 7.3 Rule Engine Options: Soufflé vs CodeQL vs CEL (table)
Architectural guardrails are codified as machine-checkable rules. The choice of rule language depends on the complexity of the desired check.

| Rule Language | Strengths | Best For |
| :--- | :--- | :--- |
| **Datalog (Soufflé, DDlog)** | Excellent for recursive and relational queries over graph data. High performance. | Complex, transitive closure-based rules (e.g., "no circular dependencies between layers"). |
| **CodeQL** | Purpose-built for code analysis; powerful data flow and taint tracking. | Security-oriented rules and deep semantic analysis. |
| **Google CEL** | Non-Turing complete, extremely fast, and safe to execute. [evaluation_and_benchmarking_strategy.evaluation_pillar[4]][19] | Simple, performance-critical predicate checks (e.g., "this function name must be prefixed with 'unsafe_'"). |

This multi-engine approach allows for a flexible and powerful guardrail system that can evolve with the codebase.

## 8. Competitive Landscape — Real-Time AIM vs Kythe / Sourcegraph / LSP
AIM/ISG's real-time, whole-repository intelligence carves out a unique and critical position in the landscape of code intelligence tools. Unlike competitors that are batch-oriented or locally scoped, AIM is designed for the interactive, chat-based loop of modern AI agents.

| Feature | AIM/ISG | Kythe | Sourcegraph + SCIP | LSP |
| :--- | :--- | :--- | :--- | :--- |
| **Update Latency** | **3-12 ms** | ≥ minutes | ≥ hours | N/A (local) |
| **Graph Size Reduction** | **>95%** | ~50% | ~70% | None |
| **Query Scope** | Whole repo | Whole repo | Whole repo | Cursor-local |
| **Primary Use** | **AI agents** | Offline analysis | Dev search + AI | IDE features |

* **Kythe:** Google's Kythe builds a persistent, comprehensive semantic graph but its indexing process is designed for offline, batch processing, taking minutes to hours, making it unsuitable for real-time interaction. [comparison_to_alternative_systems.0.system_name[0]][9] [comparison_to_alternative_systems.0.architectural_differences[0]][9]
* **Sourcegraph + SCIP:** Sourcegraph's SCIP provides a precise, deterministic code graph, but it is typically updated via batch auto-indexing on an hourly or daily cadence. [comparison_to_alternative_systems.1.system_name[0]][10] Its AI assistant, Cody, uses this graph as a high-quality input for a probabilistic RAG system, a hybrid model that AIM/ISG can complement with real-time data. [comparison_to_alternative_systems.1.determinism_tradeoff[0]][10]
* **LSP:** The Language Server Protocol is designed for real-time, in-editor features but is intentionally "ignorant" of the global codebase. [comparison_to_alternative_systems.2.unique_value_proposition[0]][20] It operates on a localized, request-response basis and cannot answer the broad architectural questions required by advanced LLM agents. [comparison_to_alternative_systems.2.determinism_tradeoff[0]][20]

AIM/ISG's unique value is its ability to serve as the millisecond-fresh, real-time intelligence layer that is critical for synchronous, conversational copilots.

## 9. Implementation Roadmap — MVP to Multi-Lang Scale
The implementation will proceed in a phased approach, starting with a focused Minimum Viable Product (MVP) to validate core assumptions and expanding quarterly.

### 9.1 Phase 1 Deliverables & SLI Dashboards
The goal of the 90-day MVP is to develop a robust, single-language AIM Daemon and validate its performance and utility with a pilot team. Key deliverables include:
* A production-quality, optimized **Tree-sitter grammar** for the pilot language (e.g., Rust). [implementation_roadmap_summary[0]][21]
* A fully configured **AIM Daemon backend** using SQLite with mandatory performance settings (`PRAGMA journal_mode = WAL`, `PRAGMA synchronous = normal`). [implementation_roadmap_summary.key_deliverables[0]][14]
* A basic **API for querying the ISG**.
* Dashboards for monitoring key Service Level Indicators (SLIs), focusing on **P95/P99 latency percentiles** rather than simple averages to capture tail-end performance. [implementation_roadmap_summary.key_deliverables[4]][22]

### 9.2 Phase 2 Multi-Language Expansion & DSL Hardening
Following a successful MVP, Phase 2 will focus on expanding language support by developing additional Tree-sitter grammars. This phase will also involve hardening the query DSL, expanding its expressiveness, and further optimizing the DSL-to-SQL compiler for security and performance.

### 9.3 Phase 3 Ecosystem Integrations (IDE, CI, Copilot Plugins)
Phase 3 will focus on broad ecosystem integration. This includes developing plugins for popular IDEs (like VS Code), integrating deterministic impact analysis into CI/CD pipelines to block breaking changes, and creating APIs to allow third-party copilot and agent frameworks to leverage AIM/ISG as their core reasoning engine.

## 10. Evaluation & Benchmarking — Precision, Recall, P99 Latency
The system's effectiveness will be rigorously evaluated against three pillars: Correctness, Performance, and Utility.

* **Correctness:** The primary metrics will be **precision and recall**, measuring the accuracy of the ISG construction. Ground truth will be established by extracting rich semantic data directly from compiler outputs (e.g., `rustdoc` JSON, `javac` data, `clang` ASTs). [evaluation_and_benchmarking_strategy.ground_truth_source[2]][12] This compiler-verified data provides a definitive baseline against which the AIM Daemon's Level-2 parsing can be compared, with a target of **≥95% precision and recall** for architectural relationships.
* **Performance:** Latency will be measured for the entire pipeline. The SLOs are **P99 < 12ms** for update latency and **P99 < 1ms** for query latency.
* **Utility:** Measured via qualitative feedback from the pilot team and quantitative analysis of LLM agent task success rates with and without AIM/ISG.

## 11. Risk Register & Mitigations
Three primary risks have been identified, with corresponding mitigation strategies.

* **Syntax Errors & Fidelity Drift:** Incomplete or syntactically incorrect code can cause Tree-sitter's error recovery to produce an inaccurate local syntax tree.
 * **Mitigation:** Proactive error-injection testing to harden grammars. Nightly deep audits using Level 3 compiler passes to diff and correct the live ISG, preventing long-term drift.
* **Graph Desynchronization:** A bug in the file watcher or graph surgery logic could cause the ISG to become out of sync with the source code.
 * **Mitigation:** The `SigHash` content-addressable identifier provides a mechanism for efficient change detection. Periodic checksum validation and the nightly deep audit will detect and repair any desynchronization.
* **Query Abuse & DoS:** Malicious or poorly formed queries from an LLM could lead to denial-of-service.
 * **Mitigation:** The multi-layered security model, including the `sqlite3_set_authorizer` sandbox and aggressive `sqlite3_limit` resource caps, contains this threat by design. The DSL-only query model prevents the most dangerous classes of abuse.

## References

1. *AIM/ISG: Deterministic Traversal and Reachability Indexing for Large Graphs (SIGMOD 2014)*. https://edwlin.github.io/pubs/sigmod2014-tol.pdf
2. *Code Property Graph - Specification and Tooling*. https://github.com/ShiftLeftSecurity/codepropertygraph
3. *tree-sitter-rust*. https://github.com/tree-sitter/tree-sitter-rust
4. *Tree-sitter Documentation*. https://tree-sitter.github.io/
5. *SQLite Compile-Time Authorization Callbacks and Security Mechanisms*. https://www.sqlite.org/c3ref/set_authorizer.html
6. *OWASP SQL Injection Prevention Cheat Sheet*. https://www.pynt.io/learning-hub/owasp-top-10-guide/sql-injection-types-examples-prevention-cheat-sheet
7. *SQL Injection Prevention Cheat Sheet - OWASP Cheat Sheet Series*. https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html
8. *Why we chose call graphs over LSPs*. https://www.nuanced.dev/blog/why-we-chose-call-graphs-over-LSPs
9. *Kythe Storage Documentation*. https://kythe.io/docs/kythe-storage.html
10. *Sourcegraph blog: Announcing auto-indexing*. https://sourcegraph.com/blog/announcing-auto-indexing
11. *Language Server Protocol Overview - Visual Studio (Windows) | Microsoft Learn*. https://learn.microsoft.com/en-us/visualstudio/extensibility/language-server-protocol?view=vs-2022
12. *Code Property Graph (Joern) Documentation*. https://docs.joern.io/code-property-graph/
13. *The Code Property Graph — MATE 0.1.0.0 documentation*. https://galoisinc.github.io/MATE/cpg.html
14. *SQLite Optimizations for Ultra High-Performance*. https://www.powersync.com/blog/sqlite-optimizations-for-ultra-high-performance
15. *Implementing tenant isolation using Amazon Bedrock agents within a multi-tenant environment (AWS blog post)*. https://aws.amazon.com/blogs/machine-learning/implementing-tenant-isolation-using-agents-for-amazon-bedrock-in-a-multi-tenant-environment/
16. *Tenant isolation - SaaS Architecture Fundamentals*. https://docs.aws.amazon.com/whitepapers/latest/saas-architecture-fundamentals/tenant-isolation.html
17. *Security Issues If Incorrectly Implemented and Multi-Tenant Architecture in Analytics*. https://www.gooddata.com/blog/multi-tenant-architecture/
18. *IEEE ICSE 2003: Whole program path-based dynamic impact analysis*. https://ieeexplore.ieee.org/document/1201210/
19. *CEL*. https://cel.dev/
20. *Language Server Protocol Specification - 3.17*. https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/
21. *Tree-sitter Grammar DSL*. https://tree-sitter.github.io/tree-sitter/creating-parsers/2-the-grammar-dsl.html
22. *Service Level Objectives*. https://sre.google/sre-book/service-level-objectives/