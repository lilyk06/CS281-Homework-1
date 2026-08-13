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

Expect 10 "loop N of 10" lines, each showing the running iteration
count alongside it, that count is what to watch, it climbs into the
millions between each printed line, that's the visible cost of
polling.

Quit that session, then run the other:

```
make run-int
```

Expect the same "loop N of 10" wording, once every 5 seconds, no
iteration count this time because there isn't one to show, the CPU did
nothing at all between wakeups. It runs for about 50 seconds (10
pulses), then just sits idle in `wfi`, that's expected, not a hang.

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

## 4. What to point out live

- Both logs print the exact same 10 "loop N of 10" lines, in the same
  wording, on the same schedule. That's deliberate: the only honest
  difference between these two programs is what's happening between
  the lines, not in the lines themselves. Worth asking the class to
  predict, before running `interrupt_demo`, what the iteration count
  will look like this time.
- `poll_demo`'s iteration count is a real, specific number, not an
  abstraction. Reading it out loud (several million, to blink an LED
  10 times) tends to land harder than saying "polling wastes power" in
  the abstract.
- `interrupt_demo` has no iteration count to print, on purpose, that
  absence is the point. Nothing happened on the CPU between wakeups,
  there's nothing to count.
- If a curious student asks why `interrupt_demo.resc` pulses the
  interrupt from a Python script instead of letting real hardware
  timing drive it, Section 3 above has the honest answer: a real
  bug/limitation in this specific simulator build, found and diagnosed
  live rather than papered over. Worth mentioning that this is a
  completely ordinary part of systems work, tools you didn't write
  sometimes don't do what their own documentation says, and the fix
  was to prove it with evidence (direct register reads) before
  routing around it, not to guess.

## 5. Notes for class

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
