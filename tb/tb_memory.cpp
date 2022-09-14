/**
 * Tests the memory module.
 */

#include <stdlib.h>
#include <iostream>

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vmemory.h"

const uint64_t MAX_SIM_TIME = 20;

uint64_t sim_time = 0;
uint64_t posedge_cnt = 0;

Vmemory *mem;

double sc_time_stamp() {
	return sim_time;
}

/**
 * Resets the memory.
 */
void mem_reset() {
	mem->reset = 0;
	if(posedge_cnt == 1) {
		mem->reset = 1;
	}
}

int main(int argc, char **argv) {
	Verilated::commandArgs(argc, argv);

	mem = new Vmemory();

	Verilated::traceEverOn(true);
	VerilatedVcdC *m_trace = new VerilatedVcdC;
	mem->trace(m_trace, 5);
	m_trace->open("waveform.vcd");

	while(sim_time < MAX_SIM_TIME) {

		mem->mclock ^=1;

		if(mem->mclock == 1) {
			posedge_cnt++;
			
			mem_reset();
			
			if(posedge_cnt == 2) {
				mem->rw = 0;
				mem->ain = 1;

				if(mem->dout != 0) {
					std::cout << "Error\n";
				}
			}

			if(posedge_cnt == 4) {
				mem->enable = 1;
				mem->rw = 1;
				mem->ain = 6;
				mem->din = 12;
			}

			if(posedge_cnt == 8) {
				mem->rw = 0;

				if(mem->dout != mem->din) {
					std::cout << "Error\n";
				}
			}
		}

		mem->eval();
		m_trace->dump(sim_time);
		sim_time++;
	}

	m_trace->close();
	delete mem;
	exit(EXIT_SUCCESS);
}
