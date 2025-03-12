`ifndef SPISIMPLEFDMAXIMUMBITSTEST_INCLUDED_
`define SPISIMPLEFDMAXIMUMBITSTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFdMaximumBitsTest
// Description:
// Extended the SpiSimpleFdMaximumBitsTest class from SpiBaseTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFdMaximumBitsTest extends SpiBaseTest;

  //Registering the SpiSimpleFdMaximumBitsTest in the factory
  `uvm_component_utils(SpiSimpleFdMaximumBitsTest)

  //-------------------------------------------------------
  // Declaring sequence handles  
  //-------------------------------------------------------
  SpiVirtualFdMaximumBitsSeq spiVirtualFdMaximumBitsSeq;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFdMaximumBitsTest", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : SpiSimpleFdMaximumBitsTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFdMaximumBitsTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFdMaximumBitsTest::new(string name = "SpiSimpleFdMaximumBitsTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function:build_phase
//--------------------------------------------------------------------------------------------
function void SpiSimpleFdMaximumBitsTest::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Task:run_phase
// Responsible for starting the transactions
//--------------------------------------------------------------------------------------------
task SpiSimpleFdMaximumBitsTest::run_phase(uvm_phase phase);
  
  spiVirtualFdMaximumBitsSeq = SpiVirtualFdMaximumBitsSeq::type_id::create("spiVirtualFdMaximumBitsSeq");

  phase.raise_objection(this);
  spiVirtualFdMaximumBitsSeq.start(spiEnv.spiVirtualSequencer);
  phase.drop_objection(this);

endtask:run_phase

`endif
