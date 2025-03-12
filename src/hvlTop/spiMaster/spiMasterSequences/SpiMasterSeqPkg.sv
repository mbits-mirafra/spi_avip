`ifndef SPIMASTERSEQPKG_INCLUDED
`define SPIMASTERSEQPKG_INCLUDED

//-----------------------------------------------------------------------------------------
// Package: m_spi_seq
// Description:
// Includes all the files written to run the simulation
//-------------------------------------------------------------------------------------------
  package SpiMasterSeqPkg;

//-------------------------------------------------------
// Import uvm package
//-------------------------------------------------------
 `include "uvm_macros.svh"
  import uvm_pkg::*;
  import SpiMasterPkg::*;
  import SpiGlobalsPkg::*;

//-------------------------------------------------------
// Importing the required packages
//-------------------------------------------------------
 `include "SpiMasterBaseSeq.sv"
 `include "SpiMasterDualSpiTypeSeq.sv"
 `include "SpiMasterFd16BitsSeq.sv"
 `include "SpiMasterFd24BitsSeq.sv"
 `include "SpiMasterFd32BitsSeq.sv"
 `include "SpiMasterFd64BitsSeq.sv"
 `include "SpiMasterFd8BitsCtSeq.sv"
 `include "SpiMasterFd8BitsSeq.sv"
 `include "SpiMasterFdBaudrateSeq.sv"
 `include "SpiMasterFdC2tDelaySeq.sv"
 `include "SpiMasterFdCpol0Cpha0Seq.sv"
 `include "SpiMasterFdCpol0Cpha1Seq.sv"
 `include "SpiMasterFdCpol1Cpha0Seq.sv"
 `include "SpiMasterFdCpol1Cpha1Seq.sv"
 `include "SpiMasterFdCrossSeq.sv"
 `include "SpiMasterFdDctSeq.sv"
 `include "SpiMasterFdLsbSeq.sv"
 `include "SpiMasterFdMaximumBitsSeq.sv"
 `include "SpiMasterFdMsbSeq.sv"
 `include "SpiMasterFdNegativeScenariosSeq.sv"
 `include "SpiMasterFdNoOfSlavesSeq.sv"
 `include "SpiMasterFdRandSeq.sv"
 `include "SpiMasterFdT2cDelaySeq.sv"
 `include "SpiMasterQuadSpiTypeSeq.sv"

endpackage :SpiMasterSeqPkg

`endif
