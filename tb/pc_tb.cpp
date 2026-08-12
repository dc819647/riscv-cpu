#include "Vpc.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vpc* dut = new Vpc;

    Verilated::traceEverOn(true);
    VerilatedVcdC* trace = new VerilatedVcdC;
    dut->trace(trace, 5);
    trace->open("wave.vcd");

    dut->reset = 1;
    for (int i = 0; i < 12; i++) {
        dut->clk = 0; dut->eval(); trace->dump(2*i);
        dut->clk = 1; dut->eval(); trace->dump(2*i+1);
        if (i == 1) dut->reset = 0;   // release reset after 2 cycles
    }
    trace->close();
    delete dut;
    return 0;
}
