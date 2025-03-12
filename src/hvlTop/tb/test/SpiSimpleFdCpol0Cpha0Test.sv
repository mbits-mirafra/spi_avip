`ifndef SPISIMPLEFDCPOL0CPHA0TEST_INCLUDED_
`define SPISIMPLEFDCPOL0CPHA0TEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFdCpol0Cpha0Test
// Description:
// Extended the SpiSimpleFdCpol0Cpha0Test class from base_test class
//--------------------------------------------------------------------------------------------
class SpiSimpleFdCpol0Cpha0Test extends SpiSimpleFd8BitsTest;

  //Registering the SpiSimpleFdCpol0Cpha0Test in the factory
  `uvm_component_utils(SpiSimpleFdCpol0Cpha0Test)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFdCpol0Cpha0Test", uvm_component parent);
  extern virtual function void setupSpiMasterAgentConfig();
  extern virtual function void setupSpiSlaveAgentConfig();

endclass : SpiSimpleFdCpol0Cpha0Test

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFdCpol0Cpha0Test
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFdCpol0Cpha0Test::new(string name = "SpiSimpleFdCpol0Cpha0Test",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: setupSpiMasterAgentConfig
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdCpol0Cpha0Test::setupSpiMasterAgentConfig();
  super.setupSpiMasterAgentConfig();
  spiEnvConfig.spiMasterAgentConfig.spiMode = operationModesEnum'(CPOL0_CPHA0);
endfunction : setupSpiMasterAgentConfig

//--------------------------------------------------------------------------------------------
// Function: setupSpiSlaveAgentConfig
// Setup the slave agent(s) configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdCpol0Cpha0Test::setupSpiSlaveAgentConfig();
  super.setupSpiSlaveAgentConfig();
  foreach(spiEnvConfig.spiSlaveAgentConfig[i])begin
    spiEnvConfig.spiSlaveAgentConfig[i].spiMode = operationModesEnum'(CPOL0_CPHA0);
  end
endfunction: setupSpiSlaveAgentConfig

`endif
