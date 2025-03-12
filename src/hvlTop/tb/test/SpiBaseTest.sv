`ifndef SPIBASETEST_INCLUDED_
`define SPIBASETEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiBaseTest
//  Base test has the test scenarios for testbench which has the env, config, etc.
//  Sequences are created and started in the test
//--------------------------------------------------------------------------------------------
class SpiBaseTest extends uvm_test;
  `uvm_component_utils(SpiBaseTest)
  // Variable: spiEnvConfig
  // Declaring environment config handle
  SpiEnvConfig spiEnvConfig;

  // Variable: spiEnv
  // Handle for environment 
  SpiEnv spiEnv;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiBaseTest", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void setupSpiEnvConfig();
  extern virtual function void setupSpiMasterAgentConfig();
  extern virtual function void setupSpiSlaveAgentConfig();
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : SpiBaseTest

//--------------------------------------------------------------------------------------------
// Construct: new
//  Initializes class object
//
// Parameters:
//  name - SpiBaseTest
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiBaseTest::new(string name = "SpiBaseTest",uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// Create required ports
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiBaseTest::build_phase(uvm_phase phase);
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
 function void SpiBaseTest::setupSpiEnvConfig();
  spiEnvConfig.noOfSlaves = NO_OF_SLAVES;
  spiEnvConfig.hasScoreboard = 1;
  spiEnvConfig.hasVirtualSequencer = 1;
  
  // Setup the master agent cfg 
  setupSpiMasterAgentConfig();
  uvm_config_db #(SpiMasterAgentConfig)::set(this,"*","SpiMasterAgentConfig",spiEnvConfig.spiMasterAgentConfig);
  `uvm_info(get_type_name(),$sformatf("master_agent_cfg = \n %0p",
  spiEnvConfig.spiMasterAgentConfig.sprint()),UVM_NONE)
  
  // Setup the slave agent(s) cfg 
  spiEnvConfig.spiSlaveAgentConfig = new[spiEnvConfig.noOfSlaves];
  foreach(spiEnvConfig.spiSlaveAgentConfig[i]) begin
    spiEnvConfig.spiSlaveAgentConfig[i] = SpiSlaveAgentConfig::type_id::create($sformatf("spiSlaveAgentConfig[%0d]",i));
  end
  setupSpiSlaveAgentConfig();
  foreach(spiEnvConfig.spiSlaveAgentConfig[i]) begin
    uvm_config_db #(SpiSlaveAgentConfig)::set(this,$sformatf("*spiSlaveAgent[%0d]*",i),
                                             "SpiSlaveAgentConfig", spiEnvConfig.spiSlaveAgentConfig[i]);
    `uvm_info(get_type_name(),$sformatf("SpiSlaveAgentConfig = \n %0p",
    spiEnvConfig.spiSlaveAgentConfig[i].sprint()),UVM_NONE)
  end

  // set method for env_cfg
  uvm_config_db #(SpiEnvConfig)::set(this,"*","SpiEnvConfig",spiEnvConfig);
  `uvm_info(get_type_name(),$sformatf("env_cfg = \n %0p", spiEnvConfig.sprint()),UVM_NONE)
 endfunction: setupSpiEnvConfig

//--------------------------------------------------------------------------------------------
// Function: setupSpiMasterAgentConfig
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
 function void SpiBaseTest::setupSpiMasterAgentConfig();
  // Configure the Master agent configuration
  spiEnvConfig.spiMasterAgentConfig.isActive            = uvm_active_passive_enum'(UVM_ACTIVE);
  spiEnvConfig.spiMasterAgentConfig.noOfSlaves          = NO_OF_SLAVES;
  spiEnvConfig.spiMasterAgentConfig.spiMode             = operationModesEnum'(CPOL0_CPHA0);
  spiEnvConfig.spiMasterAgentConfig.shiftDirection      = shiftDirectionEnum'(LSB_FIRST);
  spiEnvConfig.spiMasterAgentConfig.c2tdelay            = 1;
  spiEnvConfig.spiMasterAgentConfig.t2cdelay            = 1;
  spiEnvConfig.spiMasterAgentConfig.hasCoverage         = 1;
  spiEnvConfig.spiMasterAgentConfig.wdelay              = 1;

  // baudrate_divisor_divisor = (secondaryPrescalar+1) * (2 ** (primaryPrescalar+1))
  // baudrate = busclock / baudrate_divisor_divisor;
  spiEnvConfig.spiMasterAgentConfig.setBaudrateDivisor(.primaryPrescalar(0), .secondaryPrescalar(0));

endfunction: setupSpiMasterAgentConfig

//--------------------------------------------------------------------------------------------
// Function: setupSpiSlaveAgentConfig
// Setup the slave agent(s) configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
 function void SpiBaseTest::setupSpiSlaveAgentConfig();
  // Create slave agent(s) configurations
  // Setting the configuration for each slave
  foreach(spiEnvConfig.spiSlaveAgentConfig[i]) begin
    spiEnvConfig.spiSlaveAgentConfig[i].slaveID         = i;
    spiEnvConfig.spiSlaveAgentConfig[i].isActive        = uvm_active_passive_enum'(UVM_ACTIVE);
    spiEnvConfig.spiSlaveAgentConfig[i].spiMode         = operationModesEnum'(CPOL0_CPHA0);
    spiEnvConfig.spiSlaveAgentConfig[i].shiftDirection  = shiftDirectionEnum'(LSB_FIRST);
    spiEnvConfig.spiSlaveAgentConfig[i].hasCoverage     = 1;

  end

endfunction: setupSpiSlaveAgentConfig

//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
// Used for printing the testbench topology
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiBaseTest::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// Used for giving basic delay for simulation 
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task SpiBaseTest::run_phase(uvm_phase phase);

  phase.raise_objection(this, "SpiBaseTest");

  `uvm_info(get_type_name(), $sformatf("Inside SpiBaseTest"), UVM_NONE);
  super.run_phase(phase);

  // TODO(mshariff): 
  // Need to be replaced with delay task in BFM interface
  // in-order to get rid of time delays in HVL side
  //spi_fd_8b_master_seq_h = spi_fd_8b_master_seq::type_id::create("spi_fd_8b_master_seq_h"); 
  //spi_fd_8b_master_seq_h.start(spiEnv.master_agent_h.master_seqr_h);
  #100;
  
  `uvm_info(get_type_name(), $sformatf("Done SpiBaseTest"), UVM_NONE);
  phase.drop_objection(this);

endtask : run_phase

`endif

