#include "Vmain_decoder.h"
#include "verilated.h"
#include <cstdio>

struct Expect {
    const char* name; unsigned opcode;
    int reg_write, imm_src, alu_src, mem_write, result_src, branch, alu_type;
};

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vmain_decoder* dut = new Vmain_decoder;

    //           name       opcode  rw  imm asrc mw  rs  br  atype
    Expect t[] = {
        {"R-type",  0b0110011,  1,  0,  0,  0,  0,  0,  2},
        {"addi",    0b0010011,  1,  0,  1,  0,  0,  0,  0},
        {"lw",      0b0000011,  1,  0,  1,  0,  1,  0,  0},
        {"sw",      0b0100011,  0,  1,  1,  1,  0,  0,  0},
        {"beq",     0b1100011,  0,  2,  0,  0,  0,  1,  1},
        {"garbage", 0b1111111,  0,  0,  0,  0,  0,  0,  0},  // unknown -> must be safe
    };

    int fails = 0;
    for (auto& e : t) {
        dut->opcode = e.opcode;
        dut->eval();
        bool ok = dut->reg_write == e.reg_write && dut->imm_src == e.imm_src &&
                  dut->alu_src == e.alu_src && dut->mem_write == e.mem_write &&
                  dut->result_src == e.result_src && dut->branch == e.branch &&
                  dut->alu_type == e.alu_type;
        printf("%-8s rw=%d imm=%d asrc=%d mw=%d rs=%d br=%d atype=%d  %s\n",
               e.name, dut->reg_write, dut->imm_src, dut->alu_src, dut->mem_write,
               dut->result_src, dut->branch, dut->alu_type, ok ? "PASS" : "FAIL");
        if (!ok) fails++;
    }
    printf("%s\n", fails ? "SOME TESTS FAILED" : "ALL PASS");
    delete dut;
    return 0;
}