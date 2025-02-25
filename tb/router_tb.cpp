#include "Vrouter_regs.h"
#include "verilated.h"

int main(int argc, char** argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);

    // Create an instance of our module under test
    Vrouter_regs* tb = new Vrouter_regs;

    // Initialize all inputs
    tb->clk = 0;
    tb->rst = 0;

    // Run some cycles
    for (int i = 0; i < 10000000; i++) {
        tb->clk = !tb->clk;
        tb->eval();
    }

    printf("done!!!!!!!!!!!!!\n");
    // Clean up
    delete tb;
    return 0;
}
