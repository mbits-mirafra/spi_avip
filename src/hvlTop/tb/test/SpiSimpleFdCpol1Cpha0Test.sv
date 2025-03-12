`ifndef SPISIMPLEFDCPOL1CPHA0TEST_INCLUDED_
`define SPISIMPLEFDCPOL1CPHA0TEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFdCpol1Cpha0Test
// Description:
// Extended the SpiSimpleFdCpol1Cpha0Test class from SpiSimpleFd8BitsTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFdCpol1Cpha0Test extends SpiSimpleFd8BitsTest;

  //Registering the SpiSimpleFdCpol1Cpha0Test in the factory
  `uvm_component_utils(SpiSimpleFdCpol1Cpha0Test)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFdCpol1Cpha0Test", uvm_component parent);
  extern virtual function void setupSpiMasterAgentConfig();
  extern virtual function void setupSpiSlaveAgentConfig();

endclass : SpiSimpleFdCpol1Cpha0Test

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFdCpol1Cpha0Test
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFdCpol1Cpha0Test::new(string name = "SpiSimpleFdCpol1Cpha0Test",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: setupSpiMasterAgentConfig
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdCpol1Cpha0Test::setupSpiMasterAgentConfig();
  super.setupSpiMasterAgentConfig();
  spiEnvConfig.spiMasterAgentConfig.spiMode = operationModesEnum'(CPOL1_CPHA0);
endfunction : setupSpiMasterAgentConfig

//--------------------------------------------------------------------------------------------
// Function: setupSpiSlaveAgentConfig
// Setup the slave agent(s) configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdCpol1Cpha0Test::setupSpiSlaveAgentConfig();
  super.setupSpiSlaveAgentConfig();
  foreach(spiEnvConfig.spiSlaveAgentConfig[i])begin
    spiEnvConfig.spiSlaveAgentConfig[i].spiMode = operationModesEnum'(CPOL1_CPHA0);
  end
endfunction: setupSpiSlaveAgentConfig

`endif
