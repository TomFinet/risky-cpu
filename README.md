About:
------

This project defines a Verilog model for a CPU which implements a subset of the RISC-V 32-bit architecture. The models are tested using Verilator, a cycle-based simulator.

<img src='./cpu_block_diagram.jpg'/>

The CPU implements a 5-stage pipeline: instruction fetch (IF), register read (RR), arithmetic (ALU), memory (MEM) and write-back (WB). Data and control hazards are handled by stalling. For the case of control hazards, when a branch instruction is detected, we stall the pipeline until its outcome is determined in the ALU stage. This is achieved by inserting two NOP operations into the pipeline.

Current tasks:
--------------

1. Handle hazards. Doing
2. Handle exceptions.
3. Handle interrupts.

Roadmap:
--------

1. Add an MMU and virtual memory support.
2. Code a bootloader.
3. Write a basic OS that supports multiple processes (need interrupts, scheduler).
4. Ethernet driver.
5. TCP/IP stack.

Bibliography:
-------------

[https://github.com/riscv/riscv-isa-manual/releases/tag/draft-20220723-10eea63][RISC-V specifications]

[https://youtu.be/R0tFDXBZvKI][MIT 6.004 Computational Structures, Spring 2017, Lectures]
