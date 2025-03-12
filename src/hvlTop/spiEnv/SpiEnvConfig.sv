`ifndef SPIENVCONFIG_INCLUDED_
`define SPIENVCONFIG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiEnvConfig
// This class is used as configuration class for environment and its components
//--------------------------------------------------------------------------------------------
class SpiEnvConfig extends uvm_object;
  `uvm_object_utils(SpiEnvConfig)
  
  //int no_of_magent = 1;
  //int no_of_sagent = 1;

  // Variable: hasScoreboard
  // Enables the scoreboard. Default value is 1
  bit hasScoreboard = 1;

  // Variable: has_virtual_sqr
  // Enables the virtual sequencer. Default value is 1
  bit hasVirtualSequencer = 1;

  // Variable: noOfSlaves
  // Number of slaves connected to the SPI interface
  int noOfSlaves;

  // Variable: spiMasterAgentConfig
  // Handle for master agent configuration
  SpiMasterAgentConfig spiMasterAgentConfig;

  // Variable: spiSlaveAgentConfig
  // Dynamic array of slave agnet configuration handles
  SpiSlaveAgentConfig spiSlaveAgentConfig[];

//-------------------------------------------------------
// Externally defined Tasks and Functions
//-------------------------------------------------------
  extern function new(string name = "SpiEnvConfig");
  extern function void do_print(uvm_printer printer);

endclass : SpiEnvConfig

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - SpiEnvConfig
//--------------------------------------------------------------------------------------------
function SpiEnvConfig::new(string name = "SpiEnvConfig");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void SpiEnvConfig::do_print(uvm_printer printer);
  super.do_print(printer);
  
  printer.print_field ("hasScoreboard",hasScoreboard,1, UVM_DEC);
  printer.print_field ("has_virtual_sqr",hasVirtualSequencer,1, UVM_DEC);
  printer.print_field ("noOfSlaves",noOfSlaves,$bits(noOfSlaves), UVM_HEX);

  //commenting the lines because printing master and slave configuration in respective master
  //agent and slave agent classes

  //printer.print_field ("ma_cfg_h",ma_cfg_h,1,UVM_HEX);
  //foreach(sa_cfg_h[i])
  //printer.print_field($sformatf("sa_cfg_h[%0d]",i),this.sa_cfg_h[i],8,UVM_HEX);
endfunction : do_print

`endif

