`ifndef SPIMASTERFDCPOL0CPHA0SEQ_INCLUDED_
`define SPIMASTERFDCPOL0CPHA0SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiMasterFdCpol0Cpha0Seq extends SpiMasterBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiMasterFdCpol0Cpha0Seq)

  //---------------------------------------------
  // Externally defined tasks and functions
  //---------------------------------------------

   extern function new (string name="SpiMasterFdCpol0Cpha0Seq");

   extern virtual task body();
endclass:SpiMasterFdCpol0Cpha0Seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiMasterFdCpol0Cpha0Seq::new(string name="SpiMasterFdCpol0Cpha0Seq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiMasterFdCpol0Cpha0Seq::body(); 
  super.body();
  start_item(req);
  if(!req.randomize() with {req.masterOutSlaveIn.size() == 1;
                            // selecting only one slave  
                            $countones(req.cs) == NO_OF_SLAVES - 1;
                            // selecting slave 0
                            req.cs[0] == 0;
                           }) begin
    `uvm_fatal(get_type_name(),"Randomization failed")
  end
  `uvm_info(get_type_name(),$sformatf("master_seq = \n %0p",req.sprint()),UVM_MEDIUM)
  finish_item(req);

endtask:body

`endif

