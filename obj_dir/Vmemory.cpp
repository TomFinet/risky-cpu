// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vmemory.h for the primary calling header

#include "Vmemory.h"
#include "Vmemory__Syms.h"

//==========

VL_CTOR_IMP(Vmemory) {
    Vmemory__Syms* __restrict vlSymsp = __VlSymsp = new Vmemory__Syms(this, name());
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vmemory::__Vconfigure(Vmemory__Syms* vlSymsp, bool first) {
    if (0 && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
}

Vmemory::~Vmemory() {
    delete __VlSymsp; __VlSymsp=NULL;
}

void Vmemory::eval() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vmemory::eval\n"); );
    Vmemory__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        vlSymsp->__Vm_activity = true;
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("rtl/memory.v", 1, "",
                "Verilated model didn't converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vmemory::_eval_initial_loop(Vmemory__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    vlSymsp->__Vm_activity = true;
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("rtl/memory.v", 1, "",
                "Verilated model didn't DC converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

VL_INLINE_OPT void Vmemory::_sequent__TOP__1(Vmemory__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmemory::_sequent__TOP__1\n"); );
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if (vlTOPp->reset) {
        vlTOPp->memory__DOT__i = 0U;
        while (VL_GTS_III(1,32,32, 0x400U, vlTOPp->memory__DOT__i)) {
            vlTOPp->memory__DOT__mem[(0x3ffU & vlTOPp->memory__DOT__i)] = 0U;
            vlTOPp->memory__DOT__i = ((IData)(1U) + vlTOPp->memory__DOT__i);
        }
    }
}

VL_INLINE_OPT void Vmemory::_sequent__TOP__2(Vmemory__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmemory::_sequent__TOP__2\n"); );
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if (vlTOPp->enable) {
        if (vlTOPp->rw) {
            vlTOPp->memory__DOT__mem[(0x3ffU & vlTOPp->ain)] 
                = vlTOPp->din;
        } else {
            vlTOPp->dout = vlTOPp->memory__DOT__mem
                [(0x3ffU & vlTOPp->ain)];
        }
    }
}

void Vmemory::_eval(Vmemory__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmemory::_eval\n"); );
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if (((IData)(vlTOPp->reset) & (~ (IData)(vlTOPp->__Vclklast__TOP__reset)))) {
        vlTOPp->_sequent__TOP__1(vlSymsp);
        vlTOPp->__Vm_traceActivity = (2U | vlTOPp->__Vm_traceActivity);
    }
    if (((IData)(vlTOPp->mclock) & (~ (IData)(vlTOPp->__Vclklast__TOP__mclock)))) {
        vlTOPp->_sequent__TOP__2(vlSymsp);
    }
    // Final
    vlTOPp->__Vclklast__TOP__reset = vlTOPp->reset;
    vlTOPp->__Vclklast__TOP__mclock = vlTOPp->mclock;
}

void Vmemory::_eval_initial(Vmemory__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmemory::_eval_initial\n"); );
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->__Vclklast__TOP__reset = vlTOPp->reset;
    vlTOPp->__Vclklast__TOP__mclock = vlTOPp->mclock;
}

void Vmemory::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmemory::final\n"); );
    // Variables
    Vmemory__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vmemory::_eval_settle(Vmemory__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmemory::_eval_settle\n"); );
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

VL_INLINE_OPT QData Vmemory::_change_request(Vmemory__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmemory::_change_request\n"); );
    Vmemory* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void Vmemory::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmemory::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((mclock & 0xfeU))) {
        Verilated::overWidthError("mclock");}
    if (VL_UNLIKELY((enable & 0xfeU))) {
        Verilated::overWidthError("enable");}
    if (VL_UNLIKELY((reset & 0xfeU))) {
        Verilated::overWidthError("reset");}
    if (VL_UNLIKELY((rw & 0xfeU))) {
        Verilated::overWidthError("rw");}
}
#endif  // VL_DEBUG

void Vmemory::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmemory::_ctor_var_reset\n"); );
    // Body
    mclock = VL_RAND_RESET_I(1);
    enable = VL_RAND_RESET_I(1);
    reset = VL_RAND_RESET_I(1);
    rw = VL_RAND_RESET_I(1);
    ain = VL_RAND_RESET_I(32);
    din = VL_RAND_RESET_I(32);
    dout = VL_RAND_RESET_I(32);
    { int __Vi0=0; for (; __Vi0<1024; ++__Vi0) {
            memory__DOT__mem[__Vi0] = VL_RAND_RESET_I(32);
    }}
    memory__DOT__i = VL_RAND_RESET_I(32);
    __Vm_traceActivity = 0;
}
