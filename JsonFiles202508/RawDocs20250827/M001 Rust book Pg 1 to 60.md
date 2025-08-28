Rust revision list 3
cumulative

78 questions to revise till page 60 of the rust book

*Rust Language Design and Philosophy* (5 Qs)
1. Why are variables immutable by default in Rust, what are the implications of that design choice as compared to other languages
2. What is the meaning of Rust being a statically typed language, how is it different from other languages, what are the pros and cons of this design choice 
3. What is the difference between compile time & runtime, how are they different in their implications for Rust developers as compared to other languages
4. Why does Rust panic at runtime when an array is indexed out of its bounds? What is the reasoning behind this design choice, how is it different from other languages
5. Why did we make Rust "ahead of time compiled language", what does it mean and what are its consequences for Rust devs, how is this different from other languages

*Rust Syntax and Features* (18 Qs)
  _Variables, Constants, and Shadowing_ (6 Qs)
  6. Why did we need constants when we already have immutable variables by default in the language
  7. What do you mean by const values should always be annotated, how is it different from other languages 
  8. What is the advantage of the design choice that consts can be used in any scope as compared to let which can only be defined in a function? What use cases does this come handy in, explain with examples
  9. What are the advantages of shadowing a variable using let, how is it different from reassigning a variable, what are the use cases where shadowing is better than reassigning the variable, explain with examples
  10. In shadowing if in the same scope let x = 5 & then let x=x+1 happens, then can we ever use x=5 value again? What is the logic behind this design choice, how is it different from other languages
  11. Why doesn't a shadow variable need a mut keyword?

  _Data Types_ (6 Qs)
  12. What is the meaning of scalar type in Rust, how is it different from other languages, what are the pros and cons of using scalar types in Rust
  13. What is the meaning of compound type in Rust, how is it different from other languages, what are the pros and cons of using compound types in Rust
  14. What is the meaning of types isize & usize - how does it change by architecture, why were they thought of, how is it different from other languages
  15. Why were tuples thought of in Rust, what is the reason for this design choice & how is it different from other languages 
  16. Why do arrays & tuples both have fixed length in Rust - what is the reason of this design choice, how is it different from other languages
  17. What are the implications of Rust char being a Unicode scalar value

  _Functions and Control Flow_ (6 Qs)
  18. What is the first code that runs in every executable Rust program?
  19. Why is println! a macro and not a function?
  20. What is the utility of loop keyword in conjunction with continue & break, what is the checklist of loop keyword which we should be aware of - and how is this as a design choice been different from other languages' loops 
  21. Explain the syntax of std::cmp:Ordering in Rust - why was it thought of, we could've done all that it does using if else, isn't it? Why have a separate syntax for it with variations Less Greater & Equals - what language purpose does it serve, and are there other languages that do this level of overthinking?
  22. What is the utility of match keyword & patterns in Rust, how is it different from other languages, what are the pros and cons of using match keyword in Rust. I am curious for what examples especially benefit this game
  23. What is the meaning of a catch-all value, e.g. _ , why was it thought of - and how is it used in Rust, what are the parallels in other programming languages
    
*Ownership, Borrowing, and Lifetimes* (4 Qs)
24. When we use a syntax like io::stdin().read_line(&mut guess) why do we put it in a new line
   - In the read_line() above why are we passing a reference to guess variable and not the variable itself, what is the logic behind this design choice
   - Also why are we supposed to add mut to the reference also, how is this different from just saying &guess  
25. Why are references in Rust immutable by default, what are the pros & cons of such a design choice as compared to other languages which we have seen like JavaScript
26. What is the meaning of destructuring the tuple & how many ways can you do it, how is it actually used in idiomatic Rust code
27. What is a trait, explain using the example of rand::Rng trait

*Error Handling and Edge Cases* (6 Qs)
28. What is the meaning of panic in context of Rust, and why was it thought of, how is it different from other languages  
29. What is integer overflow & how is the compilation different for it in presence or absence of --release flag, what are the pros and cons of this design choice
    - What are the ways to manage integer overflow in Rust, what are the pros and cons of each of them
    - How is this phenomenon in other languages
30. We understand that read_line() creates an enumeration or enum, what is enum in Rust, and how is it different from say variables. What are the pros and cons of using enums in Rust as compared to other languages
31. What is the utility of expect() method
32. What are the correct ways of writing error handling code in Rust
33. What is a Result type in Rust, how is it different from other languages, what are the pros and cons of using Result type in Rust

*Rust Toolchain and Ecosystem* (24 Qs)
  _Rustup, Rustc, and Cargo_ (5 Qs)
  34. Curl is used to install Rust, how did it come into being
     - How it became such a thing, are there other libraries doing this? 
     - Can curl or its parallel be written in Rust
     - Are there more use cases it can extend to
  35. Why did we think of rustup rustc and cargo as different things?
     - Is there a diagram of tool chain in Rust & other languages 
     - What are the meta patterns there
  36. What is the comprehensive list of tasks that Cargo does for Rust programmers
  37. What is the flow diagram of end to end work done by Cargo
  38. How is Cargo different from other similar tools in the market which are built for other languages

  _Cargo Project Structure and Configuration_ (11 Qs)
  39. Will a git file be created inside the project folder when we create a new project using Cargo? If no, who thought of this feature & why?
  40. What are the 2 files created inside the new Rust project
     - What is the main utility of main. rs file?
     - What is the main utility of Cargo.toml file
  41. Why is main. rs placed inside a src folder, what is the logic behind choosing such a folder structure, what are the pros and cons of it
  42. What is the story behind TOML format files, how are they named that & how are they used in Rust and elsewhere
  43. Why are readme, license info, config & non-code files placed in top most folder of the project
  44. Why does cargo build command deposit the executable in target/debug folder, what is the logic behind this, and how is this different from other languages, with what kind of pros and cons
  45. What is the logic for creation of Cargo.lock file, what is its utility, how is it different from other languages
  46. How are Cargo build and Cargo run commands different from other languages, what are the pros and cons of this approach
  47. Difference between cargo build --release and cargo build? How is it different from other languages & what are the pros and cons of this approach
  48. Which command is better for benchmarking to code run time? release or debug? Why was this design choice made & how is it different from other languages
  49. What is the utility of Cargo watch plugin, how is it different from Cargo run

  _Crates and Dependencies_ (8 Qs)
  50. What are the different types of crates in Rust, we know of Binary & Library, are there more types of crates? How was this design choice made & how does it have parallels in other languages like JavaScript or Python, and what are the pros and cons of it
  51. Why do we have to mention a crate as a dependency in the Cargo.toml file before we can use it in code
  52. What is the meaning of semantic versioning and how does it play out in context of Rust crates, explain with examples about how people can misunderstand it or use it to their advantage smartly
  53. What is the relationship between the registry & crates. io
  54. During Cargo build does Cargo redownload & compile all dependencies or only the diff from previous version of the code, how was this thought of and why
  55. Does 0.8.5 mean >=0.8.5 OR does it mean (>=0.8.5 & <0.9.0), why was this choice made & how is it different from other languages
  56. What is the utility of Cargo lock file, does it save time for Cargo in refiguring out dependencies - and how does that relate to the logic of it being checked into source control
  57. What is the utility of Cargo update command, how is it different from other languages

*Rust Standard Library and Prelude* (3 Qs)
58. What is a prelude in Rust?
59. What is the difference between using use std::io before the fn main & using std::io::stdin() inside the main function, why will the latter work directly?
60. What is the utility of parse() method
  
*Rust Community and Learning Resources* (3 Qs)
61. Why does Rust style with 4 spaces & not a tab?
62. Why was cargo doc --open thought of, what are the parallels in other languages, is it really that helpful
63. Why does such an accomplished book give us such a tough task of giving a guessing game as an example which has only - and I repeat only 1 in 100 chance of being correct

*Miscellaneous* (15 Qs)
  _Interoperability and FFI_ (2 Qs)
  64. I used a Rust script to create folders but it needed c bindings, so I had to install build-essential library
  65. How was the whole Cargo system thought of as a product, and do other languages have such a similar system which can help the navigate dependencies gracefully

  _Shell and Debugging_ (3 Qs)
  66. How does the pushd & popd code work in shell
  67. What is the use of .pbd file
  68. What do you mean by the concept of "being local to the current thread of execution"

  _Syntax and Language Features_ (6 Qs)
  69. Why is method_name() syntax not written as io::stdin().read_line(&mut guess).expect("Failed to read line"); in a single line, but introduces new line & white space? How is this different from other languages as a design choice and what are the pros and cons of that design choice
  70. Loki reference: What is a variant in Rust
  71. What is the difference between function & method in Rust
  72. What is the reason behind the choice of having curly bracket pair { } as placeholders in Rust, how is it different from other languages, what are the pros and cons of this design choice
     - Can placeholders be used to do calculations?
     - What kind of types do they accommodate apart from strings
     - Can they do direct conversions of numbers to strings, if yes with what caveats
  73. By default in range mentioned is inclusive of left and exclusive of right in Rust, what is the reason for such a choice, and how do we implement one where the RHS needs to be included too, give a variety of examples from different features of Rust
  74. Unless mentioned otherwise why is i32 the default integer type for Rust?

  _Error Handling and Edge Cases_ (4 Qs)
  75. What is the meaning of encoding error handling information, how is it thought of in Rust vs how is thought of in other languages like JavaScript
  76. What happens is a value is returned but it is not assigned to a variable, for e.g. io::stdin().read_line(&mut guess).expect("Failed to read line"); worked out ok but we did not assign it to a variable, what happens to the value returned in such cases
  77. What happens if we do not call expect() method after read_line() method, will the program compile? If yes what will be the repurcussions
  78. Can random number generators be seeded from something apart from the operating system? Give examples of different such seeding patterns and pros/cons of them