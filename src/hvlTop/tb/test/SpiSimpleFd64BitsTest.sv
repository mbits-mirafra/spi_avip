`ifndef SPISIMPLEFD64BITSTEST_INCLUDED_
`define SPISIMPLEFD64BITSTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFd64BitsTest
// Description:
// Extended the SpiSimpleFd64BitsTest class from SpiBaseTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFd64BitsTest extends SpiBaseTest;

  //Registering the SpiSimpleFd64BitsTest in the factory
  `uvm_component_utils(SpiSimpleFd64BitsTest)

  //-------------------------------------------------------
  // Declaring sequence handles  
  //-------------------------------------------------------
  SpiVirtualFd64BitsSeq spiVirtualFd64BitsSeq;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFd64BitsTest", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : SpiSimpleFd64BitsTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFd64BitsTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFd64BitsTest::new(string name = "SpiSimpleFd64BitsTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function:build_phase
//--------------------------------------------------------------------------------------------
function void SpiSimpleFd64BitsTest::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Task:run_phase
// Responsible for starting the transactions
//--------------------------------------------------------------------------------------------
task SpiSimpleFd64BitsTest::run_phase(uvm_phase phase);
  
  spiVirtualFd64BitsSeq = SpiVirtualFd64BitsSeq::type_id::create("spiVirtualFd64BitsSeq");

  phase.raise_objection(this);
  spiVirtualFd64BitsSeq.start(spiEnv.spiVirtualSequencer); 
  phase.drop_objection(this);

endtask:run_phase

`endif
