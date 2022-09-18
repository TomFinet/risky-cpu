#include <iostream>
#include <fstream>
#include <string>
#include <bitset>
#include <unistd.h>

#include "utils.h"
#include "testbench.h"
#include "Vrr_decoder.h"

const int tests = 1;

int main(int argc, char **argv) {
	
    Verilated::commandArgs(argc, argv);
	TestBench<Vrr_decoder> *tb = new TestBench<Vrr_decoder>();
    
    uint inst[tests] = {
        0x100080, // addi x1, zero, 1
        // TODO: add more instructions to test
    };

	for(int i=0; i<tests; i++) {
        tb->m_core->inst = inst[i];
        tb->tick();

        printf("rs1: %s\n", b(tb->m_core->rs1));
        printf("pc_sel: %s\n", b(tb->m_core->pc_sel));
        printf("imm: %s\n", b(tb->m_core->imm));
	} 
    
    delete tb;
    exit(EXIT_SUCCESS);
}