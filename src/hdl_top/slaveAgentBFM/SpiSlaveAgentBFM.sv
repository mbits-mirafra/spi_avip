`ifndef SPISLAVEAGENTBFM_INCLUDED_
`define SPISLAVEAGENTBFM_INCLUDED_

//--------------------------------------------------------------------------------------------
// Module : Slave Agent BFM 
// This module is used as the configuration class for slave agent bfm and its components
//--------------------------------------------------------------------------------------------
module SpiSlaveAgentBFM(SpiInterface spiInterface);

  //-------------------------------------------------------
  // Package : Importing Uvm Package and Test Package
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  //-------------------------------------------------------
  // Package : Importing SPI Global Package 
  //-------------------------------------------------------
  import SpiGlobalsPkg::*;

  // Variable: is_active
  // Used for creating the agent in either passive or active mode
  //uvm_active_passive_enum is_active;  

  //-------------------------------------------------------
  // Slave driver bfm instantiation
  //-------------------------------------------------------
  SpiSlaveDriverBFM spiSlaveDriverBFM (.pclk(spiInterface.pclk),
                                       .areset(spiInterface.areset),
                                       .sclk(spiInterface.sclk),
                                    // TODO(mshariff): Need to modify it for more slaves
                                       .cs(spiInterface.cs[0]),
                                       .mosi0(spiInterface.mosi0),
                                       .mosi1(spiInterface.mosi1),
                                       .mosi2(spiInterface.mosi2),
                                       .mosi3(spiInterface.mosi3),
                                       .miso0(spiInterface.miso0),
                                       .miso1(spiInterface.miso1),
                                       .miso2(spiInterface.miso2),
                                       .miso3(spiInterface.miso3)
                                   );

  //-------------------------------------------------------
  // Slave monitor bfm instantiation
  //-------------------------------------------------------
  SpiSlaveMonitorBFM spiSlaveMonitorBFM (.pclk(spiInterface.pclk),
                                        .areset(spiInterface.areset),
                                        .sclk(spiInterface.sclk),
                                        .cs(spiInterface.cs[0]),
                                        .mosi0(spiInterface.mosi0),
                                        .mosi1(spiInterface.mosi1),
                                        .mosi2(spiInterface.mosi2),
                                        .mosi3(spiInterface.mosi3),
                                        .miso0(spiInterface.miso0),
                                        .miso1(spiInterface.miso1),
                                        .miso2(spiInterface.miso2),
                                        .miso3(spiInterface.miso3)
                                        );
  
  bind SpiSlaveMonitorBFM SpiSlaveAssertions SPISLAVEASSERTIONS(.pclk(pclk),
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
  // Setting SpiSlaveDriverBFM and monitor_bfm
  //-------------------------------------------------------
  initial begin

//  if (SLAVE_AGENT_ACTIVE == 1'b1) begin
//    SpiSlaveAgentBFM_h.is_active = UVM_ACTIVE;
    //if(SpiSlaveAgentBFM_h.is_active == UVM_ACTIVE) 
      uvm_config_db#(virtual SpiSlaveDriverBFM)::set(null,"*", "SpiSlaveDriverBFM", spiSlaveDriverBFM); 
//    end

//  else if (SLAVE_AGENT_ACTIVE == 1'b0) begin
//    SpiSlaveAgentBFM_h.is_active = UVM_PASSIVE;
    //else if(SpiSlaveAgentBFM_h.is_active == UVM_PASSIVE)
      uvm_config_db #(virtual SpiSlaveMonitorBFM)::set(null,"*", "SpiSlaveMonitorBFM", spiSlaveMonitorBFM); 
//    end

  end

  initial begin
    $display("Slave Agent BFM");
  end

endmodule : SpiSlaveAgentBFM

`endif
