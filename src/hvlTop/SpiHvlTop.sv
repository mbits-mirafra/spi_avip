//--------------------------------------------------------------------------------------------
// Module: Hvl top module
//--------------------------------------------------------------------------------------------
module SpiHvlTop;

  //-------------------------------------------------------
  // Package : Importing Uvm Pakckage and Test Package
  //-------------------------------------------------------
  import SpiTestPkg::*;
  import uvm_pkg::*;

  //-------------------------------------------------------
  // run_test for simulation
  //-------------------------------------------------------
  initial begin : START_TEST 
    
    // The test to start is given at the command line
    // The command-line UVM_TESTNAME takes the precedance
    run_test("SpiBaseTest");

  end

endmodule : SpiHvlTop
