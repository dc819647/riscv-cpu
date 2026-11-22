#include "Valu.h"
#include "verilated.h"
#include <cstdio>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Valu* dut = new Valu;

    const char* names[4] = {"add", "sub", "and", "or"};

    // Test all four ops with A=10, B=3
    dut->input_1 = 10;
    dut->input_2 = 3;
    for (int op = 0; op < 4; op++) {
        dut->alu_op = op;
        dut->eval();
        printf("10 %-3s 3  -> result = %2u, zero = %d\n",
               names[op], dut->result, dut->zero);
    }

    // Zero flag test: 5 - 5 should be 0
    dut->input_1 = 5;
    dut->input_2 = 5;
    dut->alu_op = 1;   // sub
    dut->eval();
    printf("5 sub 5    -> result = %2u, zero = %d\n", dut->result, dut->zero);

    // Negative result: 3 - 10 (two's complement)
    dut->input_1 = 3;
    dut->input_2 = 10;
    dut->alu_op = 1;   // sub
    dut->eval();
    printf("3 sub 10   -> result = %d (signed), 0x%08X (hex)\n",
           (int)dut->result, dut->result);

    delete dut;
    return 0;
}