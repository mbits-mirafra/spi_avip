`ifndef SPISIMPLEFDBAUDRATETEST_INCLUDED_
`define SPISIMPLEFDBAUDRATETEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFdBaudrateTest
// Description:
// Extended the SpiSimpleFdBaudrateTest class from SpiSimpleFd8BitsTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFdBaudrateTest extends SpiSimpleFd8BitsTest;

  //Registering the SpiSimpleFdBaudrateTest in the factory
  `uvm_component_utils(SpiSimpleFdBaudrateTest)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFdBaudrateTest", uvm_component parent);
  extern virtual function void setupSpiMasterAgentConfig();

endclass : SpiSimpleFdBaudrateTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFdBaudrateTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFdBaudrateTest::new(string name = "SpiSimpleFdBaudrateTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: setupSpiMasterAgentConfig
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdBaudrateTest::setupSpiMasterAgentConfig();
  super.setupSpiMasterAgentConfig();
  spiEnvConfig.spiMasterAgentConfig.setBaudrateDivisor(.primaryPrescalar(1), .secondaryPrescalar(2)); 
endfunction : setupSpiMasterAgentConfig


`endif
