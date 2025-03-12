`ifndef SPIMASTERMONITORBFM_INCLUDED_
`define SPIMASTERMONITORBFM_INCLUDED_

//--------------------------------------------------------------------------------------------
// Inteface : Master Monitor BFM
// Connects the master monitor bfm with the monitor proxy
//--------------------------------------------------------------------------------------------
import SpiGlobalsPkg::*;

interface SpiMasterMonitorBFM(input pclk, input areset, 
                              input sclk, 
                              input [NO_OF_SLAVES-1:0] cs, 
                              input mosi0, mosi1, mosi2, mosi3,
                              input miso0, miso1, miso2, miso3
                            );

  // To indicate the end of transfer when CS is de-asserted (0->1)                           
  bit endOfTransfer;

  //-------------------------------------------------------
  // Package : Importing UVM package and including macros file 
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  //-------------------------------------------------------
  // Package : Importing SPI Global Package and SPI Master Package
  //-------------------------------------------------------
  import SpiMasterPkg::*;

  import SpiMasterPkg::SpiMasterMonitorProxy;
  
  //Variable : spiMasterMonitorProxy
  //Creating the handle for proxy driver
  SpiMasterMonitorProxy spiMasterMonitorProxy;
  
  initial begin
    $display("Master Monitor BFM");
  end

  //-------------------------------------------------------
  // Task: waitForSystemReset
  // Waiting for system reset to be active
  //-------------------------------------------------------
  task waitForSystemReset();
    @(negedge areset);
    `uvm_info("SpiMasterMonitorBFM", $sformatf("System reset detected"), UVM_HIGH);
    @(posedge areset);
    `uvm_info("SpiMasterMonitorBFM", $sformatf("System reset deactivated"), UVM_HIGH);
  endtask: waitForSystemReset

  //-------------------------------------------------------
  // Task: waitForIdleState
  // Waits for the IDLE condition on SPI interface
  //-------------------------------------------------------
  task waitForIdleState();
    @(negedge pclk);

    while (cs !== 'b1) begin
      @(negedge pclk);
    end

    `uvm_info("SpiMasterMonitorBFM", $sformatf("IDLE condition has been detected"), UVM_NONE);
  endtask: waitForIdleState

  //-------------------------------------------------------
  // Task: waitForTransferStart
  // Waits for the CS to be active-low
  //-------------------------------------------------------
  // TODO(mshariff): Need to work for multiple slaves
  task waitForTransferStart();
    // 2bit shift register to check the edge on CS
    bit [1:0] csLocal;
    // MSHA: bit [NO_OF_SLAVES-1:0][1:0] csLocal;

    // Detect the falling edge on CS
    do begin
      @(negedge pclk);
      csLocal = {csLocal[0], cs};
    end while(csLocal != NEGEDGE);

    `uvm_info("SpiMasterMonitorBFM", $sformatf("Transfer start is detected"), UVM_NONE);
  endtask: waitForTransferStart

  //-------------------------------------------------------
  // Task: detectSclk
  // Detects the edge on sclk with regards to pclk
  //-------------------------------------------------------
  task detectSclk();
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
        `uvm_info("SpiMasterMonitorBFM", $sformatf("End of Transfer Detected"), UVM_NONE);
        endOfTransfer = 1;
        return;
      end

    end while(! ((sclkLocal == POSEDGE) || (sclkLocal == NEGEDGE)) );

    sclkEdgeValue = edgeDetectEnum'(sclkLocal);
    `uvm_info("SpiMasterMonitorBFM", $sformatf("SCLK %s detected", sclkEdgeValue.name()),UVM_FULL);
  
  endtask: detectSclk

  //-------------------------------------------------------
  // Task: sampleData
  // Used for sampling the MOSI and MISO data
  //-------------------------------------------------------
  task sampleData(output spiTransferPacketStruct masterPacketStruct, input spiTransferConfigStruct masterConfigStruct);
    int rowNumber;

    // Reset the counter values
    masterPacketStruct.noOfMosiBitsTransfer = 0;
    masterPacketStruct.noOfMisoBitsTransfer = 0;

    // Sampling of MISO data and MOSI data 
    // with respect to master's SCLK
    //
    // This loop is forever because the monitor will continue to operate 
    // till the CS is active-low
    forever begin

      for(int k=0, bitNumber=0; k<CHAR_LENGTH; k++) begin

        // Logic for MSB first or LSB first 
        bitNumber = masterConfigStruct.msbFirst ? ((CHAR_LENGTH - 1) - k) : k;

        if(masterConfigStruct.cpha == 0) begin : CPHA_IS_0

          // Sampling MOSI, MISO at negedge of sclk for CPOL=0 and CPHA=0  OR
          // Sampling MOSI, MISO at posedge of sclk for CPOL=1 and CPHA=0
          //
          // First edge is used for driving
          detectSclk();
          if(endOfTransfer) break; 

          // Second edge is used for sampling
          detectSclk();
          if(endOfTransfer) break; 

          masterPacketStruct.masterOutSlaveIn[rowNumber][bitNumber] = mosi0;
          masterPacketStruct.noOfMosiBitsTransfer++;

          masterPacketStruct.masterInSlaveOut[rowNumber][bitNumber] = miso0;
          masterPacketStruct.noOfMisoBitsTransfer++;

          masterPacketStruct.cs = cs;
        end
        else begin : CPHA_IS_1

          // Sampling MOSI, MISO at posedge of sclk for CPOL=0 and CPHA=1  OR
          // Sampling MOSI, MISO at negedge of sclk for CPOL=1 and CPHA=1
          detectSclk();
          if(endOfTransfer) break; 

          masterPacketStruct.masterOutSlaveIn[rowNumber][bitNumber] = mosi0;
          masterPacketStruct.noOfMosiBitsTransfer++;

          masterPacketStruct.masterInSlaveOut[rowNumber][bitNumber] = miso0;
          masterPacketStruct.noOfMisoBitsTransfer++;

          masterPacketStruct.cs = cs;

          detectSclk();
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

endinterface : SpiMasterMonitorBFM

`endif
