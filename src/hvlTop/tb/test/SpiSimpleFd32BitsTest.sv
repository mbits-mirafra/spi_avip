`ifndef SPISIMPLEFD32BITSTEST_INCLUDED_
`define SPISIMPLEFD32BITSTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFd32BitsTest
// Description:
// Extended the SpiSimpleFd32BitsTest class from SpiBaseTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFd32BitsTest extends SpiBaseTest;

  //Registering the SpiSimpleFd32BitsTest in the factory
  `uvm_component_utils(SpiSimpleFd32BitsTest)

  //-------------------------------------------------------
  // Declaring sequence handles  
  //-------------------------------------------------------
  SpiVirtualFd32BitsSeq spiVirtualFd32BitsSeq;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFd32BitsTest", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : SpiSimpleFd32BitsTest

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFd32BitsTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFd32BitsTest::new(string name = "SpiSimpleFd32BitsTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function:build_phase
//--------------------------------------------------------------------------------------------
function void SpiSimpleFd32BitsTest::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Task:run_phase
// Responsible for starting the transactions
//--------------------------------------------------------------------------------------------
task SpiSimpleFd32BitsTest::run_phase(uvm_phase phase);
  
  spiVirtualFd32BitsSeq = SpiVirtualFd32BitsSeq::type_id::create("spiVirtualFd32BitsSeq");

  phase.raise_objection(this);
  spiVirtualFd32BitsSeq.start(spiEnv.spiVirtualSequencer); //added by the team 3
  phase.drop_objection(this);

endtask:run_phase


`endif
