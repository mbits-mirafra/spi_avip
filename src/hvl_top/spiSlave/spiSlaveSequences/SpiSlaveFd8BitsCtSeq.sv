`ifndef SPISLAVEFD8BITSCTSEQ_INCLUDED_
`define SPISLAVEFD8BITSCTSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiSlaveFd8BitsCtSeq extends SpiSlaveBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiSlaveFd8BitsCtSeq)
   //---------------------------------------------
   // Externally defined tasks and functions
   //---------------------------------------------
   extern function new (string name="SpiSlaveFd8BitsCtSeq");
   extern virtual task body();

endclass:SpiSlaveFd8BitsCtSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the SpiSlaveFd8BitsCtSequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiSlaveFd8BitsCtSeq::new(string name="spi_fd_8b_ct_SpiSlaveFd8BitsCtSeq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiSlaveFd8BitsCtSeq::body(); 
  super.body();
  start_item(req);
  if(!req.randomize () with {req.masterInSlaveOut.size()==1;}) begin
    `uvm_fatal(get_type_name(),"Randomization failed")
  end
  `uvm_info(get_type_name(),$sformatf("SpiSlaveFd8BitsCtSeq = \n %0p",req.sprint()),UVM_MEDIUM)
  finish_item(req);

endtask:body

`endif

