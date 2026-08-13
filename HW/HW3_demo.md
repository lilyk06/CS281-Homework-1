# HW3 Renode Demo: Polling vs. True `wfi` + Interrupt

Two bare-metal RISC-V programs that both blink the same virtual LED
periodically, same visible outcome, very different cost. `poll_demo`
keeps the CPU fully busy the whole time, checking a timer over and
over. `interrupt_demo` executes `wfi` and sits genuinely idle until an
interrupt wakes it. Both print live status lines over a virtual UART
so the difference is visible while the demo runs, not just as a final
number.

## Files

- `hw3_renode.repl`: the simulated platform. Memory, a CPU, one LED, a
  CLINT (the RISC-V timer/interrupt peripheral), and a UART for
  printing. Nothing else, on purpose.
- `bootstrap.s`: shared startup code (stack setup, `_start`) and UART
  printing helpers (`uart_putc`, `uart_puts`, `uart_put_hex`,
  `uart_put_udec`), used by every demo below.
- `poll_demo.s`: busy-polls the CLINT's `mtime` register, toggles the
  LED every loop iteration, prints a status line periodically.
- `interrupt_demo.s`: enables the CLINT's software interrupt line,
  then `wfi`. A trap handler clears the interrupt, toggles the LED,
  and prints a line. `interrupt_demo.resc` pulses that interrupt every
  5 real seconds from the Renode monitor, see the note below on why.
- `interrupt_diag_spin.s`: diagnostic only, not a classroom demo, kept
  for reference. It's what proved the CLINT's hardware timer-compare
  interrupt (`mtimecmp`) never fires on this specific Renode build,
  see the note below.
- `poll_demo.resc` / `interrupt_demo.resc`: Renode scripts that load
  the platform, the matching ELF, set up UART output, and start the
  machine.

## 1. Build

Needs a bare-metal RISC-V ELF toolchain, not the `riscv64-linux-gnu-`
one used for the other RISC-V demos in this project, that one assumes a
Linux ABI we don't have here. On Ubuntu:

```
sudo apt install gcc-riscv64-unknown-elf
```

This package installs binaries prefixed `riscv64-unknown-elf-`, not
`riscv32-unknown-elf-`, even though it can still target the 32-bit ISA,
it's a multilib toolchain.

A `Makefile` is included and handles the rest, `bootstrap.s` gets
assembled once and linked into both binaries, the flags it passes are
worth knowing about even though you won't type them by hand: `-march`
needs `_zicsr` for the CSR instructions (`csrw`, `csrs`) that
`interrupt_demo.s` uses, and `-mno-relax`/`--no-relax` are there
because hand-written assembly mixing `la`/`call` with `.align`, exactly
what this code does, can get miscompiled by linker relaxation
otherwise, the same fix HW2's demo needed.

```
make            # builds poll_demo.elf and interrupt_demo.elf
make diag       # builds interrupt_diag_spin.elf (debugging aid, not a demo)
make clean      # removes all built .o/.elf files
```

## 2. Run

```
make run-poll
```

Each `.resc` script runs `showAnalyzer uart`, which in headless mode
(no GUI window available) sends UART output straight into the same
terminal Renode is running in, that's the primary way to watch it. As
a backup, the same bytes are also written to `poll_demo_uart.log`,
which you can `tail -f` from another terminal if you'd rather watch it
there, or if you want a persistent transcript after the run ends.

Expect a steady stream of "still spinning" lines, a handful of them
spaced a few real seconds apart, that nonstop activity between prints
is the visible cost of polling.

Quit that session, then run the other:

```
make run-int
```

Expect a single "IRQ fired!" line roughly every 5 seconds, calm and
infrequent, same outcome as polling, radically different CPU behavior
in between. It runs for about 50 seconds (10 pulses), then just sits
idle in `wfi`, that's expected, not a hang.

If a run produces no output anywhere, neither in the console nor in
the `.log` file, that points to a build or platform-loading problem
rather than a UART routing problem, check the `make` output for
assembler/linker errors first, and confirm `poll_demo.elf` (or
whichever target) actually exists before rerunning.

## 3. Why interrupt_demo uses a software interrupt, not the timer

The natural way to build this demo is a real CLINT timer interrupt
(`mtimecmp`), and that's how it was originally written. On this
specific Renode 1.16.1 build, that path turned out not to work:
`mtime` was confirmed (via direct register reads in the Renode
monitor) to run well past the scheduled `mtimecmp` value while `mip`
stayed at 0, and even a fresh write to `mtimecmp` with an already-
elapsed target didn't set the timer-pending bit, despite Renode's own
published peripheral source suggesting it should. `interrupt_diag_spin.s`
was built specifically to test this: it uses the identical interrupt
setup but busy-spins instead of calling `wfi`, and it still never
received the interrupt, which ruled out `wfi` itself as the problem
and pointed at the timer-compare peripheral specifically.

The CLINT-to-CPU wiring itself is not the issue, confirmed by writing
directly to the CLINT's software interrupt register and watching `mip`
respond immediately. So `interrupt_demo.s` uses that working path
instead, and `interrupt_demo.resc` supplies the periodic "tick" from
the host side (a short Python loop in the Renode monitor, pulsing the
register every 5 real seconds) rather than from CLINT hardware timing.
Everything else, `wfi`, `mtvec`, `mie`/`mstatus`, the trap handler,
`mret`, is the exact same mechanism a real timer interrupt would use,
only the source of the periodic tick changed.

## 4. Notes for class

- Both programs accomplish the identical task. Neither is buggy or
  slower in the sense of missing the deadline. The difference is
  entirely in how much work the CPU did to get there.
- `interrupt_demo`'s trap handler deliberately does not save and
  restore every register before returning, that's a simplification
  specific to this demo (the only thing it ever interrupts is an empty
  `wfi` loop with no live register state), not a general pattern for
  real firmware.
- The CLINT addresses and register layout here match Renode's own real
  SiFive FE310 platform file, not an invented convention.
