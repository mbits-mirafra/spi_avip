`ifndef SPISLAVEFDNOOFSLAVESSEQ_INCLUDED_
`define SPISLAVEFDNOOFSLAVESSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiSlaveFdNoOfSlavesSeq extends SpiSlaveBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiSlaveFdNoOfSlavesSeq)
   //---------------------------------------------
   // Externally defined tasks and functions
   //---------------------------------------------
   extern function new (string name="SpiSlaveFdNoOfSlavesSeq");
   extern virtual task body();

endclass:SpiSlaveFdNoOfSlavesSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the SpiSlaveFdNoOfSlavesSequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiSlaveFdNoOfSlavesSeq::new(string name="SpiSlaveFdNoOfSlavesSeq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiSlaveFdNoOfSlavesSeq::body(); 
  super.body();
  start_item(req);
  if(!req.randomize () with {req.masterInSlaveOut.size()==1;}) begin
    `uvm_fatal(get_type_name(),"Randomization failed")
  end
  `uvm_info(get_type_name(),$sformatf("SpiSlaveFdNoOfSlavesSeq = \n %0p",req.sprint()),UVM_MEDIUM)
  finish_item(req);

endtask:body

`endif

