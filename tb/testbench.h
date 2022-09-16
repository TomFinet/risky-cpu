/* Taken from http://zipcpu.com/blog/2017/06/21/looking-at-verilator.html */

#include <stdlib.h>

#include <verilated_vcd_c.h>
#include "verilated.h"

template<class MODULE> class TestBench {
	
    public:

    unsigned long m_tickcount;
	MODULE *m_core;
    VerilatedVcdC *m_trace;

	TestBench() {
        Verilated::traceEverOn(true);
		m_core = new MODULE;
		m_tickcount = 0l;
	}

	virtual ~TestBench() {
		delete m_core;
		m_core = NULL;
	}

	virtual void reset() {
		m_core->reset = 1;
		// Make sure any inheritance gets applied
		this->tick();
		m_core->reset = 0;
	}

	virtual void tick() {
		// Increment our own internal time reference
		m_tickcount++;

		// Make sure any combinatorial logic depending upon
		// inputs that may have changed before we called tick()
		// has settled before the rising edge of the clock.
		m_core->clock = 0;
		m_core->eval();

		// Toggle the clock

		// Rising edge
		m_core->clock = 1;
		m_core->eval();

		// Falling edge
		m_core->clock = 0;
		m_core->eval();
	}

	virtual bool done() { 
        return Verilated::gotFinish(); 
    }

    // Open/create a trace file
	virtual	void opentrace(const char *vcdname) {
		if (!m_trace) {
			m_trace = new VerilatedVcdC;
			m_core->trace(m_trace, 99);
			m_trace->open(vcdname);
		}
	}

    // Close a trace file
	virtual void close(void) {
		if (m_trace) {
			m_trace->close();
			m_trace = NULL;
		}
	}
};