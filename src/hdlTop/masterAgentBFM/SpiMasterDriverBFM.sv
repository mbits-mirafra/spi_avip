`ifndef SPIMASTERDRIVERBFM_INCLUDED_
`define SPIMASTERDRIVERBFM_INCLUDED_

//--------------------------------------------------------------------------------------------
//Interface : SpiMasterDriverBFM
//Used as the HDL driver for SPI
//It connects with the HVL driver_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
import SpiGlobalsPkg::*;
interface SpiMasterDriverBFM(input pclk, input areset, 
                             output reg sclk, 
                             output reg [NO_OF_SLAVES-1:0]cs, 
                             output reg mosi0, mosi1, mosi2, mosi3,
                             input miso0, miso1, miso2, miso3
                           );
  //-------------------------------------------------------
  // Importing UVM Package 
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh" 
  //-------------------------------------------------------
  // Importing SPI Global Package and Slave package
  //-------------------------------------------------------
  import SpiMasterPkg::SpiMasterDriverProxy;

  //--------------------------------------------------------------------------------------------
  // Creating handle for virtual Interface
  //--------------------------------------------------------------------------------------------
  // virtual spi_if v_intf;
 
  //Variable : spiMasterDriverProxy
  //Creating the handle for proxy driver
  SpiMasterDriverProxy spiMasterDriverProxy;

  initial begin
    $display("Master driver BFM");
  end

  //-------------------------------------------------------
  // Task: waitForReset
  // Waiting for system reset to be active
  //-------------------------------------------------------
  task waitForReset();
    @(negedge areset);
    `uvm_info("SpiMasterDriverBFM", $sformatf("System reset detected"), UVM_HIGH);
    @(posedge areset);
    `uvm_info("SpiMasterDriverBFM", $sformatf("System reset deactivated"), UVM_HIGH);
  endtask: waitForReset

  //-------------------------------------------------------
  // Task: driveIdleState 
  // This task drives the SPI interface to it's IDLA state
  //
  // Parameters:
  //  cpol - Clock polarity of sclk
  //  idleStateTime - Time(in terms od pclk) for which the IDLE state will be maintained
  //-------------------------------------------------------
  task driveIdleState(bit cpol, int idleStateTime=1);

    @(posedge pclk);

    `uvm_info("SpiMasterDriverBFM", $sformatf("Driving the IDLE state"), UVM_HIGH);
    sclk <= cpol;
    // TODO(mshariff):
    // Use of replication operator 
    // cs <= 'b1;
    // cs   <= NO_OF_SLAVES{1};
    cs <= 'b1;

    repeat(idleStateTime) begin
      @(posedge pclk);
    end
  endtask: driveIdleState

  //-------------------------------------------------------
  // Task: waitForIdleState
  // Waits for the IDLE condition on SPI interface
  //-------------------------------------------------------
  task waitForIdleState();
    @(negedge pclk);

    // TODO(mshariff): Need to modify this code for more slave
    while (cs !== 'b1)
      @(negedge pclk);

    `uvm_info("SpiMasterDriverBFM", $sformatf("IDLE condition has been detected"), UVM_HIGH);
  endtask: waitForIdleState

  //-------------------------------------------------------
  // Task: driveSclk
  // Used for generating the sclk with regards to baudrate 
  //-------------------------------------------------------
  task driveSclk(int delay);
    @(posedge pclk);
    sclk <= ~sclk;

    repeat(delay - 1) begin
      @(posedge pclk);
      sclk <= ~sclk;
    end
  endtask: driveSclk
 
  //-------------------------------------------------------
  // Task: driveMsbFirstPosedge
  // TODO(mshariff): Modify the task name and the comments
  //-------------------------------------------------------
  task driveMsbFirstPosedge(inout spiTransferPacketStruct masterPacketStruct, 
                            input spiTransferConfigStruct masterConfigStruct); 

    //`uvm_info("CS VALUE IN SpiMasterDriverBFM",$sformatf("masterPacketStruct.cs = \n %s",masterPacketStruct.cs),UVM_LOW)
    //`uvm_info("MOSI VALUE IN SpiMasterDriverBFM",$sformatf("masterPacketStruct.mosi = \n %s",masterPacketStruct.masterOutSlaveIn),UVM_LOW)
    // Asserting CS and driving sclk with initial value
    `uvm_info("SpiMasterDriverBFM", $sformatf("Transfer start is detected"), UVM_NONE);
    @(posedge pclk);
    cs <= masterPacketStruct.cs; 
    sclk <= masterConfigStruct.cpol;
 
    // Generate C2T delay
    // Delay between negedge of CS to posedge of sclk
    repeat((masterConfigStruct.c2t * masterConfigStruct.baudrateDivisor) - 1) begin
      @(posedge pclk);
    end
    `uvm_info("DEBUG MOSI CPHA SpiMasterDriverBFM",$sformatf("mosi (8bits) =8'h%0x",masterPacketStruct.masterOutSlaveIn[0]),UVM_HIGH)

    // Driving CS, sclk and MOSI
    // and sampling MISO
    for(int rowNumber=0; rowNumber<masterPacketStruct.noOfMosiBitsTransfer/CHAR_LENGTH; rowNumber++) begin

      for(int k=0, bitNumber=0; k<CHAR_LENGTH; k++) begin

        // Logic for MSB first or LSB first 
        bitNumber = masterConfigStruct.msbFirst ? ((CHAR_LENGTH - 1) - k) : k;

        if(masterConfigStruct.cpha == 0) begin : CPHA_IS_0

          // Driving MOSI at posedge of sclk for CPOL=0 and CPHA=0  OR
          // Driving MOSI at negedge of sclk for CPOL=1 and CPHA=0
          driveSclk(masterConfigStruct.baudrateDivisor/2);

          // For simple SPI
          // MSHA: mosi0 <= masterPacketStruct.data[B0];
          // mosi0 <= masterPacketStruct.data[i];
          //`uvm_info("MOSI VALUE IN SpiMasterDriverBFM",$sformatf("mosi[i]=%d",masterPacketStruct.masterOutSlaveIn[0]),UVM_LOW)
          mosi0 <= masterPacketStruct.masterOutSlaveIn[rowNumber][bitNumber];
          // MSHA: `uvm_info("DEBUG MOSI VALUE IN SpiMasterDriverBFM",$sformatf("mosi[i]=%d",masterPacketStruct.masterOutSlaveIn[i]),UVM_HIGH)

          // Sampling MISO at negedge of sclk for CPOL=0 and CPHA=0  OR
          // Sampling MISO at posedge of sclk for CPOL=1 and CPHA=0
          driveSclk(masterConfigStruct.baudrateDivisor/2);
          //masterPacketStruct.miso[i] = miso0;
          masterPacketStruct.masterInSlaveOut[rowNumber][bitNumber] = miso0;
          masterPacketStruct.noOfMisoBitsTransfer++;
        end
        else begin : CPHA_IS_1
          // Data is output half-cycle before the first rising edge of SCLK
          // MSHA: mosi0 <= masterConfigStruct.msbFirst ? masterPacketStruct.masterOutSlaveIn[0][CHAR_LENGTH - 1] :  masterPacketStruct.masterOutSlaveIn[0][0];

          // When CPHA==1, the MISO is driven half-cycle(sclk) before first edge of sclk
          //
          // Driving MOSI at negedge of sclk for CPOL=0 and CPHA=1  OR
          // Driving MOSI at posedge of sclk for CPOL=1 and CPHA=1
          mosi0 <= masterPacketStruct.masterOutSlaveIn[rowNumber][bitNumber];
          `uvm_info("DEBUG MOSI CPHA SpiMasterDriverBFM",$sformatf("mosi[%0d][%0d]=%0b",
                    rowNumber, k,
                    masterPacketStruct.masterOutSlaveIn[rowNumber][bitNumber]),UVM_HIGH)

          // Sampling MISO at posedge of sclk for CPOL=0 and CPHA=1  OR
          // Sampling MISO at negedge of sclk for CPOL=1 and CPHA=1
          driveSclk(masterConfigStruct.baudrateDivisor/2);
          //masterPacketStruct.miso[i] = miso0;
          masterPacketStruct.masterInSlaveOut[rowNumber][bitNumber] = miso0;
          masterPacketStruct.noOfMisoBitsTransfer++;

          // Driving the sclk 
          driveSclk(masterConfigStruct.baudrateDivisor/2);
          // For simple SPI
          // MSHA: mosi0 <= masterPacketStruct.data[B0];
          // mosi0 <= masterPacketStruct.data[i];
          // 
          // Since first bit in CPHA=1 is driven at CS=0, 
          // we don't have to drive the last bit twice
          // MSHA: if( ((rowNumber+1) * (bitNumber+1)) != masterPacketStruct.noOfMosiBitsTransfer) begin
          // MSHA:   int rowNumber_local, k_local;
          // MSHA:   rowNumber_local = rowNumber + ((bitNumber + 1) % CHAR_LENGTH);
          // MSHA:   k_local = (bitNumber + 1) / CHAR_LENGTH;
          // MSHA:   mosi0 <= masterPacketStruct.masterOutSlaveIn[rowNumber_local][k_local];
          // MSHA:   `uvm_info("DEBUG MOSI CPHA SpiMasterDriverBFM",$sformatf("mosi[%0d][%0d]=%0b",
          // MSHA:             rowNumber_local, k_local,
          // MSHA:             masterPacketStruct.masterOutSlaveIn[rowNumber_local][k_local]),UVM_LOW)
          // MSHA: end
        end
      end
    end

    // Generate T2C delay
    // Delay between last edge of SLCK to posedge of CS
    repeat(masterConfigStruct.t2c * masterConfigStruct.baudrateDivisor) begin
      @(posedge pclk);
    end

    // TODO(mshariff): Make it work for more slaves
    // CS is de-asserted
    cs <= 'b1;

    // Generates WDELAY
    // Delay between 2 transfers 
    // This is the time for which CS is de-asserted between the transfers 
    //
    // We are having one pclk less because when the next transfer comes,
    // then the posedg_pclk delay is added at the start of this task
    repeat((masterConfigStruct.wdelay * masterConfigStruct.baudrateDivisor) - 1) begin
      @(posedge pclk);
    end
    
  endtask: driveMsbFirstPosedge

endinterface : SpiMasterDriverBFM
`endif
