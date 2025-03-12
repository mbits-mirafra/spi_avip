`ifndef SPISLAVEFDMAXIMUMBITSSEQ_INCLUDED_
`define SPISLAVEFDMAXIMUMBITSSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiSlaveFdMaximumBitsSeq extends SpiSlaveBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiSlaveFdMaximumBitsSeq)
   //---------------------------------------------
   // Externally defined tasks and functions
   //---------------------------------------------
   extern function new (string name="SpiSlaveFdMaximumBitsSeq");
   extern virtual task body();

endclass:SpiSlaveFdMaximumBitsSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the SpiSlaveFdMaximumBitsSequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiSlaveFdMaximumBitsSeq::new(string name="SpiSlaveFdMaximumBitsSeq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiSlaveFdMaximumBitsSeq::body(); 
  super.body();
  start_item(req);
  if(!req.randomize () with {req.masterInSlaveOut.size() < MAXIMUM_BITS/CHAR_LENGTH;}) begin 
    `uvm_fatal(get_type_name(),"Randomization failed")
  end
  `uvm_info(get_type_name(),$sformatf("SpiSlaveFdMaximumBitsSeq = \n %0p",req.sprint()),UVM_MEDIUM)
  finish_item(req);

endtask:body

`endif

