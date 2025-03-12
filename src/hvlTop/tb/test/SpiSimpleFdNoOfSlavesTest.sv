`ifndef SPISIMPLEFDNOOFSLAVESTEST_INCLUDED_
`define SPISIMPLEFDNOOFSLAVESTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFdNoOfSlavesTest
// Description:
// Extended the SpiSimpleFdNoOfSlavesTest class from SpiSimpleFd8BitsTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFdNoOfSlavesTest extends SpiSimpleFd8BitsTest;

  //Registering the SpiSimpleFdNoOfSlavesTest in the factory
  `uvm_component_utils(SpiSimpleFdNoOfSlavesTest)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFdNoOfSlavesTest", uvm_component parent);
  extern virtual function void setupSpiMasterAgentConfig();

endclass : SpiSimpleFdNoOfSlavesTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFdNoOfSlavesTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFdNoOfSlavesTest::new(string name = "SpiSimpleFdNoOfSlavesTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------------------
// Function: setupSpiMasterAgentConfig
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdNoOfSlavesTest::setupSpiMasterAgentConfig();
  super.setupSpiMasterAgentConfig();
  spiEnvConfig.spiMasterAgentConfig.noOfSlaves = 2;
endfunction : setupSpiMasterAgentConfig


`endif
