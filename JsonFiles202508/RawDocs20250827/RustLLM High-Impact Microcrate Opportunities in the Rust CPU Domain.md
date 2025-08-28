# High-Impact Microcrate Opportunities in the Rust CPU Domain

## Executive Summary

A comprehensive analysis of the Rust ecosystem reveals numerous high-impact opportunities for creating minimal (<300 LOC) libraries in the CPU domain [executive_summary[0]][1]. These opportunities span numerical computation, low-level bit manipulation, specialized data structures, algorithms, and system utilities [executive_summary[0]][1].

The primary drivers for these opportunities are the persistent demand for `no_std` and WebAssembly (WASM) compatible crates, the need for lightweight alternatives to larger, complex libraries (like `nalgebra`, `rand`, `lexical-core`), and the value of porting proven, high-performance C/C++ header-only utilities into safe, idiomatic Rust [executive_summary[0]][1]. The findings confirm that developers can create highly valuable and widely adopted libraries by focusing on a single, well-defined problem and delivering a small, fast, and correct solution [executive_summary[0]][1].

## Key Opportunity Themes

Three primary themes emerge as strategic pathways for creating valuable microcrates [key_opportunity_areas[0]][2]:

* **`no_std` and WASM Compatibility**: There is strong and continuous demand for utilities that can operate in constrained environments like embedded systems, operating systems, and high-performance web applications [key_opportunity_areas[0]][2]. Opportunities in fixed-point math, CPU feature detection, and lock-free data structures are prime examples [key_opportunity_areas[7]][3] [key_opportunity_areas[8]][4].

* **Minimal-Dependency Alternatives**: Developers often require a single piece of functionality (e.g., a 3x3 matrix inverse, a fast `atoi`, a specific PRNG) without the significant overhead and dependency bloat of comprehensive libraries [key_opportunity_areas[0]][2]. This creates a clear niche for hyper-focused microcrates that do one thing well [key_opportunity_areas[9]][5] [key_opportunity_areas[10]][6].

* **Porting Proven C/C++ Libraries**: A highly effective strategy is to port well-regarded, single-file, or header-only C/C++ libraries into safe, idiomatic Rust [key_opportunity_areas[0]][2]. This leverages decades of algorithmic refinement from other ecosystems, bringing proven solutions like the Fast Inverse Square Root, classic PRNGs, and hashing algorithms to Rust developers, often with improved safety guarantees [key_opportunity_areas[5]][7].

## High-Impact Project Opportunities

The following table summarizes 20 high-potential microcrate opportunities, each under approximately 300 lines of code, designed to fill specific gaps in the Rust ecosystem [opportunity_summary_table[0]][2].

| Opportunity | Reasoning | PMF Score | Ease of Testing | Relevant Artifacts |
| :--- | :--- | :--- | :--- | :--- |
| **Modern, Portable Bit-Twiddling Microcrate** [opportunity_summary_table.0.opportunity_name[0]][8] | Fills the gap left by the unmaintained `bitintr` crate. Provides a safe, `no_std`, WASM-compatible, and dependency-free solution for high-demand primitives like PDEP/PEXT and Morton coding, which are absent from `std` and crucial for graphics, compression, and cryptography [opportunity_summary_table.0.reasoning[0]][2] [opportunity_summary_table.0.reasoning[1]][9] [opportunity_summary_table.0.reasoning[2]][10] [opportunity_summary_table.0.reasoning[3]][11] [opportunity_summary_table.0.reasoning[4]][8] [opportunity_summary_table.0.reasoning[5]][1]. | 85/100 | 95/100 | Canonical Algorithms: [http://graphics.stanford.edu/~seander/bithacks.html](http://graphics.stanford.edu/~seander/bithacks.html), Bit Scan Algorithms: [https://www.chessprogramming.org/BitScan](https://www.chessprogramming.org/BitScan), WASM SIMD Status: [https://github.com/rust-lang/rust/issues/74372](https://github.com/rust-lang/rust/issues/74372) [opportunity_summary_table.0.relevant_artifacts_links[0]][8] [opportunity_summary_table.0.relevant_artifacts_links[1]][2] [opportunity_summary_table.0.relevant_artifacts_links[2]][10] [opportunity_summary_table.0.relevant_artifacts_links[3]][9] [opportunity_summary_table.0.relevant_artifacts_links[4]][11] [opportunity_summary_table.0.relevant_artifacts_links[5]][1] | 
| **Minimal RNG Primitives (PCG32/Xoshiro128++)** | Addresses the need for a tiny, fast, and statistically robust PRNG for embedded, simulation, and WASM contexts where the full `rand` crate is overkill. The existence of `rand_pcg` and `rand_xoshiro` validates the demand for such focused libraries. | 8/10 | 9/10 | PCG Website: [https://www.pcg-random.org/](https://www.pcg-random.org/), Xoshiro Website: [http://prng.di.unimi.it/](http://prng.di.unimi.it/), Rust rand_pcg: [https://rust-random.github.io/rand_pcg/](https://rust-random.github.io/rand_pcg/) | 
| **Ziggurat-based Normal/Exponential Sampler** | Provides a hyper-focused, minimal-dependency package for the two most common statistical distributions (N(0,1), Exp(1)). It targets highly constrained environments (embedded, WASM) where the `rand_distr` crate might be too large or have too many transitive dependencies. | 0.8/1.0 | 0.7/1.0 | Ziggurat Paper: [https://www.jstatsoft.org/article/view/v005i08](https://www.jstatsoft.org/article/view/v005i08), ZIGNOR Paper: An Improved Ziggurat Method to Generate Normal Random Samples (Doornik, 2005), ETF Algorithm Discussion: [https://github.com/rust-random/rand/issues/9](https://github.com/rust-random/rand/issues/9) | 
| **Micro Float-Formatting (f32 Shortest Roundtrip)** | Offers a tiny, dependency-free alternative to `ryu` for `no_std` and WASM environments that only need `f32` formatting. By eliminating `f64` support, it achieves a significantly smaller binary size, which is critical for these domains. | High | Medium-High | Ryu Paper: [https://dl.acm.org/doi/10.1145/3192366.3192369](https://dl.acm.org/doi/10.1145/3192366.3192369), Ryu C Impl: [https://github.com/ulfjack/ryu](https://github.com/ulfjack/ryu), Ryu Rust Impl: [https://github.com/dtolnay/ryu](https://github.com/dtolnay/ryu), Dragonbox Paper: [https://fmt.dev/papers/Dragonbox.pdf](https://fmt.dev/papers/Dragonbox.pdf) | 
| **Compact Stoer–Wagner Global Min-Cut** | Fills a clear gap in the Rust ecosystem, as major graph libraries like `petgraph` lack a native implementation. A lightweight, dependency-free, pure Rust version would be highly valuable for network analysis, image segmentation, and research. | 0.8/1.0 | 0.7/1.0 | Algorithm Overview: [https://en.wikipedia.org/wiki/Stoer%E2%80%93Wagner_algorithm](https://en.wikipedia.org/wiki/Stoer%E2%80%93Wagner_algorithm), Petgraph Issue: [https://github.com/petgraph/petgraph/issues/467](https://github.com/petgraph/petgraph/issues/467) | 
| **Portable SIMD Micro-Helpers** [opportunity_summary_table.5.opportunity_name[0]][2] | Addresses known gaps and inefficiencies in the `rust-lang/portable-simd` project, such as slow horizontal reductions and inflexible swizzles. A helper crate would provide ergonomic, optimized wrappers for these fundamental operations, benefiting DSP, image processing, and scientific computing [opportunity_summary_table.5.reasoning[0]][2] [opportunity_summary_table.5.reasoning[1]][11] [opportunity_summary_table.5.reasoning[2]][9] [opportunity_summary_table.5.reasoning[3]][10] [opportunity_summary_table.5.reasoning[4]][8]. | High [opportunity_summary_table.5.pmf_probability_score[0]][2] | High [opportunity_summary_table.5.ease_of_success_testing[0]][2] | Portable SIMD Repo: [https://github.com/rust-lang/portable-simd](https://github.com/rust-lang/portable-simd), Horizontal Ops Issue: [https://github.com/rust-lang/portable-simd/issues/235](https://github.com/rust-lang/portable-simd/issues/235), Stabilization Blockers Issue: [https://github.com/rust-lang/portable-simd/issues/364](https://github.com/rust-lang/portable-simd/issues/364) | 
| **Minimal CPU Feature Detection** [opportunity_summary_table.6.opportunity_name[0]][1] | Fills a niche for a minimalist, cross-platform, `no_std`-first crate that abstracts platform-specific detection (CPUID on x86, auxv on Linux, sysctl on macOS). It provides a simpler alternative to `cpufeatures` or `raw-cpuid` for users needing only a few common feature flags [opportunity_summary_table.6.reasoning[0]][1] [opportunity_summary_table.6.reasoning[1]][11] [opportunity_summary_table.6.reasoning[2]][2] [opportunity_summary_table.6.reasoning[3]][9] [opportunity_summary_table.6.reasoning[4]][10] [opportunity_summary_table.6.reasoning[5]][8]. | 4/5 [opportunity_summary_table.6.pmf_probability_score[0]][2] | 3/5 [opportunity_summary_table.6.ease_of_success_testing[0]][1] | Intel Manual: Intel 64 and IA-32 Architectures Software Developer's Manuals, Linux Auxv: getauxval(3) man page, `cpufeatures` crate: [https://github.com/RustCrypto/utils/tree/master/cpufeatures](https://github.com/RustCrypto/utils/tree/master/cpufeatures) | 
| **Fixed-Point Math Microcrate (Q15.16/Q1.31)** | Targets embedded, DSP, and WASM developers who need deterministic, high-performance arithmetic without an FPU. It fills a niche for a minimal alternative to the comprehensive `fixed` crate, offering only the core functionality for common Q-formats to reduce binary size and complexity. | 0.85 | 0.7 | Q Format Wikipedia: [https://en.wikipedia.org/wiki/Q_(number_format)](https://en.wikipedia.org/wiki/Q_(number_format)), ARM CMSIS-DSP Library: Reference for fixed-point functions, `fixed` crate: [https://crates.io/crates/fixed](https://crates.io/crates/fixed) | 
| **Tiny 2x2/3x3 Matrix Microcrate** | Addresses the need for `const-evaluable`, `no_std` matrix operations in embedded/WASM contexts. It avoids the dependency bloat and compile times of large libraries like `glam` and `nalgebra` for users who only need basic 2D/3D transformations. | 0.8/1.0 [opportunity_summary_table.8.pmf_probability_score[0]][2] | 0.9/1.0 [opportunity_summary_table.8.ease_of_success_testing[0]][11] | Const float stabilization: [https://github.com/rust-lang/rust/issues/57241](https://github.com/rust-lang/rust/issues/57241), `matrix-rs` example: [https://github.com/matthew-c-ritter/matrix-rs](https://github.com/matthew-c-ritter/matrix-rs), `mathbench-rs` for benchmarks: [https://github.com/rust-gamedev/mathbench-rs](https://github.com/rust-gamedev/mathbench-rs) | 
| **Minimal Non-Cryptographic Hash (wyhash/xxHash32)** | Fills the need for a fast, `no_std` hashing algorithm with a **stable and deterministic output**, a feature deliberately avoided by `ahash` and `fxhash`. This is critical for checksums, content-addressable storage, and reproducible caching. | High | High | wyhash license: Unlicense, xxHash license: BSD 2-Clause, `ahash` crate: [https://crates.io/crates/ahash](https://crates.io/crates/ahash) | 
| **Fast Inverse Square Root Microcrate** | Provides a safe, idiomatic Rust port of the classic 'Quake III' algorithm. It is highly relevant for `no_std`, WASM, and other environments lacking hardware `rsqrtss` instructions. It offers a clear speed-vs-accuracy trade-off for graphics and physics simulations. | Strong | High | Rust `to_bits`/`from_bits` docs, Chris Lomont's paper on the magic constant, `micromath` crate for inspiration: [https://crates.io/crates/micromath](https://crates.io/crates/micromath) | 
| **Branchless Integer Selection/Min/Max** [opportunity_summary_table.11.opportunity_name[0]][7] | Provides explicitly branchless, constant-time integer primitives, a guarantee not offered by `core::cmp`. This is critical for cryptographic and other security-sensitive contexts to avoid timing side-channels. The `subtle` crate's success validates the market for such utilities [opportunity_summary_table.11.reasoning[0]][7]. | 0.8 | 0.9 | Bit Twiddling Hacks: [https://graphics.stanford.edu/~seander/bithacks.html](https://graphics.stanford.edu/~seander/bithacks.html), Hacker's Delight by Henry S. Warren, Jr., `subtle` crate: [https://crates.io/crates/subtle](https://crates.io/crates/subtle) [opportunity_summary_table.11.relevant_artifacts_links[0]][7] | 
| **SPSC Ring Buffer (Atomics-Only, No-Alloc)** | Fills a niche for a truly minimal, `no_std`, `no_alloc`, atomics-only SPSC queue. While crates like `ringbuf` and `heapless::spsc` exist, this targets users needing the absolute smallest, auditable primitive for embedded, real-time, and HPC workloads, verified with `loom`. | 0.8/1.0 | 0.7/1.0 | Rigtorp's SPSC queue implementation, Dmitry Vyukov's lock-free articles, `loom` testing library: [https://github.com/tokio-rs/loom](https://github.com/tokio-rs/loom) | 
| **Tiny Base Encoders (Hex/Crockford Base32)** | Fills a niche for a microcrate combining both Hex and Crockford Base32 in a single, minimal-dependency, high-throughput package. It provides a lightweight alternative to using multiple crates (`hex`, `base32`) or a large, general-purpose one (`data-encoding`). | 7/10 | 9/10 | RFC 4648 (Base16): [https://datatracker.ietf.org/doc/html/rfc4648](https://datatracker.ietf.org/doc/html/rfc4648), Crockford Base32 Spec: [http://www.crockford.com/wrmg/base32.html](http://www.crockford.com/wrmg/base32.html), Fast decoding blog: [https://lemire.me/blog/2023/07/20/fast-decoding-of-base32-strings/](https://lemire.me/blog/2023/07/20/fast-decoding-of-base32-strings/) | 
| **Tableless CRC32/CRC64 Microcrate** | Provides a minimal-footprint CRC implementation for `no_std`, embedded, and WASM environments where binary size is critical. It serves as an alternative to table-based crates like `crc32fast` or the general-purpose `crc` crate's `NoTable` feature, pushing the boundaries of minimalism. | 4/5 | 5/5 | A Painless Guide to CRC: [http://zlib.net/crc_v3.txt](http://zlib.net/crc_v3.txt), Koopman's Research on Best CRC Polynomials: [https://users.ece.cmu.edu/~koopman/crc/](https://users.ece.cmu.edu/~koopman/crc/), Chorba Paper (Novel Algorithm): [https://arxiv.org/abs/2412.16398v1](https://arxiv.org/abs/2412.16398v1) | 
| **Reservoir Sampling Microcrate (Algorithms R & L)** | Provides a minimal, zero-dependency, `no_std` compatible library for a fundamental data streaming algorithm. While `reservoir-sampling` exists, a new microcrate can focus on extreme minimalism, modern Rust idioms, and providing both Algorithm R (simple) and L (fast) in one tiny package. | 7/10 | 9/10 | Vitter's Paper (1985): 'Random Sampling with a Reservoir', ACM Transactions on Mathematical Software, Wikipedia: [https://en.wikipedia.org/wiki/Reservoir_sampling](https://en.wikipedia.org/wiki/Reservoir_sampling) | 
| **Polynomial Approximation Microcrate (expf/logf/sinf)** | Fills a clear need for fast, `no_std`/WASM `f32` math approximations with tunable precision. It targets ML inference, graphics, and embedded systems where performance is more critical than the last bit of accuracy provided by a full `libm` implementation. | 0.85 | 0.90 | Sollya Tool for polynomial generation, musl-libc source for argument reduction techniques, Cephes Math Library for reference, `micromath` crate: [https://crates.io/crates/micromath](https://crates.io/crates/micromath) | 
| **Fast Decimal `atoi` Microcrate** | Targets the persistent demand for high-performance, allocation-free integer parsing. It fills a niche for developers who find `lexical-core` too large or `atoi_simd` too specialized, offering a tiny, portable library using SWAR or other fast scalar techniques. | High | High | Daniel Lemire's Blog on SWAR: [lemire.me/blog/2022/01/21/swar-explained-parsing-eight-digits/](http://lemire.me/blog/2022/01/21/swar-explained-parsing-eight-digits/), Wojciech Muła's articles on SIMD parsing: [0x80.pl/articles/simd-parsing-int-sequences.html](http://0x80.pl/articles/simd-parsing-int-sequences.html) | 
| **Tiny Atomic Backoff/Yield Microcrate** | Addresses the fundamental problem of efficient busy-waiting in concurrent programming. It occupies a 'size-only niche' as a minimal, policy-driven alternative to robust solutions like `crossbeam-utils::Backoff` or `parking_lot_core::SpinWait`, ideal for `no_std` and other constrained environments. | 0.8/1.0 | 0.9/1.0 | Intel/ARM CPU manuals on PAUSE/YIELD instructions, `crossbeam-utils` source code, Java JEP 285 (`Thread.onSpinWait`) | 
| **Porting C/C++ Single-File Utilities** | A broad category focused on porting battle-tested, permissively licensed C/C++ utilities. Opportunities include PRNGs (SplitMix, Romu), hash functions (Bob Jenkins), and transforms (Ooura FFT, FWHT), bringing their proven performance to Rust with improved safety and ergonomics. | High | High | `nothings/stb` collection: [https://github.com/nothings/stb](https://github.com/nothings/stb), `r-lyeh/single_file_libs`: [https://github.com/r-lyeh/single_file_libs](https://github.com/r-lyeh/single_file_libs), Sebastiano Vigna's PRNG papers | 

## Deep Dive: Selected Opportunities

Here are more detailed explorations of some of the most promising microcrate opportunities.

### Deep Dive 1: Modern, Portable Bit-Twiddling Microcrate

#### Gap Analysis

The Rust ecosystem lacks a modern, maintained, and portable solution for advanced bit manipulation [bit_twiddling_primitives_opportunity[0]][9] [bit_twiddling_primitives_opportunity[1]][10]. While `core::intrinsics` provides basics, complex primitives like Parallel Bit Deposit/Extract (PDEP/PEXT) are unstable [bit_twiddling_primitives_opportunity[504]][8]. The `bitintr` crate, which aimed to fill this gap, is now unmaintained and effectively deprecated [bit_twiddling_primitives_opportunity[0]][9] [bit_twiddling_primitives_opportunity[1]][10]. This creates a clear vacuum for a new microcrate that is stable, well-documented, and provides pure Rust software fallbacks, ensuring it works on all targets, including WASM [bit_twiddling_primitives_opportunity[504]][8].

#### Proposed API

The crate's functionality could be exposed through a trait, for example `BitTwiddle`, implemented for primitive integer types (`u8` through `u64`) [bit_twiddling_primitives_opportunity[504]][8].

```rust
pub trait BitTwiddle: Sized {
 /// Parallel bit deposit: Gathers bits from `self` into contiguous
 /// low-order bits, as specified by the `mask`.
 fn pdep(self, mask: Self) -> Self;

 /// Parallel bit extract: Scatters the low-order bits of `self` to the
 /// bit positions specified by the `mask`.
 fn pext(self, mask: Self) -> Self;

 /// Checks if any byte within the integer is zero.
 fn has_zero_byte(self) -> bool;

 /// Branchless conditional select. If mask is all 1s, returns `a`;
 /// if all 0s, returns `b`.
 fn select(mask: Self, a: Self, b: Self) -> Self;
}

// Standalone function for Morton encoding (2D bit interleaving)
/// Interleaves the bits of two 32-bit integers to produce a 64-bit Morton code.
pub fn interleave_bits_u32(x: u32, y: u32) -> u64;
```
This focused API provides high-value functions whose implementations, based on public domain algorithms from sources like 'Bit Twiddling Hacks', can easily fit within the 300 LOC limit [bit_twiddling_primitives_opportunity[2]][7] [bit_twiddling_primitives_opportunity.proposed_api[4]][7].

#### Portability Plan

The crate will be designed to be `no_std` and fully compatible with WebAssembly (WASM) [bit_twiddling_primitives_opportunity.portability_plan[0]][2] [bit_twiddling_primitives_opportunity.portability_plan[1]][9] [bit_twiddling_primitives_opportunity.portability_plan[2]][10]. This is achieved by having no external dependencies and operating only on primitive integer types [bit_twiddling_primitives_opportunity.portability_plan[3]][12]. All functions will have pure Rust software fallbacks, ensuring universal portability and a functional baseline on any target, including `wasm32-unknown-unknown` [bit_twiddling_primitives_opportunity.portability_plan[0]][2].

#### Product-Market Fit Rationale

PMF is high (**85/100**) because the need for these primitives is proven across multiple domains [bit_twiddling_primitives_opportunity.pmf_rationale[0]][9] [bit_twiddling_primitives_opportunity.pmf_rationale[1]][2] [bit_twiddling_primitives_opportunity.pmf_rationale[2]][10].
* **Graphics/Games**: Morton codes for spatial data structures; PDEP/PEXT for GPU buffer packing.
* **Data Compression**: PDEP/PEXT for efficient, branch-free packing of data fields.
* **Cryptography**: Branchless selection (`select`) for constant-time code to avoid side-channel attacks.
* **Databases**: Bit manipulation for hash functions, Bloom filters, and compact data representations.
The failure of `bitintr` has created a vacuum for a reliable, modern replacement [bit_twiddling_primitives_opportunity.pmf_rationale[0]][9].

#### Testing Plan

The deterministic nature of bitwise operations makes testing highly reliable (**95/100**) [bit_twiddling_primitives_opportunity.testing_plan[0]][9].
1. **Test Vectors**: Use comprehensive input-output pairs from canonical sources like "Hacker's Delight" [bit_twiddling_primitives_opportunity.testing_plan[1]][7].
2. **Property-Based Testing**: Use `proptest` or `quickcheck` to verify invariants, e.g., `pext(pdep(source, mask), mask)` recovers the original bits.
3. **Cross-Verification**: On supported platforms, validate pure Rust fallbacks against native hardware instructions like `std::arch::x86_64::{_pdep_u64, _pext_u64}` [bit_twiddling_primitives_opportunity.testing_plan[6]][13] [bit_twiddling_primitives_opportunity.testing_plan[7]][14].

### Deep Dive 2: Minimalist, High-Quality PRNGs

There is a clear opportunity to create a minimal RNG microcrate (<300 LOC) implementing a high-quality, non-cryptographic PRNG like PCG32 or Xoshiro128++ [minimal_rng_opportunity[0]][15] [minimal_rng_opportunity[1]][16] [minimal_rng_opportunity[2]][17]. These algorithms are known for their excellent balance of speed, statistical robustness, and small state size. The crate would be `no_std` and WASM-compatible, depending only on `rand_core` [minimal_rng_opportunity[0]][15]. The API would be minimal, offering a seeding constructor, `next_u32()`, and `next_f32()`, with a clear disclaimer that it is NOT cryptographically secure. Testing would involve official test vectors and statistical test suites like TestU01's `SmallCrush` [minimal_rng_opportunity[0]][15].

### Deep Dive 3: Fast Inverse Square Root Microcrate

A highly feasible project is a Rust microcrate for the fast inverse square root (`1/sqrt(x)`) [fast_inverse_square_root_opportunity[0]][18] [fast_inverse_square_root_opportunity[1]][19]. A key advantage of a Rust port is safety, using `f32::to_bits()` and `f32::from_bits()` to avoid the undefined behavior of the original C implementation from *Quake III Arena* [fast_inverse_square_root_opportunity[4]][20] [fast_inverse_square_root_opportunity[8]][21]. The crate would be `no_std` and WASM-compatible. It could offer multiple modes: the classic algorithm (using an improved magic constant like `0x5F375A86`), an option for Newton-Raphson iterations for better accuracy, and a fallback to `1.0 / x.sqrt()` for special values like `NaN` [fast_inverse_square_root_opportunity[6]][22].

### Deep Dive 4: Porting High-Value C/C++ Utilities

Porting battle-tested, permissively licensed C/C++ single-file utilities is a highly effective strategy for creating value [c_cpp_porting_candidates[0]][17] [c_cpp_porting_candidates[1]][16] [c_cpp_porting_candidates[2]][15]. These projects bring proven performance and algorithms to the Rust ecosystem with the added benefits of safety and modern ergonomics.

| Utility Name | Category | Description | Source & License | Rationale | Est. LOC |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **SplitMix64 / SplitMix32** | PRNG | A fast, high-quality 64-bit PRNG, a fixed-increment version of Java 8's SplittableRandom. Passes BigCrush tests. | C reference by S. Vigna (CC0 1.0). Source in 'Romu' paper. | Core logic is extremely small. Excellent statistical properties and speed make it a valuable niche addition. | < 50 |
| **Romu PRNG Family** | PRNG | A family of fast, non-linear PRNGs with good statistical properties. | C source is Public Domain. MIT licensed version in `cauldron/random.h`. | A basic variant is very few lines. Provides a state-of-the-art, high-performance PRNG in a tiny package. | < 100 |
| **CRC-32C (Castagnoli) Software Fallback** | Hash | High-performance CRC-32 variant used in networking (SCTP) and storage (iSCSI). | Google's `google/crc32c` (BSD 3-Clause). | A tiny port of the software fallback is valuable for constrained environments where hardware acceleration is overkill. | < 300 |
| **Bob Jenkins Hash (lookup3)** | Hash | A fast, non-cryptographic hash with good distribution, widely used for hash tables. | `noporpoise/BitArray` C library (Public Domain / CC0-1.0). | A tiny, dependency-free port of this classic function would be a valuable utility for simple, stable hashing. | < 150 |
| **Morton Codes (Bit Interleaving)** [c_cpp_porting_candidates.4.utility_name[0]][23] | Bit Manipulation [c_cpp_porting_candidates.4.category[0]][23] | Maps multidimensional data to one dimension (Z-order curve) for spatial indexing in graphics, games, and databases [c_cpp_porting_candidates.4.description[0]][23]. | Classic public domain bit-twiddling hack. Ref: `morton-nd/morton-nd` C++ header-only library [c_cpp_porting_candidates.4.source_and_license[0]][23]. | Core logic is extremely compact. A tiny Rust crate would provide a fundamental primitive missing as a standalone utility [c_cpp_porting_candidates.4.porting_rationale[0]][23]. | < 100 |
| **Ooura FFT (Simple Version)** | FFT | A collection of FFT routines known for good performance and a permissive license. Simple versions are compact. | Original source from Takuya Ooura's website (permissive). | A strong candidate for a minimal, `no_std` FFT crate, filling a gap for a simple, dependency-free transform utility. | < 300 |
| **Fast Walsh-Hadamard Transform (FWHT)** | FFT | An efficient algorithm for the Hadamard transform used in signal processing and data compression. | Modern C implementation on GitHub (MIT license). | The core algorithm is very compact. Porting would provide a useful, specialized tool for data analysis. | < 200 |
| **stb_leakcheck port** | Utility | A port of the single-file C memory leak checker from the popular `stb` library. | Part of `nothings/stb` (Public Domain). | Useful for debugging `unsafe` code, FFI boundaries, or custom allocators where leaks are still possible. | < 200 |

## References

1. *has_fast_pdep crate page*. https://crates.io/crates/has_fast_pdep
2. *gnzlbg/bitintr: Portable Bitwise Manipulation Intrinsics*. https://github.com/gnzlbg/bitintr
3. *substrate-fixed*. https://crates.io/crates/substrate-fixed
4. *Crate mat - Rust*. https://docs.rs/mat
5. *DMat3 in glam::f64 - Rust - Docs.rs*. https://docs.rs/glam/latest/glam/f64/struct.DMat3.html
6. *Mini Matrix Library (crates.io) - crate description and docs*. https://crates.io/crates/mini-matrix
7. *Bit Twiddling Hacks*. https://graphics.stanford.edu/~seander/bithacks.html
8. *bitintr - Rust*. https://gnzlbg.github.io/bitintr/
9. *Bitintr 0.3.0 Documentation and Repository*. http://docs.rs/bitintr/latest/bitintr
10. *bitintr 0.3.0 - Docs.rs*. http://docs.rs/bitintr/0.3.0/bitintr
11. *Bitintr crate - Rust crates.io*. https://crates.io/crates/bitintr
12. *raw-cpuid crates.io description*. https://crates.io/crates/raw-cpuid
13. *core::arch::x86_64 - Rust*. https://doc.rust-lang.org/core/arch/x86_64/index.html
14. *is_x86_feature_detected in std*. https://doc.rust-lang.org/std/macro.is_x86_feature_detected.html
15. *PCG RNG ecosystem (pcg_rand and related crates)*. https://crates.io/crates/pcg_rand
16. *rand_pcg - PCG generators (Rust)*. https://rust-random.github.io/rand/rand_pcg/
17. *rand_pcg - Rust*. https://docs.rs/rand_pcg
18. *Quake inverse square root: analysis and implementation*. https://0x5f37642f.com/documents/McEniryMathematicsBehind.pdf
19. *Understanding Quake's Fast Inverse Square Root*. https://betterexplained.com/articles/understanding-quakes-fast-inverse-square-root/
20. *Fast inverse square root*. https://en.wikipedia.org/wiki/Fast_inverse_square_root
21. *"f::from_bits" Search*. https://doc.rust-lang.org/std/index.html?search=f%3A%3Afrom_bits
22. *I implemented the famous Quake inverse sqrt function in Rust! - Reddit*. https://www.reddit.com/r/rust/comments/vdroh6/i_implemented_the_famous_quake_inverse_sqrt/
23. *morton-nd/morton-nd: A header-only compile-time ...*. https://github.com/morton-nd/morton-nd