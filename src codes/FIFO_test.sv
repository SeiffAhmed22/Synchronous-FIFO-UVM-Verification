package FIFO_test_pkg;
    import uvm_pkg::*;
    import FIFO_env_pkg::*;
    import FIFO_config_obj_pkg::*;
    import FIFO_sequence_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_test extends uvm_test;
        `uvm_component_utils(FIFO_test)

        FIFO_env env;
        FIFO_config_obj FIFO_config_obj_test;
        FIFO_reset_sequence reset_seq;
        FIFO_write_only_sequence wr_seq;
        FIFO_read_only_sequence rd_seq;
        FIFO_write_read_sequence wr_rd_seq;


        function new(string name = "FIFO_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = FIFO_env::type_id::create("env", this);
            FIFO_config_obj_test = FIFO_config_obj::type_id::create("FIFO_config_obj_test");
            reset_seq = FIFO_reset_sequence::type_id::create("reset_seq");
            wr_seq = FIFO_write_only_sequence::type_id::create("wr_seq");
            rd_seq = FIFO_read_only_sequence::type_id::create("rd_seq");
            wr_rd_seq = FIFO_write_read_sequence::type_id::create("wr_rd_seq");
            
            // Retrieve the virtual interface from the uvm_config_db
            if(!uvm_config_db#(virtual FIFO_if)::get(this, "", "FIFO_IF", FIFO_config_obj_test.FIFO_config_vif))
                `uvm_fatal("build_phase", "Test - Unable to get the virtual interface of the FIFO from the uvm_config_db");

            // Set the virtual interface for all components under this test class
            uvm_config_db#(FIFO_config_obj)::set(this, "*", "CFG", FIFO_config_obj_test);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            // FIFO_1
            //reset sequence
            `uvm_info("run_phase", "Reset Asserted", UVM_LOW)
            reset_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "Reset Deasserted", UVM_LOW)

            // FIFO_2
            // writing only sequence 
            `uvm_info ("run_phase" , "Writing only Started ",UVM_LOW)
            wr_seq.start(env.agt.sqr);
            `uvm_info ("run_phase" , "Writing only Ended ",UVM_LOW)
            
            // FIFO_3
            // Reading only sequence 
            `uvm_info ("run_phase" , "Reading only Started ",UVM_LOW)
            rd_seq.start(env.agt.sqr);
            `uvm_info ("run_phase" , "Reading only Ended ",UVM_LOW)

            // FIFO_4
            //main sequence
            `uvm_info("run_phase", "Write & Read Started", UVM_LOW)
            wr_rd_seq.start(env.agt.sqr);
            `uvm_info("run_phase", "Write & Read Ended", UVM_LOW)

            phase.drop_objection(this);
        endtask
    endclass
endpackage