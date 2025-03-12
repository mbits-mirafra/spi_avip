`ifndef SPISIMPLEFDNEGATIVESCENARIOSTEST_INCLUDED_
`define SPISIMPLEFDNEGATIVESCENARIOSTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFdNegativeScenariosTest
// Description:
// Extended the SpiSimpleFdNegativeScenariosTest class from spi_simple_fd_8b_test class
//--------------------------------------------------------------------------------------------
class SpiSimpleFdNegativeScenariosTest extends SpiBaseTest;

  //Registering the SpiSimpleFdNegativeScenariosTest in the factory
  `uvm_component_utils(SpiSimpleFdNegativeScenariosTest)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFdNegativeScenariosTest", uvm_component parent);
  extern virtual function void setupSpiMasterAgentConfig();
  extern virtual function void setupSpiSlaveAgentConfig();

endclass : SpiSimpleFdNegativeScenariosTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFdNegativeScenariosTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFdNegativeScenariosTest::new(string name = "SpiSimpleFdNegativeScenariosTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: setupSpiMasterAgentConfig
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdNegativeScenariosTest::setupSpiMasterAgentConfig();
  super.setupSpiMasterAgentConfig();
 if(!spiEnvConfig.spiMasterAgentConfig.randomize()) begin
      `uvm_fatal("Master:NegativeScenariosTest",$sformatf("randomization failed"))
    end
endfunction : setupSpiMasterAgentConfig

//--------------------------------------------------------------------------------------------
// Function: setupSpiSlaveAgentConfig
// Setup the slave agent(s) configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdNegativeScenariosTest::setupSpiSlaveAgentConfig();
 super.setupSpiSlaveAgentConfig();
  foreach(spiEnvConfig.spiSlaveAgentConfig[i])begin
    if(!spiEnvConfig.spiSlaveAgentConfig[i].randomize())begin
      `uvm_fatal("Slave:NegativeScenariosTest",$sformatf("randomization failed"))
  end
end
endfunction: setupSpiSlaveAgentConfig

`endif
