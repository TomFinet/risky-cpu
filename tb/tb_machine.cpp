/**
 * Tests the cpu module on an example program.
 */

#include <stdlib.h>
#include <iostream>

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "Vmachine.h"

const uint64_t MAX_SIM_TIME = 1000;

uint64_t sim_time = 0;
uint64_t posedge_cnt = 0;

Vmachine *machine;

double sc_time_stamp() {
	return sim_time;
}

void machine_reset() {
	machine->reset = 0;
	if(posedge_cnt == 1) {
		machine->reset = 1;
	}
}

int main(int argc, char **argv) {
	Verilated::commandArgs(argc, argv);

	machine = new Vmachine();

	Verilated::traceEverOn(true);
	VerilatedVcdC *m_trace = new VerilatedVcdC;
	machine->trace(m_trace, 5);
	m_trace->open("machine_waveform.vcd");

	machine->halt = 0;

	while(sim_time < MAX_SIM_TIME) {

		machine->clock ^=1;

		if(machine->clock == 1) {
			posedge_cnt++;
			
			machine_reset();            
		}

		machine->eval();

		m_trace->dump(sim_time);
		sim_time++;
	}

	m_trace->close();
	delete machine;
	exit(EXIT_SUCCESS);
}
