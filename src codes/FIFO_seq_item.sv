package FIFO_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    parameter FIFO_WIDTH = 16;
    class FIFO_seq_item extends uvm_sequence_item;
        `uvm_object_utils(FIFO_seq_item)
    
        // Group: Variables
        rand bit [FIFO_WIDTH-1:0] data_in;
        rand bit rst_n, wr_en, rd_en;
        bit [FIFO_WIDTH-1:0] data_out;
        bit wr_ack, overflow;
        bit full, empty, almostfull, almostempty, underflow;

        int RD_EN_ON_DIST;
        int WR_EN_ON_DIST;

        // Constructor: new
        function new(string name = "FIFO_seq_item", int RD_EN_ON_DIST = 30, int WR_EN_ON_DIST = 70);
            super.new(name);
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
        endfunction: new
        
        // Group: Functions
        function string convert2string();
          string s;
          s = super.convert2string();
          return $sformatf("%s data_in = 0b%0b, rst_n = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b, data_out = 0b%0b, wr_ack = 0b%0b, overflow = 0b%0b, full = 0b%0b, empty = 0b%0b, almostfull = 0b%0b, almostempty = 0b%0b, underflow = 0b%0b", 
              s, data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
        endfunction: convert2string
      
        
        function string convert2string_stimulus();
          return $sformatf("data_in = 0b%0b, rst_n = 0b%0b, wr_en = 0b%0b, rd_en = 0b%0b, data_out = 0b%0b, wr_ack = 0b%0b, overflow = 0b%0b, full = 0b%0b, empty = 0b%0b, almostfull = 0b%0b, almostempty = 0b%0b, underflow = 0b%0b", 
              data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
        endfunction: convert2string_stimulus      

        // Group: Constraints
        // General reset constraint
        constraint reset_con {
            rst_n dist {
              0 :/ 10,
              1 :/ 90
            };
          }
      
          constraint wr_en_con {
            wr_en dist {
              1 :/ WR_EN_ON_DIST,
              0 :/ (100 - WR_EN_ON_DIST)
            };
          }
      
          constraint rd_en_con {
            rd_en dist {
              1 :/ RD_EN_ON_DIST,
              0 :/ (100 - RD_EN_ON_DIST)
            };
          }
    endclass: FIFO_seq_item
endpackage