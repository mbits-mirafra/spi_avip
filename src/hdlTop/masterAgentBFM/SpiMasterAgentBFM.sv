`ifndef SPIMASTERAGENTBFM_INCLUDED_
`define SPIMASTERAGENTBFM_INCLUDED_

//--------------------------------------------------------------------------------------------
// Module: Master Agent BFM
// This module is used as the configuration class for master agent bfm and its components
//--------------------------------------------------------------------------------------------
module SpiMasterAgentBFM(SpiInterface intf);

  //-------------------------------------------------------
  // Package : Importing Uvm Pakckage and Test Package
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  //-------------------------------------------------------
  // Importing Uvm Package
  //-------------------------------------------------------
  import SpiGlobalsPkg::*;

  //-------------------------------------------------------
  // Master Driver bfm instantiation
  //-------------------------------------------------------
  SpiMasterDriverBFM spiMasterDriverBFM (.pclk(intf.pclk), 
                                         .areset(intf.areset),
                                         .sclk(intf.sclk),
                                         .cs(intf.cs),
                                         .mosi0(intf.mosi0),
                                         .mosi1(intf.mosi1),
                                         .mosi2(intf.mosi2),
                                         .mosi3(intf.mosi3),
                                         .miso0(intf.miso0),
                                         .miso1(intf.miso1),
                                         .miso2(intf.miso2),
                                         .miso3(intf.miso3)
                                       );

  //-------------------------------------------------------
  // Master monitor  bfm instantiation
  //-------------------------------------------------------
  SpiMasterMonitorBFM spiMasterMonitorBFM (.pclk(intf.pclk), 
                                           .areset(intf.areset),
                                           .sclk(intf.sclk),
                                           .cs(intf.cs),
                                           .mosi0(intf.mosi0),
                                           .mosi1(intf.mosi1),
                                           .mosi2(intf.mosi2),
                                           .mosi3(intf.mosi3),
                                           .miso0(intf.miso0),
                                           .miso1(intf.miso1),
                                           .miso2(intf.miso2),
                                           .miso3(intf.miso3)
                                         );
   
  //-------------------------------------------------------
  // Binding Master monitor bfm with Master assertions and instantiation of handle
  //-------------------------------------------------------
  bind SpiMasterMonitorBFM SpiMasterAssertions SPIMASTERASSERTIONS(.pclk(pclk),
                                                                   .cs(cs),
                                                                   .areset(areset),
                                                                   .sclk(sclk),
                                                                   .mosi0(mosi0),
                                                                   .mosi1(mosi1),
                                                                   .mosi2(mosi2),
                                                                   .mosi3(mosi3),
                                                                   .miso0(miso0),
                                                                   .miso1(miso1),
                                                                   .miso2(miso2),
                                                                   .miso3(miso3)
                                                                  );

  //-------------------------------------------------------
  // Setting the virtual handle of BMFs into config_db
  //-------------------------------------------------------
  initial begin
    uvm_config_db#(virtual SpiMasterDriverBFM)::set(null,"*", "SpiMasterDriverBFM", spiMasterDriverBFM); 
    uvm_config_db#(virtual SpiMasterMonitorBFM)::set(null,"*", "SpiMasterMonitorBFM", spiMasterMonitorBFM);
  end
  
  initial begin
    $display("Master Agent BFM");
  end
   
endmodule : SpiMasterAgentBFM

`endif

