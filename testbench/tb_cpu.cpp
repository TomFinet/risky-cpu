/**
 * Tests the cpu module on an example program.
 */

#include <stdlib.h>
#include <iostream>

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vcpu.h"

const uint64_t MAX_SIM_TIME = 20;

uint64_t sim_time = 0;
uint64_t posedge_cnt = 0;

Vcpu *cpu;

double sc_time_stamp() {
	return sim_time;
}

void cpu_reset() {
	cpu->reset = 0;
	if(posedge_cnt == 1) {
		cpu->reset = 1;
	}
}

int main(int argc, char **argv) {
	Verilated::commandArgs(argc, argv);

	cpu = new Vcpu();

	Verilated::traceEverOn(true);
	VerilatedVcdC *m_trace = new VerilatedVcdC;
	cpu->trace(m_trace, 5);
	m_trace->open("waveform.vcd");

	cpu->halt = 0;

	while(sim_time < MAX_SIM_TIME) {

		cpu->clock ^=1;

		if(cpu->clock == 1) {
			posedge_cnt++;
			
			cpu_reset();

			if(posedge_cnt == 2) {
				cpu->Din = 12;
			}
		}

		cpu->eval();
		std::cout << cpu->cpu__DOT__instr_reg << "\n";
		
		m_trace->dump(sim_time);
		sim_time++;
	}

	m_trace->close();
	delete cpu;
	exit(EXIT_SUCCESS);
}
