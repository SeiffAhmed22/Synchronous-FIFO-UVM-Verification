package FIFO_driver_pkg;
    import uvm_pkg::*;
    import FIFO_config_obj_pkg::*;
    import FIFO_seq_item_pkg::*;
    `include "uvm_macros.svh"
    class FIFO_driver extends uvm_driver #(FIFO_seq_item);
        `uvm_component_utils(FIFO_driver)

        virtual FIFO_if FIFO_driver_vif;
        FIFO_config_obj FIFO_cfg_driver;
        FIFO_seq_item stim_seq_item;

        function new(string name = "FIFO_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        // Build phase to retrieve virtual interface
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            // Retrieve the virtual interface from uvm_config_db
            if(!uvm_config_db #(FIFO_config_obj)::get(this, "", "CFG", FIFO_cfg_driver)) begin
                `uvm_fatal("build_phase", "Driver - Unable to get the virtual interface of the FIFO from uvm_config_db");
            end
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stim_seq_item = FIFO_seq_item::type_id::create("stim_seq_item");
                seq_item_port.get_next_item(stim_seq_item);
                FIFO_driver_vif.rst_n = stim_seq_item.rst_n;
                FIFO_driver_vif.data_in = stim_seq_item.data_in;
                FIFO_driver_vif.wr_en = stim_seq_item.wr_en;
                FIFO_driver_vif.rd_en = stim_seq_item.rd_en;
                @(negedge FIFO_driver_vif.clk);
                seq_item_port.item_done();
                `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH)
            end
        endtask
    endclass
endpackage