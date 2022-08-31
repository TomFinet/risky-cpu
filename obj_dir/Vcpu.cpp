// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcpu.h for the primary calling header

#include "Vcpu.h"
#include "Vcpu__Syms.h"

//==========

VL_CTOR_IMP(Vcpu) {
    Vcpu__Syms* __restrict vlSymsp = __VlSymsp = new Vcpu__Syms(this, name());
    Vcpu* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vcpu::__Vconfigure(Vcpu__Syms* vlSymsp, bool first) {
    if (0 && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
}

Vcpu::~Vcpu() {
    delete __VlSymsp; __VlSymsp=NULL;
}

void Vcpu::eval() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vcpu::eval\n"); );
    Vcpu__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    Vcpu* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
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
            VL_FATAL_MT("rtl/cpu.v", 4, "",
                "Verilated model didn't converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vcpu::_eval_initial_loop(Vcpu__Syms* __restrict vlSymsp) {
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
            VL_FATAL_MT("rtl/cpu.v", 4, "",
                "Verilated model didn't DC converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

VL_INLINE_OPT void Vcpu::_sequent__TOP__1(Vcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu::_sequent__TOP__1\n"); );
    Vcpu* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->cpu__DOT__addr_reg = 0U;
    vlTOPp->cpu__DOT__pc = 0U;
    vlTOPp->cpu__DOT__instr_reg = 0U;
}

VL_INLINE_OPT void Vcpu::_sequent__TOP__2(Vcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu::_sequent__TOP__2\n"); );
    Vcpu* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->cpu__DOT__instr_reg = vlTOPp->Din;
    vlTOPp->cpu__DOT__addr_reg = vlTOPp->cpu__DOT__pc;
    vlTOPp->A = vlTOPp->cpu__DOT__addr_reg;
    vlTOPp->cpu__DOT__pc = ((IData)(4U) + vlTOPp->cpu__DOT__pc);
    if (vlTOPp->cpu__DOT__reg_enable) {
        if ((1U & (~ (IData)(vlTOPp->cpu__DOT__reg_rw)))) {
            vlTOPp->cpu__DOT__reg_dout = vlTOPp->cpu__DOT__register_bank__DOT__r
                [vlTOPp->cpu__DOT__reg_ain];
        }
    }
}

void Vcpu::_eval(Vcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu::_eval\n"); );
    Vcpu* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if (((IData)(vlTOPp->reset) & (~ (IData)(vlTOPp->__Vclklast__TOP__reset)))) {
        vlTOPp->_sequent__TOP__1(vlSymsp);
        vlTOPp->__Vm_traceActivity = (2U | vlTOPp->__Vm_traceActivity);
    }
    if (((IData)(vlTOPp->clock) & (~ (IData)(vlTOPp->__Vclklast__TOP__clock)))) {
        vlTOPp->_sequent__TOP__2(vlSymsp);
        vlTOPp->__Vm_traceActivity = (4U | vlTOPp->__Vm_traceActivity);
    }
    // Final
    vlTOPp->__Vclklast__TOP__reset = vlTOPp->reset;
    vlTOPp->__Vclklast__TOP__clock = vlTOPp->clock;
}

void Vcpu::_eval_initial(Vcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu::_eval_initial\n"); );
    Vcpu* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->__Vclklast__TOP__reset = vlTOPp->reset;
    vlTOPp->__Vclklast__TOP__clock = vlTOPp->clock;
}

void Vcpu::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu::final\n"); );
    // Variables
    Vcpu__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vcpu* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vcpu::_eval_settle(Vcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu::_eval_settle\n"); );
    Vcpu* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

VL_INLINE_OPT QData Vcpu::_change_request(Vcpu__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu::_change_request\n"); );
    Vcpu* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void Vcpu::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((reset & 0xfeU))) {
        Verilated::overWidthError("reset");}
    if (VL_UNLIKELY((halt & 0xfeU))) {
        Verilated::overWidthError("halt");}
    if (VL_UNLIKELY((clock & 0xfeU))) {
        Verilated::overWidthError("clock");}
}
#endif  // VL_DEBUG

void Vcpu::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcpu::_ctor_var_reset\n"); );
    // Body
    reset = VL_RAND_RESET_I(1);
    halt = VL_RAND_RESET_I(1);
    clock = VL_RAND_RESET_I(1);
    Din = VL_RAND_RESET_I(32);
    A = VL_RAND_RESET_I(32);
    Dout = VL_RAND_RESET_I(32);
    cpu__DOT__pc = VL_RAND_RESET_I(32);
    cpu__DOT__addr_reg = VL_RAND_RESET_I(32);
    cpu__DOT__instr_reg = VL_RAND_RESET_I(32);
    cpu__DOT__reg_enable = VL_RAND_RESET_I(1);
    cpu__DOT__reg_rw = VL_RAND_RESET_I(1);
    cpu__DOT__reg_din = VL_RAND_RESET_I(32);
    cpu__DOT__reg_ain = VL_RAND_RESET_I(5);
    cpu__DOT__reg_dout = VL_RAND_RESET_I(32);
    { int __Vi0=0; for (; __Vi0<32; ++__Vi0) {
            cpu__DOT__register_bank__DOT__r[__Vi0] = VL_RAND_RESET_I(32);
    }}
    __Vm_traceActivity = 0;
}
