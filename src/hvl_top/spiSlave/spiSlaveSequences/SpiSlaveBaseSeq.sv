`ifndef SPISLAVEBASESEQ_INCLUDED_
`define SPISLAVEBASESEQ_INCLUDED_

//-------------------------------------------------------------------------------------------
// Class: slave_base_base_sequence
// slave sequence 
//--------------------------------------------------------------------------------------------
class SpiSlaveBaseSeq extends uvm_sequence #(SpiSlaveTransaction);
  
  //factory registration
  `uvm_object_utils(SpiSlaveBaseSeq)

  //-------------------------------------------------------
  // Externally defined Function
  //-------------------------------------------------------
  extern function new(string name = "SpiSlaveBaseSeq");
  extern task body();
endclass : SpiSlaveBaseSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the SpiSlaveBaseSequence class object
//
// Parameters:
// name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiSlaveBaseSeq::new(string name = "SpiSlaveBaseSeq");
  super.new(name);
endfunction : new

task SpiSlaveBaseSeq::body();
  req = SpiSlaveTransaction::type_id::create("req"); 
endtask : body

`endif
