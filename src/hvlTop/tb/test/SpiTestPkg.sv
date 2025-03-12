`ifndef SPITESTPKG_INCLUDED_
`define SPITESTPKG_INCLUDED_

//-----------------------------------------------------------------------------------------
// Package: Test
// Description:
// Includes all the files written to run the simulation
//--------------------------------------------------------------------------------------------
package SpiTestPkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  //-------------------------------------------------------
  // Importing the required packages
  //-------------------------------------------------------
  import SpiGlobalsPkg::*;
  import SpiMasterPkg::*;
  import SpiSlavePkg::*;
  import SpiEnvPkg::*;
  import SpiMasterSeqPkg::*;
  import SpiSlaveSeqPkg::*;
//  import SpiVirtualSeqPkg::*;

 //including base_test for testing
 `include "SpiBaseTest.sv"
// `include "assertions_base_test.sv"
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
// `include ""
endpackage : SpiTestPkg

`endif

