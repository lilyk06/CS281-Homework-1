# HW1 Output

The goal of this demo was to show the added expressiveness of X64 assembly over RISCV - remember you would likely prefer X64 assembly over RISC-V if you were a full time assembler programmer.  These days we have compilers to abstract assembler except for very rare use cases. 

```bash
bsm23@RISCV:~/SYSARCH-HW/HW1$ ./buildandrunwcode.sh 

demo-x64:     file format elf64-x86-64


Disassembly of section .init:

Disassembly of section .text:

0000000000401106 <main>:
long a[3] = {10,20,0};
long b;

long main(void)
{
  401106:       f3 0f 1e fa             endbr64
  40110a:       55                      push   rbp
  40110b:       48 89 e5                mov    rbp,rsp
    a[2] = a[0] + a[1];
  40110e:       48 8b 15 fb 2e 00 00    mov    rdx,QWORD PTR [rip+0x2efb]        # 404010 <a>
  401115:       48 8b 05 fc 2e 00 00    mov    rax,QWORD PTR [rip+0x2efc]        # 404018 <a+0x8>
  40111c:       48 01 d0                add    rax,rdx
  40111f:       48 89 05 fa 2e 00 00    mov    QWORD PTR [rip+0x2efa],rax        # 404020 <a+0x10>
    b = b + 5;
  401126:       48 8b 05 03 2f 00 00    mov    rax,QWORD PTR [rip+0x2f03]        # 404030 <b>
  40112d:       48 83 c0 05             add    rax,0x5
  401131:       48 89 05 f8 2e 00 00    mov    QWORD PTR [rip+0x2ef8],rax        # 404030 <b>

    return b;
  401138:       48 8b 05 f1 2e 00 00    mov    rax,QWORD PTR [rip+0x2ef1]        # 404030 <b>
  40113f:       5d                      pop    rbp
  401140:       c3                      ret

Disassembly of section .fini:

demo-riscv:     file format elf64-littleriscv


Disassembly of section .plt:

Disassembly of section .text:

00000000000104e0 <main>:
long a[3] = {10,20,0};
long b;

long main(void)
{
   104e0:       ff010113                addi    sp,sp,-16
   104e4:       00113423                sd      ra,8(sp)
   104e8:       00813023                sd      s0,0(sp)
   104ec:       01010413                addi    s0,sp,16
    a[2] = a[0] + a[1];
   104f0:       000127b7                lui     a5,0x12
   104f4:       00878793                addi    a5,a5,8 # 12008 <a>
   104f8:       0007b703                ld      a4,0(a5)
   104fc:       000127b7                lui     a5,0x12
   10500:       00878793                addi    a5,a5,8 # 12008 <a>
   10504:       0087b783                ld      a5,8(a5)
   10508:       00f70733                add     a4,a4,a5
   1050c:       000127b7                lui     a5,0x12
   10510:       00878793                addi    a5,a5,8 # 12008 <a>
   10514:       00e7b823                sd      a4,16(a5)
    b = b + 5;
   10518:       8201b783                ld      a5,-2016(gp) # 12028 <b>
   1051c:       00578713                addi    a4,a5,5
   10520:       82e1b023                sd      a4,-2016(gp) # 12028 <b>

    return b;
   10524:       8201b783                ld      a5,-2016(gp) # 12028 <b>
   10528:       00078513                mv      a0,a5
   1052c:       00813083                ld      ra,8(sp)
   10530:       00013403                ld      s0,0(sp)
   10534:       01010113                addi    sp,sp,16
   10538:       00008067                ret
bsm23@RISCV:~/SYSARCH-HW/HW1$ 
```