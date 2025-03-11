`ifndef SPISLAVEFDCPOL1CPHA1SEQ_INCLUDED_
`define SPISLAVEFDCPOL1CPHA1SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiSlaveFdCpol1Cpha1Seq extends SpiSlaveBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiSlaveFdCpol1Cpha1Seq)
   //---------------------------------------------
   // Externally defined tasks and functions
   //---------------------------------------------
   extern function new (string name="SpiSlaveFdCpol1Cpha1Seq");
   extern virtual task body();

endclass:SpiSlaveFdCpol1Cpha1Seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the SpiSlaveFdCpol1Cpha1Sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiSlaveFdCpol1Cpha1Seq::new(string name="SpiSlaveFdCpol1Cpha1Seq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiSlaveFdCpol1Cpha1Seq::body(); 
  super.body();
  start_item(req);
  if(!req.randomize () with {req.masterInSlaveOut.size()==1;})begin 
    `uvm_fatal(get_type_name(),"Randomization failed")
  end 
  `uvm_info(get_type_name(),$sformatf("SpiSlaveFdCpol1Cpha1Seq = \n %0p",req.sprint()),UVM_MEDIUM)
  finish_item(req);

endtask:body

`endif

