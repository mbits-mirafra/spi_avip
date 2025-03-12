`ifndef SPISIMPLEFD8BITSTEST_INCLUDED_
`define SPISIMPLEFD8BITSTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSimpleFd8BitsTest
// Description:
// Extended the SpiSimpleFd8BitsTest class from SpiBaseTest class
//--------------------------------------------------------------------------------------------
class SpiSimpleFd8BitsTest extends SpiBaseTest;

  //Registering the SpiSimpleFd8BitsTest in the factory
  `uvm_component_utils(SpiSimpleFd8BitsTest)

  //-------------------------------------------------------
  // Declaring sequence handles  
  //-------------------------------------------------------
  SpiVirtualFd8BitsSeq spiVirtualFd8BitsSeq;


  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSimpleFd8BitsTest", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : SpiSimpleFd8BitsTest


//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes class object
// Parameters:
// name - SpiSimpleFd8BitsTest
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSimpleFd8BitsTest::new(string name = "SpiSimpleFd8BitsTest",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function:build_phase
//--------------------------------------------------------------------------------------------
function void SpiSimpleFd8BitsTest::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Task:run_phase
// Responsible for starting the transactions
//--------------------------------------------------------------------------------------------
task SpiSimpleFd8BitsTest::run_phase(uvm_phase phase);
  spiVirtualFd8BitsSeq = SpiVirtualFd8BitsSeq::type_id::create("spiVirtualFd8BitsSeq");

  phase.raise_objection(this);
  spiVirtualFd8BitsSeq.start(spiEnv.spiVirtualSequencer); 
  phase.drop_objection(this);

endtask : run_phase

`endif
