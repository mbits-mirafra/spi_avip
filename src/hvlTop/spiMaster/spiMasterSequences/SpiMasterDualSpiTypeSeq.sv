`ifndef SPIMASTERDUALSPITYPESEQ_INCLUDED_
`define SPIMASTERDUALSPITYPESEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiMasterDualSpiTypeSeq extends SpiMasterBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiMasterDualSpiTypeSeq)

  //---------------------------------------------
  // Externally defined tasks and functions
  //---------------------------------------------
   extern function new (string name="SpiMasterDualSpiTypeSeq");
   extern virtual task body();

endclass:SpiMasterDualSpiTypeSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the master_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiMasterDualSpiTypeSeq::new(string name="SpiMasterDualSpiTypeSeq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiMasterDualSpiTypeSeq::body(); 
  super.body();
  start_item(req);
  if(!req.randomize() with {req.mosi0.size() == CHAR_LENGTH/2;
                            req.mosi1.size() == CHAR_LENGTH/2;
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

