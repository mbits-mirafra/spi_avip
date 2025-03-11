`ifndef SPISLAVESEQUENCER_INCLUDED_
`define SPISLAVESEQUENCER_INCLUDED_

//--------------------------------------------------------------------------------------------
//  Class: SpiSlaveSequencer
//  It send transactions to driver via tlm ports
//--------------------------------------------------------------------------------------------
class SpiSlaveSequencer extends uvm_sequencer#(SpiSlaveTransaction);
  `uvm_component_utils(SpiSlaveSequencer)
  
    // Variable: spiSlaveAgentConfig;
    // Handle for slave agent configuration
     SpiSlaveAgentConfig spiSlaveAgentConfig;

     //-------------------------------------------------------
     // Externally defined Tasks and Functions
     //-------------------------------------------------------
     extern function new(string name = "SpiSlaveSequencer", uvm_component parent = null);
  
endclass : SpiSlaveSequencer

//--------------------------------------------------------------------------------------------
//  Construct: new
//  SpiSlaveSequencer class object is initialized
//
//  Parameters:
//  name - SpiSlaveSequencer
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSlaveSequencer::new(string name = "SpiSlaveSequencer", uvm_component parent = null);
  super.new(name, parent);
endfunction : new

`endif
