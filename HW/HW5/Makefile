# Makefile for the HW5 demos (see README.md).
#
# Three demos, meant to be shown in order, all built on the same
# full_adder.v (the exact circuit Lab5 Part 2 has you build by hand):
#   - single: one unchained full adder, inflated gate delays, a naive
#     fast sampler vs. a coordinated (clock-safe) sampler reading the
#     same circuit. The propagation-delay-means-coordination-matters
#     point, made concrete on the smallest possible real circuit.
#   - clk_fast: the same adder, now sampled by a real clocked D
#     flip-flop, with CLK_PERIOD shorter than the adder's worst-case
#     settle time. Produces real, provable MISMATCH lines: the clock
#     looked before the answer was ready.
#   - clk_ok: identical to clk_fast except CLK_PERIOD has real margin
#     above the worst-case settle time. Every sample matches. This is
#     what a clock actually buys a synchronous design: not speed, a
#     guarantee about when it's safe to look, same as Lab5's clocked
#     counter.
#
# ripple_adder.v / tb_ripple_adder.v are still in this folder (the
# WIDTH-bit ripple-carry adder, showing settle time getting worse as
# a circuit scales) but are no longer part of the main three-part
# demo below; see README.md if you want to run that one separately.

IVERILOG        ?= iverilog
VVP             ?= vvp
GTKWAVE         ?= gtkwave
GATE_DELAY_RISE ?= 7
GATE_DELAY_FALL ?= 3
CLK_PERIOD_FAST ?= 10
CLK_PERIOD_OK   ?= 32

SINGLE_SRCS = full_adder.v tb_single_adder.v
CLOCK_SRCS  = full_adder.v tb_clocked_adder.v

.PHONY: all run_single run_clk_fast run_clk_ok wave_single wave_clk_fast wave_clk_ok clean

all: sim_single.vvp sim_clk_fast.vvp sim_clk_ok.vvp

sim_single.vvp: $(SINGLE_SRCS)
	$(IVERILOG) -o sim_single.vvp -Ptb_single_adder.GATE_DELAY_RISE=$(GATE_DELAY_RISE) -Ptb_single_adder.GATE_DELAY_FALL=$(GATE_DELAY_FALL) $(SINGLE_SRCS)

sim_clk_fast.vvp: $(CLOCK_SRCS)
	$(IVERILOG) -o sim_clk_fast.vvp -Ptb_clocked_adder.GATE_DELAY_RISE=$(GATE_DELAY_RISE) -Ptb_clocked_adder.GATE_DELAY_FALL=$(GATE_DELAY_FALL) -Ptb_clocked_adder.CLK_PERIOD=$(CLK_PERIOD_FAST) -Ptb_clocked_adder.DUMPFILE=\"clocked_adder_fast.vcd\" $(CLOCK_SRCS)

sim_clk_ok.vvp: $(CLOCK_SRCS)
	$(IVERILOG) -o sim_clk_ok.vvp -Ptb_clocked_adder.GATE_DELAY_RISE=$(GATE_DELAY_RISE) -Ptb_clocked_adder.GATE_DELAY_FALL=$(GATE_DELAY_FALL) -Ptb_clocked_adder.CLK_PERIOD=$(CLK_PERIOD_OK) -Ptb_clocked_adder.DUMPFILE=\"clocked_adder_ok.vcd\" $(CLOCK_SRCS)

# run_single / run_clk_fast / run_clk_ok: just the $display trace, no
# GUI, safe to run over SSH or in a terminal with no display server.
run_single: sim_single.vvp
	$(VVP) sim_single.vvp

run_clk_fast: sim_clk_fast.vvp
	$(VVP) sim_clk_fast.vvp

run_clk_ok: sim_clk_ok.vvp
	$(VVP) sim_clk_ok.vvp

# wave_single / wave_clk_fast / wave_clk_ok: run the simulation then
# open the resulting waveform in gtkwave. single_adder.vcd,
# clocked_adder_fast.vcd, and clocked_adder_ok.vcd are three separate
# files (see tb_clocked_adder.v's DUMPFILE parameter), so running one
# demo never overwrites another's waveform, all three can stay open
# side by side.
wave_single: sim_single.vvp
	$(VVP) sim_single.vvp
	$(GTKWAVE) single_adder.vcd &

wave_clk_fast: sim_clk_fast.vvp
	$(VVP) sim_clk_fast.vvp
	$(GTKWAVE) clocked_adder_fast.vcd &

wave_clk_ok: sim_clk_ok.vvp
	$(VVP) sim_clk_ok.vvp
	$(GTKWAVE) clocked_adder_ok.vcd &

clean:
	rm -f sim_single.vvp sim_clk_fast.vvp sim_clk_ok.vvp single_adder.vcd clocked_adder_fast.vcd clocked_adder_ok.vcd
