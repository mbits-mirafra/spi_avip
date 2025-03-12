`ifndef SPISLAVEFD64BITSSEQ_INCLUDED_
`define SPISLAVEFD64BITSSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiSlaveFd64BitsSeq extends SpiSlaveBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiSlaveFd64BitsSeq)
   //---------------------------------------------
   // Externally defined tasks and functions
   //---------------------------------------------
   extern function new (string name="SpiSlaveFd64BitsSeq");
   extern virtual task body();

endclass:SpiSlaveFd64BitsSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the SpiSlaveFd64BitsSequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiSlaveFd64BitsSeq::new(string name="SpiSlaveFd64BitsSeq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiSlaveFd64BitsSeq::body(); 
  super.body();
  start_item(req);
  if(!req.randomize () with {req.masterInSlaveOut.size()==8;}) begin
    `uvm_fatal(get_type_name(),"Randomization failed")
  end
  `uvm_info(get_type_name(),$sformatf("SpiSlaveFd64BitsSeq = \n %0p",req.sprint()),UVM_MEDIUM)
  finish_item(req);
  
endtask:body

`endif

