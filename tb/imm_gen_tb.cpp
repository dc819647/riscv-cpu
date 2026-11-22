#include "Vimm_gen.h"
#include "verilated.h"
#include <cstdio>

Vimm_gen* dut;

void test(const char* asm_str, unsigned instr, int src, int expected) {
    dut->instructions = instr;
    dut->imm_src = src;
    dut->eval();
    int got = (int)dut->imm_ext;
    printf("%-20s 0x%08X -> imm = %4d (0x%08X)  expect %4d  %s\n",
           asm_str, instr, got, dut->imm_ext, expected,
           got == expected ? "PASS" : "FAIL");
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    dut = new Vimm_gen;

    // I-type (imm_src = 0)
    test("addi x1, x0, 5",   0x00500093, 0,  5);
    test("addi x1, x1, -1",  0xFFF08093, 0, -1);

    // S-type (imm_src = 1)
    test("sw x2, 8(x1)",     0x0020A423, 1,  8);
    test("sw x2, -4(x1)",    0xFE20AE23, 1, -4);

    // B-type (imm_src = 2)
    test("beq x1, x2, 16",   0x00208863, 2, 16);
    test("beq x1, x2, -8",   0xFE208CE3, 2, -8);

    delete dut;
    return 0;
}