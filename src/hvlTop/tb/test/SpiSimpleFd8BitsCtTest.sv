`ifndef SPISIMPLEFD8BITSCTTEST_INCLUDED_
`define SPISIMPLEFD8BITSCTTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFd8BitsCtTest
// Description:
// Extended the SpiSimpleFd8BitsCtTest class from SpiBaseTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFd8BitsCtTest extends SpiBaseTest;

  //Registering the SpiSimpleFd8BitsCtTest in the factory
  `uvm_component_utils(SpiSimpleFd8BitsCtTest)

  //-------------------------------------------------------
  // Declaring sequence handles  
  //-------------------------------------------------------
  SpiVirtualFd8BitsCtSeq spiVirtualFd8BitsCtSeq;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFd8BitsCtTest", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : SpiSimpleFd8BitsCtTest


//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFd8BitsCtTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFd8BitsCtTest::new(string name = "SpiSimpleFd8BitsCtTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function:build_phase
//--------------------------------------------------------------------------------------------
function void SpiSimpleFd8BitsCtTest::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Task:run_phase
// Responsible for starting the transactions
//--------------------------------------------------------------------------------------------
task SpiSimpleFd8BitsCtTest::run_phase(uvm_phase phase);
  
  spiVirtualFd8BitsCtSeq = SpiVirtualFd8BitsCtSeq::type_id::create("spiVirtualFd8BitsCtSeq");

  phase.raise_objection(this);
  spiVirtualFd8BitsCtSeq.start(spiEnv.spiVirtualSequencer); //added by the team 3
  phase.drop_objection(this);

endtask:run_phase

`endif
