package FIFO_sequence_pkg;
    import uvm_pkg::*;
    import FIFO_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_reset_sequence extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_reset_sequence)

        FIFO_seq_item seq_item;
    
        function new(string name = "FIFO_reset_sequence");
            super.new(name);
        endfunction: new

        task body();
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n = 0;
            seq_item.data_in = 0;
            seq_item.wr_en = 0;
            seq_item.rd_en = 0;
            finish_item(seq_item);
        endtask
    endclass: FIFO_reset_sequence

    class FIFO_write_only_sequence extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_write_only_sequence)

        FIFO_seq_item seq_item;

        int read_dist = 0 ; // No read
        int write_dist = 100 ; // Write only 
    
        function new(string name = "FIFO_write_only_sequence");
            super.new(name);
        endfunction: new

        task body();
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            repeat(100) begin
                seq_item.RD_EN_ON_DIST = read_dist;
                seq_item.WR_EN_ON_DIST = write_dist;
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);  
            end
        endtask
    endclass: FIFO_write_only_sequence

    class FIFO_read_only_sequence extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_read_only_sequence)

        FIFO_seq_item seq_item;

        int read_dist = 100 ; // No read
        int write_dist = 0 ; // Write only 
    
        function new(string name = "FIFO_read_only_sequence");
            super.new(name);
        endfunction: new

        task body();
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            repeat(100) begin
                seq_item.RD_EN_ON_DIST = read_dist;
                seq_item.WR_EN_ON_DIST = write_dist;
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);  
            end
        endtask
    endclass: FIFO_read_only_sequence

    class FIFO_write_read_sequence extends uvm_sequence #(FIFO_seq_item);
        `uvm_object_utils(FIFO_write_read_sequence)

        FIFO_seq_item seq_item;

        function new(string name = "FIFO_write_read_sequence");
            super.new(name);
        endfunction: new

        task body();
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            repeat (9999) begin
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask
    endclass: FIFO_write_read_sequence
endpackage