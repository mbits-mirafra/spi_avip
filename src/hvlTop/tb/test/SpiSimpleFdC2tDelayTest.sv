`ifndef SPISIMPLEFDC2TDELAYTEST_INCLUDED_
`define SPISIMPLEFDC2TDELAYTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFdC2tDelayTest
// Description:
// Extended the SpiSimpleFdC2tDelayTest class from SpiSimpleFd8BitsTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFdC2tDelayTest extends SpiSimpleFd8BitsTest;

  //Registering the SpiSimpleFdC2tDelayTest in the factory
  `uvm_component_utils(SpiSimpleFdC2tDelayTest)


  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFdC2tDelayTest", uvm_component parent);
  extern virtual function void setupSpiMasterAgentConfig();

endclass : SpiSimpleFdC2tDelayTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFdC2tDelayTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFdC2tDelayTest::new(string name = "SpiSimpleFdC2tDelayTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: setupSpiMasterAgentConfig
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdC2tDelayTest::setupSpiMasterAgentConfig();
  super.setupSpiMasterAgentConfig();
  spiEnvConfig.spiMasterAgentConfig.c2tdelay = 2;
endfunction : setupSpiMasterAgentConfig



`endif
