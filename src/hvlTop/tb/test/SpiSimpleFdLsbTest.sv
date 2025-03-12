`ifndef SPISIMPLEFDLSBTEST_INCLUDED_
`define SPISIMPLEFDLSBTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFdLsbTest
// Description:
// Extended the SpiSimpleFdLsbTest class from SpiSimpleFd8BitsTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFdLsbTest extends SpiSimpleFd8BitsTest;

  //Registering the SpiSimpleFdLsbTest in the factory
  `uvm_component_utils(SpiSimpleFdLsbTest)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFdLsbTest", uvm_component parent);
  extern virtual function void setupSpiMasterAgentConfig();
  extern virtual function void setupSpiSlaveAgentConfig();

endclass : SpiSimpleFdLsbTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFdLsbTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFdLsbTest::new(string name = "SpiSimpleFdLsbTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: setupSpiMasterAgentConfig
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdLsbTest::setupSpiMasterAgentConfig();
  super.setupSpiMasterAgentConfig();
  spiEnvConfig.spiMasterAgentConfig.shiftDirection = shiftDirectionEnum'(LSB_FIRST);
endfunction : setupSpiMasterAgentConfig

//--------------------------------------------------------------------------------------------
// Function: setupSpiSlaveAgentConfig
// Setup the slave agent(s) configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdLsbTest::setupSpiSlaveAgentConfig();
 super.setupSpiSlaveAgentConfig();
  foreach(spiEnvConfig.spiSlaveAgentConfig[i])begin
    spiEnvConfig.spiSlaveAgentConfig[i].shiftDirection = shiftDirectionEnum'(LSB_FIRST);
  end
endfunction: setupSpiSlaveAgentConfig

`endif
