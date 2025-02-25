#include <systemc.h>
#include "Vrouter_regs.h"
#include "verilated.h"

SC_MODULE(Testbench) {

  // Internal signals
  sc_clock clk_sig;
  sc_signal<bool> rst_sig;
  sc_signal<bool> psel_sig;
  sc_signal<bool> penable_sig;
  sc_signal<bool> pwrite_sig;
  sc_signal<uint32_t> paddr_sig;
  sc_signal<bool> pready_sig;
  sc_signal<bool> pslverr_sig;
  sc_signal<uint32_t> pwdata_sig;
  sc_signal<uint32_t> prdata_sig;
  sc_signal<uint32_t> hwif_in_sig;
  sc_signal<vluint64_t> hwif_out_sig;

  Vrouter_regs* dut;
  
  SC_CTOR(Testbench) : clk_sig("clk_sig", 10, SC_NS) {
    // Instantiate DUT
    dut = new Vrouter_regs("dut");
    
    // Connect DUT ports to internal signals
    dut->clk(clk_sig);
    dut->rst(rst_sig);
    dut->s_apb_psel(psel_sig);
    dut->s_apb_penable(penable_sig);
    dut->s_apb_pwrite(pwrite_sig);
    dut->s_apb_paddr(paddr_sig);
    dut->s_apb_pready(pready_sig);
    dut->s_apb_pslverr(pslverr_sig);
    dut->s_apb_pwdata(pwdata_sig);
    dut->s_apb_prdata(prdata_sig);
    dut->hwif_in(hwif_in_sig);
    dut->hwif_out(hwif_out_sig);

    // Connect module ports to internal signals 
/*     clk(clk_sig);
    rst(rst_sig);
    s_apb_psel(psel_sig);
    s_apb_penable(penable_sig);
    s_apb_pwrite(pwrite_sig);
    s_apb_paddr(paddr_sig);
    s_apb_pready(pready_sig);
    s_apb_pslverr(pslverr_sig);
    s_apb_pwdata(pwdata_sig);
    s_apb_prdata(prdata_sig);
    hwif_in(hwif_in_sig);
    hwif_out(hwif_out_sig); */
    
    // Main test process
    SC_THREAD(test);
    sensitive << clk_sig.posedge_event();
  }

  void apb3_write(uint32_t addr, uint32_t data) {
    // Setup phase
    psel_sig = 1;
    pwrite_sig = 1;
    paddr_sig = addr;
    pwdata_sig = data;
    penable_sig = 0;
    wait();
    
    // Access phase
    penable_sig = 1;
    wait();
    while (!pready_sig) wait();
    
    // Back to idle
    psel_sig = 0;
    penable_sig = 0;
    wait();
  }

  void apb3_read(uint32_t addr) {
    // Setup phase
    psel_sig = 1;
    pwrite_sig = 0;
    paddr_sig = addr;
    penable_sig = 0;
    wait();
    
    // Access phase
    penable_sig = 1;
    wait();
    while (!pready_sig) wait();
    
    // Back to idle
    psel_sig = 0;
    penable_sig = 0;
    wait();
  }

  void test() {
    // Initialize signals
    psel_sig = 0;
    penable_sig = 0;
    pwrite_sig = 0;
    paddr_sig = 0;
    pwdata_sig = 0;
    hwif_in_sig = 0;
    
    // Reset
    rst_sig = 1;
    wait(10);
    rst_sig = 0;
    wait();
    
    // Test some register accesses
    apb3_write(0x0, 0x12345678);  // Write to first register
    apb3_read(0x0);               // Read it back
    
    wait(10);
    std::cout << "End of Simulation!" << std::endl;
    sc_stop();
  }

  ~Testbench() {
    delete dut;
  }
};

int sc_main(int argc, char** argv) {
  // Init Verilator
  Verilated::commandArgs(argc, argv);
  
  // Create testbench
  Testbench* tb = new Testbench("tb");
  
  // Start simulation
  sc_start();
  
  delete tb;
  return 0;
}
