`ifndef SPISLAVEFD16BITSSEQ_INCLUDED_
`define SPISLAVEFD16BITSSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiSlaveFd16BitsSeq extends SpiSlaveBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiSlaveFd16BitsSeq)
   //---------------------------------------------
   // Externally defined tasks and functions
   //---------------------------------------------
   extern function new (string name="SpiSlaveFd16BitsSeq");
   extern virtual task body();

endclass:SpiSlaveFd16BitsSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the SpiSlaveFd16BitsSequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiSlaveFd16BitsSeq::new(string name="SpiSlaveFd16BitsSeq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiSlaveFd16BitsSeq::body(); 
  super.body();
  start_item(req);
  if(!req.randomize () with {req.masterInSlaveOut.size()==2;})begin
    `uvm_fatal(get_type_name(),"Randomization failed")
  end
  `uvm_info(get_type_name(),$sformatf("SpiSlaveFd16BitsSeq = \n %0p",req.sprint()),UVM_MEDIUM)
  finish_item(req);
  
endtask:body

`endif

