`ifndef SPISLAVEFD8BITSSEQ_INCLUDED_
`define SPISLAVEFD8BITSSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiSlaveFd8BitsSeq extends SpiSlaveBaseSeq;

  //register with factory so can use create uvm_method
  //and override in future if necessary 

 `uvm_object_utils(SpiSlaveFd8BitsSeq)

  //---------------------------------------------
  // Externally defined tasks and functions
  //---------------------------------------------
  extern function new (string name="SpiSlaveFd8BitsSeq");
  extern virtual task body();

endclass:SpiSlaveFd8BitsSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the SpiSlaveFd8BitsSequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiSlaveFd8BitsSeq::new(string name="SpiSlaveFd8BitsSeq");
  super.new(name);
endfunction : new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiSlaveFd8BitsSeq::body(); 
    super.body();
    start_item(req);
    if(!req.randomize() with { req.masterInSlaveOut.size()==1;})begin
      `uvm_fatal(get_type_name(),"Randomization FAILED")
    end
    `uvm_info(get_type_name(),$sformatf("SpiSlaveFd8BitsSeq = \n %0p",req.sprint()),UVM_MEDIUM)
    finish_item(req);
endtask : body

`endif

