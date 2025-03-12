`ifndef SPIMASTERFDCPOL1CPHA0SEQ_INCLUDED_
`define SPIMASTERFDCPOL1CPHA0SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiMasterFdCpol1Cpha0Seq extends SpiMasterBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiMasterFdCpol1Cpha0Seq)

  //---------------------------------------------
  // Externally defined tasks and functions
  //---------------------------------------------

   extern function new (string name="SpiMasterFdCpol1Cpha0Seq");

   extern virtual task body();
endclass:SpiMasterFdCpol1Cpha0Seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiMasterFdCpol1Cpha0Seq::new(string name="SpiMasterFdCpol1Cpha0Seq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiMasterFdCpol1Cpha0Seq::body(); 
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

