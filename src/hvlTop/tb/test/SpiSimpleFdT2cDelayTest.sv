`ifndef SPISIMPLEFDT2CDELAYTEST_INCLUDED_
`define SPISIMPLEFDT2CDELAYTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFdT2cDelayTest
// Description:
// Extended the SpiSimpleFdT2cDelayTest class from SpiSimpleFd8BitsTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFdT2cDelayTest extends SpiSimpleFd8BitsTest;

  //Registering the SpiSimpleFdT2cDelayTest in the factory
  `uvm_component_utils(SpiSimpleFdT2cDelayTest)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFdT2cDelayTest", uvm_component parent);
  extern virtual function void setupSpiMasterAgentConfig();

endclass : SpiSimpleFdT2cDelayTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFdT2cDelayTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFdT2cDelayTest::new(string name = "SpiSimpleFdT2cDelayTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: setupSpiMasterAgentConfig
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdT2cDelayTest::setupSpiMasterAgentConfig();
  super.setupSpiMasterAgentConfig();
  spiEnvConfig.spiMasterAgentConfig.t2cdelay = 2;
endfunction : setupSpiMasterAgentConfig

`endif
