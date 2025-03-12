`ifndef SPISIMPLEFD24BITSTEST_INCLUDED_
`define SPISIMPLEFD24BITSTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFd24BitsTest
// Description:
// Extended the SpiSimpleFd24BitsTest class from SpiBaseTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFd24BitsTest extends SpiBaseTest;

  //Registering the SpiSimpleFd24BitsTest in the factory
  `uvm_component_utils(SpiSimpleFd24BitsTest)

  //-------------------------------------------------------
  // Declaring sequence handles  
  //-------------------------------------------------------

  SpiVirtualFd24BitsSeq spiVirtualFd24BitsSeq;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFd24BitsTest", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : SpiSimpleFd24BitsTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFd24BitsTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFd24BitsTest::new(string name = "SpiSimpleFd24BitsTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function:build_phase
//--------------------------------------------------------------------------------------------
function void SpiSimpleFd24BitsTest::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Task:run_phase
// Responsible for starting the transactions
//--------------------------------------------------------------------------------------------
task SpiSimpleFd24BitsTest::run_phase(uvm_phase phase);
  
  spiVirtualFd24BitsSeq = SpiVirtualFd24BitsSeq::type_id::create("spiVirtualFd24BitsSeq");

  phase.raise_objection(this);
  spiVirtualFd24BitsSeq.start(spiEnv.spiVirtualSequencer); 
  phase.drop_objection(this);

endtask:run_phase


`endif
