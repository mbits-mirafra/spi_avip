`ifndef SPISLAVEFDCPOL0CPHA0SEQ_INCLUDED_
`define SPISLAVEFDCPOL0CPHA0SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiSlaveFdCpol0Cpha0Seq extends SpiSlaveBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiSlaveFdCpol0Cpha0Seq)
   //---------------------------------------------
   // Externally defined tasks and functions
   //---------------------------------------------
   extern function new (string name="SpiSlaveFdCpol0Cpha0Seq");
   extern virtual task body();

endclass:SpiSlaveFdCpol0Cpha0Seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the SpiSlaveFdCpol0Cpha0Sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiSlaveFdCpol0Cpha0Seq::new(string name="SpiSlaveFdCpol0Cpha0Seq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiSlaveFdCpol0Cpha0Seq::body(); 
  super.body();
  start_item(req);
  if(!req.randomize () with {req.masterInSlaveOut.size()==1;}) begin 
    `uvm_fatal(get_type_name(),"Randomization failed")
  end
  `uvm_info(get_type_name(),$sformatf("SpiSlaveFdCpol0Cpha0Seq = \n %0p",req.sprint()),UVM_MEDIUM)
  finish_item(req);

endtask:body

`endif

