module FIFO_SVA (
    FIFO_if.DUT FIFOif
);
    property write_count;
        @(posedge FIFOif.clk) disable iff(!FIFOif.rst_n) 
        (!FIFOif.rd_en && FIFOif.wr_en && dut.count != FIFOif.FIFO_DEPTH) |=> ($past(dut.count) + 1'b1 == dut.count);
    endproperty
    property read_count;
        @(posedge FIFOif.clk) disable iff(!FIFOif.rst_n) 
        (FIFOif.rd_en && !FIFOif.wr_en && dut.count != 0) |=> ($past(dut.count) - 1'b1 == dut.count);
    endproperty
    property read_write_count;
        @(posedge FIFOif.clk) disable iff(!FIFOif.rst_n) 
        (FIFOif.rd_en && FIFOif.wr_en && dut.count != 0 && dut.count != FIFOif.FIFO_DEPTH) |=> ($past(dut.count) == dut.count);
    endproperty
    property read_write_count_empty;
        @(posedge FIFOif.clk) disable iff(!FIFOif.rst_n) 
        (FIFOif.rd_en && FIFOif.wr_en && FIFOif.empty) |=> ($past(dut.count) + 1'b1 == dut.count);
    endproperty
    property read_write_count_full;
        @(posedge FIFOif.clk) disable iff(!FIFOif.rst_n) 
        (FIFOif.rd_en && FIFOif.wr_en && FIFOif.full) |=> ($past(dut.count) - 1'b1 == dut.count);
    endproperty
    property write_ptr;
        @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n) 
        (FIFOif.wr_en && dut.count != FIFOif.FIFO_DEPTH) |=> ($past(dut.wr_ptr) + 1'b1 == dut.wr_ptr);
    endproperty
    property read_ptr;
        @(posedge FIFOif.clk) disable iff (!FIFOif.rst_n)
        (FIFOif.rd_en && dut.count != 0) |=> ($past(dut.rd_ptr) + 1'b1 == dut.rd_ptr);
    endproperty
    // Assertions
    wr_count_assert: assert property (write_count)
        else $error("Assertion failed: dut.count did not increment when write correctly at time %0t, dut.count = %0d, expected = %0d", 
                        $time, dut.count, $past(dut.count) + 1'b1);
    rd_count_assert: assert property (read_count)
        else $error("Assertion failed: dut.count did not decrement when read correctly at time %0t, dut.count = %0d, expected = %0d", 
                        $time, dut.count, $past(dut.count) - 1'b1);
    rd_wr_count_assert: assert property (read_write_count)
        else $error("Assertion failed: dut.count should remain the same when read and write, and not empty or full at time %0t, dut.count = %0d, expected = %0d", 
                        $time, dut.count, $past(dut.count));
    rd_wr_count_empty_assert:assert property (read_write_count_empty)
        else $error("Assertion failed: dut.count did not increment when write, read and empty correctly at time %0t, dut.count = %0d, expected = %0d", 
                        $time, dut.count, $past(dut.count) + 1'b1);
    rd_wr_count_full_assert:assert property (read_write_count_full)
        else $error("Assertion failed: dut.count did not increment when write, read and full correctly at time %0t, dut.count = %0d, expected = %0d", 
                        $time, dut.count, $past(dut.count) - 1'b1);
    wr_ptr_assert: assert property (write_ptr)
        else $error("Assertion failed: dut.wr_ptr did not increment correctly at time %0t, dut.wr_ptr = %0d, expected = %0d", 
                        $time, dut.wr_ptr, $past(dut.wr_ptr) + 1'b1);
    rd_ptr_assert: assert property (read_ptr)
        else $error("Assertion failed: dut.rd_ptr did not increment correctly at time %0t, dut.rd_ptr = %0d, expected = %0d", 
                        $time, dut.rd_ptr, $past(dut.rd_ptr) + 1'b1);

    // Cover Assertions
    wr_count_cover: cover property (write_count);
    rd_count_cover: cover property (read_count);
    rd_wr_count_cover: cover property (read_write_count);
    rd_wr_count_empty_cover:cover property (read_write_count_empty);
    rd_wr_count_full_cover:cover property (read_write_count_full);
    wr_ptr_cover: cover property (write_ptr);
    rd_ptr_cover: cover property (read_ptr);

    always_comb begin
        if(!FIFOif.rst_n)begin
            rst_count_assert: assert final (dut.count==0);
            rst_count_cover: cover final (dut.count==0);

            rst_wr_ptr_assert: assert final (dut.wr_ptr==0);
            rst_wr_ptr_cover: cover final (dut.wr_ptr==0);

            rst_rd_ptr_assert: assert final (dut.rd_ptr==0);
            rst_rd_ptr_cover: cover final (dut.rd_ptr==0);
        end
        if(dut.count == FIFOif.FIFO_DEPTH) begin
            full_assert: assert final (FIFOif.full);
            full_cover: cover final (FIFOif.full);
        end
        if(dut.count == 0) begin
            empty_assert: assert final (FIFOif.empty);
            empty_cover: cover final (FIFOif.empty);
        end
        if(dut.count == 0 && FIFOif.rd_en) begin
            underflow_assert: assert final (FIFOif.underflow);
            underflow_cover: cover final (FIFOif.underflow);
        end
        if(dut.count == FIFOif.FIFO_DEPTH && FIFOif.wr_en) begin
            overflow_assert: assert final (FIFOif.overflow);
            overflow_cover: cover final (FIFOif.overflow);
        end
        if(dut.count == FIFOif.FIFO_DEPTH - 1) begin
            almostfull_assert: assert final (FIFOif.almostfull);
            almostfull_cover: cover final (FIFOif.almostfull);
        end
        if(dut.count == 1) begin
            almostempty_assert: assert final (FIFOif.almostempty);
            almostempty_cover: cover final (FIFOif.almostempty);
        end
        if((dut.count != FIFOif.FIFO_DEPTH) && FIFOif.wr_en) begin
            wr_ack_assert: assert final (FIFOif.wr_ack);
            wr_ack_cover: cover final (FIFOif.wr_ack);
        end
    end
endmodule