`ifndef SPISLAVEDUALSPITYPESEQ_INCLUDED_
`define SPISLAVEDUALSPITYPESEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// class: extended class from base class
//--------------------------------------------------------------------------------------------
class SpiSlaveDualSpiTypeSeq extends SpiSlaveBaseSeq;

  //register with factory so can use create uvm_method 
  //and override in future if necessary 

   `uvm_object_utils(SpiSlaveDualSpiTypeSeq)
   //---------------------------------------------
   // Externally defined tasks and functions
   //---------------------------------------------
   extern function new (string name="SpiSlaveDualSpiTypeSeq");
   extern virtual task body();

endclass:SpiSlaveDualSpiTypeSeq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the slave_sequence class object
//
// Parameters:
//  name - instance name of the config_template
//-----------------------------------------------------------------------------
function SpiSlaveDualSpiTypeSeq::new(string name="SpiSlaveDualSpiTypeSeq");
  super.new(name);
endfunction:new

//-----------------------------------------------------------------------------
//task:body
//based on the request from driver task will drive the transaction
//-----------------------------------------------------------------------------
task SpiSlaveDualSpiTypeSeq::body(); 
  super.body();
  start_item(req);
  if(!req.randomize () with {req.miso0.size()==CHAR_LENGTH/2;
                             req.miso1.size()==CHAR_LENGTH/2;}) begin
    `uvm_fatal(get_type_name(),"Randomization failed")
  end
  `uvm_info(get_type_name(),$sformatf("slave_seq = \n %0p",req.sprint()),UVM_MEDIUM)

  finish_item(req);

endtask:body

`endif

