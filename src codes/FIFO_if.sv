interface FIFO_if (input bit clk);
  parameter FIFO_WIDTH = 16;
  parameter FIFO_DEPTH = 8;

  // Input Signals
  logic [FIFO_WIDTH-1:0] data_in;
  logic rst_n, wr_en, rd_en;

  // Output signals
  logic [FIFO_WIDTH-1:0] data_out;
  logic wr_ack, overflow;
  logic full, empty, almostfull, almostempty, underflow;

  modport DUT(
      input clk, data_in, rst_n, wr_en, rd_en,
      output data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow
  );
endinterface