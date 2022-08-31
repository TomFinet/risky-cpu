// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vcpu__Syms.h"


//======================

void Vcpu::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addCallback(&Vcpu::traceInit, &Vcpu::traceFull, &Vcpu::traceChg, this);
}
void Vcpu::traceInit(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->open()
    Vcpu* t = (Vcpu*)userthis;
    Vcpu__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    if (!Verilated::calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
                        "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vcdp->scopeEscape(' ');
    t->traceInitThis(vlSymsp, vcdp, code);
    vcdp->scopeEscape('.');
}
void Vcpu::traceFull(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    Vcpu* t = (Vcpu*)userthis;
    Vcpu__Syms* __restrict vlSymsp = t->__VlSymsp;  // Setup global symbol table
    t->traceFullThis(vlSymsp, vcdp, code);
}

//======================


void Vcpu::traceInitThis(Vcpu__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vcpu* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c = code;
    if (0 && vcdp && c) {}  // Prevent unused
    vcdp->module(vlSymsp->name());  // Setup signal names
    // Body
    {
        vlTOPp->traceInitThis__1(vlSymsp, vcdp, code);
    }
}

void Vcpu::traceFullThis(Vcpu__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vcpu* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c = code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
        vlTOPp->traceFullThis__1(vlSymsp, vcdp, code);
    }
    // Final
    vlTOPp->__Vm_traceActivity = 0U;
}

void Vcpu::traceInitThis__1(Vcpu__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vcpu* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c = code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
        vcdp->declBit(c+33,"reset", false,-1);
        vcdp->declBit(c+41,"halt", false,-1);
        vcdp->declBit(c+49,"clock", false,-1);
        vcdp->declBus(c+57,"Din", false,-1, 31,0);
        vcdp->declBus(c+65,"A", false,-1, 31,0);
        vcdp->declBus(c+73,"Dout", false,-1, 31,0);
        vcdp->declBit(c+33,"cpu reset", false,-1);
        vcdp->declBit(c+41,"cpu halt", false,-1);
        vcdp->declBit(c+49,"cpu clock", false,-1);
        vcdp->declBus(c+57,"cpu Din", false,-1, 31,0);
        vcdp->declBus(c+65,"cpu A", false,-1, 31,0);
        vcdp->declBus(c+73,"cpu Dout", false,-1, 31,0);
        vcdp->declBus(c+1,"cpu pc", false,-1, 31,0);
        vcdp->declBus(c+9,"cpu addr_reg", false,-1, 31,0);
        vcdp->declBus(c+17,"cpu instr_reg", false,-1, 31,0);
        vcdp->declBit(c+81,"cpu reg_enable", false,-1);
        vcdp->declBit(c+89,"cpu reg_rw", false,-1);
        vcdp->declBus(c+97,"cpu reg_din", false,-1, 31,0);
        vcdp->declBus(c+105,"cpu reg_ain", false,-1, 4,0);
        vcdp->declBus(c+25,"cpu reg_dout", false,-1, 31,0);
        vcdp->declBit(c+49,"cpu register_bank clock", false,-1);
        vcdp->declBit(c+81,"cpu register_bank enable", false,-1);
        vcdp->declBit(c+89,"cpu register_bank rw", false,-1);
        vcdp->declBus(c+97,"cpu register_bank din", false,-1, 31,0);
        vcdp->declBus(c+105,"cpu register_bank ain", false,-1, 4,0);
        vcdp->declBus(c+25,"cpu register_bank dout", false,-1, 31,0);
        vcdp->declBus(c+113,"cpu register_bank N", false,-1, 31,0);
        {int i; for (i=0; i<32; i++) {
                vcdp->declBus(c+121+i*1,"cpu register_bank r", true,(i+0), 31,0);}}
    }
}

void Vcpu::traceFullThis__1(Vcpu__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vcpu* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c = code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
        vcdp->fullBus(c+1,(vlTOPp->cpu__DOT__pc),32);
        vcdp->fullBus(c+9,(vlTOPp->cpu__DOT__addr_reg),32);
        vcdp->fullBus(c+17,(vlTOPp->cpu__DOT__instr_reg),32);
        vcdp->fullBus(c+25,(vlTOPp->cpu__DOT__reg_dout),32);
        vcdp->fullBit(c+33,(vlTOPp->reset));
        vcdp->fullBit(c+41,(vlTOPp->halt));
        vcdp->fullBit(c+49,(vlTOPp->clock));
        vcdp->fullBus(c+57,(vlTOPp->Din),32);
        vcdp->fullBus(c+65,(vlTOPp->A),32);
        vcdp->fullBus(c+73,(vlTOPp->Dout),32);
        vcdp->fullBit(c+81,(vlTOPp->cpu__DOT__reg_enable));
        vcdp->fullBit(c+89,(vlTOPp->cpu__DOT__reg_rw));
        vcdp->fullBus(c+97,(vlTOPp->cpu__DOT__reg_din),32);
        vcdp->fullBus(c+105,(vlTOPp->cpu__DOT__reg_ain),5);
        vcdp->fullBus(c+113,(0x20U),32);
        vcdp->fullBus(c+121,(vlTOPp->cpu__DOT__register_bank__DOT__r[0]),32);
        vcdp->fullBus(c+122,(vlTOPp->cpu__DOT__register_bank__DOT__r[1]),32);
        vcdp->fullBus(c+123,(vlTOPp->cpu__DOT__register_bank__DOT__r[2]),32);
        vcdp->fullBus(c+124,(vlTOPp->cpu__DOT__register_bank__DOT__r[3]),32);
        vcdp->fullBus(c+125,(vlTOPp->cpu__DOT__register_bank__DOT__r[4]),32);
        vcdp->fullBus(c+126,(vlTOPp->cpu__DOT__register_bank__DOT__r[5]),32);
        vcdp->fullBus(c+127,(vlTOPp->cpu__DOT__register_bank__DOT__r[6]),32);
        vcdp->fullBus(c+128,(vlTOPp->cpu__DOT__register_bank__DOT__r[7]),32);
        vcdp->fullBus(c+129,(vlTOPp->cpu__DOT__register_bank__DOT__r[8]),32);
        vcdp->fullBus(c+130,(vlTOPp->cpu__DOT__register_bank__DOT__r[9]),32);
        vcdp->fullBus(c+131,(vlTOPp->cpu__DOT__register_bank__DOT__r[10]),32);
        vcdp->fullBus(c+132,(vlTOPp->cpu__DOT__register_bank__DOT__r[11]),32);
        vcdp->fullBus(c+133,(vlTOPp->cpu__DOT__register_bank__DOT__r[12]),32);
        vcdp->fullBus(c+134,(vlTOPp->cpu__DOT__register_bank__DOT__r[13]),32);
        vcdp->fullBus(c+135,(vlTOPp->cpu__DOT__register_bank__DOT__r[14]),32);
        vcdp->fullBus(c+136,(vlTOPp->cpu__DOT__register_bank__DOT__r[15]),32);
        vcdp->fullBus(c+137,(vlTOPp->cpu__DOT__register_bank__DOT__r[16]),32);
        vcdp->fullBus(c+138,(vlTOPp->cpu__DOT__register_bank__DOT__r[17]),32);
        vcdp->fullBus(c+139,(vlTOPp->cpu__DOT__register_bank__DOT__r[18]),32);
        vcdp->fullBus(c+140,(vlTOPp->cpu__DOT__register_bank__DOT__r[19]),32);
        vcdp->fullBus(c+141,(vlTOPp->cpu__DOT__register_bank__DOT__r[20]),32);
        vcdp->fullBus(c+142,(vlTOPp->cpu__DOT__register_bank__DOT__r[21]),32);
        vcdp->fullBus(c+143,(vlTOPp->cpu__DOT__register_bank__DOT__r[22]),32);
        vcdp->fullBus(c+144,(vlTOPp->cpu__DOT__register_bank__DOT__r[23]),32);
        vcdp->fullBus(c+145,(vlTOPp->cpu__DOT__register_bank__DOT__r[24]),32);
        vcdp->fullBus(c+146,(vlTOPp->cpu__DOT__register_bank__DOT__r[25]),32);
        vcdp->fullBus(c+147,(vlTOPp->cpu__DOT__register_bank__DOT__r[26]),32);
        vcdp->fullBus(c+148,(vlTOPp->cpu__DOT__register_bank__DOT__r[27]),32);
        vcdp->fullBus(c+149,(vlTOPp->cpu__DOT__register_bank__DOT__r[28]),32);
        vcdp->fullBus(c+150,(vlTOPp->cpu__DOT__register_bank__DOT__r[29]),32);
        vcdp->fullBus(c+151,(vlTOPp->cpu__DOT__register_bank__DOT__r[30]),32);
        vcdp->fullBus(c+152,(vlTOPp->cpu__DOT__register_bank__DOT__r[31]),32);
    }
}
