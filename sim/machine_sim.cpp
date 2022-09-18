#include <iostream>
#include <fstream>
#include <string>
#include <bitset>
#include <unistd.h>

#include "../tb/utils.h"
#include "../tb/testbench.h"

#include "Vmachine.h"

/* TODO: Only print out the registers which have changed value. */

class Machine_Sim : public TestBench<Vmachine> {

    const static int MAX_TICKS = 12;

    public:

    virtual void reset() {
		m_core->reset = 1;
		// Make sure any inheritance gets applied
		this->tick();
		m_core->reset = 0;
	}

    virtual bool done() {
        return m_tickcount > MAX_TICKS;
    }

    void loadProgram(std::string  &progfile) {
        // read program instructions into memory
        std::ifstream f;
        f.open(progfile);

        int i = 0;
        std::string l;
        if(f.is_open()) {
            while(getline(f, l)) {
                std::bitset<32> x(l);
                m_core->machine__DOT__memory_module__DOT__mem[i] = (uint) x.to_ulong();
                i++;
            }
        }
    }

    virtual void tick() {
        TestBench<Vmachine>::tick();

        // Internals of the Machine are printed in groups based on
        // pipeline stages.

        // IF stage
        printf("IF Stage:\n\n");

        printf("pc: %u\n", m_core->machine__DOT__cpu_module__DOT__pc);
        
        // RR stage
        printf("\nRR stage:\n\n");

        printf("pc_rr: %u\n", m_core->machine__DOT__cpu_module__DOT__pc_pipe[0]);
        printf("ir_rr: %s \n", b(m_core->machine__DOT__cpu_module__DOT__ir_pipe[0]));
        printf("pc_sel: %u\n", m_core->machine__DOT__cpu_module__DOT__pc_sel);
        printf("a_sel: %u\n", m_core->machine__DOT__cpu_module__DOT__a_sel);
        printf("b_sel: %u\n", m_core->machine__DOT__cpu_module__DOT__b_sel);
        printf("rs1: %s\n", b(m_core->machine__DOT__cpu_module__DOT__rs1));
        printf("rs2: %s\n", b(m_core->machine__DOT__cpu_module__DOT__rs2));
        printf("rs1_val: missing\n");
        printf("rs2_val: %s\n", b(m_core->machine__DOT__cpu_module__DOT__rs2_val));
        printf("imm_rr: %s\n", b(m_core->machine__DOT__cpu_module__DOT__rr_imm));
        
        // ALU stage
        printf("\nALU stage:\n\n");

        printf("pc_alu: %u\n", m_core->machine__DOT__cpu_module__DOT__pc_pipe[1]);
        printf("ir_alu: %s\n", b(m_core->machine__DOT__cpu_module__DOT__ir_pipe[1]));
        printf("a: %u\n", m_core->machine__DOT__cpu_module__DOT__a);
        printf("b: %u\n", m_core->machine__DOT__cpu_module__DOT__b);
        printf("d_alu: %s\n", b(m_core->machine__DOT__cpu_module__DOT__d_pipe[0]));
        printf("alu_op: %s\n", b(m_core->machine__DOT__cpu_module__DOT__alu_op));
        printf("alu_res: %s\n", b(m_core->machine__DOT__cpu_module__DOT__alu_res));
        printf("imm_alu: %s\n", b(m_core->machine__DOT__cpu_module__DOT__alu_imm));

        // MEM stage
        printf("\nMEM stage:\n\n");

        printf("pc_mem: %u\n", m_core->machine__DOT__cpu_module__DOT__pc_pipe[2]);
        printf("ir_mem: %s\n", b(m_core->machine__DOT__cpu_module__DOT__ir_pipe[2]));
        printf("alu_res_mem: %u\n", m_core->machine__DOT__cpu_module__DOT__r_pipe[0]);
        printf("store_sel: %u\n", m_core->machine__DOT__cpu_module__DOT__store_sel);
        printf("rw: %u\n", m_core->machine__DOT__mem_rw);
        printf("mem_ain: %u\n", m_core->machine__DOT__cpu_module__DOT__d_pipe[1]);
        printf("mem_din: %u\n", m_core->machine__DOT__mem_din);
        printf("mem[20]: %s\n", b(m_core->machine__DOT__memory_module__DOT__mem[20]));

        // WB stage
        printf("\nWB stage:\n");
        
        printf("pc_wb: %u\n", m_core->machine__DOT__cpu_module__DOT__pc_pipe[3]);
        printf("alu_res_wb: %u\n", m_core->machine__DOT__cpu_module__DOT__r_pipe[1]);
        printf("mem_dout: %s\n", b(m_core->machine__DOT__mem_dout));
        printf("reg_we: %u\n", m_core->machine__DOT__cpu_module__DOT__reg_we);
        printf("reg_sel: %u\n", m_core->machine__DOT__cpu_module__DOT__reg_sel);
        printf("reg_rd: %s\n", b(m_core->machine__DOT__cpu_module__DOT__rd));
        printf("load_sel: %u\n", m_core->machine__DOT__cpu_module__DOT__load_sel);

        // print contents of registers
        /*for(int i = 0; i < 32; i++) {
            printf("x%d: %u\n", i, m_core->machine__DOT__cpu_module__DOT__register_bank_module__DOT__r[i]);
        }*/
        printf("x1: %s\n", b(m_core->machine__DOT__cpu_module__DOT__register_bank_module__DOT__r[1]));
        printf("x2: %s\n", b(m_core->machine__DOT__cpu_module__DOT__register_bank_module__DOT__r[2]));
        printf("x3: %s\n", b(m_core->machine__DOT__cpu_module__DOT__register_bank_module__DOT__r[3]));
        printf("\n");
        printf("========================================================\n\n");
        //sleep(1);
    }
};

int main(int argc, char **argv) {
	
    Verilated::commandArgs(argc, argv);
	Machine_Sim *tb = new Machine_Sim();

    tb->opentrace("machine_trace.vcd");
    tb->reset();

    std::string progfile = "memory.list";
    tb->loadProgram(progfile);
    
    // set all registers to 0
    for(int i=1; i<32; i++) {
        tb->m_core->machine__DOT__cpu_module__DOT__register_bank_module__DOT__r[i] = 0;
    }

    // dump memory contents
    for(int i = 0; i < 1024; i++) {
        uint32_t data = tb->m_core->machine__DOT__memory_module__DOT__mem[i];
        if(data != 0) printf("%u\n", data);
    }
    printf("\n");

	while(!tb->done()) {
		tb->tick();
	}

    for(int i=0; i<32; i++) {
        printf("x%d: %s\n", i, b(tb->m_core->machine__DOT__cpu_module__DOT__register_bank_module__DOT__r[i]));
    }
    printf("\n");

    delete tb;
    exit(EXIT_SUCCESS);
}