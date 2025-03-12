`ifndef SPISIMPLEFDDCTTEST_INCLUDED_
`define SPISIMPLEFDDCTTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: spi_simple_fd_8b_dct_test
// Description:
// Extended the spi_simple_fd_8b_dct_test class from SpiBaseTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFdDctTest extends SpiBaseTest;

  //Registering the SpiSimpleFdDctTest in the factory
  `uvm_component_utils(SpiSimpleFdDctTest)

  //-------------------------------------------------------
  // Declaring sequence handles  
  //-------------------------------------------------------
  SpiVirtualFd8BitsSeq spiVirtualFd8BitsSeq;
  SpiVirtualFd16BitsSeq spiVirtualFd16BitsSeq;
  SpiVirtualFd32BitsSeq spiVirtualFd32BitsSeq;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFdDctTest", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase); 
  extern virtual function void setupSpiMasterAgentConfig();
endclass : SpiSimpleFdDctTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - spi_simple_fd_8b_dct_test
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFdDctTest::new(string name = "SpiSimpleFdDctTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
//Function: setupSpiMasterAgentConfig
//Setup the master agent configuration with the required values
//and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdDctTest::setupSpiMasterAgentConfig();
  super.setupSpiMasterAgentConfig();
  spiEnvConfig.spiMasterAgentConfig.wdelay= 4;
endfunction : setupSpiMasterAgentConfig

//--------------------------------------------------------------------------------------------
// Function:build_phase
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdDctTest::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Task:run_phase
// Responsible for starting the transactions
//--------------------------------------------------------------------------------------------
task SpiSimpleFdDctTest::run_phase(uvm_phase phase);
  
  spiVirtualFd8BitsSeq = SpiVirtualFd8BitsSeq::type_id::create("spiVirtualFd8BitsSeq");
  spiVirtualFd16BitsSeq = SpiVirtualFd16BitsSeq::type_id::create("spiVirtualFd16BitsSeq");
  spiVirtualFd32BitsSeq = SpiVirtualFd32BitsSeq::type_id::create("spiVirtualFd32BitsSeq");

  phase.raise_objection(this);
  spiVirtualFd8BitsSeq.start(spiEnv.spiVirtualSequencer); 
  spiVirtualFd16BitsSeq.start(spiEnv.spiVirtualSequencer); 
  spiVirtualFd32BitsSeq.start(spiEnv.spiVirtualSequencer); 
  phase.drop_objection(this);

endtask:run_phase

`endif
