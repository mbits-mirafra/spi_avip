`ifndef SPIVIRTUALSEQUENCER_INCLUDED_
`define SPIVIRTUALSEQUENCER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiVirtualSequencer
// Description of the class.
//  
// This class contains the handle of actual sequencer pointing towards them
//--------------------------------------------------------------------------------------------
class SpiVirtualSequencer extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(SpiVirtualSequencer)
  
  // Variable: spiEnvConfig
  // Declaring environment configuration handle
  SpiEnvConfig spiEnvConfig;

  // Variable: spiMasterSequencer
  // Declaring master sequencer handle
  SpiMasterSequencer spiMasterSequencer;

  // Variable: spiSlaveSequencer
  // Declaring slave sequencer handle
  SpiSlaveSequencer  spiSlaveSequencer;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiVirtualSequencer", uvm_component parent );
  extern virtual function void build_phase(uvm_phase phase);

endclass : SpiVirtualSequencer

//--------------------------------------------------------------------------------------------
// Construct: new
// initializes the monitor class object
//
// Parameters:
//  name - instance name of the  SpiVirtualSequencer
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiVirtualSequencer::new(string name = "SpiVirtualSequencer",uvm_component parent );
    super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// creates the required ports
//
// Parameters:
//  phase - stores the current phase
//--------------------------------------------------------------------------------------------
function void SpiVirtualSequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  if(!uvm_config_db #(SpiEnvConfig)::get(this,"","SpiEnvConfig",spiEnvConfig))
  `uvm_error("VSEQR","COULDNT GET")
  
  //spiSlaveSequencer = new[spiEnvConfig.no_of_sagent];
  spiMasterSequencer = SpiMasterSequencer::type_id::create("spiMasterSequencer",this);
  spiSlaveSequencer = SpiSlaveSequencer::type_id::create("spiSlaveSequencer",this);
  
endfunction : build_phase


`endif

