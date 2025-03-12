`ifndef SPISIMPLEFDCPOL0CPHA1TEST_INCLUDED_
`define SPISIMPLEFDCPOL0CPHA1TEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFdCpol0Cpha1Test
// Description:
// Extended the SpiSimpleFdCpol0Cpha1Test class from SpiSimpleFd8BitsTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFdCpol0Cpha1Test extends SpiSimpleFd8BitsTest;

  //Registering the SpiSimpleFdCpol0Cpha1Test in the factory
  `uvm_component_utils(SpiSimpleFdCpol0Cpha1Test)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFdCpol0Cpha1Test", uvm_component parent);
  extern virtual function void setupSpiMasterAgentConfig();
  extern virtual function void setupSpiSlaveAgentConfig();

endclass : SpiSimpleFdCpol0Cpha1Test

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFdCpol0Cpha1Test
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFdCpol0Cpha1Test::new(string name = "SpiSimpleFdCpol0Cpha1Test",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function:setupSpiMasterAgentConfig
// setup the master agent configurations with required values
// and store the handle into configdb
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdCpol0Cpha1Test::setupSpiMasterAgentConfig();
  super.setupSpiMasterAgentConfig();
  spiEnvConfig.spiMasterAgentConfig.spiMode = operationModesEnum'(CPOL0_CPHA1);
endfunction : setupSpiMasterAgentConfig


//--------------------------------------------------------------------------------------------
// Function:setup_slave_agent_cfg
// setup the slave agent configurations with required values
// and store the handle into configdb
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdCpol0Cpha1Test::setupSpiSlaveAgentConfig();
  super.setupSpiSlaveAgentConfig();
  foreach(spiEnvConfig.spiSlaveAgentConfig[i])begin
    spiEnvConfig.spiSlaveAgentConfig[i].spiMode = operationModesEnum'(CPOL0_CPHA1);
  end
endfunction: setupSpiSlaveAgentConfig


`endif
