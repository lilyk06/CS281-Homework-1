# HW7 — Submission Template

This is the only file you need to fill out and submit for HW7. Copy it,
fill in your answers directly below each question, and turn in the
completed copy. You don't need to touch or resubmit `HW7.md`.

For multiple-choice items, mark your choice by changing `[ ]` to `[x]`.
For the Feedback section, several items just ask you to enter a single
number, see the instructions there.

---

# Part A: Multiple Choice (5 pts each, 20 pts total)

**MC1.** What is the most important conclusion to draw from the HW7 demo?

- [ ] A. GPUs are always faster than CPUs.
- [ ] B. CPUs should no longer be used for mathematical computation.
- [x] C. Different workloads and problem sizes can reward different architectural choices.
- [ ] D. Matrix multiplication can only be performed efficiently on GPUs.

**MC2.** Why can a CPU outperform a GPU for a very small parallel workload?

- [ ] A. GPUs cannot perform small calculations.
- [x] B. The overhead of using the GPU can outweigh the benefit of its parallel resources when there is too little work.
- [ ] C. CPUs contain more GPU cores for small problems.
- [ ] D. GPUs disable parallel execution for small matrices.

**MC3.** Which statement best captures the architectural difference explored in this homework?

- [ ] A. CPUs and GPUs perform different mathematics.
- [x] B. CPUs emphasize flexible general-purpose execution, while GPUs make different tradeoffs to support high parallel throughput.
- [ ] C. GPUs are CPUs running at a higher clock frequency.
- [ ] D. CPUs cannot execute instructions in parallel.

**MC4.** Why are specialized AI accelerators useful for some machine-learning workloads?

- [x] A. They can dedicate hardware to computational patterns that occur frequently in those workloads.
- [ ] B. They can execute every possible program more efficiently than a CPU.
- [ ] C. They eliminate the need for memory.
- [ ] D. They make algorithms independent of hardware architecture.

---

# Part B: Show What You Learned

### N1 — Correct the model (15 pts)

Correct this statement: "A GPU is basically a faster CPU with thousands of smaller CPU cores." In 2–4 sentences, explain why that description is incomplete, referencing architectural tradeoffs, throughput, and workload characteristics.

> Your answer:
> A GPU is not a faster CPU with more cores. It is a throughput-oriented design that gives up the machinery CPUs use to make a single thread fast and spends that area on many simple arithmetic lanes, large register files, and high memory bandwidth. Its lanes are grouped so that 32 threads share one instruction fetch and decode (SIMT), and it hides memory latency by switching among thousands of resident warps instead of avoiding the latency. This makes it much better on regular, data-parallel, high-arithmetic-intensity work such as matrix multiplication, but much worse than a CPU on serial, branch-heavy, or latency-bound work, so it is a different tradeoff and **not** a faster version of the **same** thing.

### N2 — Explain the crossover (15 pts)

The CPU dominated the smallest matrices while the GPU became much more effective as the workload grew. Explain why that pattern is more useful than simply saying "the GPU is faster." Discuss available parallel work, fixed/setup overhead, and why workload size matters.

> Your answer:
> It is more useful than "the GPU is faster" because it shows that GPU performance depends on workload size, not just on the hardware. A GPU only pays off when there is enough independent parallel work to keep thousands of lanes busy and to give the warp scheduler enough resident warps to hide memory latency. For a matrix multiplication of size N, the work grows as N^3 while the data grows as N^2, so larger matrices provide both more parallelism and higher data reuse (arithmetic intensity). For small matrices, fixed costs dominate: the kernel launch, the data transfer over PCIe, and underused lanes with too few warps to hide latency, all of which can exceed the time a CPU needs to just finish the job. As the matrices grow, those fixed costs are amortized over far more computation, and the GPU's throughput advantage overtakes the CPU's lower latency and zero setup cost. The right choice depends on the problem size and whether or not the data already lives on the GPU, so the crossover point is the useful result and not a blanket claim about which processor is faster.

### N3 — Choose the architecture (15 pts)

For each workload, choose the architecture you would investigate first (CPU, GPU, or specialized AI accelerator) and explain why.

**A. A compiler processing source code**

- **Architecture:** CPU
- **Why:** A compiler involves complex branching, parsing, and irregular data structures such as abstract syntax trees, control-flow graphs, and symbol tables. CPUs are designed to handle these kinds of workloads through features like branch prediction, out-of-order execution, strong single-thread performance, and cache hierarchies. GPUs are less suitable because their SIMT architecture works best when many threads perform the same operations, while AI accelerators are too specialized for general-purpose compiler tasks.

**B. Applying the same operation independently to millions of pixels**

- **Architecture:** GPU
- **Why:** Processing millions of pixels independently is a highly parallel workload because the same operation can be applied to each pixel without depending on the results of other pixels. GPUs have thousands of arithmetic lanes that can process many pixels simultaneously. Their SIMT architecture, high memory bandwidth, and ability to combine adjacent memory accesses through coalescing make them particularly effective for this type of task. A CPU could handle smaller images, but a GPU is generally better suited for large-scale parallel processing.

**C. Large-scale neural-network training dominated by matrix operations**

- **Architecture:** Specialized AI accelerator
- **Why:** Large neural networks rely heavily on matrix multiplication and tensor operations, which are exactly what specialized AI accelerators are designed to perform. Architectures such as Google's TPU use systolic arrays containing thousands of multiply-accumulate units that can perform matrix operations efficiently while reusing data internally. This provides high computational throughput and energy efficiency. A GPU with tensor cores would also be a strong choice because it combines specialized matrix hardware with more flexibility, but a TPU can be especially efficient for large, regular, matrix-dominated workloads.

### N4 — Make specialization concrete (10 pts)

- **Architecture / feature:** Google's Tensor Processing Unit (TPU), specifically its Matrix Multiply Unit (MXU) and systolic array architecture.
- **What workload or operation it is designed to accelerate:** Large-scale neural-network operations, particularly matrix multiplication and multiply-accumulate operations used during neural-network training and inference.
- **What architectural specialization you found:** The TPU uses a two-dimensional grid of multiply-accumulate units called a systolic array. Data flows through the array between neighboring processing elements, allowing weights and intermediate values to be reused without repeatedly accessing external memory. This allows many matrix calculations to happen simultaneously.
- **Why that specialization helps:** Neural networks perform enormous numbers of matrix operations, so having dedicated hardware for these calculations significantly improves throughput and energy efficiency. The systolic array reduces unnecessary data movement by reusing values within the hardware instead of repeatedly fetching them from memory. This makes it particularly effective for large, regular matrix operations.
- **Source:** Jouppi et al., In-Datacenter Performance Analysis of a Tensor Processing Unit, ISCA 2017. Google Research - TPU architecture paper.

### N5 — Catch the AI (15 pts)

- **What the AI claimed:** The AI originally claimed that Google's TPUs do not use warp schedulers, speculation, or dynamic latency hiding through thread switching, unlike GPUs.
- **Why you questioned it or wanted more precision:** I wanted to verify whether or not this was an accurate comparison of TPU and GPU architectures or just an oversimplification. I was specifically interested in whether the claim applied to every generation of TPU and whether GPUs actually use speculation in the same way as CPUs.
- **What you did to check it:** I asked the AI to break down the claim and identify which parts were documented versus its own interpretation. I then identified Google's original TPU research paper, In-Datacenter Performance Analysis of a Tensor Processing Unit (Jouppi et al., ISCA 2017), Google's official Cloud TPU architecture documentation, and NVIDIA's CUDA Programming Guide as technical sources for verification.
- **What you concluded:** The original claim was mostly accurate but it was also oversimplified. Google's original TPU paper describes a deterministic execution model and explicitly discusses omitting features such as hardware multithreading and out-of-order execution. NVIDIA's documentation explains how GPU warp schedulers select ready warps to hide memory latency. However, the claim about speculation was misleading because GPUs generally do not use CPU-style speculative, out-of-order execution either. Additionally, findings about the original TPU should not automatically be generalized to every newer TPU generation.

### N6 — Your best follow-up (5 pts)

**Your follow-up question:**

>"I want to closely examine one of the technical claims you made in your explanation of Google's TPU. You stated that TPUs do not use warp schedulers, speculation, or dynamic latency hiding through thread switching, unlike GPUs. I want to figure out how accurate this comparison is... Please distinguish between what is documented and what is your own interpretation. Don't simply defend your original answer."

**Why it was useful, or how it changed your understanding (1–2 sentences):**

>It showed me that the neat contrast that I been given by Claude was oversimplified: speculation is a CPU feature that GPUs also lack, the TPU still hides latency but through compiler-scheduled data movement instead of thread switching, and the strongest documentation (the 2017 ISCA paper) only covers TPU v1. It also taught me to separate what a source states explicitly from what I am inferring, and to treat CPU, GPU, and TPU designs as points on a spectrum of hardware-decided versus compiler-decided scheduling, and not as a clean binary.

### N7 — The course in one architectural question (5 pts)

Complete in your own words: "Before this course, I mostly thought of a processor as **an abstract "brain" of the computer, a black box that just does computing without me needing to know how**. Now I think the more useful architectural question is **what kind of work is this hardware built to do, and what has it traded away to do it well?**" Then briefly explain why.

> Your answer:
> The reason for my thought process is that a processor is not one generic thing. It's a physical design with a limited budget of chip area and power, and every design spends that budget differently. A CPU spends it on making one task finish quickly, a GPU on doing thousands of simple, similar tasks at once, and a TPU on a matrix-multiplication engine for neural networks. Every single choice makes some workloads much faster and others slower, which is why the best processor depends on the job, and why moving data to and from memory often matters as much as the arithmetic itself. This class has taught me that there will always be some tradeoff, and no processor is "best" in general, so the useful skill is matching the hardware to the shape of the workload instead of asking which chip is faster.

---

# Appendix — AI Conversation

Paste your full AI chat export below. No cleanup required.

>I am working on understanding the architectural differences between CPUs and GPUs for a computer architecture assignment.
I understand that CPUs are moreso for general-purpose computing, while GPUs are designed to handle large amounts of parallel work. However, I want to understand what is actually different about their hardware designs.
Why can a GPU be so much more effective than a CPU for something like matrix multiplication, where thousands or millions of independent calculations can be performed?
Specifically, I want you to explain:

What makes a CPU core architecturally different from a GPU execution resource?
What does a CPU prioritize that a GPU potentially simplifies or sacrifices to achieve higher throughput?
How do latency-oriented and throughput-oriented designs differ?
Why wouldn't a GPU automatically outperform a CPU on every workload?

Please explain this step by step.

CPU vs. GPU architecture: step by step

The core idea is that the two chips spend their transistor budgets on different problems. A CPU spends transistors to make one thread finish as fast as possible. A GPU spends them to finish as much total work as possible per second.

Step 1: What is a CPU core vs. a GPU execution resource?

A CPU core is a large, sophisticated machine built to run one instruction stream quickly. A modern core typically includes:

Several execution units, issuing multiple instructions per cycle (superscalar)
Out-of-order execution hardware (reorder buffer, register renaming, schedulers)
Branch predictors and speculative execution machinery
Large private L1/L2 caches, plus a big shared L3
Wide SIMD units (e.g., AVX), but only a handful of lanes

A chip has maybe 8 to 64 of these cores, and most of each core's area is control and caching, not arithmetic.

A GPU is organized differently. The unit you should think about is a streaming multiprocessor (NVIDIA) or compute unit (AMD). Each one contains:

Many simple arithmetic lanes (what NVIDIA calls "CUDA cores")
A small number of instruction fetch/decode units shared across all those lanes
A very large register file
Fast programmer-managed scratchpad memory ("shared memory")
Warp schedulers (see Step 3)

Threads execute in groups of about 32 (a "warp" on NVIDIA, a "wavefront" on AMD) that run the same instruction in lockstep on different data. This model is called SIMT (single instruction, multiple threads). One fetch and decode serves 32 or more lanes, which amortizes the control overhead. Modern GPUs also include tensor cores or matrix units: fixed-function hardware that multiplies small matrix tiles in a single operation, which is directly relevant to your matrix multiplication question.

So a GPU "core" is not comparable to a CPU core. A single GPU lane is far simpler, but there are thousands of them.

Step 2: What does a CPU prioritize that a GPU simplifies or sacrifices?

A CPU is designed so that arbitrary, unpredictable, serial-ish code runs fast. That requires expensive mechanisms:

CPU investment	Purpose	GPU approach
Out-of-order execution, register renaming	Find independent instructions within one thread and overlap them	Mostly in-order issue; parallelism comes from other threads instead
Branch prediction and speculation	Avoid stalling on if statements and loops	Minimal; divergent branches are handled by masking lanes
Large, deep cache hierarchy	Make memory latency look short for one thread	Small caches relative to thread count; more reliance on bandwidth and scratchpad
Strong memory-ordering guarantees, precise exceptions	Make programming and OS support tractable	Much weaker consistency model; limited support for interrupts and context switching
OS support (privilege levels, virtualization, interrupts)	General-purpose system control	Largely absent from the compute path

Every one of these features costs silicon area and power. A GPU removes or shrinks most of them and reallocates that area to arithmetic units and registers. That is the trade: less cleverness per thread, far more threads doing math.

Step 3: Latency-oriented vs. throughput-oriented design

Latency-oriented (CPU): The goal is to make each task complete quickly. If a thread asks for data from DRAM, which takes hundreds of cycles, the CPU fights that delay with caches, prefetchers, and speculation so the thread rarely waits.

Throughput-oriented (GPU): The goal is to maximize total work completed per unit time, and individual thread latency is allowed to be bad. Instead of avoiding the memory delay, the GPU hides it:

A warp issues a memory load and stalls.
The warp scheduler instantly switches to another warp that's ready to compute.
By the time it runs through the other ready warps, the first warp's data has arrived.

This switch is nearly free because the register file is big enough to hold the state of many resident warps at once, so there's no saving and restoring of registers as in a CPU context switch. A GPU keeps thousands of threads in flight to keep its ALUs busy.

This follows Little's Law: the concurrency you need equals throughput times latency. High memory latency plus a high target throughput means you need an enormous number of operations in flight, which a GPU provides and a CPU core doesn't.

GPUs also pair this with much higher memory bandwidth (roughly an order of magnitude beyond typical CPU memory systems, thanks to wide buses and HBM/GDDR), because thousands of threads need to be fed.

Why this fits matrix multiplication so well

For C = A × B with N×N matrices:

There are N² output elements, and each one can be computed independently (a dot product of a row and a column).
The work is about N³ multiply-adds on only N² data, so there's a high ratio of arithmetic to memory traffic (high arithmetic intensity). Data loaded once gets reused many times.
Access patterns are regular and predictable, with no unpredictable branching.
The work tiles naturally: a block of threads loads a tile of A and B into shared memory once, and every thread in the block reuses it.
Tensor cores then perform small tile multiply-accumulates as single hardware operations.

Every feature of the GPU (many lanes, lockstep execution, huge bandwidth, scratchpad, matrix units) is being used, and none of the CPU's sophisticated machinery (speculation, deep caching of irregular access) would help much.

Step 4: Why doesn't a GPU win everywhere?

The same design choices that help on regular parallel work hurt elsewhere:

Serial or dependent work. If step n+1 needs the result of step n, thousands of lanes can't help, and one weak GPU lane is much slower than a strong CPU core. This is Amdahl's Law: the serial fraction limits overall speedup.
Branch-heavy, irregular control flow. In a warp, if some lanes take the if and others take the else, the hardware runs both paths with lanes masked off. This is warp divergence, and it wastes throughput. CPUs handle unpredictable branching far better.
Pointer chasing and irregular memory access. Linked lists, trees, and hash-table lookups are latency-bound and have poor locality. The GPU's latency hiding only works if there are enough independent threads to switch to.
Small problems. Moving data over PCIe (or launching a kernel) has fixed overhead. If the computation is small, that overhead can exceed the savings.
Low arithmetic intensity. If each byte loaded gets only a little math done on it, you're bound by memory bandwidth rather than compute, which shrinks the GPU's advantage.
Capacity and system tasks. GPU memory is smaller than system RAM, and GPUs aren't designed to run an OS, handle interrupts, or manage I/O.

A good rule of thumb: GPUs excel when the problem has massive data parallelism, regular control flow, and high arithmetic intensity. CPUs excel when the problem is latency-sensitive, branchy, irregular, or inherently serial.

For your assignment, a clean framing is that the CPU spends area on making one thread fast (speculation, out-of-order, caches), while the GPU spends it on running many threads at once (shared control, big register files, warp switching). Hiding latency through concurrency instead of eliminating it through cleverness is the single most important distinction.

If you'd like, I can sketch a diagram comparing the die-area allocation of the two designs, or walk through a tiled matrix multiply showing how threads share data in shared memory.

I definitely understand how CPUs invest more hardware in making individual threads execute quickly, while GPUs prioritize total throughput by keeping many threads active and switching between them when some are waiting.
I want to understand how this actually works inside the GPU.
Can you walk me through the GPU execution hierarchy, starting with GPU threads, thread blocks (or workgroups), warps, streaming multiprocessors (or compute units), ad kernels and grids
I'm particularly confused about a few things:

Does each GPU thread actually have its own execution core, or are multiple threads sharing hardware?
What exactly happens when 32 threads in a warp execute the same instruction?
How does the GPU decide which warps execute and when?
What happens when threads in the same warp need to take different branches?
How does this organization allow a GPU to handle thousands of threads without needing thousands of full CPU-like cores?

Please use a specific, concrete example and explain how the work moves from the programmer's code to the actual hardware.

Inside the GPU: from your code to the hardware
The running example

Suppose we add two arrays of 1,000,000 floats:

cuda
__global__ void add(const float* a, const float* b, float* c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;   // my global index
    if (i < n) {
        c[i] = a[i] + b[i];
    }
}

// Host side: launch with 256 threads per block
int blocks = (1000000 + 255) / 256;                  // = 3907
add<<<blocks, 256>>>(a, b, c, 1000000);

You write the code for one thread. The launch says "run this function 1,000,000+ times, once per data element," and the hardware figures out where and when.

Part 1: The software hierarchy (what you describe)
Thread: one instance of the kernel function. It has its own registers and its own index i, so it works on its own element.
Thread block (workgroup): a group of threads you choose the size of (256 here). Threads in a block can synchronize (__syncthreads()) and share fast on-chip memory. Threads in different blocks cannot cooperate directly.
Grid: all the blocks from one launch. Here the grid has 3,907 blocks, or 1,000,192 threads (slightly more than needed, which is why we have the if (i < n) check).
Kernel: the function itself, plus the act of launching it. One launch = one kernel = one grid.

Blocks are required to be independent, so the hardware can run them in any order, on any available processor, with no coordination. That rule is what lets the same program run on a small GPU with 10 processors or a big one with 130.

Part 2: The hardware hierarchy
Streaming multiprocessor (SM) (AMD: compute unit): the real "processor" of a GPU. A GPU has dozens to over a hundred of them. Each SM has its own register file, shared memory/L1 cache, and schedulers.
Sub-partition: an SM is typically split into 4 of these. Each has its own warp scheduler, instruction dispatch, and a set of arithmetic lanes (e.g., 32 FP32 lanes).
Warp (AMD: wavefront): a group of 32 threads (64 on some AMD hardware) that the hardware executes together. You don't declare warps. The hardware carves each block into consecutive groups of 32 threads: threads 0-31 are warp 0, 32-63 are warp 1, and so on. Our 256-thread block becomes 8 warps.
Software	Hardware
Grid	The whole GPU
Block	Assigned to one SM, stays there until done
Warp (carved from block)	The unit the scheduler issues instructions for
Thread	One lane's worth of a warp instruction, plus its own registers
Part 3: How work moves from code to hardware
Compilation. The compiler turns the kernel into GPU instructions (PTX, then the machine code, SASS). The kernel becomes a short instruction sequence roughly like: compute i, compare to n, load a[i], load b[i], add, store c[i].
Launch. The driver sends the grid description (3,907 blocks, 256 threads each, registers needed per thread, etc.) to the GPU.
Block distribution. A hardware block scheduler hands blocks to SMs that have room. "Room" means enough free registers, shared memory, and thread slots. With, say, 100 SMs, the first ~100 or more blocks are dispatched immediately (an SM can hold several blocks at once). The remaining blocks wait in a queue, and whenever a block finishes, its SM takes the next one. Nothing is time-sliced here: a block stays on its SM until it finishes.
Warp creation and residency. Once a block lands on an SM, its 8 warps become resident: they get registers allocated for their whole lifetime. This is the key to cheap switching.
Execution. The warp schedulers in the SM issue instructions from resident warps, as described below.
Your five questions
1. Does each thread have its own execution core?

No. A thread is a logical entity with its own registers and its own position in the program, but it has no dedicated core. The 32 threads of a warp share one instruction fetch, one decode, and one scheduler, and run on 32 simple arithmetic lanes.

The marketing term "CUDA core" is misleading. It's an ALU pipeline (e.g., one FP32 multiply-add unit), not a core with fetch, decode, branch prediction, and so on. A better mental model: an SM is a few "front ends" (the schedulers) driving many arithmetic lanes.

2. What happens when 32 threads execute the same instruction?

Take the load a[i]. The warp's scheduler issues one instruction, LOAD. Then:

Each of the 32 lanes reads its own thread's registers (each thread has a different i, so a different address).
The 32 addresses are a[base] through a[base+31]: consecutive floats, 128 contiguous bytes.
The memory system notices this and coalesces them into one (or very few) wide memory transactions instead of 32 separate ones.

For the FADD, the instruction is fetched and decoded once, and 32 lanes each add their own pair of values at the same time. This is SIMT: same instruction, different data per thread. Control overhead (fetch, decode, scheduling) is paid once and amortized across 32 results, which is exactly where the area savings over a CPU come from.

3. How does the GPU decide which warps run?

Each sub-partition has a warp scheduler managing the warps resident on it (up to roughly 16 or more, depending on the chip). Every cycle, it:

Looks at its resident warps and identifies which are eligible: the next instruction's operands are ready, and the warp isn't waiting at a barrier or on a pending memory result. (Hardware bookkeeping called a scoreboard tracks this.)
Picks one by some policy (round-robin, oldest-first, and so on; the exact policy is chip-specific and often not public).
Issues that warp's next instruction.

Now see how latency hiding works in practice. Warp 0 issues LOAD a[i], then LOAD b[i], and then its FADD has to wait several hundred cycles for DRAM. Since warp 0 is not eligible, the scheduler issues from warp 1, then warp 2, and so on. By the time it cycles back, warp 0's data has arrived.

This switch costs essentially nothing because every resident warp's registers are physically present in the large register file. Nothing gets saved or restored, in contrast to a CPU context switch.

(Separately, the block scheduler decides which blocks go to which SM, as in step 3 above. The two levels are different: blocks are assigned to SMs once, and warps are switched cycle by cycle.)

4. What happens when threads in a warp take different branches?

Our if (i < n) is a good small example, and here's a more interesting one:

cuda
if (x[i] > 0)  y[i] = sqrt(x[i]);   // path A
else           y[i] = 0.0f;          // path B

Suppose in one warp, lanes 0-15 have positive x and lanes 16-31 do not. The hardware can't issue two different instructions to one set of lanes at once, so it uses an active mask:

Run path A with the mask set to lanes 0-15. Lanes 16-31 are idle (their results are discarded).
Run path B with the mask set to lanes 16-31. Lanes 0-15 are idle.
Reconverge: at the end of the if/else, all 32 lanes become active again.

The warp takes the time of path A plus path B. This is warp divergence. Key points:

If all 32 threads agree on the branch, there's no cost. Only the path taken executes.
Divergence only matters within a warp. Different warps can take different paths with no penalty.
In our bounds check, only the very last warp has any divergence (a few lanes with i >= n), so the cost is negligible.
Worst case is 32 different paths, which serializes to 1/32 efficiency.

A caveat on modern hardware: since NVIDIA's Volta architecture, each thread logically has its own program counter ("independent thread scheduling"), which allows interleaving divergent paths and makes some fine-grained synchronization patterns safe. The execution is still SIMT underneath, and divergent paths still cost throughput, so for performance purposes the mental model above holds.

5. How do thousands of threads run without thousands of CPU-like cores?

The key is how cheap a thread is and how much of the machine is shared. Rough numbers for a recent design (they vary by generation):

An SM has 4 schedulers (so 4 fetch/decode front ends) driving about 128 FP32 lanes.
It can keep up to ~2,048 threads (64 warps) resident, many times more threads than lanes.
Its register file holds about 64K 32-bit registers. At 2,048 threads that's 32 registers per thread. This is the "cost" of each resident thread: a slice of registers rather than a whole core.
A GPU with ~100 SMs has ~12,800 lanes but over 200,000 threads in flight.

So the picture is:

Few expensive things (schedulers, fetch/decode) shared by many lanes.
Many cheap things (lanes, registers) that make up most of the chip's area.
Oversubscription (far more resident threads than lanes) so there's always some warp ready to run, which is what hides memory latency.

A thread costs a few dozen registers and a bit of scheduler bookkeeping. A CPU-style core per thread would cost an out-of-order engine, branch predictor, and private caches. That's why the GPU can have a million-thread launch run efficiently.

One consequence: resources limit occupancy. If your kernel uses 128 registers per thread instead of 32, fewer warps fit on an SM, there are fewer to switch among, and latency hiding gets worse. Tuning register and shared-memory usage is a big part of GPU performance work.

Summary of the flow
Your kernel + <<<3907 blocks, 256 threads>>>
   → block scheduler assigns blocks to SMs (as resources free up)
      → each block is split into 8 warps of 32 threads, made resident
         → per-cycle, each sub-partition's warp scheduler picks an eligible warp
            → one instruction is fetched/decoded once, executed by 32 lanes
               → stalled warps wait while others run; divergent branches use masks

Terminology note for AMD/OpenCL: thread = work-item, block = workgroup, warp = wavefront (32 or 64 wide), SM = compute unit, grid = NDRange.

If it would help, I can extend this to the matrix multiplication example from before, showing how a 2D block of 16×16 threads maps to warps and how shared memory tiling works within one SM.

Great, now I want to understand the GPU memory hierarchy and why memory becomes such an important architectural challenge when you have thousands of threads executing in parallel.
Can you walk me through how a GPU manages memory, specifically:

What are registers, shared memory, caches (L1/L2), and global/device memory? How are they different in terms of speed, capacity, and purpose?
What makes GPU shared memory different from the caches we've studied in CPUs?
What is memory coalescing, and why does it matter when many threads access memory simultaneously?
How does memory bandwidth limit GPU performance?
What happens when thousands of threads all need data at approximately the same time?
How does matrix multiplication take advantage of memory reuse and shared memory to avoid repeatedly accessing slower global memory?

Please use a concrete example, preferably matrix multiplication, and connect the explanation to the CPU cache hierarchy and memory concepts.
I want to understand why having thousands of execution resources is not just enough by itself, and why the memory system has to be designed around the GPU's throughput goals.

GPU memory: why thousands of lanes aren't enough

Arithmetic units are cheap to add, but feeding them is hard. Peak GPU compute grows much faster than memory speed, so most GPU optimization is really data movement optimization. Numbers below are representative of recent high-end NVIDIA-style GPUs and vary by generation.

Part 1: The memory hierarchy
Level	Scope	Rough capacity	Rough latency	Managed by
Registers	One thread	~256 KB per SM total (up to 255 per thread)	~1 cycle	Compiler
Shared memory	One thread block	Tens to ~200 KB per SM	~20-30 cycles	Programmer
L1 cache	One SM	Shares the same SRAM array as shared memory	~30 cycles	Hardware
L2 cache	Whole GPU	Tens of MB	~200-300 cycles	Hardware
Global (device) memory	Whole GPU, persists across kernels	8 GB to 100+ GB (GDDR/HBM)	~400-800 cycles	Programmer (allocation), hardware (caching)
Registers hold each thread's private variables. They are the fastest storage, but they are also the resource that limits occupancy (Part 5). If a thread needs more than its allotment, the compiler spills to "local memory," which is really just global memory with a different name and is slow.
Shared memory is on-chip SRAM that all threads in a block can read and write, which is how a block cooperates.
L1/L2 are hardware-managed caches that behave much as you'd expect. L2 is shared across all SMs and is the last stop before DRAM.
Global memory is the large off-chip pool where your arrays live. It has high bandwidth (roughly 1 to 3+ TB/s on high-end parts) but very high latency.

CPU comparison. A CPU has a similar shape (registers, L1/L2/L3, DRAM), but the CPU hierarchy is entirely hardware-managed and tuned to cut latency for one or two threads per core. A GPU hierarchy is tuned for bandwidth to many threads, and one level (shared memory) is under software control.

Part 2: How shared memory differs from a CPU cache

Both are fast on-chip SRAM, but they behave very differently:

	CPU cache	GPU shared memory
Who decides what's stored	Hardware (tags, replacement policy)	You, with explicit loads and stores
Lookup mechanism	Tag comparison, hit or miss	None. It's directly addressed
Latency	Variable (hit vs. miss)	Fixed and predictable (barring bank conflicts)
Eviction	Automatic, can evict your data unexpectedly	Never. Data stays until the block exits
Visibility	Coherent across cores	Visible to one block only, with explicit __syncthreads()

Why GPUs need this. Consider cache capacity per thread. An SM with ~128 KB of L1 and ~2,048 resident threads has about 64 bytes of cache per thread. A CPU core has 32-64 KB of L1 for one or two threads. At 64 bytes per thread, a conventional cache can't hold any thread's working set, and threads constantly evict each other. So GPUs give programmers a scratchpad where they can deliberately stage the data that a group of threads will reuse.

Banks. Shared memory is split into 32 banks, each 4 bytes wide, so the 32 lanes of a warp can access 32 different banks in one cycle. If two lanes hit different addresses in the same bank, the accesses serialize (a bank conflict). If all lanes read the same address, it's a broadcast and costs nothing.

Part 3: Memory coalescing

Global memory is served in fixed-size chunks (32-byte sectors, grouped into 128-byte lines), not individual floats. When a warp executes a load, the hardware looks at the 32 addresses and merges them into as few chunks as possible.

Coalesced case: thread i reads a[base + i]. The 32 addresses cover 128 contiguous bytes, so the warp needs about 4 sectors of 32 bytes. All of the fetched bytes are used. Efficiency is ~100%.

Strided case: thread i reads a[base + i*32] (for example, walking down a column of a row-major matrix). Each lane's address lands in a different sector. The warp now needs 32 sectors, so it fetches 1,024 bytes to use 128. That's 8× the traffic for the same useful data. (In the worst case, 4 useful bytes out of each 32-byte sector.)

Why it matters more on a GPU: a CPU core that does a strided access suffers on one thread, and the prefetcher may partially rescue it. On a GPU, 32 lanes issue the access together, thousands of threads do it concurrently, and bandwidth is already the scarce resource. Wasted sectors directly reduce your effective bandwidth.

CPU parallel: this is spatial locality and cache-line utilization, taken to the extreme. On a CPU, a 64-byte line is used well by one thread walking sequentially. On a GPU, the neighboring threads must collectively use the line.

Part 4: Bandwidth as the limit

Compare peak arithmetic to peak memory bandwidth for a hypothetical GPU: 30 TFLOPS FP32 and 1 TB/s of DRAM bandwidth.

To keep the ALUs fully busy, you need about 30 FLOPs per byte moved, or roughly 120 FLOPs per 4-byte float loaded from DRAM.

Now check our earlier vector add, c[i] = a[i] + b[i]:

Per element: 1 FLOP, 12 bytes of traffic (two loads and one store).
Attainable: 1 TB/s ÷ 12 B × 1 FLOP ≈ 83 GFLOPS, about 0.3% of peak.

No amount of extra lanes helps here, because the kernel is memory-bound. The key quantity is arithmetic intensity (FLOPs per byte of DRAM traffic), which is the x-axis of the roofline model. Below the "ridge point" (30 FLOP/B in this example), performance is limited by bandwidth. Above it, performance is limited by compute.

Tensor cores raise peak FLOPs even more than bandwidth rises, so the ridge point moves further right and the pressure to reuse data grows.

Part 5: What happens when thousands of threads all need data at once

Remember Little's Law from before. To sustain 1 TB/s with ~500 ns latency, you need about 1e12 B/s × 500e-9 s = ~500 KB of data in flight at all times. Spread over 100 SMs, that's ~5 KB per SM, or about 40 outstanding 128-byte warp loads per SM. That's why a GPU needs thousands of resident threads: each warp stalled on a load is one of those in-flight requests, and the machine only reaches full bandwidth if enough warps have loads outstanding.

Then the memory system has to survive the flood:

Many channels. DRAM is split into many independent channels (wide buses, HBM stacks), and L2 is split into slices. Addresses are hashed across them so concurrent requests spread out and don't pile up on one.
Miss merging. When many warps request the same line, the hardware tracks outstanding misses and merges duplicates so one DRAM fetch serves many requesters.
Queuing. If demand exceeds supply, requests queue, latency rises, and eventually every warp is waiting on memory. The scheduler has nothing to issue, and the ALUs sit idle. Latency hiding fails when the issue is bandwidth rather than latency, because switching to another warp just adds another request to an already saturated system.
Occupancy tradeoffs. If threads use too many registers or too much shared memory, fewer warps fit on an SM, fewer loads are in flight, and bandwidth is underused. This is how register and shared-memory use feed back into memory performance.

So the design requires two things at once: enough concurrency to cover latency, and enough bandwidth plus reuse to avoid saturating DRAM.

Part 6: Matrix multiplication and data reuse

Compute C = A × B, where all are N×N, row-major, FP32.

Naive kernel

Each thread computes one element C[row][col]:

cuda
float acc = 0;
for (int k = 0; k < N; ++k)
    acc += A[row*N + k] * B[k*N + col];
C[row*N + col] = acc;
Per iteration: 2 loads (8 bytes), 1 FMA (2 FLOPs) → 0.25 FLOP/byte, far below the ~30 needed.
Total loads: N² threads × 2N = 2N³, but only 2N² unique elements exist. Each element is fetched about N times. For N = 4096, that's thousands of redundant loads per element.
Coalescing here is decent: threads in a warp share a row and have consecutive col, so B[k*N + col] is coalesced, and A[row*N + k] is the same address across the warp (a broadcast). L1/L2 catch some of the repeated loads, but the cache is too small per thread to capture all the reuse.
Tiled kernel

Make each block compute a T×T tile of C, and stage tiles of A and B in shared memory (here T = 16):

cuda
#define T 16
__global__ void matmul(const float* A, const float* B, float* C, int N) {
    __shared__ float As[T][T];
    __shared__ float Bs[T][T];
    int row = blockIdx.y * T + threadIdx.y;
    int col = blockIdx.x * T + threadIdx.x;
    float acc = 0.0f;

    for (int t = 0; t < N / T; ++t) {          // assumes N is a multiple of T
        As[threadIdx.y][threadIdx.x] = A[row * N + t*T + threadIdx.x];
        Bs[threadIdx.y][threadIdx.x] = B[(t*T + threadIdx.y) * N + col];
        __syncthreads();                        // tile fully loaded

        for (int k = 0; k < T; ++k)
            acc += As[threadIdx.y][k] * Bs[k][threadIdx.x];
        __syncthreads();                        // done before overwriting
    }
    C[row * N + col] = acc;
}

What happens:

The block's 256 threads (8 warps) each load one element of the A tile and one of the B tile, with consecutive threads reading consecutive addresses, so the loads are coalesced.
__syncthreads() ensures the whole tile has arrived.
Each thread does T = 16 FMAs, reading operands from shared memory (fast, on-chip). Every loaded element is used by T different threads.
Barrier again, then slide to the next tile along the K dimension.

The payoff: each thread now issues 2N/T global loads instead of 2N, a T× reduction in global traffic (16× here). Arithmetic intensity rises from 0.25 to about 0.25 × T = 4 FLOP/byte, and with T = 32 it would be 8.

Bank behavior is also fine: Bs[k][threadIdx.x] has consecutive lanes hitting consecutive banks, and As[threadIdx.y][k] is a broadcast within each row of threads.

Honest caveat: 4 to 8 FLOP/byte is still below the ~30 ridge point in our example, so this kernel is better but not yet compute-bound. Real high-performance GEMM kernels add more layers of reuse: larger tiles, register tiling (each thread computes a small block of outputs, such as 8×8, so values loaded from shared memory are reused from registers many times), and tensor cores. Each step is the same idea one level down: move data up to a faster level once, reuse it many times.

The CPU connection

This is cache blocking (loop tiling), the same technique used to make CPU matrix multiply fast: pick a tile that fits in cache and do all the work on it before moving on. The difference is control. On a CPU, you size tiles hoping the hardware cache keeps them resident. On a GPU, you explicitly place the tile in shared memory, and it can't be evicted by other threads. That determinism is what makes it practical when 64 bytes of cache per thread can't be trusted to hold anything.

Why thousands of lanes aren't enough
Compute throughput grows with lanes.       ← cheap to add
Memory bandwidth grows with pins/channels. ← expensive, physically limited
Memory latency barely improves.            ← fixed by DRAM physics

So a throughput design must do four things together:

Hide latency with massive multithreading (cheap switching via the big register file).
Supply bandwidth with wide, many-channel memory like HBM.
Use bandwidth efficiently with coalescing, so every fetched byte is useful.
Reduce demand with explicit on-chip reuse (shared memory, registers) so most operands never touch DRAM.

Take any of these away and the thousands of lanes sit idle. The CPU makes the opposite bet: spend on large caches and prefetchers so a single thread rarely sees memory latency. The GPU instead assumes latency exists and builds the whole memory system to keep a very large number of requests in flight.

If it would help, I can work through the roofline model numerically for the naive vs. tiled kernels, or show how register tiling takes the intensity past the ridge point.

Good so now I want to understand why these architectural characteristics make GPUs particularly useful for modern AI and machine learning.
Can you explain:

Why do neural networks rely so heavily on matrix multiplication, vector operations, and tensor computations?
What makes these operations a particularly good fit for GPU architecture?
What are tensor cores, and how are they different from the regular CUDA cores or arithmetic lanes we discussed earlier?
How do tensor cores accelerate matrix multiplication at the hardware level?
What are some tradeoffs of using specialized hardware instead of general-purpose execution resources?

Then I would like to investigate one architecture designed specifically for AI, such as Google's TPU or Apple's Neural Engine. Please explain how it works, what it specializes in, and what it gives up compared with a general-purpose CPU or GPU.
Use a concrete example from neural-network training or inference. I want to understand what the hardware is actually doing, not just why AI companies use it.

Why GPUs fit AI, and what specialized hardware changes
Part 1: Why neural networks are mostly matrix multiplication

A neuron computes a weighted sum of its inputs plus a nonlinearity: y = f(w·x + b). A layer is many neurons reading the same input, so stacking their weight vectors into a matrix W gives y = f(W x + b), a matrix-vector product. Process a batch of inputs together and it becomes a matrix-matrix product, Y = X W.

Other layer types reduce to the same operation:

Transformers: the Q/K/V projections, the attention scores (QKᵀ), the attention-weighted sum (softmax output × V), the output projection, and both feed-forward layers are all matmuls. Most of the model's FLOPs are here.
Convolutions: typically lowered to matmul (im2col or "implicit GEMM").
Training: the backward pass is also matmul. For Y = X W, the gradients are dX = dY Wᵀ and dW = Xᵀ dY. That's two more matmuls per layer, so training costs about 3× the forward FLOPs.

The remaining operations (activations, softmax, layer norm, residual adds) are elementwise or reduction operations. They're a small fraction of the FLOPs but not of the runtime, because they do very little math per byte.

Running example. One transformer feed-forward matmul: X is 8,192 tokens × 4,096, W is 4,096 × 16,384, in bf16 (2 bytes per value).

FLOPs: 2 × 8,192 × 4,096 × 16,384 ≈ 1.1 TFLOP
Bytes moved (X + W + Y): 64 MB + 128 MB + 256 MB ≈ 450 MB
Arithmetic intensity: ~2,300 FLOP/byte

Recall the ridge point of ~30 FLOP/B from the last section. This operation is far above it, so it can be compute-bound. Each weight is used by 8,192 tokens, so one fetch from memory feeds thousands of multiplies.

Part 2: Why this fits GPU architecture

Each earlier design feature lines up with a property of the workload:

Workload property	GPU feature that exploits it
Millions of independent output elements	Thousands of lanes, massive multithreading
Identical operation on every element, no data-dependent branching	SIMT lockstep, no divergence
High data reuse (each weight used by every token)	Shared memory and register tiling
Regular, predictable access patterns	Coalescing works well
Tolerance for low precision	Narrow, cheap arithmetic (Part 3)

The elementwise operations are the weak spot. They're memory-bound, so frameworks fuse them (for example, applying bias + GELU while the matmul result is still in registers) to avoid extra round trips to DRAM.

Part 3: Tensor cores vs. regular lanes

A regular lane executes a scalar fused multiply-add: d = a × b + c, one multiply and one add per lane per cycle. A warp-wide FFMA instruction performs 32 of them.

A tensor core executes a small matrix multiply-accumulate in one operation: D = A × B + C, where A, B, C, D are tiles. Volta's first tensor cores did a 4×4×4 tile (64 FMAs per cycle per core). Current designs operate on much larger tiles, and a warp-level instruction such as a 16×8×16 MMA does 2,048 FMAs.

Other differences:

Mixed precision. Inputs are narrow (FP16, BF16, FP8, and on the newest chips FP4), while accumulation happens in FP32. Narrow inputs matter because multiplier area grows roughly with the square of the mantissa width, so a narrow multiplier is far smaller than an FP32 one.
Fixed function. It does one thing, tile multiply-accumulate, at fixed shapes and data types. It isn't programmable like a lane.

The throughput gap is large. On a recent high-end part (representative numbers: ~130 SMs, ~1.8 GHz), the non-tensor FP32 path delivers roughly 60–70 TFLOPS, while dense BF16 tensor throughput is roughly 1,000 TFLOPS. That's more than an order of magnitude from the same chip.

Part 4: How tensor cores do this at the hardware level

The speedup comes from amortizing overhead, not from faster individual multipliers.

Instruction overhead. An FFMA warp instruction is fetched, decoded, and scheduled to produce 32 FMAs. A 16×8×16 MMA instruction produces 2,048, so the front-end cost per FMA drops about 64×.

Operand traffic. A scalar FMA reads three register operands and writes one: 4 register-file accesses per FMA. Reading the register file is often more expensive in energy than the multiply itself. In a 16×8×16 FP16 MMA, the hardware reads 256 + 128 + 128 = 512 operand elements and writes 128, so 640 accesses for 2,048 FMAs, or about 0.31 per FMA, roughly 13× fewer.

Reuse inside the unit. Every element of A feeds several multipliers, and every element of B feeds several others, through direct wiring. The products are summed by an adder tree inside the unit, so partial sums never travel to the register file and back. This is data reuse, as in tiling, but hardwired at the lowest level.

In code, the warp cooperatively holds the tile "fragments" in its registers:

cuda
wmma::fragment<wmma::matrix_a, 16,16,16, half, wmma::row_major> a;
wmma::fragment<wmma::matrix_b, 16,16,16, half, wmma::row_major> b;
wmma::fragment<wmma::accumulator, 16,16,16, float> acc;
wmma::fill_fragment(acc, 0.0f);
wmma::load_matrix_sync(a, A_tile, lda);
wmma::load_matrix_sync(b, B_tile, ldb);
wmma::mma_sync(acc, a, b, acc);   // warp-wide: 16x16x16 = 4,096 FMAs
wmma::store_matrix_sync(C_tile, acc, ldc, wmma::mem_row_major);

This slots into the tiled kernel from the last section: the inner loop of 16 scalar FMAs per thread is replaced by mma_sync. Tiling now has three levels: the block tile in shared memory, the warp tile in registers, and the MMA tile in the tensor core. Newer generations go further, with asynchronous MMA that reads operands straight from shared memory and dedicated copy engines that move tiles from global memory without tying up threads. This reflects the memory problem from the last section: once math is this fast, feeding the tensor cores becomes the main challenge.

Part 5: Tradeoffs of specialization
Flexibility: Tensor cores accelerate only tile matmuls in supported formats. Everything else still runs on ordinary lanes. By Amdahl's Law, the non-matmul fraction increasingly dominates runtime as matmul gets faster.
Memory wall: Peak FLOPs grew much faster than bandwidth, so the ridge point moves right. On a part with ~1,000 TFLOPS and ~3.35 TB/s, you need roughly 300 FLOP/B to be compute-bound. Small or skinny matmuls are memory-bound and gain little.
Numerics: FP16 has limited range (training needs loss scaling), BF16 has fewer mantissa bits, and FP8/FP4 need careful per-tensor or per-block scaling. Lower precision can affect model quality.
Shape constraints: Dimensions should be multiples of the tile size (often 8 or 16) or you pad and waste work.
Obsolescence and ecosystem: Hardware formats must be chosen years before models use them, and software has to be rewritten to target each generation's instructions.
Cost: The area and power go to matmul, and a workload that doesn't use it doesn't benefit.
Part 6: Case study, Google's TPU

The TPU takes the specialization argument to its conclusion. Where a GPU adds tensor cores to a flexible multithreaded machine, a TPU is built around a matrix unit.

The core: a systolic array

The MXU (matrix multiply unit) is a 2D grid of multiply-accumulate cells. The first TPU (2015, inference) had a 256×256 grid of 8-bit MACs, or 65,536 MACs. Later generations use bfloat16 with 128×128 arrays, and newer ones use 256×256. Check Google's documentation for the latest generation's specifics.

It uses a weight-stationary scheme:

Each cell holds one weight for the duration of a tile computation.
Activations flow in from the left, one row per cycle.
Each cell multiplies its weight by the incoming activation, adds the partial sum arriving from the cell above, passes the activation right, and passes the new partial sum down.
Finished results emerge from the bottom edge.
        x0 →  [W00]→ [W01]→
                ↓       ↓
        x1 →  [W10]→ [W11]→
                ↓       ↓
               y0      y1

Tiny trace. Let W = [[1,2],[3,4]] and x = [5,6]. We want y = x·W = [5·1+6·3, 5·2+6·4] = [23, 34]. Input x₁ is delayed one cycle (the "skew") so partial sums line up:

Cycle	What happens
1	Cell W00 gets 5: computes 5×1 = 5, sends partial sum 5 down, passes 5 right
2	W10 gets partial sum 5 and x₁ = 6: 6×3 + 5 = 23 → y₀ leaves the bottom. Meanwhile W01 gets 5: 5×2 = 10, sends down
3	W11 gets partial sum 10 and x₁ = 6: 6×4 + 10 = 34 → y₁ leaves

Feed a new input row every cycle, and after the pipeline fills, every cell does a MAC every cycle. For a 128×128 array that's 16,384 MACs per cycle.

Why this is efficient: a value fetched from memory once is used by every cell it passes through. Partial sums move only to the adjacent cell over short wires. There is no register file, no instruction per multiply, and no cache lookup in the inner loop. The control logic is tiny compared with the arithmetic.

Mapping our feed-forward example onto it

For Y = X·W with X 8,192×4,096 and W 4,096×16,384, using a 128×128 MXU:

Slice W into 128×128 weight tiles.
Load one tile into the array (the next tile is loaded in the background).
Stream all 8,192 rows of X through it, one row per cycle, and accumulate results in on-chip accumulators.
Repeat for the 32 tiles along the 4,096 dimension (accumulating), then for each output column block.

Each weight tile is loaded once and reused for 8,192 rows, versus a reuse factor of 16 in the GPU tiled kernel from earlier. Filling the array costs on the order of a couple hundred cycles, which is trivial when streaming thousands of rows. This is why TPUs want large batches and large matrices.

The rest of the chip
Vector unit: handles elementwise operations (activations, softmax, layer norm) that the MXU can't.
Scalar unit: control flow and address generation.
On-chip scratchpad plus HBM: the scratchpad is software-managed like GPU shared memory, but it is the primary working memory, with no hardware-managed cache hierarchy.
Compiler-scheduled execution: the XLA compiler decides at compile time when each DMA, matmul, and vector operation happens, and overlaps data movement with compute. There are no warp schedulers, no speculation, and no dynamic latency hiding by thread switching. Timing is deterministic because the compiler builds the schedule.
Chip-to-chip interconnect: chips link directly in a torus topology into "pods" of thousands, because large-model training is dominated by communication as well as compute.
What it gives up

Compared with a CPU:

Essentially all general-purpose ability: branchy code, OS tasks, pointer chasing, and low-latency single-thread work don't run on it.

Compared with a GPU:

Dynamic behavior. Data-dependent control flow and dynamic tensor shapes are awkward because the compiler wants static shapes (changing shapes triggers recompilation or padding).
Irregular memory access. Gather/scatter and sparse workloads fit poorly (newer TPUs add a dedicated unit for embedding lookups for this reason).
Small or skinny work. Batch-1 inference leaves most of the array idle, with each weight loaded to serve a single row. The memory-bound problem from Part 5 applies even more starkly.
Breadth. No graphics pipeline, weak FP64 for scientific computing, and a narrower software ecosystem (JAX, TensorFlow, and PyTorch via XLA, mainly on Google Cloud).
Precision flexibility: it supports a defined set of formats rather than arbitrary ones.
Inference vs. training, concretely

In autoregressive decoding of one token, the FFN matmul above becomes a matrix-vector product: ~134 MFLOPs against 128 MB of weights read, about 1 FLOP/byte. Any accelerator is bandwidth-starved here, with the arrays mostly idle. Serving systems batch many requests together so each weight read serves many tokens. In bf16, intensity ≈ the batch size in FLOP/B, so you need a batch of a few hundred to approach the ridge point. Training sidesteps this by using large batches and sequence lengths, which is why it uses these chips so well.

Comparison
	CPU	GPU (with tensor cores)	TPU
Design goal	Fast single thread	Throughput, flexible	Matmul throughput per watt
Parallelism source	ILP, few cores	Thousands of threads + MMA tiles	One huge systolic array
Latency hiding	Caches, speculation	Warp switching	Compiler scheduling
Memory	Hardware caches	Caches + shared memory	Software-managed scratchpad
Flexibility	Highest	High	Lowest
Matmul efficiency	Lowest	High	Highest per area and watt

The pattern across all of this is that each step trades generality for efficiency by removing machinery that moves, schedules, or decides things at run time and spending that area on arithmetic. The cost is that the hardware performs well only on workloads shaped like the one it was designed for. Neural-network matmul happens to be a very large, very regular workload, which is why this tradeoff works so well here.

I think I understand the differences between CPUs, GPUs, and specialized AI accelerators now. I want to apply what I've learned. For each of these three workloads, explain which architecture would be the best fit and why: Compiler: Processing source code, including complex parsing, branching, and irregular data structures. Image processing: Applying the same operation to millions of individual pixels in an image. Neural network training: Training a large neural network dominated by matrix multiplication and tensor operations.

For each one, explain which architecture (CPU, GPU, or specialized AI accelerator) you would choose, which specific hardware characteristics make it a good fit, why the other architectures might be less suitable, and whether there are any tradeoffs or situations where your choice might change.

Matching workloads to architectures

Each workload gets the same four-part treatment: the choice, the hardware traits behind it, why the alternatives fall short, and where the answer could change.

1. Compiler: CPU

Why the CPU fits

A compiler is almost the opposite of the workload GPUs are built for. Parsing is a chain of dependent decisions (the next token depends on the previous one), and later phases walk and rewrite irregular structures: abstract syntax trees, control-flow graphs, symbol tables, hash maps. The relevant CPU traits are:

Branch prediction and speculation. Parsing and optimization passes are full of if/switch logic. Good prediction keeps the pipeline full, even though the branches are data-dependent.
Deep caches and prefetching. Pointer-chasing through trees and graphs is latency-bound, and the CPU's cache hierarchy shortens the effective latency for each thread. Compilers also reuse symbol tables and type information repeatedly, which caches capture well.
Out-of-order execution. It finds whatever instruction-level parallelism exists inside a serial, irregular instruction stream.
Strong single-thread performance and general-purpose support. The compiler reads files, allocates memory, and talks to the OS, all of which a CPU does natively.

Why not the others

GPU: The warp model punishes divergent branches, since lanes run both sides of an if with masking. Pointer chasing exposes full memory latency, and latency hiding only helps when thousands of independent threads are available to switch to. A parser has a few at best. A single GPU lane is also far weaker than a CPU core, so the serial portions would be much slower.
AI accelerator: It's even less flexible. A systolic array has nothing to do here, and the scalar control hardware is minimal.

Tradeoffs and exceptions

Compilers do have coarse-grained parallelism: separate source files can be compiled independently, and some passes parallelize. That's best exploited by many CPU cores, not by moving to a different architecture. A build system running 32 compiler processes in parallel is still a CPU workload.
Some narrow subproblems have been explored on GPUs (for example, large-scale static analysis or graph algorithms on huge codebases), but they're research-level special cases and not the standard way to build a compiler.
Ironically, compilers for GPUs and TPUs (like XLA) run on the CPU.
2. Image processing: GPU

Why the GPU fits

Applying the same operation to millions of pixels is nearly a textbook data-parallel workload. Take a Gaussian blur on a 4K image (about 8.3 million pixels): each output pixel is a weighted average of a small neighborhood of input pixels, and no output depends on any other output.

Massive parallelism. One thread per pixel gives millions of independent threads, which map directly onto the thousands of lanes and the oversubscription that hides memory latency.
No divergence. Every pixel runs the same instruction sequence, so lockstep SIMT execution is fully efficient. (Edge pixels may take a slightly different path, but that affects only a few warps.)
Coalescing. Adjacent threads handle adjacent pixels, so a warp reads consecutive memory addresses. Images are stored in memory in exactly the layout that coalesces well.
Shared memory reuse. Neighboring pixels' windows overlap heavily. A thread block can load a tile of the image plus a border ("halo") into shared memory once, and every thread reuses it. This is the same tiling idea as in matrix multiplication.
High bandwidth. Many image operations have low arithmetic intensity (a few operations per pixel), so they're bandwidth-bound, and a GPU's wide memory system helps a lot.
Graphics heritage. GPUs also include texture units with hardware interpolation, useful for resizing and warping, which accelerate operations like scaling and rotation.

Why not the others

CPU: A CPU can do this, particularly with SIMD instructions (AVX) and multiple cores, and for small images it's perfectly adequate. But it has only dozens of cores with a few SIMD lanes each, versus thousands of lanes, and lower memory bandwidth. Much of its area (speculation, large out-of-order machinery) buys nothing on a loop with no unpredictable branches.
AI accelerator: A systolic array is built for matrix multiplication. A blur or a color adjustment is not a large dense matmul, so most of the matrix hardware would sit idle. The exception is when the processing is a neural network (see below).

Tradeoffs and exceptions

Transfer overhead. If the image lives in CPU memory, copying it across PCIe takes time. For a single small image or a trivial operation (say, one brightness adjustment), the copy and kernel launch can cost more than the CPU would take to do the work. GPUs pay off for large images, batches, or pipelines of several operations where the data stays on the GPU.
Integrated GPUs and phones share memory with the CPU, which removes the copy cost and makes GPU processing attractive even for modest workloads. Dedicated image signal processors (ISPs) in phone chips handle camera pipelines with fixed-function hardware, an even more specialized choice.
Neural image processing (denoising, upscaling, segmentation with a CNN) changes the picture: the dominant operation becomes convolution lowered to matmul, so tensor cores or an NPU can be the better target.
Irregular operations such as connected-component labeling or flood fill have data-dependent control flow and serial dependencies, so they run less efficiently on a GPU than simple per-pixel filters do.
3. Neural network training: Specialized AI accelerator (or a tensor-core GPU)

This is the one case where the answer isn't clean, so I'll state it plainly: either a GPU with tensor cores or a TPU-style accelerator is a strong choice, and the CPU is clearly the wrong one. Which of those two wins depends on context. If I have to pick for a large network dominated by matrix multiplication, I'd lean toward the specialized accelerator on pure efficiency grounds, with GPUs as the more flexible option.

Why accelerators fit

Everything from the last section applies. Training a transformer is dominated by large dense matmuls (forward, plus two more in the backward pass) at very high arithmetic intensity, with regular shapes and precision tolerance.

Dense matmul hardware. A systolic array or tensor core does thousands of multiply-accumulates per cycle with minimal control overhead and heavy internal operand reuse, giving the highest throughput per area and per watt.
Reduced precision. BF16/FP16/FP8 inputs with FP32 accumulation make multipliers smaller and cut memory traffic in half or better, and training tolerates this with loss scaling and careful numerics.
High-bandwidth memory plus on-chip scratchpads keep the arrays fed, and large batches provide the reuse needed to reach the compute-bound regime.
Fast interconnect. Training a large model means splitting it across many chips, so the communication fabric (NVLink on GPUs, the inter-chip torus on TPUs) matters about as much as the compute. Gradient synchronization can be a major share of step time.

Why not the others

CPU: It has the flexibility but not the throughput. Even a high-end server CPU delivers a small fraction of a GPU's matmul FLOPs, with far less memory bandwidth, so training a large model would take impractically long. CPUs are fine for small models and prototyping.
GPU vs. TPU-style accelerator: A GPU's extra generality (warp scheduling, caches, flexible threading) costs some area and power that a pure matmul engine doesn't spend. That's the efficiency edge for the accelerator. But the GPU wins on flexibility and ecosystem.

Tradeoffs and situations where the choice changes

Choose the GPU when the model has dynamic shapes, custom operators, sparse or irregular components, or research code that changes often. The CUDA ecosystem (PyTorch support, mature libraries, wide availability) also lowers engineering risk, and a team may simply have the GPU hardware already.
Choose the specialized accelerator when the workload is large, stable, and matmul-dominated, and cost or energy per training run is the priority. That's the case where static compiler scheduling and a big systolic array pay off. You also accept a narrower software stack and more effort if your model doesn't fit the compiler's static-shape assumptions.
Small models: Overhead and underutilization (the "skinny matmul" problem) mean a single GPU, or even a CPU, may be the practical choice.
Inference differs from training. Autoregressive decoding is memory-bandwidth-bound at small batch sizes, so the best hardware there depends more on memory bandwidth and batching than on peak FLOPs.
Mixed pipelines: In practice a training job uses a CPU too, for data loading and preprocessing. Where one machine hosts all three roles, the CPU feeds the accelerator, which is a good reminder that real systems are heterogeneous.
Summary
Workload	Best fit	Deciding trait	What would change the answer
Compiler	CPU	Branch prediction, caches, strong single thread	Many files → many CPU cores, still CPU
Image processing	GPU	Data parallelism, coalescing, shared-memory tiling, bandwidth	Tiny images/transfer costs → CPU; neural processing → tensor cores/NPU
NN training	AI accelerator (or tensor-core GPU)	Dense matmul throughput, low precision, interconnect	Dynamic or custom models → GPU; small models → GPU/CPU

The decision rule from this whole conversation: ask how regular and parallel the work is. Irregular, branchy, serial work wants the CPU's latency-oriented machinery. Regular data-parallel work wants a GPU's throughput design. And when nearly all of the work reduces to one operation (dense matmul), specialized hardware can remove everything else and spend the area on arithmetic, at the cost of flexibility.

Ok great now I want to closely examine one of the technical claims you made in your explanation of Google's TPU. You stated that TPUs do not use warp schedulers, speculation, or dynamic latency hiding through thread switching, unlike GPUs. I want to figure out how accurate this comparison is.

Can you explain exactly what this claim means in terms of TPU and GPU architecture, identify which parts of the claim are well-established facts and which parts might be oversimplified, point me toward a specific technical source, preferably official Google TPU documentation or a technical architecture paper, that I can use to verify the claim. Also, explain what I should look for in that source to determine whether the claim is accurate.

Please distinguish between what is documented and what is your own interpretation. Don't simply defend your original answer.

I'll check the sources first so the pointers I give you are real and I'm not relying on memory.

Auditing my claim: TPU vs. GPU scheduling

My original statement was too blunt, and one part of it was wrong.

What the claim means

It bundles three separate claims, and they don't all hold equally:

No warp schedulers. The TPU has no hardware that tracks many resident groups of threads and picks a ready one each cycle.
No speculation. The TPU doesn't guess branch outcomes and run ahead of them.
No dynamic latency hiding by thread switching. The TPU doesn't cover memory stalls by swapping in other threads. Instead, a compiler decides ahead of time when to move data and when to compute.
What is documented and what isn't

Well supported (TPU v1, 2017 paper):

The ISCA 2017 paper says the TPU's deterministic execution model suits strict tail-latency requirements better than the time-varying features of CPUs and GPUs, which it lists as caches, out-of-order execution, multithreading, multiprocessing, and prefetching. It also says leaving these out is part of why the chip is small and low power. The abstract frames this as a deliberate tradeoff against average-throughput features. 
research
The paper also describes the host as the one feeding instructions to the TPU, which it says makes the TPU closer to a floating-point coprocessor than to a GPU. That supports the "no thread scheduling" point for v1, since there are no autonomous threads to schedule. 
wustl

Documented for current TPUs, but only partly relevant:

Google's Cloud TPU documentation says each TensorCore consists of matrix-multiply units, a vector unit, and a scalar unit. It adds that the scalar unit handles control flow, memory address calculation, and maintenance operations. 
google
google
The v6e page lists two 256x256 MXUs, a vector processing unit with 128 lanes by 8 sublanes, two cross-lane units, and a scalar unit per TensorCore. 
google

This describes the units and their roles. It does not say "no warp scheduler" or "no speculation." A component list that doesn't mention something is evidence, but not proof. I'm inferring the absence.

My interpretation, not something I can point to a line for:

That later generations (v2 onward) also lack speculation and hardware multithreading. v1's paper is explicit, but it covers a 2015 inference chip, and I extended the claim to the whole family.
That the compiler "builds the schedule." This is how I understand XLA to work, but you'd need Google's compiler and architecture papers to confirm the details.
Where my original answer was oversimplified or wrong
Speculation is not a GPU-vs-TPU difference. I grouped it under "unlike GPUs," and that was wrong. GPUs also generally don't do CPU-style branch prediction and speculation. They issue mostly in order and get parallelism from other warps. Speculation is a CPU contrast. The accurate version is that neither a GPU nor a TPU speculates the way a big out-of-order CPU does.
"No dynamic latency hiding" overstated the case. The TPU does hide latency, but statically. DMA transfers overlap with matrix work through double buffering, so a stall isn't exposed. What differs is who decides: the compiler plans it ahead, instead of a hardware scheduler discovering ready warps cycle by cycle. A more accurate phrasing is "static, software-orchestrated latency hiding instead of hardware thread switching." Docs describing infeed and outfeed queues between host and TPU, and parameters loaded from HBM into the MXU, are consistent with this pipelined picture, but they don't spell out the mechanism. 
google
"Deterministic" is strongest for v1 and weakest at system scale. Even if compute inside a core is statically scheduled, HBM access, host communication, and multi-chip collectives over the interconnect have variable timing. The v1 paper's determinism argument concerns a single chip serving inference, and I shouldn't have implied it holds for a pod during training.
The GPU side is blurring toward the TPU's approach. From my own knowledge (not verified in this search), recent NVIDIA architectures added asynchronous bulk copy engines and "warp specialization," where some warps move data while others compute. That is software-managed pipelining, close in spirit to TPU-style overlap. NVIDIA's compiler also embeds scheduling hints in its machine code. So the contrast is a spectrum, not a binary.
Not everything on a TPU is statically regular. The docs describe SparseCores as dataflow processors for sparse operations, which is a different execution model from the dense MXU path. 
google
What to read and what to look for

Primary source: Jouppi et al., "In-Datacenter Performance Analysis of a Tensor Processing Unit," ISCA 2017 (arXiv:1704.04760, https://arxiv.org/abs/1704.04760; Google's page is at https://research.google/pubs/pub46078/). Check these things:

The abstract and introduction: confirm the determinism-vs-time-varying-features argument.
The architecture section: how instructions reach the chip, and whether it has branching. My recollection is that the instruction set is small, host-driven, and executed in order, but I haven't re-verified the exact wording, so check it yourself.
The related-work and discussion sections: where the authors compare against GPUs and say why they omitted multithreading.
Scope check: note that it covers v1 inference only. Anything you conclude about later chips needs another source.

For later generations:

Google Cloud TPU architecture docs: https://docs.cloud.google.com/tpu/docs/system-architecture and the per-version pages such as https://docs.cloud.google.com/tpu/docs/v6e. Look for the unit descriptions, and also for what they don't claim.
The TPU v2/v3 paper, "A Domain-Specific Supercomputer for Training Deep Neural Networks" (Communications of the ACM, 2020), which the Cloud docs themselves point readers to for TensorCore details. I didn't open it, so I can't tell you what it says about instruction issue.
The TPU v4 paper (ISCA 2023): I believe it discusses the core's instruction format, but I haven't verified that here, so treat it as a lead.

For the GPU side: NVIDIA's architecture whitepapers (Volta, Hopper) for how warp scheduling and async copy work.

A test to apply

For each of the three sub-claims, ask whether the source states the absence explicitly, only lists the components, or says nothing. Only the first is documentation. The second supports an inference, and the third is a gap you're filling yourself. For v1, the paper gives explicit statements on determinism and on omitting multithreading. For v2 and later, as far as I could verify, you'll mostly be in the second category.

Corrected claim: TPU v1 is documented as deliberately omitting caches, out-of-order execution, and multithreading, in favor of deterministic execution. Later TPUs are documented as built from MXU, vector, and scalar units with compiler-driven data movement, but I haven't verified from primary sources that they lack speculation or hardware thread scheduling. GPUs, for their part, don't speculate like CPUs either.

Sources:

In-Datacenter Performance Analysis of a Tensor Processing Unit (Google Research)
ISCA '17 paper text
Cloud TPU architecture docs
Cloud TPU v6e docs

Okay, we have explored CPUs, GPUs, and specialized AI accelerators like Google's TPU. Now I want to step back and explore what other processor architectures exist beyond the ones we've discussed.
What are some important processor architectures or computing approaches that we haven't covered yet?
For every one, explain:

How the architecture works.
What types of workloads it is designed for.
What advantages it offers over traditional CPUs or GPUs.
What tradeoffs or limitations it has.

Then, identify one architecture that you think is particularly interesting or important for the future of computing and explain why. I'd like to understand how processor design continues to evolve as computing workloads change.

Beyond CPUs, GPUs, and TPUs

I'll cover eight architectures. Many of them sit at different points on the same trade-off we've followed all along: how much hardware decides things at run time versus how much is fixed ahead of time, and how close the compute sits to the data.

1. Vector processors and wide-SIMD ISAs

How it works: A single instruction operates on a long vector of elements (Cray supercomputers, and now ARM SVE and RISC-V's vector extension). Modern designs are vector-length agnostic: the same binary runs on hardware with 128-bit or 2048-bit vectors, and the hardware reports how many elements it handles per iteration. Masking handles the tail of a loop without special cleanup code.

Workloads: Scientific computing, signal processing, media, and regular loops over arrays.

Advantages: It amortizes instruction fetch and decode over many elements (the same argument as SIMT), but inside a normal CPU programming model. There are no kernel launches, no separate memory space, and no PCIe copies. It also scales across hardware generations without recompiling.

Tradeoffs: Irregular control flow wastes lanes. Peak throughput is far below a GPU's, because it scales with vector width and core count, not with thousands of threads.

2. VLIW (very long instruction word)

How it works: The compiler packs several independent operations into one wide instruction, so the hardware doesn't need out-of-order logic to find parallelism. Scheduling is decided statically.

Workloads: Digital signal processing, embedded systems, and some accelerators. (Qualcomm's Hexagon DSP is VLIW-based, and Intel's Itanium was a notable general-purpose attempt.)

Advantages: Simple, low-power hardware with predictable timing, since there's no speculation machinery to power or verify.

Tradeoffs: Performance depends on the compiler finding parallelism. Unpredictable cache misses stall the whole instruction word, and binaries are tied to a specific hardware generation's width and latencies. This is why Itanium struggled on general-purpose code. It does well on regular kernels, which is why DSPs and accelerators still use it.

3. DSPs (digital signal processors)

How it works: CPU-like cores with features tuned for signal processing: single-cycle multiply-accumulate, special addressing modes (circular buffers, bit-reversed addressing for FFTs), zero-overhead loops, and often multiple memory buses so several operands can be fetched at once. Many are VLIW.

Workloads: Audio, radio and baseband processing, radar, motor control, and anything with real-time deadlines.

Advantages: Very good performance per watt on streaming math, with hard real-time guarantees because timing is predictable.

Tradeoffs: Poor at general-purpose code and operating systems, and the programming model is more specialized. They've increasingly been absorbed into SoCs as one block among several.

4. FPGAs (field-programmable gate arrays)

How it works: Instead of executing instructions, an FPGA is a fabric of lookup tables, flip-flops, memory blocks, and DSP slices connected by a programmable routing network. You describe a circuit (in Verilog, VHDL, or high-level synthesis), and the tools configure the fabric to become that circuit. A dataflow pipeline then runs in hardware with no instruction fetch at all.

Workloads: Networking and packet processing, low-latency finance, signal processing, hardware prototyping, and custom pipelines with unusual bit widths.

Advantages: Latency can be deterministic and extremely low (nanoseconds, with no OS or scheduler in the path). Hardware can be reconfigured after deployment, and you can match the data type to the problem, for example 5-bit arithmetic if that's what the algorithm needs. It's also good for streaming, where data flows through fixed stages.

Tradeoffs: Development is much harder and slower than software, and compile and place-and-route cycles can take hours. Clock speeds are lower and area and power are worse than a custom ASIC doing the same job, because the configurability itself costs silicon. Raw peak throughput on dense matmul usually trails a GPU or TPU.

5. ASICs and fixed-function blocks

How it works: A circuit designed for one task and hardened into silicon. The TPU is the large-scale example, and small ones are everywhere: video encode/decode engines, crypto accelerators, image signal processors in phones, and network offload engines.

Workloads: Stable, high-volume tasks with a standard specification (H.264/H.265 decoding, AES, Bitcoin hashing).

Advantages: The best possible performance per watt and per area, since nothing is spent on flexibility. Decoding video in dedicated hardware uses a small fraction of the power software would.

Tradeoffs: Design costs are enormous (a leading-edge chip can cost hundreds of millions of dollars), so it only pays off at scale or for stable standards. If the algorithm changes (a new codec), the block becomes obsolete. This is the far end of the flexibility-for-efficiency trade we've discussed.

6. Spatial and dataflow architectures (CGRAs, wafer-scale, statically scheduled chips)

How it works: Instead of fetching instructions to run on shared units, the program is laid out spatially across a grid of processing elements, and data flows between them directly. Coarse-grained reconfigurable arrays (CGRAs) can be reconfigured per workload at a coarser granularity than an FPGA. Cerebras's wafer-scale engine puts hundreds of thousands of cores and large amounts of on-chip SRAM on one wafer, and Groq's design is built around fully compiler-scheduled execution with SRAM as primary memory. (From my own knowledge of public descriptions; vendor details change quickly, so verify specifics before citing.)

Workloads: Large neural network training and inference, and some graph and scientific workloads.

Advantages: Intermediate values stay on chip instead of making round trips to DRAM, directly attacking the memory-bandwidth problem we covered. Statically scheduled designs get predictable latency.

Tradeoffs: Mapping a program onto the fabric is hard, so the compiler is critical. Dynamic or irregular workloads fit poorly, on-chip SRAM capacity limits the model size you can hold without spreading across many chips, and the software ecosystems are small compared with CUDA.

7. Neuromorphic processors

How it works: Hardware modeled loosely on biological neurons. Instead of clocked dense arithmetic, it uses many small neuron-like cells that communicate through spikes, discrete events sent only when a neuron's state crosses a threshold. Computation is event-driven, and memory is co-located with the neurons (Intel's Loihi and IBM's TrueNorth are research examples).

Workloads: Sparse, event-based sensing (like data from event cameras), always-on low-power inference, and research into brain-inspired learning.

Advantages: If activity is sparse, almost no energy is spent on idle units. Co-locating memory and compute avoids data-movement costs.

Tradeoffs: This is the most speculative item on the list. Training spiking networks is harder than training conventional ones, the dominant deep learning methods map poorly onto it, and the tooling is immature. Commercial adoption has been limited, so treat its advantages as potential for particular workloads, not proven wins over GPUs.

8. Quantum processors

How it works: Qubits can be placed in superpositions, and operations are sequences of gates that manipulate amplitudes so that wrong answers cancel and correct ones are reinforced. Measurement then yields a classical result.

Workloads: A narrow set of problems with known quantum algorithms: factoring (Shor's algorithm), simulating quantum systems, and certain search and optimization structures. It is not a faster general-purpose computer.

Advantages: For specific problems, an asymptotic speedup that no classical hardware can match by scaling.

Tradeoffs: Qubits are fragile and noisy, and useful fault-tolerant computation needs error correction with a large overhead in physical qubits. Most machines also run near absolute zero or in other demanding environments. It's best thought of as a possible future accelerator for specific tasks, sitting beside classical systems, and not a replacement for them.

Overview
Architecture	Core idea	Best at	Main cost
Vector / wide SIMD	One instruction, long vectors, inside a CPU	Regular array loops	Lower peak than GPU, divergence
VLIW	Compiler schedules parallelism	Regular embedded kernels	Compiler dependence, stalls
DSP	CPU tuned for streaming MAC	Real-time signals	Narrow generality
FPGA	Reconfigurable circuit fabric	Low-latency pipelines, custom precision	Hard to program, lower density
ASIC / fixed function	Hardwired for one task	Stable high-volume tasks	Cost and obsolescence
Spatial / dataflow	Program laid out across a grid	Keeping data on-chip	Compiler, SRAM capacity
Neuromorphic	Event-driven spiking cells	Sparse, low-power sensing	Immature, narrow
Quantum	Amplitude manipulation	Specific algorithms	Noise, error-correction overhead
The one I find most important: moving compute toward the data

If I pick one thread to watch, it's processing-in-memory (PIM) and near-memory compute, together with the broader idea of designing around data movement.

Why it matters: Everything we discussed pointed at the same bottleneck. Arithmetic got cheap, but moving a value from DRAM costs far more energy and time than computing on it, and bandwidth and latency improve much more slowly than FLOPs. Tensor cores, systolic arrays, shared memory, caches, and HBM are all ways to avoid data movement. PIM attacks it more directly by putting simple compute units inside or beside the memory arrays so data doesn't travel to a distant processor.

What exists: Commercial and research designs place logic near DRAM banks, and some use analog in-memory computation, where memory cells themselves perform multiply-accumulates. This matters because workloads like LLM decoding are memory-bandwidth-bound, with very low arithmetic intensity (as we saw: ~1 FLOP/byte), so they gain little from more raw FLOPs.

Caveats, honestly: PIM has been promising for decades without becoming mainstream. DRAM processes are optimized for density and not logic, so compute near memory is limited, programming models are unsettled, and analog approaches face precision and noise problems. I'd call it important as a direction, not proven as a product. The more certain near-term trend is heterogeneity: SoCs and chiplet-based packages that combine CPU cores, GPU-like units, NPUs, and fixed-function blocks, with memory increasingly integrated by advanced packaging (stacked HBM, unified memory in Apple's chips, chiplets over standard interconnects). That is already how phones and many servers are built.

The broader pattern: Each architecture here removes some run-time machinery (speculation, scheduling, generality, even instructions) to spend the savings on arithmetic or locality. As workloads settle into recognizable shapes, designers specialize for them, and as specialization pushes compute throughput up, the cost of moving data becomes the limiting factor, which is why attention keeps shifting from the arithmetic units to the memory system.

---

# Feedback on the Assignment (5 free points)

Your opportunity to tell us about this assignment. There are no right or wrong answers, every item is optional, and leaving any item blank is fine. All items are graded on completion only, never on the response given. For the numeric items below, entering 6 or leaving the answer blank both count as "Prefer not to answer."

### B1 — Before

Before this assignment, how well could you explain why different kinds of processors might be better suited to different kinds of workloads?

1. I could not explain this topic at all; it was new to me.
2. I knew CPUs and GPUs were different but could not explain the architectural reasons.
3. I could explain some differences between CPUs and GPUs at a high level but not how workload characteristics connect to them.
4. I had some previous knowledge and could explain why different workloads might favor different architectures.
5. I had a working understanding of CPUs, GPUs, and specialized accelerators and could explain their major architectural tradeoffs.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** _2_

### P1 — After

After this assignment, how well could you explain why different kinds of processors might be better suited to different kinds of workloads?

1. I still do not feel I could explain this comfortably yet.
2. I could describe some CPU/GPU differences but would need more help connecting them to workload behavior.
3. I could explain the major CPU/GPU architectural tradeoffs and give examples of workloads that favor each.
4. I am confident I could explain why workload characteristics influence architecture selection to another student.
5. I could confidently compare CPU, GPU, and specialized accelerator tradeoffs in a technical discussion.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** _4_

### INV — What drove your investigation?

Pick the one that fits best.

- [ ] I mainly wanted to complete the required assignment efficiently.
- [ ] I mainly wanted to understand enough to answer the assignment questions correctly.
- [ ] I mainly wanted to understand why the CPU and GPU behaved so differently in the demonstration.
- [x] I mainly wanted to understand how workload characteristics influence architectural design.
- [ ] The demo made me curious about architectures beyond the ones required by the assignment.
- [ ] Something else. *(Optional: tell us what.)*
- [ ] Prefer not to answer

### FAV — What helped most?

Pick one.

- [ ] Seeing the CPU/GPU crossover in the in-class demonstration
- [ ] Connecting HW6's execution resources to the much larger parallelism in HW7
- [ ] Reading the Concept section
- [ ] Investigating how GPU execution actually works
- [ ] Investigating GPU memory and data movement
- [ ] Investigating AI accelerators / tensor hardware
- [ ] Challenging or verifying something the AI told me
- [x] Choosing architectures for different workloads
- [ ] The open-ended "we only scratched the surface" investigation
- [ ] Prefer not to answer

### DEMO — Did the demonstration create a useful question?

After seeing the demonstration, how strongly did you want to understand why the CPU and GPU behaved differently as the workload grew?

1. Not at all — the result did not make me curious about the reason.
2. Slightly — I noticed the difference but was not particularly motivated to investigate it.
3. Moderately — I wanted to understand the basic explanation.
4. Strongly — the result made me want to understand the architecture behind it.
5. Very strongly — the result made me want to investigate beyond what the assignment required.
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** _4_

### PRO — Professional relevance

How much do you agree: "Understanding how workload characteristics interact with CPU, GPU, and accelerator architecture will be useful to me when designing or evaluating software systems."

1. Strongly disagree
2. Disagree
3. Neither agree nor disagree
4. Agree
5. Strongly agree
6. (or blank) = Prefer not to answer.

**Your answer (1–6):** _5_

### SCA — What should we do with this format?

- [x] Continue as is. *Tell us more (optional): any suggestions to make it even better?*
- [ ] Adjust something. *Tell us more (optional): what would you change?*
- [ ] Stop, and go back to a traditional homework model. *Tell us more (optional): what didn't work for you?*
- [ ] Prefer not to answer

### AI Investigation Skills

For each statement, enter a number based on what you can do right now, not what you think you're expected to be able to do.

1. Strongly disagree.
2. Disagree.
3. Neither agree nor disagree.
4. Agree.
5. Strongly agree.
6. (or blank) = Prefer not to answer.

- **AI1.** When investigating an unfamiliar technical topic with AI, I can decide what question would be useful to ask next. **Your answer (1–6):** _4_
- **AI2.** I can recognize when an AI explanation or technical claim needs further investigation. **Your answer (1–6):** _5_
- **AI3.** I know how to check a technical claim made by AI using evidence beyond the AI's own explanation. **Your answer (1–6):** _5_
- **AI4.** I can use follow-up questions with AI to improve my own understanding of a technical topic. **Your answer (1–6):** _4_
- **AI5.** I can decide when I have enough evidence to accept, reject, or remain uncertain about a technical explanation provided by AI. **Your answer (1–6):** _4_

---

# Grading Rubric

| # | What's being evaluated | Points |
|---|---|---:|
| MC1–MC4 | Correctly identifies the central architectural ideas behind workload-dependent performance and specialization | 20 |
| N1 | Corrects the "GPU = faster CPU" model using architectural tradeoffs, throughput, and workload characteristics | 15 |
| N2 | Explains the CPU/GPU crossover using parallel work, overhead, and workload scale | 15 |
| N3 | Selects defensible architectures for three different workloads and supports each choice with architectural reasoning | 15 |
| N4 | Investigates a real GPU/AI architecture or feature, identifies its specialization, and provides a credible source | 10 |
| N5 | Identifies a specific AI claim, gives a genuine reason for checking it, describes a verification action, and reaches a supported conclusion | 15 |
| N6 | Identifies a specific follow-up question and explains how it advanced or refined understanding | 5 |
| N7 | Demonstrates a broader architectural perspective connecting the course's CPU focus to workload-driven architecture | 5 |
| Transcript | Included and shows the AI investigation | Required |
| Feedback | Completes the required feedback items; "Prefer not to answer" (or leaving an item blank) counts as complete | 5 |

**Total: 100 points.**
