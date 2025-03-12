`ifndef SPISLAVEAGENTCONFIG_INCLUDED_
`define SPISLAVEAGENTCONFIG_INCLUDED_

//--------------------------------------------------------------------------------------------
//  Class: SpiSlaveAgentConfig
//  Used as the configuration class for slave agent and it's components
//--------------------------------------------------------------------------------------------
class SpiSlaveAgentConfig extends uvm_object;
  
  `uvm_object_utils(SpiSlaveAgentConfig)

  // Variable: isActive
  // Used for creating the agent in either passive or active mode
  uvm_active_passive_enum isActive=UVM_ACTIVE;  

  // Variable: slaveID
  // Used for indicating the ID of this slave
  int slaveID;

  // Variable: spiMode 
  // Used for setting the opeartion mode 
  rand operationModesEnum spiMode;

  // Variable: shiftDirection
  // Shifts the data, LSB first or MSB first
  rand shiftDirectionEnum shiftDirection;

  // Variable: hasCoverage
  // Used for enabling the slave agent coverage
  bit hasCoverage;
  
  //spiTypeEnum enum declared in global pakage for simple,dual,quad 
  spiTypeEnum spiType;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSlaveAgentConfig");
  extern function void do_print(uvm_printer printer);
endclass : SpiSlaveAgentConfig

//--------------------------------------------------------------------------------------------
//  Construct: new
//
//  Parameters:
//  name - SpiSlaveAgentConfig
//--------------------------------------------------------------------------------------------
function SpiSlaveAgentConfig::new(string name = "SpiSlaveAgentConfig");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void SpiSlaveAgentConfig::do_print(uvm_printer printer);
  super.do_print(printer);

//printer.print_field("isActive",isActive);
  printer.print_string ("isActive",isActive.name());
  printer.print_field ("slaveID",slaveID,2, UVM_DEC);
  printer.print_string ("spiMode",spiMode.name());
  printer.print_string ("shiftDirection",shiftDirection.name());
  printer.print_field ("hasCoverage",hasCoverage, 1, UVM_DEC);
  printer.print_string ("spiType",spiType.name());
  
endfunction : do_print

`endif

