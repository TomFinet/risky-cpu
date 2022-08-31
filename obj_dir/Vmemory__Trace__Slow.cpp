// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vmemory__Syms.h"


//======================

void Vmemory::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addCallback(&Vmemory::traceInit, &Vmemory::traceFull, &Vmemory::traceChg, this);
}
void Vmemory::traceInit(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->open()
    Vmemory* t = (Vmemory*)userthis;
    Vmemory__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    if (!Verilated::calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
                        "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vcdp->scopeEscape(' ');
    t->traceInitThis(vlSymsp, vcdp, code);
    vcdp->scopeEscape('.');
}
void Vmemory::traceFull(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    Vmemory* t = (Vmemory*)userthis;
    Vmemory__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    t->traceFullThis(vlSymsp, vcdp, code);
}

//======================


void Vmemory::traceInitThis(Vmemory__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c = code;
    if (0 && vcdp && c) {}  // Prevent unused
    vcdp->module(vlSymsp->name());  // Setup signal names
    // Body
    {
        vlTOPp->traceInitThis__1(vlSymsp, vcdp, code);
    }
}

void Vmemory::traceFullThis(Vmemory__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c = code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
        vlTOPp->traceFullThis__1(vlSymsp, vcdp, code);
    }
    // Final
    vlTOPp->__Vm_traceActivity = 0U;
}

void Vmemory::traceInitThis__1(Vmemory__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c = code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
        vcdp->declBit(c+9,"mclock", false,-1);
        vcdp->declBit(c+17,"enable", false,-1);
        vcdp->declBit(c+25,"reset", false,-1);
        vcdp->declBit(c+33,"rw", false,-1);
        vcdp->declBus(c+41,"ain", false,-1, 31,0);
        vcdp->declBus(c+49,"din", false,-1, 31,0);
        vcdp->declBus(c+57,"dout", false,-1, 31,0);
        vcdp->declBit(c+9,"memory mclock", false,-1);
        vcdp->declBit(c+17,"memory enable", false,-1);
        vcdp->declBit(c+25,"memory reset", false,-1);
        vcdp->declBit(c+33,"memory rw", false,-1);
        vcdp->declBus(c+41,"memory ain", false,-1, 31,0);
        vcdp->declBus(c+49,"memory din", false,-1, 31,0);
        vcdp->declBus(c+57,"memory dout", false,-1, 31,0);
        vcdp->declBus(c+65,"memory N", false,-1, 31,0);
        vcdp->declBus(c+1,"memory i", false,-1, 31,0);
    }
}

void Vmemory::traceFullThis__1(Vmemory__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c = code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
        vcdp->fullBus(c+1,(vlTOPp->memory__DOT__i),32);
        vcdp->fullBit(c+9,(vlTOPp->mclock));
        vcdp->fullBit(c+17,(vlTOPp->enable));
        vcdp->fullBit(c+25,(vlTOPp->reset));
        vcdp->fullBit(c+33,(vlTOPp->rw));
        vcdp->fullBus(c+41,(vlTOPp->ain),32);
        vcdp->fullBus(c+49,(vlTOPp->din),32);
        vcdp->fullBus(c+57,(vlTOPp->dout),32);
        vcdp->fullBus(c+65,(0x400U),32);
    }
}
