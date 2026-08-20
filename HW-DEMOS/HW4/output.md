# HW4 Output

The goal here is to show the difference between selectively picking hardware features, in this case adding a floating point unit to the chip itself vs not adding the hardware and needing to support the feature set in software. 

```bash
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW4$ make
riscv64-linux-gnu-gcc -O2 -ffreestanding -fno-builtin -fno-stack-protector -mno-relax -fno-pie -march=rv64imac -mabi=lp64 -DSOFT_FLOAT -DITERATIONS=10000000L \
        -nostdlib -no-pie -Wl,--no-relax -Wl,-z,noexecstack -Wl,-z,separate-code -o fp_demo_soft start.S fp_demo.c
riscv64-linux-gnu-gcc -O2 -ffreestanding -fno-builtin -fno-stack-protector -mno-relax -fno-pie -march=rv64gc -mabi=lp64d -DITERATIONS=10000000L \
        -nostdlib -no-pie -Wl,--no-relax -Wl,-z,noexecstack -Wl,-z,separate-code -o fp_demo_hard start.S fp_demo.c
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW4$ time qemu-riscv64 ./fp_demo_hard

real    0m1.604s
user    0m1.589s
sys     0m0.013s
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW4$ time qemu-riscv64 ./fp_demo_soft

real    0m11.327s
user    0m11.318s
sys     0m0.010s
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW4$ make clean
rm -f fp_demo_soft fp_demo_hard
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW4$ 
```