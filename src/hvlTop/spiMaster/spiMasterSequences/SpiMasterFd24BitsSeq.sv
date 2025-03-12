`ifndef SPIMASTERFD24BITSSEQ_INCLUDED_
`define SPIMASTERFD24BITSSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiMasterFd24BitsSeq extends SpiMasterBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiMasterFd24BitsSeq)

  //---------------------------------------------
  // Externally defined tasks and functions
  //---------------------------------------------

   extern function new (string name="SpiMasterFd24BitsSeq");
   extern virtual task body();

endclass:SpiMasterFd24BitsSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiMasterFd24BitsSeq::new(string name="SpiMasterFd24BitsSeq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiMasterFd24BitsSeq::body(); 
  super.body();
  start_item(req);
  if(!req.randomize() with {req.masterOutSlaveIn.size() == 3;
                            // Selecting only one slave  
                            $countones(req.cs) == NO_OF_SLAVES - 1;
                            // Selecting slave 0
                            req.cs[0] == 0;
                           }) begin
    `uvm_fatal(get_type_name(),"Randomization failed")
  end
  req.print();
  finish_item(req);

endtask:body

`endif

