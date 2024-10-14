////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT FIFOif);
localparam max_fifo_addr = $clog2(FIFOif.FIFO_DEPTH);
reg [FIFOif.FIFO_WIDTH-1:0] mem [FIFOif.FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;
always @(posedge FIFOif.clk or negedge FIFOif.rst_n) begin
	if (!FIFOif.rst_n) begin
		wr_ptr <= 0;
	end
	else if (FIFOif.wr_en && count < FIFOif.FIFO_DEPTH) begin
		mem[wr_ptr] <= FIFOif.data_in;
		// FIFOif.wr_ack <= 1; // BUG HERE
		wr_ptr <= wr_ptr + 1;
	end
	// BUG HERE
	// else begin 
	// 	FIFOif.wr_ack <= 0;
	// 	if (FIFOif.full & FIFOif.wr_en)
	// 		FIFOif.overflow <= 1;
	// 	else
	// 		FIFOif.overflow <= 0;
	// end
end
always @(posedge FIFOif.clk or negedge FIFOif.rst_n) begin
	if (!FIFOif.rst_n) begin
		rd_ptr <= 0;
	end
	else if (FIFOif.rd_en && count != 0) begin
		FIFOif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
end
always @(posedge FIFOif.clk or negedge FIFOif.rst_n) begin
	if (!FIFOif.rst_n) begin
		count <= 0;
	end
	else begin
		if	((({FIFOif.wr_en, FIFOif.rd_en} == 2'b10) && !FIFOif.full) || 
		(({FIFOif.wr_en, FIFOif.rd_en} == 2'b11) && FIFOif.empty)) // Added the part for the note
			count <= count + 1;
		else if ((({FIFOif.wr_en, FIFOif.rd_en} == 2'b01) && !FIFOif.empty) || 
		(({FIFOif.wr_en, FIFOif.rd_en} == 2'b11) && FIFOif.full)) // Added the part for the note
			count <= count - 1;
	end
end
assign FIFOif.full = (count == FIFOif.FIFO_DEPTH)? 1 : 0;
assign FIFOif.empty = (count == 0)? 1 : 0;
assign FIFOif.underflow = (FIFOif.empty && FIFOif.rd_en)? 1 : 0; 
// assign FIFOif.almostfull = (count == FIFOif.FIFO_DEPTH-2)? 1 : 0; // BUG HERE
assign FIFOif.almostempty = (count == 1)? 1 : 0;
// Fixed bugs
assign FIFOif.wr_ack = ((count != FIFOif.FIFO_DEPTH) && FIFOif.wr_en)? 1 : 0;
assign FIFOif.almostfull = (count == FIFOif.FIFO_DEPTH - 1)? 1 : 0;
assign FIFOif.overflow = (FIFOif.full && FIFOif.wr_en)? 1 : 0;
endmodule