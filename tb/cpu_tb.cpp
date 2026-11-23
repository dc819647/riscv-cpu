#include "Vcpu.h"
#include "Vcpu___024root.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <cstdio>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vcpu* dut = new Vcpu;

    Verilated::traceEverOn(true);
    VerilatedVcdC* trace = new VerilatedVcdC;
    dut->trace(trace, 5);
    trace->open("cpu.vcd");

    int t = 0;
    dut->reset = 1;
    for (int cycle = 0; cycle < 20; cycle++) {
        dut->clk = 0; dut->eval(); trace->dump(t++);
        dut->clk = 1; dut->eval(); trace->dump(t++);
        if (cycle == 1) dut->reset = 0;
    }

    // Expected final register values
    unsigned expect[10] = {0, 5, 10, 15, 5, 0, 15, 15, 0, 7};
    const char* why[10] = {
        "x0 always 0", "addi", "addi", "add", "sub", "and", "or",
        "lw (loaded from mem)", "skipped by beq", "landed after beq"
    };
    int fails = 0;
    for (int r = 1; r <= 9; r++) {
        unsigned got = dut->rootp->cpu__DOT__u_regfile__DOT__registers[r];
        bool ok = got == expect[r];
        printf("x%d = %3u  expect %3u  %-22s %s\n", r, got, expect[r], why[r], ok ? "PASS" : "FAIL");
        if (!ok) fails++;
    }
    unsigned m0 = dut->rootp->cpu__DOT__u_dmem__DOT__memory[0];
    printf("mem[0] = %u  expect 15  %-17s %s\n", m0, "sw stored x3", m0 == 15 ? "PASS" : "FAIL");
    if (m0 != 15) fails++;
    printf("%s\n", fails ? "SOME TESTS FAILED" : "ALL PASS — the CPU runs the program correctly");

    trace->close();
    delete dut;
    return 0;
}