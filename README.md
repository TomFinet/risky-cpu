
About:
------

This project defines a Verilog model for a CPU which implements the RISC-V 32-bit architecture. The models are tested using Verilator, a cycle-based simulator. The CPU implements a 3-stage pipeline, namely: fetch, decode and execute, each of which occupies a clock cycle.

Roadmap:
--------

1. Design CPU RTL diagram on paper with all control signals for all instructions. First operate under assumption that 1 instruction per cycle.
2. Then pipeline the CPU, use stalling for data-hazards.
3. Add an MMU and virtual memory support.
4. Code an assembler.
5. Code a bootloader.
6. Write a basic OS that supports multiple processes (need interrupts, scheduler).
7. Ethernet driver.
8. TCP/IP stack.

Resources:
----------

[https://github.com/riscv/riscv-isa-manual/releases/tag/draft-20220723-10eea63][RISC-V specifications]
