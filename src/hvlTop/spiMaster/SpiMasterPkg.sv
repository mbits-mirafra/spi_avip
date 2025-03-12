`ifndef SPIMASTERPKG_INCLUDED_
`define SPIMASTERPKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: SpiMasterPkg
//  Includes all the files related to SPI master
//--------------------------------------------------------------------------------------------
package SpiMasterPkg;

  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;
 
  // Import SpiGlobalsPkg 
  import SpiGlobalsPkg::*;

  //-------------------------------------------------------
  // Include all other files
  //-------------------------------------------------------
  `include "SpiMasterTransaction.sv"
  `include "SpiMasterAgentConfig.sv"
  `include "SpiMasterSeqItemConverter.sv"
  `include "SpiMasterConfigConverter.sv"
  `include "SpiMasterSequencer.sv"
//`include "master_sequence.sv"
  `include "SpiMasterDriverProxy.sv"
  `include "SpiMasterMonitorProxy.sv"
  `include "SpiMasterCoverage.sv"
  `include "SpiMasterAgent.sv"
  
endpackage : SpiMasterPkg

`endif
