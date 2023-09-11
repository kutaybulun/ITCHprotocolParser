class tb_monitor extends uvm_monitor;

`uvm_component_utils(tb_monitor)
virtual tb_interface vif;
tb_sequence_item item;
uvm_analysis_port #(tb_sequence_item) monitor_port;
//--------------------------------------------------------
//Constructor
//--------------------------------------------------------
function new(string name = "tb_monitor", uvm_component parent);
    super.new(name, parent);
    `uvm_info("MONITOR_CLASS", "Inside Constructor!", UVM_HIGH)
endfunction: new

//--------------------------------------------------------
//Build Phase
//--------------------------------------------------------
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MONITOR_CLASS", "Build Phase!", UVM_HIGH)
    monitor_port = new("monitor_port", this);
    if(!(uvm_config_db #(virtual tb_interface)::get(this, "*", "vif", vif))) begin
      `uvm_error("DRIVER_CLASS", "Failed to get VIF from config DB!")
    end
endfunction: build_phase

//--------------------------------------------------------
//Connect Phase
//--------------------------------------------------------
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MONITOR_CLASS", "Connect Phase!", UVM_HIGH)
endfunction: connect_phase

//--------------------------------------------------------
//Run Phase
//--------------------------------------------------------
task run_phase (uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("MONITOR_CLASS", "Run Phase!", UVM_HIGH)
    //LOGIC
    forever begin
        item = tb_sequence_item::type_id::create("item");
        wait(!vif.reset);
        //sample inputs
        @(posedge vif.clk);
            item.rx_data_net = vif.rx_data_net;
        //sample outputs
        //send item to scoreboard
        monitor_port.write(item);
    end
endtask: run_phase

endclass //tb_monitor extends uvm_test