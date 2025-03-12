`ifndef SPIQUADSPITYPETEST_INCLUDED_
`define SPIQUADSPITYPETEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: spi_quad_spi_type_delay_test
// Description:
// Extended the spi_quad_spi_type_delay_test class from SpiSimpleFd8BitsTest class
//--------------------------------------------------------------------------------------------
class SpiQuadSpiTypeTest extends SpiSimpleFd8BitsTest;

  //Registering the spi_quad_spi_type_delay_test in the factory
  `uvm_component_utils(SpiQuadSpiTypeTest)
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiQuadSpiTypeTest", uvm_component parent);
  extern virtual function void setupSpiMasterAgentConfig();
  extern virtual function void setupSpiSlaveAgentConfig();
endclass : SpiQuadSpiTypeTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - spi_quad_spi_type_delay_test
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiQuadSpiTypeTest::new(string name = "SpiQuadSpiTypeTest",uvm_component parent);
  super.new(name, parent);
endfunction : new


//--------------------------------------------------------------------------------------------
// Function: setupSpiMasterAgentConfig
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
function void SpiQuadSpiTypeTest::setupSpiMasterAgentConfig();
  super.setupSpiMasterAgentConfig();
  spiEnvConfig.spiMasterAgentConfig.spiType =spiTypeEnum'(QUAD_SPI);
endfunction : setupSpiMasterAgentConfig


function void SpiQuadSpiTypeTest::setupSpiSlaveAgentConfig();
  foreach(spiEnvConfig.spiSlaveAgentConfig[i])begin
    spiEnvConfig.spiSlaveAgentConfig[i].spiType = spiTypeEnum'(QUAD_SPI);
  end
endfunction: setupSpiSlaveAgentConfig

`endif
