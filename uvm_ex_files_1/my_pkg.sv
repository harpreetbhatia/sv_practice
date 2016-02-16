
`include "uvm_macros.svh"

package my_pkg;

  import uvm_pkg::*;
  import my_sequences::*;


  typedef uvm_sequencer #(my_transaction) my_sequencer;

  class my_dut_config extends uvm_object;
     `uvm_object_utils(my_dut_config)

     virtual dut_if dut_vi;
     // optionally add other config fields as needed
     
  endclass // my_dut_config
   
   
  class my_driver extends uvm_driver #(my_transaction);
  
    `uvm_component_utils(my_driver)

     my_dut_config dut_config_0;
     virtual dut_if dut_vi;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new
    
    function void build_phase(uvm_phase phase);
       assert( uvm_config_db #(my_dut_config)::get(this, "", "dut_config", 
						   dut_config_0) );
       dut_vi = dut_config_0.dut_vi;
       // other config settings from dut_config_0 object as needed
    endfunction : build_phase
   
    task run_phase(uvm_phase phase);
      forever
      begin
        my_transaction tx;
        
        @(posedge dut_vi.clock);
        seq_item_port.get(tx);
        
        // Wiggle pins of DUT
        dut_vi.cmd  = tx.cmd;
        dut_vi.addr = tx.addr;
        dut_vi.data = tx.data;
      end
    endtask: run_phase

  endclass: my_driver


  class my_monitor extends uvm_monitor;
  
    `uvm_component_utils(my_monitor)

     uvm_analysis_port #(my_transaction) aport;
    
     my_dut_config dut_config_0;
     virtual dut_if dut_vi;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new
    
    function void build_phase(uvm_phase phase);
       dut_config_0 = my_dut_config::type_id::create("config");
       aport = new("aport", this);
       assert( uvm_config_db #(my_dut_config)::get(this, "", "dut_config",
						   dut_config_0) );
       dut_vi = dut_config_0.dut_vi;
       // other config settings as needed
    endfunction : build_phase
   
    task run_phase(uvm_phase phase);
      forever
      begin
        my_transaction tx;
        
        @(posedge dut_vi.clock);
        tx = my_transaction::type_id::create("tx");
        tx.cmd  = dut_vi.cmd;
        tx.addr = dut_vi.addr;
        tx.data = dut_vi.data;
        
        aport.write(tx);
      end
    endtask: run_phase

  endclass: my_monitor


  class my_agent extends uvm_agent;

    `uvm_component_utils(my_agent)
    
    uvm_analysis_port #(my_transaction) aport;
    
    my_sequencer my_sequencer_h;
    my_driver    my_driver_h;
    my_monitor   my_monitor_h;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new
    
    function void build_phase(uvm_phase phase);
       aport = new("aport", this);
       my_sequencer_h = my_sequencer::type_id::create("my_sequencer_h", this);
       my_driver_h    = my_driver   ::type_id::create("my_driver_h"   , this);
       my_monitor_h   = my_monitor  ::type_id::create("my_monitor_h"  , this);
    endfunction: build_phase
    
    function void connect_phase(uvm_phase phase);
      my_driver_h.seq_item_port.connect( my_sequencer_h.seq_item_export );
      my_monitor_h.       aport.connect( aport );
    endfunction: connect_phase
    
  endclass: my_agent
  
  
  class my_subscriber extends uvm_subscriber #(my_transaction);
  
    `uvm_component_utils(my_subscriber)
    
    bit cmd;
    int addr;
    int data;
        
    covergroup cover_bus;
      coverpoint cmd;
      coverpoint addr { 
        bins a[16] = {[0:255]};
      }
      coverpoint data {
        bins d[16] = {[0:255]};
      }
    endgroup: cover_bus
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
      cover_bus = new;  
    endfunction: new

    function void write(my_transaction t);
      `uvm_info("mg", $psprintf("Subscriber received tx %s", t.convert2string()), UVM_NONE);
      
      cmd  = t.cmd;
      addr = t.addr;
      data = t.data;
      cover_bus.sample();
      /*
      begin
        my_transaction expected;
        expected = new;
        expected.copy(t);
        if ( !t.compare(expected))
          `uvm_error("mg", "Transaction differs from expected");
      end
      */
    endfunction: write

  endclass: my_subscriber
  
  
  class my_env extends uvm_env;

    `uvm_component_utils(my_env)
    
    UVM_FILE file_h;
    my_agent      my_agent_h;
    my_subscriber my_subscriber_h;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction: new
    
    function void build_phase(uvm_phase phase);
      my_agent_h      = my_agent     ::type_id::create("my_agent_h", this);
      my_subscriber_h = my_subscriber::type_id::create("my_subscriber_h", this);
    endfunction: build_phase
    
    function void connect_phase(uvm_phase phase);
      my_agent_h.aport.connect( my_subscriber_h.analysis_export );
    endfunction: connect_phase
    
    function void start_of_simulation_phase(uvm_phase phase);
    
      //uvm_top.set_report_verbosity_level_hier(UVM_NONE);
      uvm_top.set_report_verbosity_level_hier(UVM_HIGH);
      //uvm_top.set_report_severity_action_hier(UVM_INFO, UVM_NO_ACTION);
      //uvm_top.set_report_id_action_hier("ja", UVM_NO_ACTION);
      
      file_h = $fopen("uvm_basics_complete.log", "w");
      uvm_top.set_report_default_file_hier(file_h);
      uvm_top.set_report_severity_action_hier(UVM_INFO, UVM_DISPLAY + UVM_LOG);

    endfunction: start_of_simulation_phase

  endclass: my_env
  
  
  class my_test extends uvm_test;
  
    `uvm_component_utils(my_test)
    
     my_dut_config dut_config_0;
    
     my_env my_env_h;   
   
     function new(string name, uvm_component parent);
	super.new(name, parent);
     endfunction: new
    
     function void build_phase(uvm_phase phase);
	dut_config_0 = new();

	if(!uvm_config_db #(virtual dut_if)::get( this, "", "dut_vi", 
						  dut_config_0.dut_vi))
          `uvm_fatal("NOVIF", "No virtual interface set")
	// other DUT configuration settings
	uvm_config_db #(my_dut_config)::set(this, "*", "dut_config", 
					    dut_config_0);
	my_env_h = my_env::type_id::create("my_env_h", this);
     endfunction: build_phase
     
  endclass // my_test

  class test1 extends my_test;
   `uvm_component_utils(test1)

     function new(string name, uvm_component parent);
	super.new(name, parent);
     endfunction: new
    
     task run_phase(uvm_phase phase);
	read_modify_write seq;
	seq = read_modify_write::type_id::create("seq");
	phase.raise_objection(this);
	seq.start(my_env_h.my_agent_h.my_sequencer_h);
	phase.drop_objection(this);
     endtask // run_phase
  endclass: test1
   
  class test2 extends my_test;
     `uvm_component_utils(test2)
	
     function new(string name, uvm_component parent);
	super.new(name, parent);
     endfunction: new
    
     task run_phase(uvm_phase phase);
	seq_of_commands seq;
	seq = seq_of_commands::type_id::create("seq");
	assert( seq.randomize() );
	phase.raise_objection(this);
	seq.start( my_env_h.my_agent_h.my_sequencer_h );
	phase.drop_objection(this);
     endtask: run_phase
     
  endclass: test2
   
  class test3 extends my_test;
     `uvm_component_utils(test3)
	
     function new(string name, uvm_component parent);
	super.new(name, parent);
     endfunction: new
    
     task run_phase(uvm_phase phase);
	seq_of_commands seq;
	seq = seq_of_commands::type_id::create("seq");
	seq.how_many.constraint_mode(0);
	assert( seq.randomize() with {seq.n > 10 && seq.n < 20;});
	phase.raise_objection(this);
	seq.start( my_env_h.my_agent_h.my_sequencer_h );
	phase.drop_objection(this);
     endtask: run_phase
     
  endclass: test3
  
endpackage: my_pkg