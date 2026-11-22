#include "Valu_decoder.h"
#include "verilated.h"
#include <cstdio>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Valu_decoder* dut = new Valu_decoder;

    struct T { const char* name; int alu_type, funct3, funct7_5, expect; };
    T t[] = {
        {"lw/sw/addi (add)",        0, 0b111, 1, 0},  // funct fields must be ignored
        {"beq (sub)",               1, 0b111, 0, 1},  // funct fields must be ignored
        {"R: add",                  2, 0b000, 0, 0},
        {"R: sub",                  2, 0b000, 1, 1},
        {"R: and",                  2, 0b111, 0, 2},
        {"R: or",                   2, 0b110, 0, 3},
        {"R: unlisted funct3 (xor)",2, 0b100, 0, 0},  // inner default
        {"alu_type 11 (unused)",    3, 0b000, 0, 0},  // outer default
    };

    int fails = 0;
    for (auto& e : t) {
        dut->alu_type = e.alu_type;
        dut->funct3   = e.funct3;
        dut->funct7_5 = e.funct7_5;
        dut->eval();
        bool ok = dut->alu_op == e.expect;
        printf("%-26s alu_op=%d expect %d  %s\n", e.name, dut->alu_op, e.expect,
               ok ? "PASS" : "FAIL");
        if (!ok) fails++;
    }
    printf("%s\n", fails ? "SOME TESTS FAILED" : "ALL PASS");
    delete dut;
    return 0;
}