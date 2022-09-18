# Risky CPU:

This project defines a Verilog model for a CPU which implements a subset of the RISC-V 32-bit architecture. The models are tested using Verilator, a cycle-based simulator.

<img src='./cpu_block_diagram.jpg'/>

The CPU implements a 5-stage pipeline: instruction fetch (IF), register read (RR), arithmetic (ALU), memory (MEM) and write-back (WB). Data and control hazards are handled by stalling. For the case of control hazards, when a branch or jump instruction is detected, we stall the pipeline until its outcome is determined in the ALU stage. This is achieved by inserting two NOP operations into the pipeline.

To run the assembler run

`python ./asm/asm.py ./asm/tests/{your_asm_here}.s > memory.list`

and to simulate the machine, simply run `make`.

## Supported instructions:

Throughout this section we denote the contents stored at a particular register `xs` as `[xs]`.

| Instruction       | Description |
|-------------------|-------------|
| `addi xd, xs, imm`| Adds the 12-bit immediate `imm` to `[xs]` and stores the result in `xd`. |

## Current tasks:

1. Implement logic for control hazard stalling.
2. Write good verilator testbenches.
3. Handle interrupts.

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

[ZipCPU blog on Verilator](http://zipcpu.com/blog/2017/06/21/looking-at-verilator.html)