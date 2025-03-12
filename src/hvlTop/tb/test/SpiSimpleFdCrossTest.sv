`ifndef SPISIMPLEFDCROSSTEST_INCLUDED_
`define SPISIMPLEFDCROSSTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFdCrossTest
// Description:
//--------------------------------------------------------------------------------------------
class SpiSimpleFdCrossTest extends SpiSimpleFd8BitsTest;
  `uvm_component_utils(SpiSimpleFdCrossTest)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFdCrossTest", uvm_component parent);
  extern virtual function void setupSpiMasterAgentConfig();
  extern virtual function void setupSpiSlaveAgentConfig();

endclass : SpiSimpleFdCrossTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFdCrossTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFdCrossTest::new(string name = "SpiSimpleFdCrossTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: setupSpiMasterAgentConfig
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
 function void SpiSimpleFdCrossTest::setupSpiMasterAgentConfig();

  // Configure the Master agent configuration
  super.setupSpiMasterAgentConfig();

  // Modifying ONLY the required fields 
  spiEnvConfig.spiMasterAgentConfig.spiMode = operationModesEnum'(CPOL0_CPHA1);
  spiEnvConfig.spiMasterAgentConfig.shiftDirection = shiftDirectionEnum'(MSB_FIRST);
  spiEnvConfig.spiMasterAgentConfig.setBaudrateDivisor(.primaryPrescalar(0), .secondaryPrescalar(0));
  spiEnvConfig.spiMasterAgentConfig.t2cdelay = 2;
  spiEnvConfig.spiMasterAgentConfig.c2tdelay = 2;
  spiEnvConfig.spiMasterAgentConfig.wdelay = 2;
  spiEnvConfig.spiMasterAgentConfig.noOfSlaves = 1;

endfunction: setupSpiMasterAgentConfig

//--------------------------------------------------------------------------------------------
// Function: setupSpiSlaveAgentConfig
// Setup the slave agent(s) configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
 function void SpiSimpleFdCrossTest::setupSpiSlaveAgentConfig();

  // Configure the Master agent configuration
  super.setupSpiSlaveAgentConfig();

  // Setting the configuration for each slave
  foreach(spiEnvConfig.spiSlaveAgentConfig[i]) begin
    spiEnvConfig.spiSlaveAgentConfig[i].spiMode = operationModesEnum'(CPOL0_CPHA1);
    spiEnvConfig.spiSlaveAgentConfig[i].shiftDirection = shiftDirectionEnum'(MSB_FIRST);
  end

endfunction: setupSpiSlaveAgentConfig

`endif
