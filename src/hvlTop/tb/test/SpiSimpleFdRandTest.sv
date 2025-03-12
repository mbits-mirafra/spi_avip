`ifndef SPISIMPLEFDRANDTEST_INCLUDED_
`define SPISIMPLEFDRANDTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFdRandTest
// Description:
// Extended the SpiSimpleFdRandTest class from SpiSimpleFd8BitsTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFdRandTest extends SpiSimpleFd8BitsTest;

  //Registering the SpiSimpleFdRandTest in the factory
  `uvm_component_utils(SpiSimpleFdRandTest)

  operationModesEnum operationModes;
  shiftDirectionEnum shiftDirection;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFdRandTest", uvm_component parent);
  extern virtual function void setupSpiMasterAgentConfig();
  extern virtual function void setupSpiSlaveAgentConfig();
endclass : SpiSimpleFdRandTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFdRandTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFdRandTest::new(string name = "SpiSimpleFdRandTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: setupSpiMasterAgentConfig
// Setup the master agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
 function void SpiSimpleFdRandTest::setupSpiMasterAgentConfig();

  // Configure the Master agent configuration
  super.setupSpiMasterAgentConfig();

  // Using the std randomize trying to sync the master random configs with slave configs
  if(!std::randomize(operationModes)) begin
    `uvm_error("test",$sformatf("randomization of cfg failed"))
    end
  if(!std::randomize(shiftDirection)) begin
    `uvm_error("test",$sformatf("randomization  of dir failed"))
  end

  `uvm_info("master_random_operationModes",$sformatf("rand_test_operationModes =  \n %0p",operationModes),UVM_FULL)
  `uvm_info("master_random_operationModes",$sformatf("rand_test_shiftDirection =  \n %0p",shiftDirection),UVM_FULL)

  if(! spiEnvConfig.spiMasterAgentConfig.randomize() with {this.spiMode == operationModes;
                                                      this.shiftDirection == shiftDirection; 
                                                    }) begin
      `uvm_fatal(get_type_name(),$sformatf("Randomization failed in master test"))
  end
  `uvm_info(get_type_name(),$sformatf("randomize master config data =  \n %0p",
                                       spiEnvConfig.spiMasterAgentConfig.sprint()),UVM_FULL)
  //spiEnvConfig.spiMasterAgentConfig.print();

endfunction: setupSpiMasterAgentConfig

//--------------------------------------------------------------------------------------------
// Function: setupSpiSlaveAgentConfig
// Setup the slave agent(s) configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
 function void SpiSimpleFdRandTest::setupSpiSlaveAgentConfig();
  
  // Configure the Master agent configuration
  super.setupSpiSlaveAgentConfig();
  
  `uvm_info("slave_random_operationModes",$sformatf("rand_test_operationModes =  \n %0p",operationModes),UVM_FULL)
  `uvm_info("slave_random_operationModes",$sformatf("rand_test_shiftDirection =  \n %0p",shiftDirection),UVM_FULL)

  // Setting the configuration for each slave
  foreach(spiEnvConfig.spiSlaveAgentConfig[i]) begin
    if(! spiEnvConfig.spiSlaveAgentConfig[i].randomize() with {this.spiMode == operationModes;
                                                               this.shiftDirection == shiftDirection; 
                                                    }) begin
      `uvm_fatal(get_type_name(),$sformatf("Randomization failed in test"))
    end
  end

endfunction: setupSpiSlaveAgentConfig

`endif
