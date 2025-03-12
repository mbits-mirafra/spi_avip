`ifndef SPISLAVEPKG_INCLUDED_
`define SPISLAVEPKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: SpiSlavePkg
//  Includes all the files related to SPI slave
//--------------------------------------------------------------------------------------------
package SpiSlavePkg;

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
  `include "SpiSlaveTransaction.sv"
  `include "SpiSlaveAgentConfig.sv"
  `include "SpiSlaveSeqItemConverter.sv"
  `include "SpiSlaveConfigConverter.sv"
  `include "SpiSlaveSequencer.sv"
  `include "SpiSlaveDriverProxy.sv"
  `include "SpiSlaveMonitorProxy.sv"
  `include "SpiSlaveCoverage.sv"
  `include "SpiSlaveAgent.sv"

endpackage : SpiSlavePkg

`endif
