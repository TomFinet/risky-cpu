#!/usr/bin/env python2
# TODO:
#   0. Add error checking
#   1. Add .data section

import re
import sys

progf = sys.argv[1]

opcode = {
    "op_imm"   : 0b0000000,
    "op"       : 0b0000001,
    "lui"      : 0b0000010,
    "auipc"    : 0b0000011,
    "jal"      : 0b0000100,
    "jalr"     : 0b0000101,
    "branch"   : 0b0000110,
    "load"     : 0b0000111,
    "store"    : 0b0001000,
    "misc_mem" : 0b0001001,
    "system"   : 0b0001010
}

function = {
    "add"   : 0b000,
    "slt"   : 0b001,
    "sltu"  : 0b010,
    "and"   : 0b011,
    "or"    : 0b100,
    "xor"   : 0b101,
    "sll"   : 0b110,
    "srl"   : 0b111,
    "sra"   : 0b000,
    "sub"   : 0b001,
   
    "addi"  : 0b000,
    "slti"  : 0b001,
    "sltui" : 0b010,
    "andi"  : 0b011,
    "ori"   : 0b100,
    "xori"  : 0b101,
    "slli"  : 0b110,
    "srli"  : 0b111,
    "srai"  : 0b000,

    "beq"   : 0b010,
    "bne"   : 0b011,
    "ble"   : 0b100,
    "bleu"  : 0b101,

    "blt"   : 0b001,
    "bltu"  : 0b010,
    

    "lw"    : 0b000,
    "lh"    : 0b001,
    "lhu"   : 0b010,
    "lb"    : 0b011,
    "lbu"   : 0b100,

    "sw"    : 0b000,
    "sh"    : 0b001,
    "sb"    : 0b010
}

# mapping of meaningfull register names to addresses
reg = {
    "zero" : 0b00000, # this register is hard-wired to 0 
    "ra"   : 0b00001, # return address
    "sp"   : 0b00010, # stack pointer
    "gp"   : 0b00011, # global pointer
    "tp"   : 0b00100, # thread pointer
    "t0"   : 0b00101, # alternate link register
    "t1"   : 0b00110, # temporary
    "t2"   : 0b00111, # temporary
    "s0"   : 0b01000, # saved register
    "fp"   : 0b01000, # frame pointer
    "s1"   : 0b01001, # saved register
    "a0"   : 0b01010, # function arg
    "a1"   : 0b01011, # return val
    "a2"   : 0b01100, # 
    "a3"   : 0b01101, # 
    "a4"   : 0b01110, # function args
    "a5"   : 0b01111, #
    "a6"   : 0b10000, #
    "a7"   : 0b10001, #
    "s2"   : 0b10010, #
    "s3"   : 0b10011, #
    "s4"   : 0b10100, #
    "s5"   : 0b10101, #
    "s6"   : 0b10110, # saved registers
    "s7"   : 0b10111, #
    "s8"   : 0b11000, #
    "s9"   : 0b11001, #
    "s10"  : 0b11010, #
    "s11"  : 0b11011, # 
    "t3"   : 0b11100, #
    "t4"   : 0b11101, # temporaries
    "t5"   : 0b11110, #
    "t6"   : 0b11111, #
}

TEXT, DATA, MEM_SIZE = 0, 1, 1024
mem = [0 for _ in range(MEM_SIZE)]
addr = 0

FUNC3_SIZE = 3
REG_SIZE, IMM5 = 5, 5
FUNC7_SIZE, OPCODE_SIZE = 7, 7
IMM5, IMM12 = 5, 12

labels = {}

def base_int(s):
    if isinstance(s, int):
        return s
    elif s.startswith("0x"):
        return int(s, 16)
    elif s.startswith("0b"):
        return int(s, 2)
    return int(s)

def get_reg(r):
    r = re.sub(",", "", r)
    if r.startswith("x"):
        return r[1:]
    elif r in reg:
        return reg[r]
    else:
        return 0

def build_R_type(instr):
    [func7, rs2, rs1, func3, rd, op] = map(base_int, instr)
    inst = func7 << REG_SIZE
    inst = (inst + rs2) << REG_SIZE
    inst = (inst + rs1) << FUNC3_SIZE
    inst = (inst + func3) << REG_SIZE
    inst = (inst + rd) << OPCODE_SIZE
    inst = inst + op
    return inst

def build_I_type(instr):
    [imm, rs, func3, rd, op] = map(base_int, instr)
    inst = imm << REG_SIZE
    inst = (inst + rs) << FUNC3_SIZE
    inst = (inst + func3) << REG_SIZE
    inst = (inst + rd) << OPCODE_SIZE
    inst = inst + op
    return inst

def build_S_type(instr):
    [imm7, rs2, rs1, func3, imm5, op] = map(base_int, instr)
    inst = imm7 << REG_SIZE
    inst = (inst + rs2) << REG_SIZE
    inst = (inst + rs1) << FUNC3_SIZE
    inst = (inst + func3) << IMM5
    inst = (inst + imm5) << OPCODE_SIZE
    inst = inst + op
    return inst

def build_B_type(instr):
    [imm1a, imm5a, rs2, rs1, func3, imm4, imm1b, op] = map(base_int, instr)
    inst = imm1a << IMM5
    inst = (inst + imm5a) << REG_SIZE
    inst = (inst + rs2) << REG_SIZE
    inst = (inst + rs1) << FUNC3_SIZE
    inst = (inst + func3) << 4
    inst = (inst + imm4) << 1
    inst = (inst + imm1b) << OPCODE_SIZE
    inst = inst + op
    return inst

def build_U_type(instr):
    [imm20, rd, op] = map(base_int, instr)
    inst = imm20 << REG_SIZE
    inst = (inst + rd) << OPCODE_SIZE
    inst = inst + op
    return inst

def build_J_type(instr):
    [imm20, rd, op] = map(base_int, instr)
    inst = imm20 << REG_SIZE
    inst = (inst + rd) << OPCODE_SIZE
    inst = inst + op
    return inst


with open(progf) as f:
    for l in f:

        l = l.strip()
        if l == "":
            continue

        kw = l.split()
        if kw[0][-1] == ":":
            labels[kw[0].rstrip(":")] = addr
        else:
            curr_inst = kw[0].lower()
            inst = 0

            if (
                curr_inst == "addi"  or 
                curr_inst == "slti"  or
                curr_inst == "sltiu" or 
                curr_inst == "andi"  or
                curr_inst == "ori"   or
                curr_inst == "xori"
            ):
                rs = get_reg(kw[2])
                rd = get_reg(kw[1])

                # curr_inst xd, xs, c
                inst = build_I_type([
                    kw[3],
                    rs,
                    function[curr_inst],
                    rd,
                    opcode["op_imm"]
                ])

            elif curr_inst == "nop":
                # addi x0, x0, 0
                inst = build_I_type([
                    0, 
                    0, 
                    function["addi"],
                    0,
                    opcode["op_imm"]
                ])
                
            elif curr_inst == "mov":
                rs = get_reg(kw[2])
                rd = get_reg(kw[1])

                # addi xd, xs, 0
                inst = build_I_type([
                    0,
                    rs,
                    function["addi"],
                    rd,
                    opcode["op_imm"]
                ])

            elif (
                curr_inst == "slli" or
                curr_inst == "srli"
            ):
                rs = get_reg(kw[2])
                rd = get_reg(kw[1])

                # curr_inst xd, xs, c
                inst = build_I_type([
                    kw[3],
                    rs,
                    function[curr_inst],
                    rd,
                    opcode["op_imm"]
                ])
            
            elif curr_inst == "srai":
                rs = get_reg(kw[2])
                rd = get_reg(kw[1])

                # srai rd, rs, c
                inst = build_I_type([
                    kw[3],
                    rs,
                    function[curr_inst],
                    rd,
                    opcode["op_imm"]
                ])

            elif (
                curr_inst == "lui" or
                curr_inst == "auipc"
            ):
                rd = get_reg(kw[1])

                # curr_inst rd, c
                inst = build_I_type([
                    kw[2],
                    rd,
                    opcode[curr_inst]
                ])

            elif (
                curr_inst == "add"  or
                curr_inst == "slt"  or
                curr_inst == "sltu" or
                curr_inst == "and"  or
                curr_inst == "or"   or
                curr_inst == "xor"  or
                curr_inst == "sll"  or
                curr_inst == "srl" 
            ):
                rs2 = get_reg(kw[3])
                rs1 = get_reg(kw[2])
                rd  = get_reg(kw[1])

                # curr_inst rd, rs1, rs2
                inst = build_R_type([
                    0,
                    rs2,
                    rs1,
                    function[curr_inst],
                    rd,
                    opcode["op"]
                ])
            
            elif (
                curr_inst == "sub" or 
                curr_inst == "sra"
            ):
                rs2 = get_reg(kw[3])
                rs1 = get_reg(kw[2])
                rd  = get_reg(kw[1])

                # curr_inst rd, rs1, rs2
                inst = build_R_type([
                    0b0100000,
                    rs2,
                    rs1,
                    function[curr_inst],
                    rd,
                    opcode["op"]
                ])
            
            elif curr_inst == "jal":
                rd = get_reg(kw[1])
                
                # jal rd, offset20
                inst = build_J_type([
                    kw[2],
                    rd,
                    opcode["jal"]
                ])

            elif curr_inst == "jalr":
                rs = get_reg(kw[2])
                rd = get_reg(kw[1])

                # jalr rd, rs, offset12
                inst = build_I_type([
                    kw[3],
                    rs,
                    0,
                    rd,
                    opcode["jalr"]
                ])

            elif curr_inst == "jmp":
                # jmp offset
                offset = kw[1]
                if offset in labels:
                    offset = labels[offset]
                
                inst = build_J_type([
                    offset,
                    reg["zero"],
                    opcode["jal"]
                ])

            elif (
                curr_inst == "beq"  or
                curr_inst == "bne"  or
                curr_inst == "blt"  or
                curr_inst == "bltu" or
                curr_inst == "bge"  or
                curr_inst == "bgeu"
            ):
                rs1 = get_reg(kw[1])
                rs2 = get_reg(kw[2])

                # curr_inst rs1, rs2, offset
                inst = build_B_type([
                    base_int(kw[3]) & 127, # last 7 bits
                    rs2,
                    rs1,
                    function[curr_inst],
                    base_int(kw[3]) & 4160749568, # 111110...0 in decimal to get first 5 bits
                    opcode["branch"]
                ])

            elif (
                curr_inst == "lw"  or
                curr_inst == "lh"  or
                curr_inst == "lhu" or
                curr_inst == "lb"  or
                curr_inst == "lbu"
            ):
                rs = get_reg(kw[3])
                rd = get_reg(kw[1])
                # curr_inst rd, func3, rs, c
                inst = build_I_type([
                    kw[4],
                    rs,
                    function[curr_inst],
                    rd,
                    opcode["load"],
                ])

            elif (
                curr_inst == "sw"  or
                curr_inst == "sh"  or
                curr_inst == "sb"              
            ):
                rs1 = get_reg(kw[1])
                rs2 = get_reg(kw[2])

                # curr_inst rs2, rs1, imm12
                inst = build_S_type([
                    base_int(kw[3]) & 127, # last 7 bits
                    rs2,
                    rs1,
                    function[curr_inst],
                    base_int(kw[3]) & 4160749568, # first 5 bits
                    opcode["store"],
                ])

            else: # error
                None
            
            mem[addr] = inst
            addr += 1

print(' '.join(["{:032b}".format(b) for b in mem]))