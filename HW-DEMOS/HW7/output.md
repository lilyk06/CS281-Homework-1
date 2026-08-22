# HW6 Output

This demo shows how the parallel execution of a highly optimized GPU architecture can result in a massive speedup in common computations used in special purpose applications and algorithms such as AI.

```bash
============================================================
DGL HW7 - EXECUTION MODEL DEMO
============================================================

Python         : 3.9.6
PyTorch        : 2.8.0
GPU backend    : Apple MPS
GPU            : Apple Silicon GPU

IMPORTANT:

The CPU implementation is intentionally naive.
It directly executes the three nested loops from our
conceptual CPU model.

This is NOT a comparison of optimized CPU and GPU libraries.


============================================================
MATRIX: 16 x 16
============================================================

CPU
  executing three nested loops...
  approximately 4,096 multiply/add steps
  finished: 0.0003 seconds

GPU
  transferring matrices to GPU...
  launching parallel matrix multiplication...
  finished: 0.185128 seconds

Speedup: 0.0x

============================================================
MATRIX: 32 x 32
============================================================

CPU
  executing three nested loops...
  approximately 32,768 multiply/add steps
  finished: 0.0024 seconds

GPU
  transferring matrices to GPU...
  launching parallel matrix multiplication...
  finished: 0.054388 seconds

Speedup: 0.0x

============================================================
MATRIX: 64 x 64
============================================================

CPU
  executing three nested loops...
  approximately 262,144 multiply/add steps
  finished: 0.0179 seconds

GPU
  transferring matrices to GPU...
  launching parallel matrix multiplication...
  finished: 0.004899 seconds

Speedup: 3.7x

============================================================
MATRIX: 128 x 128
============================================================

CPU
  executing three nested loops...
  approximately 2,097,152 multiply/add steps
  finished: 0.1406 seconds

GPU
  transferring matrices to GPU...
  launching parallel matrix multiplication...
  finished: 0.003246 seconds

Speedup: 43.3x

============================================================
MATRIX: 256 x 256
============================================================

CPU
  executing three nested loops...
  approximately 16,777,216 multiply/add steps
  finished: 1.1330 seconds

GPU
  transferring matrices to GPU...
  launching parallel matrix multiplication...
  finished: 0.004066 seconds

Speedup: 278.7x

============================================================
MATRIX: 512 x 512
============================================================

CPU
  executing three nested loops...
  approximately 134,217,728 multiply/add steps
  finished: 9.8105 seconds

GPU
  transferring matrices to GPU...
  launching parallel matrix multiplication...
  finished: 0.005784 seconds

Speedup: 1,696.0x

============================================================
MATRIX: 1024 x 1024
============================================================

CPU
  executing three nested loops...
  approximately 1,073,741,824 multiply/add steps
  finished: 97.1192 seconds

GPU
  transferring matrices to GPU...
  launching parallel matrix multiplication...
  finished: 0.004474 seconds

Speedup: 21,705.2x


==============================================================================
FINAL RESULTS
==============================================================================
        Matrix        CPU (ms)        GPU (ms)                    Result
------------------------------------------------------------------------------
     16 x 16               0.331         185.128        CPU faster: 558.5x
     32 x 32               2.384          54.388         CPU faster: 22.8x
     64 x 64              17.925           4.899          GPU faster: 3.7x
    128 x 128            140.567           3.246         GPU faster: 43.3x
    256 x 256          1,132.972           4.066        GPU faster: 278.7x
    512 x 512          9,810.527           5.784      GPU faster: 1,696.0x
   1024 x 1024        97,119.235           4.474     GPU faster: 21,705.2x
==============================================================================
```