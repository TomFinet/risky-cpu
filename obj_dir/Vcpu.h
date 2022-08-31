// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _VCPU_H_
#define _VCPU_H_  // guard

#include "verilated.h"

//==========

class Vcpu__Syms;
class Vcpu_VerilatedVcd;


//----------

VL_MODULE(Vcpu) {
  public:
    
    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    VL_IN8(reset,0,0);
    VL_IN8(clock,0,0);
    VL_IN8(halt,0,0);
    VL_IN(Din,31,0);
    VL_OUT(A,31,0);
    VL_OUT(Dout,31,0);
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    CData/*0:0*/ cpu__DOT__reg_enable;
    CData/*0:0*/ cpu__DOT__reg_rw;
    CData/*4:0*/ cpu__DOT__reg_ain;
    IData/*31:0*/ cpu__DOT__pc;
    IData/*31:0*/ cpu__DOT__addr_reg;
    IData/*31:0*/ cpu__DOT__instr_reg;
    IData/*31:0*/ cpu__DOT__reg_din;
    IData/*31:0*/ cpu__DOT__reg_dout;
    IData/*31:0*/ cpu__DOT__register_bank__DOT__r[32];
    
    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    CData/*0:0*/ __Vclklast__TOP__reset;
    CData/*0:0*/ __Vclklast__TOP__clock;
    IData/*31:0*/ __Vm_traceActivity;
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    Vcpu__Syms* __VlSymsp;  // Symbol table
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vcpu);  ///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// The special name  may be used to make a wrapper with a
    /// single model invisible with respect to DPI scope names.
    Vcpu(const char* name = "TOP");
    /// Destroy the model; called (often implicitly) by application code
    ~Vcpu();
    /// Trace signals in the model; called by application code
    void trace(VerilatedVcdC* tfp, int levels, int options = 0);
    
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval();
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(Vcpu__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(Vcpu__Syms* symsp, bool first);
  private:
    static QData _change_request(Vcpu__Syms* __restrict vlSymsp);
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _eval(Vcpu__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif  // VL_DEBUG
  public:
    static void _eval_initial(Vcpu__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(Vcpu__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _sequent__TOP__1(Vcpu__Syms* __restrict vlSymsp);
    static void _sequent__TOP__2(Vcpu__Syms* __restrict vlSymsp);
    static void traceChgThis(Vcpu__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceChgThis__2(Vcpu__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceChgThis__3(Vcpu__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceChgThis__4(Vcpu__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceFullThis(Vcpu__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) VL_ATTR_COLD;
    static void traceFullThis__1(Vcpu__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) VL_ATTR_COLD;
    static void traceInitThis(Vcpu__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) VL_ATTR_COLD;
    static void traceInitThis__1(Vcpu__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) VL_ATTR_COLD;
    static void traceInit(VerilatedVcd* vcdp, void* userthis, uint32_t code);
    static void traceFull(VerilatedVcd* vcdp, void* userthis, uint32_t code);
    static void traceChg(VerilatedVcd* vcdp, void* userthis, uint32_t code);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
