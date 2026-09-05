# HW2 Output

This file shows a sample run showcasing the locality issue:

```bash
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW2$ make 
riscv64-linux-gnu-as -march=rv64gc -o HW2_Locality_Demo.o HW2_Locality_Demo.s
riscv64-linux-gnu-ld -o HW2_Locality_Demo HW2_Locality_Demo.o
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW2$ make run
./HW2_Locality_Demo
row-major:    113288993 ns
column-major: 710432720 ns
speedup:      6.2x
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW2$ make clean
rm -f HW2_Locality_Demo.o HW2_Locality_Demo
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW2$ 
```