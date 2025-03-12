`ifndef SPIENVPKG_INCLUDED_
`define SPIENVPKG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Package: SpiEnvPkg
// Includes all the files related to SPI env
//--------------------------------------------------------------------------------------------
package SpiEnvPkg;
  
  // Import uvm package
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  // Importing the required packages
  import SpiGlobalsPkg::*;
  import SpiMasterPkg::*;
  import SpiSlavePkg::*;

  // Include all other files
  `include "SpiEnvConfig.sv"
  `include "SpiVirtualSequencer.sv"

  // SCOREBOARD
  `include "SpiScoreboard.sv"

  // Coverage 

  `include "SpiEnv.sv"

endpackage : SpiEnvPkg

`endif
