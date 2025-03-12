`ifndef SPIMASTERFD8BITSSEQ_INCLUDED_
`define SPIMASTERFD8BITSSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiMasterFd8BitsSeq extends SpiMasterBaseSeq;

  
  //register with factory so can use create uvm_method 
  //and override in future if necessary 
  `uvm_object_utils(SpiMasterFd8BitsSeq)

  // master_tx req;

  //---------------------------------------------
  // Externally defined tasks and functions
  //---------------------------------------------

  extern function new (string name="SpiMasterFd8BitsSeq");
  extern virtual task body();

endclass:SpiMasterFd8BitsSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------

function SpiMasterFd8BitsSeq::new(string name="SpiMasterFd8BitsSeq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiMasterFd8BitsSeq::body();
  super.body();

  start_item(req);

  if(!req.randomize() with {req.masterOutSlaveIn.size() == 1;
                            // Selecting only one slave  
                            $countones(req.cs) == NO_OF_SLAVES - 1;
                            // Selecting slave 0
                            req.cs[0] == 0;
                           }) begin
    `uvm_fatal(get_type_name(),"Randomization failed")
  end
  `uvm_info(get_type_name(),$sformatf("master_seq = \n %0p",req.sprint()),UVM_MEDIUM)
  finish_item(req);

endtask:body

`endif

