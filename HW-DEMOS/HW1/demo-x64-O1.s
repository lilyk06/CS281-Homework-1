	.file	"demo.c"
	.text
.Ltext0:
	.file 0 "/home/bsm23/SYSARCH-HW/HW1" "demo.c"
	.globl	main
	.type	main, @function
main:
.LFB0:
	.file 1 "demo.c"
	.loc 1 15 1 view -0
	.cfi_startproc
	endbr64
	.loc 1 16 5 view .LVU1
	.loc 1 16 17 is_stmt 0 view .LVU2
	movq	a+8(%rip), %rax
	addq	a(%rip), %rax
	.loc 1 16 24 view .LVU3
	addq	a+16(%rip), %rax
	.loc 1 16 31 view .LVU4
	addq	a+24(%rip), %rax
	.loc 1 16 38 view .LVU5
	addq	a+32(%rip), %rax
	.loc 1 16 45 view .LVU6
	addq	a+40(%rip), %rax
	.loc 1 16 10 view .LVU7
	movq	%rax, a+48(%rip)
	.loc 1 17 5 is_stmt 1 view .LVU8
	.loc 1 17 11 is_stmt 0 view .LVU9
	movq	b(%rip), %rax
	addq	$5, %rax
	.loc 1 17 7 view .LVU10
	movq	%rax, b(%rip)
	.loc 1 19 5 is_stmt 1 view .LVU11
	.loc 1 20 1 is_stmt 0 view .LVU12
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	b
	.bss
	.align 8
	.type	b, @object
	.size	b, 8
b:
	.zero	8
	.globl	a
	.data
	.align 32
	.type	a, @object
	.size	a, 56
a:
	.quad	10
	.quad	20
	.quad	30
	.quad	40
	.quad	50
	.quad	60
	.quad	0
	.text
.Letext0:
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x8e
	.value	0x5
	.byte	0x1
	.byte	0x8
	.long	.Ldebug_abbrev0
	.uleb128 0x3
	.long	.LASF4
	.byte	0x1d
	.byte	0x3
	.long	0x31647
	.long	.LASF0
	.long	.LASF1
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x4
	.long	0x49
	.long	0x43
	.uleb128 0x5
	.long	0x43
	.byte	0x6
	.byte	0
	.uleb128 0x1
	.byte	0x7
	.long	.LASF2
	.uleb128 0x1
	.byte	0x5
	.long	.LASF3
	.uleb128 0x2
	.string	"a"
	.byte	0xb
	.long	0x33
	.uleb128 0x9
	.byte	0x3
	.quad	a
	.uleb128 0x2
	.string	"b"
	.byte	0xc
	.long	0x49
	.uleb128 0x9
	.byte	0x3
	.quad	b
	.uleb128 0x6
	.long	.LASF5
	.byte	0x1
	.byte	0xe
	.byte	0x6
	.long	0x49
	.quad	.LFB0
	.quad	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 6
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x90
	.uleb128 0xb
	.uleb128 0x91
	.uleb128 0x6
	.uleb128 0x3
	.uleb128 0x1f
	.uleb128 0x1b
	.uleb128 0x1f
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x2c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x8
	.byte	0
	.value	0
	.value	0
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF3:
	.string	"long int"
.LASF4:
	.string	"GNU C23 15.2.0 -D_FORTIFY_SOURCE=3 -mtune=generic -march=x86-64 -g -O1 -fno-pie -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection -fzero-init-padding-bits=all"
.LASF2:
	.string	"long unsigned int"
.LASF5:
	.string	"main"
	.section	.debug_line_str,"MS",@progbits,1
.LASF0:
	.string	"demo.c"
.LASF1:
	.string	"/home/bsm23/SYSARCH-HW/HW1"
	.ident	"GCC: (Ubuntu 15.2.0-16ubuntu1) 15.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
