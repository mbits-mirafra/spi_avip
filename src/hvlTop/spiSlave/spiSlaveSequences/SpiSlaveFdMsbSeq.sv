`ifndef SPISLAVEFDMSBSEQ_INCLUDED_
`define SPISLAVEFDMSBSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiSlaveFdMsbSeq extends SpiSlaveBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiSlaveFdMsbSeq)
   //---------------------------------------------
   // Externally defined tasks and functions
   //---------------------------------------------
   extern function new (string name="SpiSlaveFdMsbSeq");
   extern virtual task body();

endclass:SpiSlaveFdMsbSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the SpiSlaveFdMsbSequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiSlaveFdMsbSeq::new(string name="SpiSlaveFdMsbSeq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiSlaveFdMsbSeq::body(); 
  super.body();
  start_item(req);
  if(!req.randomize () with {req.masterInSlaveOut.size()==1;}) begin
    `uvm_fatal(get_type_name(),"Randomization failed")
  end
  `uvm_info(get_type_name(),$sformatf("SpiSlaveFdMsbSeq = \n %0p",req.sprint()),UVM_MEDIUM)
  finish_item(req);

endtask:body

`endif

