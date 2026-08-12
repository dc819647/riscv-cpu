#include "Vimem.h"
#include "verilated.h"
#include <cstdio>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vimem* dut = new Vimem;

    // fetch from addresses 0, 4, 8 and print what comes out
    for (int addr = 0; addr <= 8; addr += 4) {
        dut->address_from_pc = addr;
        dut->eval();
        printf("address %2d -> instruction 0x%08X\n", addr, dut->instructions);
    }
    delete dut;
    return 0;
}
