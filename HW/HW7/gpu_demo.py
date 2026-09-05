"""
DGL HW7 Demo #2
Sequential CPU Thinking vs. Massively Parallel GPU Thinking

This is NOT a production performance benchmark.

The CPU implementation deliberately follows the simple
three-nested-loop model discussed in class.

The GPU implementation expresses the same matrix multiplication
through PyTorch and lets the GPU execute it in parallel.
"""

import platform
import time
import torch


# ------------------------------------------------------------
# GPU DETECTION
# ------------------------------------------------------------

def find_gpu():

    # NVIDIA CUDA or AMD ROCm
    if torch.cuda.is_available():

        if torch.version.hip is not None:
            return (
                torch.device("cuda"),
                "AMD ROCm",
                torch.cuda.get_device_name(0),
            )

        return (
            torch.device("cuda"),
            "NVIDIA CUDA",
            torch.cuda.get_device_name(0),
        )

    # Apple Silicon
    if (
        hasattr(torch.backends, "mps")
        and torch.backends.mps.is_available()
    ):
        return (
            torch.device("mps"),
            "Apple MPS",
            "Apple Silicon GPU",
        )

    return None, None, None


def synchronize(device):

    if device.type == "cuda":
        torch.cuda.synchronize()

    elif device.type == "mps":
        torch.mps.synchronize()


gpu, gpu_backend, gpu_name = find_gpu()

if gpu is None:
    print("ERROR: No supported GPU found.")
    raise SystemExit(1)


# ------------------------------------------------------------
# NAIVE CPU MATRIX MULTIPLICATION
# ------------------------------------------------------------

def cpu_naive(A, B):

    n = len(A)

    C = [
        [0.0 for _ in range(n)]
        for _ in range(n)
    ]

    # This is intentionally the algorithm
    # we drew on the board.

    for row in range(n):

        for column in range(n):

            total = 0.0

            for j in range(n):

                total += (
                    A[row][j]
                    *
                    B[j][column]
                )

            C[row][column] = total

    return C


# ------------------------------------------------------------
# GPU MATRIX MULTIPLICATION
# ------------------------------------------------------------

def gpu_matmul(A, B):

    A_gpu = A.to(gpu)
    B_gpu = B.to(gpu)

    synchronize(gpu)

    start = time.perf_counter()

    C_gpu = A_gpu @ B_gpu

    synchronize(gpu)

    elapsed = time.perf_counter() - start

    return elapsed


# ------------------------------------------------------------
# RUN ONE TEST
# ------------------------------------------------------------

def run_test(n):

    print()
    print("=" * 60)
    print(f"MATRIX: {n} x {n}")
    print("=" * 60)

    # Create tensors first so both calculations
    # start with the same numbers.

    A_tensor = torch.randn(n, n)
    B_tensor = torch.randn(n, n)

    # Convert to ordinary Python lists.
    #
    # The CPU implementation below therefore gets
    # NO optimized PyTorch matrix multiplication.

    A_python = A_tensor.tolist()
    B_python = B_tensor.tolist()

    # --------------------------------------------------------
    # CPU
    # --------------------------------------------------------

    print()
    print("CPU")
    print("  executing three nested loops...")
    print(f"  approximately {n**3:,} multiply/add steps")

    start = time.perf_counter()

    cpu_naive(A_python, B_python)

    cpu_time = time.perf_counter() - start

    print(f"  finished: {cpu_time:.4f} seconds")

    # --------------------------------------------------------
    # GPU
    # --------------------------------------------------------

    print()
    print("GPU")
    print("  transferring matrices to GPU...")
    print("  launching parallel matrix multiplication...")

    gpu_time = gpu_matmul(
        A_tensor,
        B_tensor,
    )

    print(f"  finished: {gpu_time:.6f} seconds")

    # --------------------------------------------------------
    # RESULT
    # --------------------------------------------------------

    speedup = cpu_time / gpu_time

    print()
    print(f"Speedup: {speedup:,.1f}x")

    return cpu_time, gpu_time, speedup


# ------------------------------------------------------------
# SYSTEM INFORMATION
# ------------------------------------------------------------

print("=" * 60)
print("DGL HW7 - EXECUTION MODEL DEMO")
print("=" * 60)

print()
print(f"Python         : {platform.python_version()}")
print(f"PyTorch        : {torch.__version__}")
print(f"GPU backend    : {gpu_backend}")
print(f"GPU            : {gpu_name}")

print()
print("IMPORTANT:")
print()
print("The CPU implementation is intentionally naive.")
print("It directly executes the three nested loops from our")
print("conceptual CPU model.")
print()
print("This is NOT a comparison of optimized CPU and GPU libraries.")
print()


# ------------------------------------------------------------
# TESTS
# ------------------------------------------------------------

results = []

# Do NOT use 4096 or 16384 here!
#
# Pure Python performs n^3 loop iterations.
#
# 512^3 = 134,217,728
#
# That is already enormous for the Python interpreter.

sizes = [
    16,
    32,
    64,
    128,
    256,
    512,
    1024,
]

for n in sizes:

    cpu_time, gpu_time, speedup = run_test(n)

    results.append(
        (n, cpu_time, gpu_time, speedup)
    )


# ------------------------------------------------------------
# FINAL TABLE
# ------------------------------------------------------------

print()
print()
print("=" * 78)
print("FINAL RESULTS")
print("=" * 78)

print(
    f"{'Matrix':>14}"
    f"{'CPU (ms)':>16}"
    f"{'GPU (ms)':>16}"
    f"{'Result':>26}"
)

print("-" * 78)

for n, cpu_time, gpu_time, speedup in results:

    # Convert both measurements to milliseconds
    cpu_ms = cpu_time * 1000
    gpu_ms = gpu_time * 1000

    # Make the result describe which architecture won
    if speedup > 1:
        result = f"GPU faster: {speedup:,.1f}x"

    elif speedup < 1:
        result = f"CPU faster: {1 / speedup:,.1f}x"

    else:
        result = "Approximately equal"

    print(
        f"{n:>7} x {n:<6}"
        f"{cpu_ms:>16,.3f}"
        f"{gpu_ms:>16,.3f}"
        f"{result:>26}"
    )

print("=" * 78)