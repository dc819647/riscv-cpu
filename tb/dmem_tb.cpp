#include "Vdmem.h"
#include "verilated.h"
#include <cstdio>

Vdmem* dut;

void tick() {
    dut->clk = 0; dut->eval();
    dut->clk = 1; dut->eval();
}

void check(const char* label, unsigned addr, unsigned expected) {
    dut->address = addr;
    dut->eval();
    printf("%-34s addr %2u -> %4u  expect %4u  %s\n", label, addr,
           dut->read_data, expected,
           dut->read_data == expected ? "PASS" : "FAIL");
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    dut = new Vdmem;

    // sw: store 42 at address 0
    dut->mem_write = 1; dut->address = 0; dut->write_data = 42;  tick();
    // sw: store 100 at address 8
    dut->address = 8;  dut->write_data = 100; tick();

    // stop writing, then lw both back
    dut->mem_write = 0;
    check("lw from addr 0", 0, 42);
    check("lw from addr 8", 8, 100);

    // mem_write OFF: try to overwrite addr 0 with 999 -> must NOT change
    dut->address = 0; dut->write_data = 999; tick();
    check("write blocked when mem_write=0", 0, 42);

    // addr 4 is a separate word from 0 and 8 -> still untouched (0 or x)
    dut->mem_write = 1; dut->address = 4; dut->write_data = 7; tick();
    dut->mem_write = 0;
    check("addr 4 independent of 0 and 8", 4, 7);
    check("addr 0 unchanged after addr 4 write", 0, 42);

    delete dut;
    return 0;
}