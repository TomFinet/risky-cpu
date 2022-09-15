# Risky CPU:

This project defines a Verilog model for a CPU which implements a subset of the RISC-V 32-bit architecture. The models are tested using Verilator, a cycle-based simulator.

<img src='./cpu_block_diagram.jpg'/>

The CPU implements a 5-stage pipeline: instruction fetch (IF), register read (RR), arithmetic (ALU), memory (MEM) and write-back (WB). Data and control hazards are handled by stalling. For the case of control hazards, when a branch or jump instruction is detected, we stall the pipeline until its outcome is determined in the ALU stage. This is achieved by inserting two NOP operations into the pipeline.

To run the assembler run

`python ./asm/asm.py ./asm/tests/{your_asm_here}.s > memory.list`

and to run the machine, simply run `make` followed by `make waves` if you want gtkwave to display the signals over time.

## Current tasks:

0. Write good verilator testbenches.
1. Implement verilog for stalling.
2. Handle interrupts.

## Roadmap:

1. Add an MMU and virtual memory support.
2. Code a bootloader.
3. Write a basic OS that supports multiple processes (need interrupts, scheduler).
4. Ethernet driver.
5. TCP/IP stack.

## Bibliography:

[RISC-V specifications](https://github.com/riscv/riscv-isa-manual/releases/tag/draft-20220723-10eea63)

[MIT 6.004 Computational Structures, Spring 2017, Lectures](https://youtu.be/R0tFDXBZvKI)

[lightcode's 8bit-computer github project](https://github.com/lightcode/8bit-computer)