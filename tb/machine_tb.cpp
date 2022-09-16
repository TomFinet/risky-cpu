#include <iostream>
#include <fstream>
#include <string>
#include <bitset>
#include <unistd.h>

#include "testbench.h"

#include "Vmachine.h"

class Machine_TB : public TestBench<Vmachine> {

    public:

    void loadProgram(std::string  &progfile) {
        // read program instructions into memory
        std::ifstream f;
        f.open(progfile);

        int i = 0;
        std::string l;
        if(f.is_open()) {
            while(getline(f, l)) {
                std::bitset<32> x(l);
                m_core->machine__DOT__memory_module__DOT__mem[i] = (int) x.to_ulong();
                i++;
            }
        }
    }

    virtual void tick() {
        TestBench<Vmachine>::tick();

        if(m_core->reset) return;
        printf("pc: %u\n", m_core->machine__DOT__cpu_module__DOT__pc);
        printf("ir: %u\n", m_core->machine__DOT__cpu_module__DOT__ir_pipe[0]);

        // print contents of registers
        for(int i = 0; i < 32; i++) {
            printf("x%d: %u\n", i, m_core->machine__DOT__cpu_module__DOT__register_bank_module__DOT__r[i]);
        }
        printf("\n");
        sleep(1);
    }
};

int main(int argc, char **argv) {
	
    Verilated::commandArgs(argc, argv);
	Machine_TB *tb = new Machine_TB();

    tb->reset();

    std::string progfile = "memory.list";
    tb->loadProgram(progfile);
    
    // dump memory contents
    for(int i = 0; i < 1024; i++) {
        uint32_t data = tb->m_core->machine__DOT__memory_module__DOT__mem[i];
        if(data != 0) printf("%u\n", data);
    }
    printf("\n");

	while(!tb->done()) {
		tb->tick();
	} exit(EXIT_SUCCESS);

    delete tb;
}