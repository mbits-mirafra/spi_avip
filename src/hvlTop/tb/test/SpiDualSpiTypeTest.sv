`ifndef SPIDUALSPITYPETEST_INCLUDED_
`define SPIDUALSPITYPETEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: spi_dual_spi_type_delay_test
// Description:
// Extended the spi_dual_spi_type_delay_test class from SpiSimpleFd8BitsTest class
//--------------------------------------------------------------------------------------------
class SpiDualSpiTypeTest extends SpiSimpleFd8BitsTest;

  //Registering the spi_dual_spi_type_delay_test in the factory
  `uvm_component_utils(SpiDualSpiTypeTest)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiDualSpiTypeTest", uvm_component parent);
  extern virtual function void setupSpiMasterAgentConfig();
  extern virtual function void setupSpiSlaveAgentConfig();
endclass : SpiDualSpiTypeTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - spi_dual_spi_type_delay_test
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiDualSpiTypeTest::new(string name = "SpiDualSpiTypeTest",uvm_component parent);
  super.new(name, parent);
endfunction : new


//--------------------------------------------------------------------------------------------
// Function: setupSpiMasterAgentConfig
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiDualSpiTypeTest::setupSpiMasterAgentConfig();
  super.setupSpiMasterAgentConfig();
  spiEnvConfig.spiMasterAgentConfig.spiType =spiTypeEnum'(DUAL_SPI);
endfunction : setupSpiMasterAgentConfig


function void SpiDualSpiTypeTest::setupSpiSlaveAgentConfig();
  super.setupSpiSlaveAgentConfig();
  foreach(spiEnvConfig.spiSlaveAgentConfig[i])begin
    spiEnvConfig.spiSlaveAgentConfig[i].spiType = spiTypeEnum'(DUAL_SPI);
  end
endfunction: setupSpiSlaveAgentConfig

`endif
