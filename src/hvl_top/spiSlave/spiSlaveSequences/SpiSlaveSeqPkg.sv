`ifndef SPISLAVESEQPKG_INCLUDED
`define SPISLAVESEQPKG_INCLUDED

//-----------------------------------------------------------------------------------------
// Package: s_spi_seq
// Description:
// Includes all the files written to run the simulation
//-------------------------------------------------------------------------------------------
  package SpiSlaveSeqPkg;

//-------------------------------------------------------
// Import uvm package
//-------------------------------------------------------
 `include "uvm_macros.svh"
  import uvm_pkg::*;
  import SpiSlavePkg::*;
  import SpiGlobalsPkg::*;

//-------------------------------------------------------
// Importing the required packages
//-------------------------------------------------------
 `include "SpiSlaveBaseSeq.sv"
 `include "SpiSlaveFd8BitsSeq.sv"
 `include "SpiSlaveFd16BitsSeq.sv"
 `include "SpiSlaveFd24BitsSeq.sv"
 `include "SpiSlaveFdNegativeScenariosSeq.sv"
 `include "SpiSlaveFd32BitsSeq.sv"
 `include "SpiSlaveFd64BitsSeq.sv"
 `include "SpiSlaveFd8BitsCtSeq.sv"
 `include "SpiSlaveFdDctSeq.sv"
 `include "SpiSlaveFdMsbSeq.sv"
 `include "SpiSlaveFdLsbSeq.sv"
 `include "SpiSlaveFdCrossSeq.sv"
 `include "SpiSlaveFdCpol0Cpha0Seq.sv"
 `include "SpiSlaveFdCpol0Cpha1Seq.sv"
 `include "SpiSlaveFdCpol1Cpha0Seq.sv"
 `include "SpiSlaveFdCpol1Cpha1Seq.sv"
 `include "SpiSlaveFdMaximumBitsSeq.sv"
 `include "SpiSlaveFdC2tDelaySeq.sv"
 `include "SpiSlaveFdT2cDelaySeq.sv"
 `include "SpiSlaveFdBaudrateSeq.sv"
 `include "SpiSlaveFdRandSeq.sv"
 `include "SpiSlaveFdNoOfSlavesSeq.sv"
 `include "SpiSlaveDualSpiTypeSeq.sv"
 `include "SpiSlaveQuadSpiTypeSeq.sv"
endpackage :SpiSlaveSeqPkg

`endif


