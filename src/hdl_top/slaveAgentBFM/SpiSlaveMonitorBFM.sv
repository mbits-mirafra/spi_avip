`ifndef SPISLAVEMONITORBFM_INCLUDED_
`define SPISLAVEMONITORBFM_INCLUDED_

//--------------------------------------------------------------------------------------------
// Inteface : Slave Monitor BFM
// Connects the slave monitor bfm with the monitor proxy
// to call the tasks and functions from monitor bfm to monitor proxy
//--------------------------------------------------------------------------------------------

import SpiGlobalsPkg::*;
interface SpiSlaveMonitorBFM(input pclk, 
                             input areset, 
                             input sclk, 
                             input cs, 
                             input mosi0, mosi1, mosi2, mosi3,
                             input miso0, miso1, miso2, miso3);

  // To indicate the end of transfer when CS is de-asserted (0->1)                           
  bit endOfTransfer;

  //-------------------------------------------------------
  // 
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  //-------------------------------------------------------
  // Package : Importing SPI Global Package and SPI Slave Package
  //-------------------------------------------------------
  import SpiSlavePkg::*;

  //Variable : spiSlaveMonitorProxy
  // Creating the handle for proxy driver
  SpiSlaveMonitorProxy spiSlaveMonitorProxy;

  initial begin
    $display("Slave Monitor BFM");
  end

  //-------------------------------------------------------
  // Task: waitForSystemReset
  // Waiting for system reset to be active
  //-------------------------------------------------------
  task waitForSystemReset();
    @(negedge areset);
    `uvm_info("SpiSlaveMonitorBFM", $sformatf("System reset detected"), UVM_HIGH);
    @(posedge areset);
    `uvm_info("SpiSlaveMonitorBFM", $sformatf("System reset deactivated"), UVM_HIGH);
  endtask: waitForSystemReset

  //-------------------------------------------------------
  // Task: waitForIdleState
  // Waits for the IDLE condition on SPI interface
  //-------------------------------------------------------
  task waitForIdleState();
    @(negedge pclk);

    while (cs !== 1'b1) begin
      @(negedge pclk);
    end

    `uvm_info("SpiSlaveMonitorBFM", $sformatf("IDLE condition has been detected"), UVM_NONE);
  endtask: waitForIdleState

  //-------------------------------------------------------
  // Task: waitForTransferStart
  // Waits for the CS to be active-low
  //-------------------------------------------------------
  task waitForTransferStart();
    // 2bit shift register to check the edge on CS
    bit [1:0] csLocal;

    // Detect the falling edge on CS
    do begin
      @(negedge pclk);
      csLocal = {csLocal[0], cs};
    end while(csLocal != NEGEDGE);

    `uvm_info("SpiSlaveMonitorBFM", $sformatf("Transfer start is detected"), UVM_NONE);
  endtask: waitForTransferStart

  //-------------------------------------------------------
  // Task: datectSclk
  // Detects the edge on sclk with regards to pclk
  //-------------------------------------------------------
  task datectSclk();
    // 2bit shift register to check the edge on sclk
    bit [1:0] sclkLocal;
    bit [1:0] csLocal;
    edgeDetectEnum sclkEdgeValue;

    // Detect the edge on SCLK
    do begin

      @(negedge pclk);
      sclkLocal = {sclkLocal[0], sclk};
      endOfTransfer = 0;

      // Check for premature CS 
      // Stop the transfer when the CS is active-high
      csLocal = {csLocal[0], cs};
      if(csLocal == POSEDGE) begin
        `uvm_info("SpiSlaveMonitorBFM", $sformatf("End of Transfer Detected"), UVM_NONE);
        endOfTransfer = 1;
        return;
      end

    end while(! ((sclkLocal == POSEDGE) || (sclkLocal == NEGEDGE)) );

    sclkEdgeValue = edgeDetectEnum'(sclkLocal);
    `uvm_info("SpiSlaveMonitorBFM", $sformatf("SCLK %s detected", sclkEdgeValue.name()), UVM_FULL);
  
  endtask: datectSclk

  //-------------------------------------------------------
  // Task: sampleData
  // Used for sampling the MOSI and MISO data
  //-------------------------------------------------------
  task sampleData(output spiTransferPacketStruct dataPacket, input spiConfigPacketStruct configPacket);
    int rowNumber;

    // Reset the counter values
    dataPacket.noOFMOSIBitsTransfer = 0;
    dataPacket.noOfMISOBitsTransfer = 0;

    // Sampling of MISO data and MOSI data 
    // with respect to master's SCLK
    //
    // This loop is forever because the monitor will continue to operate 
    // till the CS is active-low
    forever begin

      for(int k=0, bit_no=0; k<CHAR_LENGTH; k++) begin

        // Logic for MSB first or LSB first 
        bit_no = configPacket.msbFirst ? ((CHAR_LENGTH - 1) - k) : k;

        if(configPacket.cpha == 0) begin : CPHA_IS_0

          // Sampling MOSI, MISO at negedge of sclk for CPOL=0 and CPHA=0  OR
          // Sampling MOSI, MISO at posedge of sclk for CPOL=1 and CPHA=0
          //
          // First edge is used for driving
          datectSclk();
          if(endOfTransfer) break; 

          // Second edge is used for sampling
          datectSclk();
          if(endOfTransfer) break; 

          dataPacket.masterOutSlaveIn[rowNumber][bit_no] = mosi0;
          dataPacket.noOFMOSIBitsTransfer++;

          dataPacket.masterInSlaveOut[rowNumber][bit_no] = miso0;
          dataPacket.noOfMISOBitsTransfer++;
        end
        else begin : CPHA_IS_1

          // Sampling MOSI, MISO at posedge of sclk for CPOL=0 and CPHA=1  OR
          // Sampling MOSI, MISO at negedge of sclk for CPOL=1 and CPHA=1
          datectSclk();
          if(endOfTransfer) break; 

          dataPacket.masterOutSlaveIn[rowNumber][bit_no] = mosi0;
          dataPacket.noOFMOSIBitsTransfer++;

          dataPacket.masterInSlaveOut[rowNumber][bit_no] = miso0;
          dataPacket.noOfMISOBitsTransfer++;

          datectSclk();
          if(endOfTransfer) break; 
        
        end

      end

      // Incrementing the row number
      rowNumber++;

      // break will come out of inner-most loop
      // This work-around is used to come out of the nested loop
      if(endOfTransfer) begin 
        endOfTransfer = 0;
        rowNumber = 0; 
        break; 
      end

    end
    
  endtask: sampleData

//  bind SpiSlaveMonitorBFM slave_assertions slave_assertions_h(.pclk(pclk),
//                                                             .cs(cs),
//                                                             .areset(areset),
//                                                             .sclk(sclk),
//                                                             .mosi0(mosi0),
//                                                             .mosi1(mosi1),
//                                                             .mosi2(mosi2),
//                                                             .mosi3(mosi3),
//                                                             .miso0(miso0),
//                                                             .miso1(miso1),
//                                                             .miso2(miso2),
//                                                             .miso3(miso3)); 

endinterface : SpiSlaveMonitorBFM

`endif
