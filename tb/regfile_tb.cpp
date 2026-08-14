#include "Vregfile.h"
#include "verilated.h"
#include <cstdio>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vregfile* dut = new Vregfile;

    // helper to pulse one clock cycle
    auto tick = [&]() {
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
    };

    // Write 42 into register 5
    dut->write_reg = 5;
    dut->write_data = 42;
    dut->write_enable = 1;
    tick();                       // write happens on this rising edge

    // Write 100 into register 10
    dut->write_reg = 10;
    dut->write_data = 100;
    tick();

    dut->write_enable = 0;        // stop writing

    // Now read reg 5 on port 1, reg 10 on port 2
    dut->read_reg1 = 5;
    dut->read_reg2 = 10;
    dut->eval();
    printf("reg5  = %d  (expect 42)\n", dut->read_data1);
    printf("reg10 = %d  (expect 100)\n", dut->read_data2);

    // Test the x0 rule: read register 0
    dut->read_reg1 = 0;
    dut->eval();
    printf("reg0  = %d  (expect 0)\n", dut->read_data1);

    delete dut;
    return 0;
}