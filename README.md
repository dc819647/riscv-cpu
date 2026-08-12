# RISC-V CPU

A pipelined RV32I processor core written in SystemVerilog, simulated with Verilator.

## Goal
Build a working RISC-V CPU from scratch: single-cycle first, then pipelined
with hazard detection and forwarding, verified against the RISC-V test suite.

## Supported instructions (target)
add, sub, and, or, addi, lw, sw, beq

## Status
- [x] Toolchain setup (Verilator, GTKWave)
- [ ] Program counter
- [ ] Single-cycle datapath
- [ ] Pipeline

## Structure
- `rtl/` — SystemVerilog source modules
- `tb/`  — testbenches
