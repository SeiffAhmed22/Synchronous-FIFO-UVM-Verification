import uvm_pkg::*;
import FIFO_test_pkg::*;
`include "uvm_macros.svh"

module FIFO_top();
    bit clk;
    always #5 clk = ~clk;
    FIFO_if FIFOif (clk);
    FIFO dut (FIFOif);
    bind FIFO FIFO_SVA assert_inst (FIFOif);

    initial begin
        uvm_config_db #(virtual FIFO_if)::set(null, "uvm_test_top", "FIFO_IF", FIFOif);
        run_test("FIFO_test");
    end
endmodule