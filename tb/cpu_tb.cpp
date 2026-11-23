#include "Vcpu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vcpu* dut = new Vcpu;

    Verilated::traceEverOn(true);
    VerilatedVcdC* trace = new VerilatedVcdC;
    dut->trace(trace, 5);
    trace->open("cpu.vcd");

    int t = 0;
    dut->reset = 1;
    for (int cycle = 0; cycle < 8; cycle++) {
        dut->clk = 0; dut->eval(); trace->dump(t++);
        dut->clk = 1; dut->eval(); trace->dump(t++);
        if (cycle == 1) dut->reset = 0;   // hold reset for 2 cycles, then run
    }

    trace->close();
    delete dut;
    return 0;
}