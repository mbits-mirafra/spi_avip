`ifndef SPIMASTERSEQUENCER_INCLUDED_
`define SPIMASTERSEQUENCER_INCLUDED_

//--------------------------------------------------------------------------------------------
//  Class: SpiMasterSequencer
//--------------------------------------------------------------------------------------------
class SpiMasterSequencer extends uvm_sequencer #(SpiMasterTransaction);
  `uvm_component_utils(SpiMasterSequencer)

  // Variable: spiMasterAgentConfig
  // Declaring handle for master agent config class 
  SpiMasterAgentConfig spiMasterAgentConfig;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiMasterSequencer", uvm_component parent);
 
endclass : SpiMasterSequencer
 
//--------------------------------------------------------------------------------------------
// Construct: new
// initializes the master sequencer class component
//
// Parameters:
// name - SpiMasterSequencer
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiMasterSequencer::new(string name = "SpiMasterSequencer",uvm_component parent);
  super.new(name,parent);
endfunction : new


`endif
