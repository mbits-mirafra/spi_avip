`ifndef SPIMASTERCOVERAGE_INCLUDED_
`define SPIMASTERCOVERAGE_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiMasterCoverage
// SpiMasterCoverage determines the how much code is covered for better functionality of the TB.
//--------------------------------------------------------------------------------------------
class SpiMasterCoverage extends uvm_subscriber#(SpiMasterTransaction);
  `uvm_component_utils(SpiMasterCoverage)

  // Variable: spiMasterAgentConfig
  // Declaring handle for master agent configuration class 
    SpiMasterAgentConfig spiMasterAgentConfig;
 
  //-------------------------------------------------------
  // Covergroup
  // // TODO(mshariff): Add comments
  // Covergroup consists of the various coverpoints based on the no. of the variables used to improve the coverage.
  //-------------------------------------------------------
  covergroup spiMasterCovergroup with function sample (SpiMasterAgentConfig cfg, SpiMasterTransaction packet);
    option.per_instance = 1;

    // Mode of the operation

    // {cpol,cpha} = operationModesEnum'(cfg.spiMode);
    OPERATION_MODE_CP : coverpoint operationModesEnum'(cfg.spiMode) {
      option.comment = "Operation mode SPI. CPOL and CPHA";
      // TODO(mshariff): 
       bins MODE[] = {[0:3]};
    }

    // Chip-selcet to first SCLK-edge delay
    C2T_DELAY_CP : coverpoint cfg.c2tdelay {
      option.comment = "Delay betwen CS assertion to first SCLK edge";
      // TODO(mshariff): 
       bins DELAY_1 = {1};
       bins DELAY_2 = {2};
       bins DELAY_3 = {3};
       bins DELAY_4_TO_MAX = {[4:MAXIMUM_BITS]};
    
       illegal_bins illegal_bin = {0};
     } 
//     // Chip-selcet to first SCLK-edge delay 
    T2C_DELAY_CP : coverpoint cfg.t2cdelay {
      option.comment = "Delay betwen last SCLK to the CS assertion";
      // TODO(mshariff): 
       bins DELAY_1 = {1};
       bins DELAY_2 = {2};
       bins DELAY_3 = {3};
       bins DELAY_4_TO_MAX = {[4:MAXIMUM_BITS]};
    
     }

    W_DELAY_CP : coverpoint cfg.wdelay {
      option.comment = "Delay between two transfer";
      bins W_DELAY_1 = {1}; 
      bins W_DELAY_2 = {2}; 
      bins W_DELAY_3 = {3}; 
      bins W_DELAY_MAX = {[4:MAXIMUM_BITS]}; 
    } 
   
    
    SHIFTDIRECTIONECTION_CP : coverpoint shiftDirectionEnum'(cfg.shiftDirection) {
      option.comment = "Shift direction SPI. MSB and LSB";
      bins LSB_FIRST = {0};
      bins MSB_FIRST = {1};
    } 
    
    CS_CP : coverpoint packet.cs{
      option.comment = "Chip select assign one slave based on config"; 
      bins SLAVE_0 = {0};
      //bins SLAVE_1 ={1};
      //bins SLAVE_2 ={2};
      //bins SLAVE_3 ={3};
    }
    
    
    MOSI_DATA_TRANSFER_CP : coverpoint packet.masterOutSlaveIn.size()*CHAR_LENGTH {
      option.comment = "Data size of the packet transfer";
      bins TRANSFER_8BIT = {8};
      bins TRANSFER_16BIT = {16};
      bins TRANSFER_24BIT = {24};
      bins TRANSFER_32BIT = {32};
      bins TRANSFER_64BIT = {64};
      bins TRANSFER_MANY_BITS = {[72:MAXIMUM_BITS]};
    } 
   
    
    MISO_DATA_TRANSFER_CP : coverpoint packet.masterInSlaveOut.size()*CHAR_LENGTH {
      option.comment = "Data size of the packet transfer";
      bins TRANSFER_8BIT = {8};
      bins TRANSFER_16BIT = {16};
      bins TRANSFER_24BIT = {24};
      bins TRANSFER_32BIT = {32};
      bins TRANSFER_64BIT = {64};
      bins TRANSFER_MANY_BITS = {[72:MAXIMUM_BITS]};
    } 



    //If the pclk is 10mhz and the baudrate_divisor is 2 then the sclk will be 5mhz.
    
      BAUD_RATE_CP : coverpoint cfg.getBaudrateDivisor() {
      option.comment = "it control the rate of transfer in communication channel";
     
      bins BAUDRATE_DIVISOR_2 = {2}; 
      bins BAUDRATE_DIVISOR_4 = {4}; 
      bins BAUDRATE_DIVISOR_6 = {6}; 
      bins BAUDRATE_DIVISOR_8 = {8}; 
      bins BAUDRATE_DIVISOR_MORE_THAN_10 = {[10:$]}; 

       illegal_bins illegal_bin = {0};

//      // need to add bins for baud rate
//      TODO
//      to have a bins for the baud rate for the 4,6,8,and more
//
    }

    //CROSS OF THE CFG AND THE PACKET WITH MULTIPLE COVERPOINT.
    //Cross of the OPERATION_MODE with and the CS,DATA_WIDTH,masterOutSlaveIn,masterInSlaveOut
    //cross of the operation mode with the all type of the delays
      OPERATION_MODE_CP_X_C2T_DELAY_CP : cross OPERATION_MODE_CP,C2T_DELAY_CP;
      OPERATION_MODE_CP_X_T2C_DELAY_CP : cross OPERATION_MODE_CP,T2C_DELAY_CP;
      OPERATION_MODE_CP_X_W_DELAY_CP : cross OPERATION_MODE_CP,W_DELAY_CP;

      //cross of the mosi_data_trasfer_cp with shift direction and the operation mode  and the delays
      MOSI_DATA_TRANSFER_CP_X_SHIFTDIRECTIONECTION_CP : cross MOSI_DATA_TRANSFER_CP,SHIFTDIRECTIONECTION_CP;
      MOSI_DATA_TRANSFER_CP_X_OPERATION_MODE_CP : cross MOSI_DATA_TRANSFER_CP,OPERATION_MODE_CP;
      //MOSI_DATA_TRANSFER_CP_X_C2T_DELAY_CP_X_T2C_DELAY_CP : cross MOSI_DATA_TRANSFER_CP,C2T_DELAY_CP,T2C_DELAY_CP;
      MOSI_DATA_TRANSFER_CP_X_C2T_DELAY_CP : cross MOSI_DATA_TRANSFER_CP,C2T_DELAY_CP;
      MOSI_DATA_TRANSFER_CP_X_T2C_DELAY_CP : cross MOSI_DATA_TRANSFER_CP,T2C_DELAY_CP;
      MOSI_DATA_TRANSFER_CP_X_W_DELAY_CP : cross MOSI_DATA_TRANSFER_CP,W_DELAY_CP;
      
      //Cross of the mosi_data_transfer_cp with teh baudrate
      MOSI_DATA_TRANSFER_CP_X_BAUD_RATE_CP : cross MOSI_DATA_TRANSFER_CP,BAUD_RATE_CP;
    
      //cross of the cs_cp with mosi_data_transfer_cp, shiftDirectionection, operation_modeand the delays
      CS_CP_X_MOSI_DATA_TRANSFER_CP : cross CS_CP,MOSI_DATA_TRANSFER_CP;
      CS_CP_X_SHIFTDIRECTIONECTION_CP : cross CS_CP,SHIFTDIRECTIONECTION_CP;
      CS_CP_X_OPERATION_MODE_CP : cross CS_CP,OPERATION_MODE_CP;
      //CS_CP_X_C2T_DELAY_CP_X_T2C_DELAY_CP_X_W_DELAY_CP : cross CS_CP,C2T_DELAY_CP,T2C_DELAY_CP,W_DELAY_CP;
      CS_CP_X_T2C_DELAY_CP : cross CS_CP,T2C_DELAY_CP;
      CS_CP_X_C2T_DELAY_CP : cross CS_CP,C2T_DELAY_CP;
      CS_CP_X_W_DELAY_CP : cross CS_CP,W_DELAY_CP;
    

  endgroup : spiMasterCovergroup

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiMasterCoverage", uvm_component parent = null);
  extern virtual function void display();
  extern virtual function void write(SpiMasterTransaction t);
  extern virtual function void report_phase(uvm_phase phase);

endclass : SpiMasterCoverage

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - SpiMasterCoverage
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiMasterCoverage::new(string name = "SpiMasterCoverage", uvm_component parent = null);
  super.new(name, parent);
  // TODO(mshariff): Create the covergroup
     spiMasterCovergroup = new(); 
endfunction : new

//--------------------------------------------------------------------------------------------
// HAVING THE DISPLAY STATEMENTS
//--------------------------------------------------------------------------------------------
function void  SpiMasterCoverage::display(); 
  
  $display("");
  $display("--------------------------------------");
  $display("MASTER COVERAGE");
  $display("--------------------------------------");
  $display("");

endfunction : display
//--------------------------------------------------------------------------------------------
// Function: write
// // TODO(mshariff): Add comments
// To acess the subscriber write function is required with default parameter as t
//--------------------------------------------------------------------------------------------
function void SpiMasterCoverage::write(SpiMasterTransaction t);
//  // TODO(mshariff):
  
  `uvm_info("MUNEEB_DEBUG", $sformatf("Config values = %0s", spiMasterAgentConfig.sprint()), UVM_HIGH);
//sampling for the covergroup is started over here
   spiMasterCovergroup.sample(spiMasterAgentConfig,t);     

endfunction: write

//--------------------------------------------------------------------------------------------
// Function: report_phase
// Used for reporting the coverage instance percentage values
//--------------------------------------------------------------------------------------------
function void SpiMasterCoverage::report_phase(uvm_phase phase);
 
  display();
  `uvm_info(get_type_name(), $sformatf("Master Agent Coverage = %0.2f %%",spiMasterCovergroup.get_coverage()), UVM_NONE);
//  `uvm_info(get_type_name(), $sformatf("Master Agent Coverage") ,UVM_NONE);
endfunction: report_phase
`endif

