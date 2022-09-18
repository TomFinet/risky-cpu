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

	virtual void tick() {
		// Increment our own internal time reference
		m_tickcount++;

		// Make sure any combinatorial logic depending upon
		// inputs that may have changed before we called tick()
		// has settled before the rising edge of the clock.
		m_core->clock = 0;
		m_core->eval();

        if(m_trace) m_trace->dump(10*m_tickcount-2);

		// Toggle the clock

		// Rising edge
		m_core->clock = 1;
		m_core->eval();

        if(m_trace) m_trace->dump(10*m_tickcount);

		// Falling edge
		m_core->clock = 0;
		m_core->eval();

        if (m_trace) {
			// This portion, though, is a touch different.
			// After dumping our values as they exist on the
			// negative clock edge ...
			m_trace->dump(10*m_tickcount+5);
			//
			// We'll also need to make sure we flush any I/O to
			// the trace file, so that we can use the assert()
			// function between now and the next tick if we want to.
			m_trace->flush();
		}
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