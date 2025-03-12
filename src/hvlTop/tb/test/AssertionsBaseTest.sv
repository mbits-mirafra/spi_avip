`ifndef ASSERTIONSBASETEST_INCLUDED_
`define ASSERTIONSBASETEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiBaseTest
//  Base test has the test scenarios for testbench which has the env, config, etc.
//  Sequences are created and started in the test
//--------------------------------------------------------------------------------------------
class AssertionsBaseTest extends SpiBaseTest;
  `uvm_component_utils(AssertionsBaseTest)
  // Variable: spiEnvConfig
  // Declaring environment config handle
  SpiEnvConfig spiEnvConfig;

  // Variable: env_h
  // Handle for environment 
  SpiEnv spiEnv;


  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "AssertionsBaseTest", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
 // extern virtual function void setupSpiEnvConfig();
 // extern virtual function void setup_master_agent_cfg();
//  extern virtual function void setup_slave_agents_cfg();
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : AssertionsBaseTest

//--------------------------------------------------------------------------------------------
// Construct: new
//  Initializes class object
//
// Parameters:
//  name - AssertionsBaseTest
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function AssertionsBaseTest::new(string name = "AssertionsBaseTest",uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// Create required ports
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void AssertionsBaseTest::build_phase(uvm_phase phase);
  
  `uvm_info(get_type_name(), $sformatf("BUILD_PHASE AssertionsBaseTest"), UVM_NONE);
   super.build_phase(phase);
  // Setup the environemnt cfg 
  spiEnvConfig = SpiEnvConfig::type_id::create("spiEnvConfig");
  spiEnvConfig.spiMasterAgentConfig = SpiMasterAgentConfig::type_id::create("spiMasterAgentConfig");
  setupSpiEnvConfig();
  // Create the environment
  spiEnv = SpiEnv::type_id::create("spiEnv",this);

endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: setupSpiEnvConfig
// Setup the environment configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
/* function void AssertionsBaseTest::setupSpiEnvConfig();
  //spiEnvConfig = SpiEnvConfig::type_id::create("spiEnvConfig");
  spiEnvConfig.no_of_slaves = NO_OF_SLAVES;
  spiEnvConfig.has_scoreboard = 1;
  spiEnvConfig.has_virtual_seqr = 1;
  
  // Setup the master agent cfg 
  //spiEnvConfig.spiMasterAgentConfig = SpiMasterAgentConfig::type_id::create("spiMasterAgentConfig");
  setup_master_agent_cfg();
  uvm_config_db #(SpiMasterAgentConfig)::set(this,"*master_agent*","SpiMasterAgentConfig",spiEnvConfig.spiMasterAgentConfig);
  spiEnvConfig.spiMasterAgentConfig.print();
  
  // Setup the slave agent(s) cfg 
  spiEnvConfig.slave_agent_cfg_h = new[spiEnvConfig.no_of_slaves];
  foreach(spiEnvConfig.slave_agent_cfg_h[i]) begin
    spiEnvConfig.slave_agent_cfg_h[i] = slave_agent_config::type_id::create($sformatf("slave_agent_cfg_h[%0d]",i));
  end
  setup_slave_agents_cfg();
  foreach(spiEnvConfig.slave_agent_cfg_h[i]) begin
    uvm_config_db #(slave_agent_config)::set(this,$sformatf("*slave_agent_h[%0d]*",i),
                                             "slave_agent_config", spiEnvConfig.slave_agent_cfg_h[i]);
   spiEnvConfig.slave_agent_cfg_h[i].print();
  end

  // set method for env_cfg
  uvm_config_db #(SpiEnvConfig)::set(this,"*","SpiEnvConfig",spiEnvConfig);
  spiEnvConfig.print();
 endfunction: setupSpiEnvConfig

//--------------------------------------------------------------------------------------------
// Function: setup_master_agent_cfg
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
 function void AssertionsBaseTest::setup_master_agent_cfg();
  //spiEnvConfig.spiMasterAgentConfig = SpiMasterAgentConfig::type_id::create("spiMasterAgentConfig");
  // Configure the Master agent configuration
  spiEnvConfig.spiMasterAgentConfig.is_active            = uvm_active_passive_enum'(UVM_ACTIVE);
  spiEnvConfig.spiMasterAgentConfig.no_of_slaves         = NO_OF_SLAVES;
  spiEnvConfig.spiMasterAgentConfig.spi_mode             = operation_modes_e'(CPOL0_CPHA0);
  spiEnvConfig.spiMasterAgentConfig.shift_dir            = shift_direction_e'(LSB_FIRST);
  spiEnvConfig.spiMasterAgentConfig.c2tdelay             = 1;
  spiEnvConfig.spiMasterAgentConfig.t2cdelay             = 1;
  spiEnvConfig.spiMasterAgentConfig.has_coverage         = 1;

  // baudrate_divisor_divisor = (secondary_prescalar+1) * (2 ** (primary_prescalar+1))
  // baudrate = busclock / baudrate_divisor_divisor;
  spiEnvConfig.spiMasterAgentConfig.set_baudrate_divisor(.primary_prescalar(0), .secondary_prescalar(0));

 // uvm_config_db #(SpiMasterAgentConfig)::set(this,"*master_agent*","SpiMasterAgentConfig",spiEnvConfig.spiMasterAgentConfig);
 //spiEnvConfig.spiMasterAgentConfig.print();
endfunction: setup_master_agent_cfg

//--------------------------------------------------------------------------------------------
// Function: setup_slave_agents_cfg
// Setup the slave agent(s) configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
 function void AssertionsBaseTest::setup_slave_agents_cfg();
  // Create slave agent(s) configurations
  // spiEnvConfig.slave_agent_cfg_h = new[spiEnvConfig.no_of_slaves];
  // Setting the configuration for each slave
  foreach(spiEnvConfig.slave_agent_cfg_h[i]) begin
    //spiEnvConfig.slave_agent_cfg_h[i] = slave_agent_config::type_id::create($sformatf("salve_agent_cfg_h[%0d]",i));
    spiEnvConfig.slave_agent_cfg_h[i].slave_id     = i;
    spiEnvConfig.slave_agent_cfg_h[i].is_active    = uvm_active_passive_enum'(UVM_ACTIVE);
    spiEnvConfig.slave_agent_cfg_h[i].spi_mode     = operation_modes_e'(CPOL0_CPHA0);
    spiEnvConfig.slave_agent_cfg_h[i].shift_dir    = shift_direction_e'(LSB_FIRST);
    spiEnvConfig.slave_agent_cfg_h[i].has_coverage = 1;

    // MSHAdb #(slave_agent_config)::set(this,"*slave_agent*",
    // MSHA:                                         $sformatf("slave_agent_config[%0d]",i),
    // MSHA:                                         spiEnvConfig.salve_agent_cfg_h[i]);

   // uvm_config_db #(slave_agent_config)::set(this,$sformatf("*slave_agent_h[%0d]*",i),
   //                                          "slave_agent_config", spiEnvConfig.slave_agent_cfg_h[i]);
   // spiEnvConfig.slave_agent_cfg_h[i].print();
  end

endfunction: setup_slave_agents_cfg
*/

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
// Used for printing the testbench topology
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void AssertionsBaseTest::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// Used for giving basic delay for simulation 
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task AssertionsBaseTest::run_phase(uvm_phase phase);

  phase.raise_objection(this, "AssertionsBaseTest");

  `uvm_info(get_type_name(), $sformatf("Inside AssertionsBaseTest"), UVM_NONE);
  super.run_phase(phase);

  // TODO(mshariff): 
  // Need to be replaced with delay task in BFM interface
  // in-order to get rid of time delays in HVL side
  //spi_fd_8b_master_seq_h = spi_fd_8b_master_seq::type_id::create("spi_fd_8b_master_seq_h"); 
  //spi_fd_8b_master_seq_h.start(env_h.master_agent_h.master_seqr_h);
  #1000;
  
  `uvm_info(get_type_name(), $sformatf("Done AssertionsBaseTest"), UVM_NONE);
  phase.drop_objection(this);

endtask : run_phase

`endif

