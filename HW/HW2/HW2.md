# HW2: Same Operations, Different Speed

## Connect

In Lab2 you worked with loads, address calculations, and array traversal.

At the level you've mostly worked at so far, estimating the cost of a program seems straightforward:

- count the instructions,
- count the loads,
- count the arithmetic,
- and compare how much work each version performs.

That's a useful model.

If two loops execute the same number of additions and read the same number of array elements, you would reasonably expect them to take about the same amount of time.

We're going to test that assumption.


## Confront

In class, we'll run one RISC-V program that sums every element of the **same 2048 × 2048 array of 32-bit integers** two different ways.

The first traversal walks across each row before moving to the next:

```text
a[0][0], a[0][1], a[0][2], ...
a[1][0], a[1][1], a[1][2], ...
```

The second walks down each column before moving to the next:

```text
a[0][0], a[1][0], a[2][0], ...
a[0][1], a[1][1], a[2][1], ...
```

Both versions:

- visit every element exactly once,
- perform the same number of loads,
- perform the same number of additions,
- sum the same data,
- and produce the same result.

Only the **order of the memory accesses** changes.

Before seeing the timing results, make a prediction:

**How much slower do you expect one traversal to be than the other?**

- ☐ Essentially the same
- ☐ Less than 2× different
- ☐ 2–5× different
- ☐ More than 5× different

Now watch the demonstration.

**Row-major time:** __________________

**Column-major time:** _______________

**Observed ratio:** __________________


Here's the assumption we're going to challenge:

> **If two programs perform the same operations the same number of times, they should take roughly the same amount of time.**

Nothing about the math changed.

Nothing about the number of array elements changed.

Nothing about the number of logical loads changed.

Yet changing only the **order** in which memory was accessed caused a large performance difference.

Something your operation-count model doesn't account for is determining a substantial part of the runtime.

That's the gap we're going to investigate.


### Instructor Demo

The instructor will run the row-major/column-major comparison in class.

The RISC-V source and instructions for running it yourself are available in `HW/DEMOS/HW2` if you'd like to experiment with them, but **running the demo yourself is not required for this homework**.

The demo uses a 16 MB array deliberately: it is large enough that the memory hierarchy has to matter rather than allowing the entire working set to remain in a small cache.

Exact timing will vary by machine. The important observation is the **difference produced by changing the access pattern while keeping the logical work the same**.


# Concept

The model we're missing is the **memory hierarchy**.

A CPU generally doesn't retrieve exactly one 4-byte integer from main memory every time your program executes a load.

Memory is transferred and cached in larger contiguous blocks called **cache lines**.

A common cache-line size on modern processors is 64 bytes.

Our demo uses 32-bit integers:

**4 bytes per integer**

so a 64-byte cache line can contain:

**16 consecutive integers.**


### Row-major traversal

A row-major traversal reads:

```text
a[0][0]
a[0][1]
a[0][2]
a[0][3]
...
```

Those values are stored next to each other in memory.

When the processor needs `a[0][0]`, the memory hierarchy can bring in a whole cache line containing that value **and the next several values the loop is about to request**.

The program uses the data that arrived with the first access.


### Column-major traversal

A column-major traversal reads:

```text
a[0][0]
a[1][0]
a[2][0]
a[3][0]
...
```

But this is still a row-major-stored array.

Each row contains 2048 integers:

```text
2048 × 4 bytes = 8192 bytes
```

So consecutive accesses in the column traversal are **8192 bytes apart**.

Instead of immediately asking for neighboring data that was brought into the cache, the program jumps thousands of bytes away and asks for data from somewhere else.


| Access pattern | Distance to next element | Useful pattern |
|---|---:|---|
| Row-major | 4 bytes | Neighboring data is used immediately |
| Column-major | 8192 bytes | Traversal repeatedly jumps to another row |


The name for the useful behavior in the first case is **spatial locality**:

> If a program accesses one memory location, it is likely to access nearby locations soon afterward.

Caches are designed to exploit that behavior.

That's enough of the model to begin investigating.

You already know **what happened** in the demonstration.

Now you need to figure out:

- why locality changes performance so dramatically,
- what actually happens on a cache hit versus a cache miss,
- why operation count alone misses this cost,
- why the compiler can't always rescue poor locality,
- and where programmers deliberately reorganize computation around the memory hierarchy.


# Construct

Use any AI assistant for this investigation.

The prompts below are **starting points**, not questions you need to copy word-for-word.

Follow the investigation where your understanding requires it. Ask follow-up questions when something is unclear, incomplete, surprising, or worth checking.

At least once, you must stop and verify or challenge something the AI tells you. You'll document that moment in Confirm.


### Step 1 — Where did the extra time actually go?

Start from the contradiction you observed.

Both traversals perform the same logical work, yet one takes substantially longer.

Investigate what the processor is actually waiting for during the slower traversal.

Among the questions you might explore:

- What is a cache hit?
- What is a cache miss?
- What happens after a requested value isn't available in the closest cache?
- Why can accessing data already in a cache be much faster than obtaining it from farther down the memory hierarchy?
- Why doesn't counting source-level loads capture this difference?

Don't stop at:

> "Column-major has more cache misses."

Try to understand **why those misses cost time**.


### Step 2 — Follow one cache line

Now make the effect concrete.

Our array contains 32-bit integers and we'll use a 64-byte cache line as the working example.

Investigate what happens after the processor requests:

```text
a[0][0]
```

during row-major traversal.

How many neighboring array elements can arrive in the same 64-byte cache line?

How many of those elements will the row-major traversal use immediately?

Then compare that with the column-major access pattern, where the next requested element is 8192 bytes away.

Explain to yourself why the two programs can execute the **same number of load instructions** while placing very different demands on the memory hierarchy.


### Step 3 — Put numbers on the hierarchy

Now investigate how large the latency differences in a modern memory hierarchy can be.

Choose a **specific modern processor or processor family** for which you can find credible information.

Investigate approximate access costs for some combination of:

- L1 cache,
- L2 cache,
- L3 / last-level cache,
- main memory.

The exact values will depend on the processor, so don't look for one universal number.

Instead, try to answer:

> **How different can the cost of "a load" become depending on where the requested data is found?**

Record the processor/source you use, and pay attention to whether the values are measured, manufacturer-specified, estimated, or converted between cycles and time.


### Step 4 — Catch the AI

During Steps 1–3, identify **one claim that deserves checking**.

The AI does **not** have to be wrong.

It might give you:

- a cache-line size,
- a latency number,
- a statement about what happens on a cache miss,
- a claim about prefetching,
- or an explanation that sounds more universal than you think it should.

Push back.

Ask for more precision, request evidence, compare the claim against processor documentation or another credible source, or otherwise investigate whether the claim deserves your confidence.

What matters isn't catching the AI making a mistake.

What matters is recognizing:

> **"This sounds plausible, but how do I know?"**


### Step 5 — Why doesn't the compiler just fix it?

Modern compilers perform sophisticated optimization.

So if row-major traversal is faster, why doesn't the compiler simply turn every poorly ordered traversal into a cache-friendly one?

Investigate what could prevent that transformation.

Consider questions such as:

- Can changing loop order change program behavior?
- Could one iteration depend on the result of another?
- Could memory references alias each other?
- Does the compiler always know the size and layout of the data?
- Can the best traversal depend on information only known at runtime?

Try to identify at least one concrete situation where changing loop order would **not** be safe.


### Step 6 — Where professionals deliberately exploit locality

Now find one real example where software or data layout is deliberately organized around memory locality.

Possibilities include:

- loop tiling/blocking in matrix algorithms,
- BLAS or other numerical libraries,
- cache-aware matrix multiplication,
- database storage/layout decisions,
- image processing,
- game-engine data structures,
- structure-of-arrays versus array-of-structures layouts,
- machine-learning kernels,
- or another example you find.

Choose a **specific technique, system, library, or algorithm**, not just a generic statement that "programmers optimize caches."

Investigate:

- what access pattern was causing a problem,
- what was changed,
- and why the new organization interacts better with the memory hierarchy.

By the end of your investigation, you should be able to answer:

> **If the algorithm performs the same logical work, how can changing where and when data is accessed change performance so dramatically?**


# Confirm

## Part A: Multiple Choice (5 pts each, 20 pts total)

Circle one.


**MC1.** Why can column-major traversal of a row-major-stored array run much slower even when it performs the same number of arithmetic operations and logical loads?

- A. Column-major traversal uses a slower addition instruction
- B. Its access pattern makes much poorer use of data brought into the cache, causing more costly interaction with the memory hierarchy
- C. The CPU has to execute every column-major instruction twice
- D. Row-major traversal skips some array elements


**MC2.** What is a cache line?

- A. A single variable stored in a CPU register
- B. A contiguous block of memory transferred and cached together
- C. A dedicated wire connecting the CPU directly to RAM
- D. A compiler-generated marker identifying loops


**MC3.** What does **spatial locality** describe?

- A. A program repeatedly executing the same arithmetic instruction
- B. A program being likely to access memory locations near one it recently accessed
- C. A processor keeping frequently used variables only in registers
- D. Two processors accessing memory at the same time


**MC4.** Why can't a compiler safely reorder every column-major loop into a row-major loop?

- A. Compilers aren't allowed to change loops
- B. Changing iteration order can change program behavior when dependencies, aliasing, data layout, or other constraints are present
- C. Compilers don't know that caches exist
- D. Row-major traversal is only valid in assembly language


## Part B: Show What You Learned


### N1 — The corrected model (20 pts)

In 2–3 sentences, correct this statement:

> **"If two programs perform the same operations the same number of times, they should take roughly the same amount of time."**

Your answer should explain why **memory access pattern and spatial locality** can make operation count alone a poor predictor of runtime.


### N2 — Put real numbers on it (15 pts)

Give the memory-hierarchy comparison you investigated in Step 3.

- **Processor / processor family:**
- **Fastest cache level you investigated:**
- **Approximate access cost:**
- **Slower cache level or main memory:**
- **Approximate access cost:**
- **What surprised you about the comparison:**
- **Source:**


### N3 — Catch the AI (20 pts)

Identify one claim from your AI investigation that you did not simply accept.

- **What the AI claimed:**
- **Why you questioned it or wanted more precision:**
- **What you did to check it:**
- **What you concluded:**

Remember: there is no requirement that the AI actually be wrong. Good technical investigation means recognizing which claims deserve checking and finding evidence before deciding whether to trust them.


### N4 — Your best follow-up (10 pts)

Look back through your AI conversation.

**What follow-up question most improved your understanding?**

Write the question:

> ________________________________________________________________

In 1–2 sentences, explain **why that question was useful or how it changed/refined your understanding.**


### N5 — Connect back (10 pts)

Check the **two** architecture concepts from lecture that most directly explain the performance difference you investigated.

Write one sentence for each explaining the connection.

- ☐ Cache lines / block-based memory transfers
- ☐ Spatial locality
- ☐ Temporal locality
- ☐ Cache hierarchy (L1/L2/L3)
- ☐ Cache-miss penalty / memory latency


## Appendix — AI Conversation

Paste your full AI chat export.

No cleanup is required. The transcript is not graded for writing quality. It is included as evidence of the investigation you performed.


---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment.

There are no right or wrong answers. All items below are graded on **completion only**, never on the response selected. Selecting **Prefer not to answer** counts as complete.


### B1 — Before

Before this assignment, how well could you explain why two programs that perform the same number of operations can have very different runtimes because of their memory access patterns?

1. I could not explain this topic at all; it was new to me.
2. I could name some related terms, but not explain the concepts behind them.
3. I could explain some of the assignment's key concepts at a high level, but not how they fit together.
4. I had some previous knowledge of this topic and would have felt comfortable explaining most of the key concepts.
5. I had a working background in this topic and was confident I could explain the performance effect to someone else.

- ☐ Prefer not to answer


### P1 — After

After this assignment, how well could you explain why two programs that perform the same number of operations can have very different runtimes because of their memory access patterns?

1. I still don't feel I could explain this comfortably yet; I need more practice and exposure to the topic.
2. I could explain some of the assignment's key concepts at a high level, but not in detail.
3. I could explain the individual concepts but not fully how they connect to the observed performance difference.
4. I am confident I could explain the effect well enough to help a fellow classmate understand it.
5. I could confidently explain and defend the relationship between access pattern, locality, and performance in a technical discussion.

- ☐ Prefer not to answer


### INV — What drove your investigation?

Thinking about your AI investigation on this assignment, which statement best describes what **primarily drove your approach**?

Pick the one that fits best.

- ☐ I mainly wanted to complete the required assignment efficiently.
- ☐ I mainly wanted to understand enough to answer the assignment questions correctly.
- ☐ I mainly wanted to resolve why the two traversals behaved differently even though they appeared to perform the same work.
- ☐ I mainly wanted to understand memory locality well enough that I could recognize or apply it in other programs.
- ☐ Something else. *(Optional: tell us what.)*
- ☐ Prefer not to answer


### FAV — What helped most?

Which part of this homework helped you **understand the topic the most**?

Pick one.

- ☐ The in-class demonstration / prediction
- ☐ Reading the Concept section
- ☐ The AI investigation
- ☐ Challenging or verifying something the AI told me
- ☐ Answering the Confirm questions
- ☐ Prefer not to answer


### SCA — What should we do with this format?

Thinking about the topic and the process overall, what should we do with this homework format going forward?

- ☐ **Continue as is.** *Tell us more (optional): any suggestions to make it even better?*
- ☐ **Adjust something.** *Tell us more (optional): what would you change?*
- ☐ **Stop, and go back to a traditional homework model.** *Tell us more (optional): what didn't work for you?*
- ☐ Prefer not to answer


---

# Grading Rubric

| # | What's being evaluated | Points |
|---|---|---:|
| MC1–MC4 | Correctly identifies the core memory-hierarchy and locality concepts | 20 |
| N1 | States the corrected model: explains why memory access pattern and spatial locality can make operation count alone a poor predictor of runtime | 20 |
| N2 | Provides a specific memory-hierarchy latency comparison for a named processor/family with a credible source | 15 |
| N3 | Identifies a specific AI claim, gives a genuine reason for checking it, describes a verification action, and reaches a supported conclusion | 20 |
| N4 | Identifies a specific follow-up question and explains how it advanced or refined understanding | 10 |
| N5 | Selects two defensible architecture concepts and correctly explains their connection to the observed performance difference | 10 |
| Transcript | Included and shows the AI investigation | Required |
| Feedback | Completes the required feedback items; “Prefer not to answer” counts as complete | 5 |

**Total: 100 points.**