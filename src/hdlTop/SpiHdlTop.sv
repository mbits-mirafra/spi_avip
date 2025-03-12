`ifndef SPIHDLTOP_INCLUDED_
`define SPIHDLTOP_INCLUDED_

//--------------------------------------------------------------------------------------------
// Module      : HDL Top
// Description : Has a interface and slave agent bfm.
//--------------------------------------------------------------------------------------------

module SpiHdlTop;

  //-------------------------------------------------------
  // Clock Reset Initialization
  //-------------------------------------------------------
  bit clk;
  bit rst;

  //-------------------------------------------------------
  // Display statement for SpiHdlTop
  //-------------------------------------------------------
  initial begin
    $display("SpiHdlTop");
  end

  //-------------------------------------------------------
  // System Clock Generation
  //-------------------------------------------------------
  initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
  end

  //-------------------------------------------------------
  // System Reset Generation
  // Active low reset
  //-------------------------------------------------------
  initial begin
    rst = 1'b1;

    repeat (2) begin
      @(posedge clk);
    end
    rst = 1'b0;

    repeat (2) begin
      @(posedge clk);
    end
    rst = 1'b1;
  end
  
  // Variable : spiInterface
  // SPI Interface Instantiation
  SpiInterface spiInterface(.pclk(clk),
                            .areset(rst));
  
  // Variable : spiSlaveAgentBFM
  // SPI Slave BFM Agent Instantiation
  SpiSlaveAgentBFM spiSlaveAgentBFM(spiInterface);

  // Variable : spiMasterAgentBFM
  //SPI Master BFM Agent Instantiation 
  SpiMasterAgentBFM spiMasterAgentBFM(spiInterface); 

  // Waveform dump for Cadence simulator
  // For Questa the makefile will generate the waveforms (.wlf)
/*  initial begin
    `ifdef WAVES_OFF
     `else
       string path_to_waveform;
       reg [2047:0] path_to_waveform_reg;

       if($value$plusargs("WAVEFORM_PATH=%s", path_to_waveform)) begin
         // The simulator will not support the string as input to shm_open system task.
         // To mitigate this you need to send reg variable to shm_open
         path_to_waveform_reg = reg'(path_to_waveform);
         end
       else path_to_waveform = "waves.shm";

       $shm_probe("AS");
     `endif
   end
   */

endmodule : SpiHdlTop

`endif

