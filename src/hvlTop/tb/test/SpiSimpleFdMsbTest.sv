`ifndef SPISIMPLEFDMSBTEST_INCLUDED_
`define SPISIMPLEFDMSBTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFdMsbTest
// Description:
// Extended the SpiSimpleFdMsbTest class from SpiSimpleFd8BitsTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFdMsbTest extends SpiSimpleFd8BitsTest;

  //Registering the SpiSimpleFdMsbTest in the factory
  `uvm_component_utils(SpiSimpleFdMsbTest)


  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFdMsbTest", uvm_component parent);
  extern virtual function void setupSpiMasterAgentConfig();
  extern virtual function void setupSpiSlaveAgentConfig();

endclass : SpiSimpleFdMsbTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFdMsbTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFdMsbTest::new(string name = "SpiSimpleFdMsbTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: setupSpiMasterAgentConfig
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdMsbTest::setupSpiMasterAgentConfig();
  super.setupSpiMasterAgentConfig();
  spiEnvConfig.spiMasterAgentConfig.shiftDirection = shiftDirectionEnum'(MSB_FIRST);
endfunction : setupSpiMasterAgentConfig

//--------------------------------------------------------------------------------------------
// Function: setupSpiSlaveAgentConfig
// Setup the slave agent(s) configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdMsbTest::setupSpiSlaveAgentConfig();
 super.setupSpiSlaveAgentConfig();
  foreach(spiEnvConfig.spiSlaveAgentConfig[i])begin
    spiEnvConfig.spiSlaveAgentConfig[i].shiftDirection = shiftDirectionEnum'(MSB_FIRST);
  end
endfunction: setupSpiSlaveAgentConfig

`endif
