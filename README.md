# Risky CPU:

This project defines a Verilog model for a CPU which implements a subset of the RISC-V 32-bit architecture. The models are tested using Verilator, a cycle-based simulator.

<img src='./cpu_block_diagram.jpg'/>

The CPU implements a 5-stage pipeline: instruction fetch (IF), register read (RR), arithmetic (ALU), memory (MEM) and write-back (WB). Data and control hazards are handled by stalling. For the case of control hazards, when a branch or jump instruction is detected, we stall the pipeline until its outcome is determined in the ALU stage. This is achieved by inserting two NOP operations into the pipeline.

## How to simulate:

To run the assembler run

`python ./asm/asm.py ./asm/tests/{your_asm_here}.s > memory.list`

To simulate the machine, simply run `make`. If you want to use gtkwave to take a peek at the signals run `make waves`.

## Supported instructions:

Throughout this section we denote the contents stored at a particular register `xs` as `[xs]`.

### Instructions on immediates

For brievity, we denote the 32-bit sign-extended value of the immediate `imm` as `sext(imm)`. Additionally, we write assume `imm` is a 12-bit value unless otherwise stated. Finally, we use the notation `{a, b}` to denote the concatenation of `a` and `b` and `a^b = {a, a, ..., a}` b times. For example `{011, 1001} = 0111001` and `{110, 0^5} = 11000000`. 

| Instruction        | Description |
|--------------------|-------------|
| `addi xd, xs, imm` | Adds `sext(imm)` to `[xs]` and stores the result in `xd`. |
| `slti xd, xs, imm` | Sets `xd` to 1 if signed `[xs]` is less than `sext(imm)`. |
| `sltiu xd, xs, imm`| Same as `slti`, but where `[xd]` and `imm` are unsigned. |
| `andi xd, xs, imm` | Stores the bitwise and of `[xs]` and `imm` in `xd`. | 
| `ori xd, xs, imm` | Stores the bitwise or of `[xs]` and `imm` in `xd`. |
| `xori xd, xs, imm` | Stores the bitwise exclusive-or of `[xs]` and `imm` in `xd`. |
| `slli xd, xs, imm` | Stores the left `imm`-shift of `[xs]` in `xd`. |
| `srli xd, xs, imm` | Same as `slli`, but with a right shift. |
| `srai xd, xs, imm` | Stores the right `imm`-arithmetic shift of `[xs]` in `xd`. |
| `lui xd, imm20` | Stores `{imm20, 0^12}` in `xd`. |
| `auipc xd, imm20` | Adds `{imm20, 0^12}` to the address of the `auipc` instruction and stores the result in `xd`. |

### Register-to-register instructions



## Roadmap:

-2. Add an end instruction so that simulator can run until it hits it.
-1. Add more pseudoinstructions to the assembler.
0. Add exception and interrupt support.
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