`ifndef SPIMASTERFDNEGATIVESCENARIOSSEQ_INCLUDED_
`define SPIMASTERFDNEGATIVESCENARIOSSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiMasterFdNegativeScenariosSeq extends SpiMasterBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiMasterFdNegativeScenariosSeq)

  //---------------------------------------------
  // Externally defined tasks and functions
  //---------------------------------------------
   extern function new (string name="SpiMasterFdNegativeScenariosSeq");
   extern virtual task body();

endclass:SpiMasterFdNegativeScenariosSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiMasterFdNegativeScenariosSeq::new(string name="SpiMasterFdNegativeScenariosSeq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiMasterFdNegativeScenariosSeq::body(); 
  super.body();
  start_item(req);
  if(!req.randomize() with {req.masterOutSlaveIn.size() <  MAXIMUM_BITS / CHAR_LENGTH;
                            // selecting only one slave  
                            $countones(req.cs) == NO_OF_SLAVES - 1;
                            // selecting slave 0
                            req.cs[0] == 0;
                           }) begin
    `uvm_fatal(get_type_name(),"Randomization failed")
  end
  req.print();
  finish_item(req);

endtask:body

`endif

