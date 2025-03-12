`ifndef SPIMASTERBASESEQ_INCLUDED_
`define SPIMASTERBASESEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiMasterBaseSeq 
// creating SpiMasterBaseSeq class extends from uvm_sequence
//--------------------------------------------------------------------------------------------
class SpiMasterBaseSeq extends uvm_sequence #(SpiMasterTransaction);
  //factory registration
  `uvm_object_utils(SpiMasterBaseSeq)

   `uvm_declare_p_sequencer(SpiMasterSequencer)

  //-------------------------------------------------------
  // Externally defined Function
  //-------------------------------------------------------
  extern function new(string name = "SpiMasterBaseSeq");
  extern task body();
endclass : SpiMasterBaseSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiMasterBaseSeq::new(string name = "SpiMasterBaseSeq");
  super.new(name);
endfunction : new

task SpiMasterBaseSeq::body();
  req = SpiMasterTransaction::type_id::create("req");
  //dynamic casting of p_sequencer and m_sequencer
  if(!$cast(p_sequencer,m_sequencer))begin
    `uvm_error(get_full_name(),"Virtual sequencer pointer cast failed")
  end
endtask : body

`endif
