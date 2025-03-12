`ifndef SPIVIRTUALSEQPKG_INCLUDED_
`define SPIVIRTUALSEQPKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: SpiVirtualSeqPkg
//  Includes all the files related to SPI virtual sequences
//--------------------------------------------------------------------------------------------
package SpiVirtualSeqPkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import SpiMasterPkg::*;
  import SpiSlavePkg::*;
  import SpiMasterSeqPkg::*;
  import SpiSlaveSeqPkg::*;
  import SpiEnvPkg::*;


  //-------------------------------------------------------
  // Include all other files
  //-------------------------------------------------------
  `include "SpiVirtualBaseFdSeq.sv"
  `include "SpiVirtualFd8BitsSeq.sv"
  `include "SpiVirtualFd16BitsSeq.sv"
  `include "SpiVirtualFd24BitsSeq.sv"
  `include "SpiVirtualFdNegativeScenariosSeq.sv"
  `include "SpiVirtualFd32BitsSeq.sv"
  `include "SpiVirtualFd64BitsSeq.sv"
  `include "SpiVirtualFdC2tDelaySeq.sv"
  `include "SpiVirtualFdDctSeq.sv"
  `include "SpiVirtualFdCrossSeq.sv"
  `include "SpiVirtualFdCpol0Cpha0Seq.sv"
  `include "SpiVirtualFdCpol0Cpha1Seq.sv"
  `include "SpiVirtualFdCpol1Cpha0Seq.sv"
  `include "SpiVirtualFdCpol1Cpha1Seq.sv"
  `include "SpiVirtualFdMsbSeq.sv"
  `include "SpiVirtualFdLsbSeq.sv"
  `include "SpiVirtualFdMaximumBitsSeq.sv"
  `include "SpiVirtualFdC2tDelaySeq.sv"
  `include "SpiVirtualFdT2cDelaySeq.sv"
  `include "SpiVirtualFdBaudrateSeq.sv"
  `include "SpiVirtualFdRandSeq.sv"
  `include "SpiVirtualFdNoOfSlavesSeq.sv"
  `include "SpiVirtualFdDualTypeSeq.sv"
  `include "SpiVirtualQuadSpiTypeSeq.sv"

endpackage : SpiVirtualSeqPkg

`endif
