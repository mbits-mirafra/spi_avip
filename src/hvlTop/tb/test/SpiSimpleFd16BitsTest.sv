`ifndef SPISIMPLEFD16BITSTEST_INCLUDED_
`define SPISIMPLEFD16BITSTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFd16BitsTest
// Description:
// Extended the SpiSimpleFd16BitsTest class from SpiBaseTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFd16BitsTest extends SpiBaseTest;

  //Registering the SpiSimpleFd16BitsTest in the factory
  `uvm_component_utils(SpiSimpleFd16BitsTest)

  //-------------------------------------------------------
  // Declaring sequence handles  
  //-------------------------------------------------------
  SpiVirtualFd16BitsSeq spiVirtualFd16BitsSeq;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFd16BitsTest", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : SpiSimpleFd16BitsTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFd16BitsTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFd16BitsTest::new(string name = "SpiSimpleFd16BitsTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function:build_phase
//--------------------------------------------------------------------------------------------
function void SpiSimpleFd16BitsTest::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Task:run_phase
// Responsible for starting the transactions
//--------------------------------------------------------------------------------------------
task SpiSimpleFd16BitsTest::run_phase(uvm_phase phase);
  
  spiVirtualFd16BitsSeq = SpiVirtualFd16BitsSeq::type_id::create("spiVirtualFd16BitsSeq");

  phase.raise_objection(this);
  spiVirtualFd16BitsSeq.start(spiEnv.spiVirtualSequencer); 
  phase.drop_objection(this);

endtask:run_phase

`endif
