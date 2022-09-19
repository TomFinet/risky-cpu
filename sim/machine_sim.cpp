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

    const static int MAX_TICKS = 20;

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
                m_core->machine__DOT__memory_m__DOT__mem[i] = (uint) x.to_ulong();
                i++;
            }
        }
    }

    virtual void tick() {
        TestBench<Vmachine>::tick();
    }
};

int main(int argc, char **argv) {
	
    Verilated::commandArgs(argc, argv);
	Machine_Sim *tb = new Machine_Sim();

    tb->opentrace("machine_trace.vcd");
    tb->reset();

    std::string progfile = "memory.list";
    tb->loadProgram(progfile);
    
    //tb->m_core->machine__DOT__cpu_m__DOT__register_bank_m__DOT__r[1] = 63;

    // dump memory contents
    for(int i = 0; i < 1024; i++) {
        uint32_t data = tb->m_core->machine__DOT__memory_m__DOT__mem[i];
        if(data != 0) printf("%s\n", b(data));
    }
    printf("\n");

	while(!tb->done()) {
		tb->tick();
	}

    for(int i = 0; i < 1024; i++) {
        printf("mem[%d]: %s\n", i, b(tb->m_core->machine__DOT__memory_m__DOT__mem[i]));
    }
    printf("\n\n");

    for(int i = 0; i < 32; i++) {
        printf("x%d: %s\n", i, b(tb->m_core->machine__DOT__cpu_m__DOT__register_bank_m__DOT__r[i]));
    }
    printf("\n");

    delete tb;
    exit(EXIT_SUCCESS);
}