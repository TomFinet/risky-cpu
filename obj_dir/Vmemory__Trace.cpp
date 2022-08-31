// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vmemory__Syms.h"


//======================

void Vmemory::traceChg(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    Vmemory* t = (Vmemory*)userthis;
    Vmemory__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    if (vlSymsp->getClearActivity()) {
        t->traceChgThis(vlSymsp, vcdp, code);
    }
}

//======================


void Vmemory::traceChgThis(Vmemory__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c = code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
        if (VL_UNLIKELY((2U & vlTOPp->__Vm_traceActivity))) {
            vlTOPp->traceChgThis__2(vlSymsp, vcdp, code);
        }
        vlTOPp->traceChgThis__3(vlSymsp, vcdp, code);
    }
    // Final
    vlTOPp->__Vm_traceActivity = 0U;
}

void Vmemory::traceChgThis__2(Vmemory__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c = code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
        vcdp->chgBus(c+1,(vlTOPp->memory__DOT__i),32);
    }
}

void Vmemory::traceChgThis__3(Vmemory__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c = code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
        vcdp->chgBit(c+9,(vlTOPp->mclock));
        vcdp->chgBit(c+17,(vlTOPp->enable));
        vcdp->chgBit(c+25,(vlTOPp->reset));
        vcdp->chgBit(c+33,(vlTOPp->rw));
        vcdp->chgBus(c+41,(vlTOPp->ain),32);
        vcdp->chgBus(c+49,(vlTOPp->din),32);
        vcdp->chgBus(c+57,(vlTOPp->dout),32);
    }
}
