`ifndef SPISLAVEDRIVERBFM_INCLUDED_
`define SPISLAVEDRIVERBFM_INCLUDED_

//--------------------------------------------------------------------------------------------
// Interface : SpiSlaveDriverBFM
// Used as the HDL driver for SPI
// It connects with the HVL driver_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
//-------------------------------------------------------
// Importing SPI Global Package
//-------------------------------------------------------
import SpiGlobalsPkg::*;

interface SpiSlaveDriverBFM(input pclk, 
                            input areset, 
                            input sclk, 
                            input cs, 
                            input mosi0, mosi1, mosi2, mosi3, 
                            output reg miso0, miso1, miso2, miso3);
 
  // To indicate the end of transfer when CS is de-asserted (0->1)                           
  bit endOfTransfer;

  // Importing SPI Slave Package
  import SpiSlavePkg::*;
  

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  //--------------------------------------------------------------------------------------------
  // Creating handle for virtual Interface
  //--------------------------------------------------------------------------------------------
  // virtual spi_if v_intf;
  
  // Variable : SpiSlaveDriverProxy
  // Creating the handle for proxy driver
  SpiSlaveDriverProxy spiSlaveDriverProxy;
  
  initial begin
    $display("Slave Driver BFM");
  end

  //-------------------------------------------------------
  // Task: waitForSystemReset
  // Waiting for system reset to be active
  //-------------------------------------------------------
  task waitForSystemReset();
    @(negedge areset);
    `uvm_info("SpiSlaveDriverBFM", $sformatf("System reset detected"), UVM_HIGH);
    @(posedge areset);
    `uvm_info("SpiSlaveDriverBFM", $sformatf("System reset deactivated"), UVM_HIGH);
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

    `uvm_info("SpiSlaveDriverBFM", $sformatf("IDLE condition has been detected"), UVM_NONE);
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

    `uvm_info("SpiSlaveDriverBFM", $sformatf("Transfer start is detected"), UVM_NONE);
  endtask: waitForTransferStart

  //-------------------------------------------------------
  // Task: driveMisoData
  //-------------------------------------------------------
  // TODO(mshariff): Reconsider the logic with different baudrates
  task driveMisoData (inout spiTransferPacketStruct slavePacketStruct,
                      input spiTransferConfigStruct slaveConfigStruct);
    int rowNumber;
    // reseting the no_of_miso_bits inorder to get the required count of miso data
    slavePacketStruct.noOfMisoBitsTransfer = 0;

    `uvm_info("DEBUG MOSI CPHA SpiSlaveDriverBFM",$sformatf("miso(8bits)=8'h%0x",slavePacketStruct.masterInSlaveOut[0]),UVM_HIGH)

    // Driving of MISO data and sampling of MOSI data 
    // with respect to master's SCLK
    //
    // This loop is forever because the slave will continue to operate 
    // till the CS is active-low
    forever begin

      for(int k=0, bit_no=0; k<CHAR_LENGTH; k++) begin

        // Logic for MSB first or LSB first 
        bit_no = slaveConfigStruct.msbFirst ? ((CHAR_LENGTH - 1) - k) : k;

        if(slaveConfigStruct.cpha == 0) begin : CPHA_IS_0

          // Driving MISO at posedge of sclk for CPOL=0 and CPHA=0  OR
          // Driving MISO at negedge of sclk for CPOL=1 and CPHA=0
          datectSclk();
          if(endOfTransfer) break; 
          miso0 <= slavePacketStruct.masterInSlaveOut[rowNumber][bit_no];
          slavePacketStruct.noOfMisoBitsTransfer++;
          `uvm_info("DEBUG MOSI0 SpiSlaveDriverBFM",$sformatf("miso=\n %0p",miso0),UVM_HIGH)
          `uvm_info("DEBUG MISO TRANSFER COUNT SpiSlaveDriverBFM",$sformatf("miso count=\n %0p",
          slavePacketStruct.noOfMisoBitsTransfer),UVM_HIGH)

          // Sampling MOSI at negedge of sclk for CPOL=0 and CPHA=0  OR
          // Sampling MOSI at posedge of sclk for CPOL=1 and CPHA=0
          datectSclk();
          if(endOfTransfer) break; 
          slavePacketStruct.masterOutSlaveIn[rowNumber][bit_no] = mosi0;
          slavePacketStruct.noOfMosiBitsTransfer++;
        end
        else begin : CPHA_IS_1

          // When CPHA==1, the MISO is driven half-cycle(sclk) before first edge of sclk
          //
          // Driving MISO at negedge of sclk for CPOL=0 and CPHA=1  OR
          // Driving MISO at posedge of sclk for CPOL=1 and CPHA=1
          miso0 <= slavePacketStruct.masterInSlaveOut[rowNumber][bit_no];
          slavePacketStruct.noOfMisoBitsTransfer++;

          datectSclk();
          if(endOfTransfer) break; 

          // Sampling MOSI at posedge of sclk for CPOL=0 and CPHA=1  OR
          // Sampling MOSI at negedge of sclk for CPOL=1 and CPHA=1
          datectSclk();
          if(endOfTransfer) break; 
          slavePacketStruct.masterOutSlaveIn[rowNumber][bit_no] = mosi0;
          slavePacketStruct.noOfMosiBitsTransfer++;
        
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
    
  endtask: driveMisoData

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
        `uvm_info("SpiSlaveDriverBFM", $sformatf("End of Transfer Detected"), UVM_NONE);
        endOfTransfer = 1;
        return;
      end

    end while(! ((sclkLocal == POSEDGE) || (sclkLocal == NEGEDGE)) );

    sclkEdgeValue = edgeDetectEnum'(sclkLocal);
    `uvm_info("SpiSlaveDriverBFM", $sformatf("SCLK %s detected", sclkEdgeValue.name()), UVM_FULL);
  
  endtask: datectSclk

endinterface : SpiSlaveDriverBFM

`endif

