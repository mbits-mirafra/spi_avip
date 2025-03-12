`ifndef SPISLAVEFDBAUDRATESEQ_INCLUDED_
`define SPISLAVEFDBAUDRATESEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiSlaveFdBaudrateSeq extends SpiSlaveBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiSlaveFdBaudrateSeq)
   //---------------------------------------------
   // Externally defined tasks and functions
   //---------------------------------------------
   extern function new (string name="SpiSlaveFdBaudrateSeq");
   extern virtual task body();

endclass:SpiSlaveFdBaudrateSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the SpiSlaveFdBaudrateSequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiSlaveFdBaudrateSeq::new(string name="SpiSlaveFdBaudrateSeq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiSlaveFdBaudrateSeq::body(); 
  super.body();
  start_item(req);
  if(!req.randomize () with {req.masterInSlaveOut.size()==1;})  begin
    `uvm_fatal(get_type_name(),"Randomization failed")
  end
  `uvm_info(get_type_name(),$sformatf("SpiSlaveFdBaudrateSeq = \n %0p",req.sprint()),UVM_MEDIUM)
  finish_item(req);
endtask:body

`endif

