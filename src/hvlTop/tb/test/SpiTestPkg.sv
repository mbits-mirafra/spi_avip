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
  import SpiVirtualSeqPkg::*;

 //including base_test for testing
 `include "SpiBaseTest.sv"
 `include "SpiSimpleFd8BitsTest.sv"
 `include "SpiSimpleFd16BitsTest.sv"
 `include "SpiSimpleFd24BitsTest.sv"
 `include "SpiSimpleFd32BitsTest.sv"
 `include "SpiSimpleFd64BitsTest.sv"
 `include "SpiSimpleFdMaximumBitsTest.sv"
 `include "SpiQuadSpiTypeTest.sv"
 `include "SpiDualSpiTypeTest.sv"
 `include "SpiSimpleFdMsbTest.sv"
 `include "SpiSimpleFdLsbTest.sv"
 `include "SpiSimpleFdNegativeScenariosTest.sv"
 `include "SpiSimpleFd8BitsCtTest.sv"
 `include "SpiSimpleFdNoOfSlavesTest.sv"
 `include "SpiSimpleFdBaudrateTest.sv"
 `include "SpiSimpleFdC2tDelayTest.sv"
 `include "SpiSimpleFdCpol0Cpha0Test.sv"
 `include "SpiSimpleFdCpol0Cpha1Test.sv"
 `include "SpiSimpleFdCpol1Cpha0Test.sv"
 `include "SpiSimpleFdCpol1Cpha1Test.sv"
 `include "SpiSimpleFdCrossTest.sv"
 `include "SpiSimpleFdDctTest.sv"
 `include "SpiSimpleFdRandTest.sv"
 `include "SpiSimpleFdT2cDelayTest.sv"
 `include "AssertionsBaseTest.sv"

endpackage : SpiTestPkg

`endif

