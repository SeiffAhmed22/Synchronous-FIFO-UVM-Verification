package FIFO_coverage_pkg;
    import uvm_pkg::*;
    import FIFO_seq_item_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_coverage extends uvm_component;
        `uvm_component_utils(FIFO_coverage)

        uvm_analysis_export #(FIFO_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
        FIFO_seq_item seq_item_cov;

        covergroup cg_FIFO;
            cp_wr_en: coverpoint seq_item_cov.wr_en;
            cp_rd_en: coverpoint seq_item_cov.rd_en;
            cp_wr_ack: coverpoint seq_item_cov.wr_ack;
            cp_overflow: coverpoint seq_item_cov.overflow;
            cp_full: coverpoint seq_item_cov.full;
            cp_empty: coverpoint seq_item_cov.empty;
            cp_almostfull: coverpoint seq_item_cov.almostfull;
            cp_almostempty: coverpoint seq_item_cov.almostempty;
            cp_underflow: coverpoint seq_item_cov.underflow;
        
            // Cross coverage
            // Write Ack cross with ignored bins
            cx_wr_ack: cross cp_wr_en, cp_rd_en, cp_wr_ack {
                ignore_bins auto_wr_ack_0 = binsof(cp_wr_en) intersect {0} &&
                                               binsof(cp_rd_en) intersect {1} &&
                                               binsof(cp_wr_ack) intersect {1};
                ignore_bins auto_wr_ack_1 = binsof(cp_wr_en) intersect {0} &&
                                               binsof(cp_rd_en) intersect {0} &&
                                               binsof(cp_wr_ack) intersect {1};
                ignore_bins auto_wr_ack_2 = binsof(cp_wr_en) intersect {1} &&
                                               binsof(cp_rd_en) intersect {1} &&
                                               binsof(cp_wr_ack) intersect {0};
            }
            // Overflow cross with ignored bins
            cx_overflow: cross cp_wr_en, cp_rd_en, cp_overflow {
                ignore_bins auto_overflow_0 = binsof(cp_wr_en) intersect {0} &&
                                               binsof(cp_rd_en) intersect {1} &&
                                               binsof(cp_overflow) intersect {1};
                ignore_bins auto_overflow_1 = binsof(cp_wr_en) intersect {0} &&
                                               binsof(cp_rd_en) intersect {0} &&
                                               binsof(cp_overflow) intersect {1};
                ignore_bins auto_overflow_2 = binsof(cp_wr_en) intersect {1} &&
                                               binsof(cp_rd_en) intersect {1} &&
                                               binsof(cp_overflow) intersect {1};
            }
            // Full cross with ignored bins
            cx_full: cross cp_wr_en, cp_rd_en, cp_full {
                ignore_bins auto_full_0 = binsof(cp_wr_en) intersect {0} &&
                                          binsof(cp_rd_en) intersect {1} &&
                                          binsof(cp_full) intersect {1};
                ignore_bins auto_full_1 = binsof(cp_wr_en) intersect {1} &&
                                          binsof(cp_rd_en) intersect {1} &&
                                          binsof(cp_full) intersect {1};
            }
            // Empty cross coverage
            cx_empty: cross cp_wr_en, cp_rd_en, cp_empty;
        
            // Almost full cross coverage
            cx_almostfull: cross cp_wr_en, cp_rd_en, cp_almostfull;
        
            // Almost empty cross coverage
            cx_almostempty: cross cp_wr_en, cp_rd_en, cp_almostempty;
        
            // Underflow cross with ignored bins
            cx_underflow: cross cp_wr_en, cp_rd_en, cp_underflow {
                ignore_bins auto_underflow_0 = binsof(cp_wr_en) intersect {1} &&
                                               binsof(cp_rd_en) intersect {0} &&
                                               binsof(cp_underflow) intersect {1};
                ignore_bins auto_underflow_1 = binsof(cp_wr_en) intersect {0} &&
                                               binsof(cp_rd_en) intersect {0} &&
                                               binsof(cp_underflow) intersect {1};
            }
        endgroup: cg_FIFO

        function new(string name = "FIFO_coverage", uvm_component parent = null);
            super.new(name, parent);
            cg_FIFO = new();
            cg_FIFO.start();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export", this);
            cov_fifo = new("cov_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            //connect the analysis exports
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                cg_FIFO.sample();
            end
        endtask
    endclass
endpackage