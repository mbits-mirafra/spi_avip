`ifndef SPISLAVEMONITORPROXY_INCLUDED_
`define SPISLAVEMONITORPROXY_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class: SpiSlaveMonitorProxy
// This is the HVL slave monitor proxy
// It gets the sampled data from the HDL slave monitor and 
// converts them into transaction items
//--------------------------------------------------------------------------------------------
class SpiSlaveMonitorProxy extends uvm_monitor;
  `uvm_component_utils(SpiSlaveMonitorProxy)

  //Declaring Monitor Analysis Import
  uvm_analysis_port #(SpiSlaveTransaction) spiSlaveAnalysisPort;
  
  //Declaring Virtual Monitor BFM Handle
  virtual SpiSlaveMonitorBFM spiSlaveMonitorBFM;
    
  // Variable: spiSlaveAgentConfig;
  // Handle for slave agent configuration
  SpiSlaveAgentConfig spiSlaveAgentConfig;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSlaveMonitorProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  // MSHA: extern virtual task sample_from_bfm(SpiSlaveTransaction packet);
  //extern virtual task read_from_bfm(spiTransferPacketStruct packet);
  extern virtual function void resetDetected();
  extern virtual task read(spiTransferPacketStruct dataPacket);

endclass : SpiSlaveMonitorProxy
                                                          
//--------------------------------------------------------------------------------------------
//  Construct: new
//  Parameters:
//  name - SpiSlaveMonitorProxy
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSlaveMonitorProxy::new(string name = "SpiSlaveMonitorProxy",uvm_component parent = null);
  super.new(name, parent);

 spiSlaveAnalysisPort = new("spiSlaveAnalysisPort",this);

endfunction : new

//--------------------------------------------------------------------------------------------
//  Function: build_phase
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiSlaveMonitorProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!uvm_config_db#(virtual SpiSlaveMonitorBFM)::get(this,"","SpiSlaveMonitorBFM",spiSlaveMonitorBFM)) begin
     `uvm_fatal("FATAL_SMP_MON_BFM",$sformatf("Couldn't get S_MON_BFM in SpiSlaveMonitorProxy"));  
  end 
  //spiSlaveAnalysisPort = new("spiSlaveAnalysisPort",this);

  // MSHA: if(!uvm_config_db#(SpiSlaveAgentConfig)::get(this,"","SpiSlaveAgentConfig",spiSlaveAgentConfig)) begin
  // MSHA:   `uvm_fatal("FATAL_S_AGENT_CFG",$sformatf("Couldn't get S_AGENT_CFG in SpiSlaveMonitorProxy"));
  // MSHA: end

endfunction : build_phase


//--------------------------------------------------------------------------------------------
//  Function: connect_phase
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
/*function void SpiSlaveMonitorProxy::connect_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual SpiSlaveMonitorBFM)::get(this,"","SpiSlaveMonitorBFM",spiSlaveMonitorBFM)) begin
     `uvm_fatal("FATAL_SMP_MON_BFM",$sformatf("Couldn't get SLAVE_MON_BFM in SpiSlaveMonitorProxy"));  
   end 
  //spiSlaveAnalysisPort = new("spiSlaveAnalysisPort",this);
  
endfunction : connect_phase
*/
//--------------------------------------------------------------------------------------------
//  Task: run_phase
//  Calls tasks defined in SpiSlaveMonitorBFM 
//--------------------------------------------------------------------------------------------
//task SpiSlaveMonitorProxy::run_phase(uvm_phase phase);
//  `uvm_info(get_type_name(), $sformatf("Inside the SpiSlaveMonitorProxy"), UVM_LOW)
//  
////  Will be using this when transaction object in connected
////  forever begin 
//
////  end
//  
//  repeat(1) begin
//    
//    //Variable : CPOL
//    //Clock Polarity 
//    bit CPOL=0;
//    
//    //Signal : CPHA
//    //Clock Phase
//    bit CPHA=0;
//    
//    //Signal : Mosi
//    //Master-in Slave-Out
////    bit mosi;
//
//    //Signal : Miso
//    //Master-in Slave-out
//    bit miso;
//    
//    //Signal : CS
//    //Chip Select
////    bit cs;
//    
//    //-------------------------------------------------------
//    // Calling the tasks from monitor bfm
//    //-------------------------------------------------------
//    read_from_mon_bfm(CPOL,CPHA,mosi);    
//  end
//
//endtask : run_phase 
//
//
////:browse confirm wa
////-------------------------------------------------------
//// Task : read_from_mon_bfm
//// Used to call the tasks from moitor bfm
////-------------------------------------------------------
//task SpiSlaveMonitorProxy::read_from_mon_bfm(bit CPOL,bit CPHA,bit mosi);
//    case({CPOL,CPHA})
//      2'b00 : begin
//                  spiSlaveMonitorBFM.sample_mosi_pos_00(mosi);
//                  //$display("data_mosi=%d",spiSlaveMonitorBFM.data_mosi);
//                  `uvm_info("data_mosi=%d",spiSlaveMonitorBFM.data_mosi);
//                  write(spiSlaveMonitorBFM.data_mosi);
//              end
//      2'b01 : begin 
//                  spiSlaveMonitorBFM.sample_mosi_neg_01(mosi);
//                  write(spiSlaveMonitorBFM.data_mosi);
//              end
//      2'b10 : begin                  
//                  spiSlaveMonitorBFM.sample_mosi_pos_10(mosi);
//                  write(spiSlaveMonitorBFM.data_mosi);
//              end
//      2'b11 : begin
//                  spiSlaveMonitorBFM.sample_mosi_neg_11(mosi);
//                 write(spiSlaveMonitorBFM.data_mosi);
//  end
//    endcase
//endtask : read_from_mon_bfm
////
//////-------------------------------------------------------
////// Task : Write
////// Captures the 8 bit MOSI data sampled.
//////-------------------------------------------------------
//task SpiSlaveMonitorProxy::write(bit [DATA_WIDTH-1:0]data);
//
//  data_mosi = data;
//  $display("WRITE__data_mosi=%0d",data_mosi);
//  `uvm_info("WRITE__data_mosi=%0d",data_mosi);
//  data_mosi_q.push_front(data_mosi);
//  ap.write(data_mosi_q);
//  foreach(data_mosi_q[i])
//  begin
//    $display(data_mosi_q[i]);
//    `uvm_info(data_mosi_q[i]);
//  end
//endtask
//
//-------------------------------------------------------------------------------------------
// Function : End of Elobaration Phase
// Used to connect the SpiSlaveMonitorProxy defined in SpiSlaveMonitorBFM
//--------------------------------------------------------------------------------------------
function void SpiSlaveMonitorProxy::end_of_elaboration_phase(uvm_phase phase);
  spiSlaveMonitorBFM.spiSlaveMonitorProxy = this;
endfunction : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
// Task: read_from_bfm
// This task receieves the dataPacket from SpiSlaveMonitorBFM 
// and converts into the transaction object
//--------------------------------------------------------------------------------------------
//task SpiSlaveMonitorProxy::read_from_bfm(spiTransferPacketStruct packet);
//
//  // TODO(mshariff): Have a way to print the struct values
//  // SpiSlaveSeqItemConverter::display_struct(packet);
//  // string s;
//  // s = SpiSlaveSeqItemConverter::display_struct(packet);
//  // `uvm_info(get_type_name(), $sformatf("Packet to drive : \n %s", s), UVM_HIGH);
//
//  case ({spiSlaveAgentConfig.spi_mode, spiSlaveAgentConfig.shift_dir})
//
//    {CPOL0_CPHA0,MSB_FIRST}: spiSlaveMonitorBFM.drive_the_miso_data();
//
//  endcase
//
//endtask: read_from_bfm

//--------------------------------------------------------------------------------------------
// Function resetDetected
// This task detect the system reset appliction
//--------------------------------------------------------------------------------------------
function void SpiSlaveMonitorProxy::resetDetected();
  `uvm_info(get_type_name(), $sformatf("System reset is detected"), UVM_NONE);

  // TODO(mshariff): 
  // Clear the data queues and kill the required threads
endfunction: resetDetected


//--------------------------------------------------------------------------------------------
// Task: run_phase
// Calls tasks defined in SpiSlaveMonitorBFM 
//--------------------------------------------------------------------------------------------
task SpiSlaveMonitorProxy::run_phase(uvm_phase phase);
  SpiSlaveTransaction slaveTxPacket;

  `uvm_info(get_type_name(), $sformatf("Inside the SpiSlaveMonitorProxy"), UVM_LOW);

  slaveTxPacket = SpiSlaveTransaction::type_id::create("slaveTxPacket");

  // Wait for system reset
  spiSlaveMonitorBFM.waitForSystemReset();

  // TODO(mshariff): If this is enabled then the CS edge for start of transfer is getting missed
  // Need to work on this code
  // Wait for the IDLE state of SPI interface
  spiSlaveMonitorBFM.waitForIdleState();

  // Driving logic
  forever begin
    spiTransferPacketStruct structPacket;
    spiConfigPacketStruct structConfig;

    SpiSlaveTransaction spiSlaveClonePacket;

    // Wait for transfer to start
    spiSlaveMonitorBFM.waitForTransferStart();

    // TODO(mshariff): Have a way to print the struct values
    // SpiSlaveSeqItemConverter::display_struct(packet);
    // string s;
    // s = SpiSlaveSeqItemConverter::display_struct(packet);
    // `uvm_info(get_type_name(), $sformatf("Packet to drive : \n %s", s), UVM_HIGH);

    SpiSlaveConfigConverter::fromClass(spiSlaveAgentConfig, structConfig); 

    spiSlaveMonitorBFM.sampleData(structPacket, structConfig);

    SpiSlaveSeqItemConverter::toClass(structPacket, slaveTxPacket);

    `uvm_info(get_type_name(),$sformatf("Received packet from SLAVE MONITOR BFM : , \n %s",
                                        slaveTxPacket.sprint()),UVM_HIGH)

    // Clone and publish the cloned item to the subscribers
    $cast(spiSlaveClonePacket, slaveTxPacket.clone());
    `uvm_info(get_type_name(),$sformatf("Sending packet via analysis_port : , \n %s",
                                        spiSlaveClonePacket.sprint()),UVM_HIGH)
    spiSlaveAnalysisPort.write(spiSlaveClonePacket);

  end
endtask : run_phase 

//-------------------------------------------------------
// Task : Read
// Captures the MOSI and MISO data sampled.
//-------------------------------------------------------
//task SpiSlaveMonitorProxy::read(bit [DATA_WIDTH-1:0]data_mosi,
//                               bit [DATA_WIDTH-1:0]data_miso,
//                               bit [DATA_WIDTH-1:0]count);
task SpiSlaveMonitorProxy::read(spiTransferPacketStruct dataPacket);
  
 // if(count >= DATA_WIDTH && count >= DATA_WIDTH ) begin
 //   `uvm_info(get_type_name(), $sformatf("MOSI is = %d",data_mosi), UVM_LOW);
 //   `uvm_info(get_type_name(), $sformatf("MISO is = %d",data_miso), UVM_LOW);     
 // end
 // else begin
 //   `uvm_error(get_type_name(),"Either MOSI data or MISO data is less than the charachter length mentioned");
 // end
 

  //SpiSlaveTransaction SpiSlaveTransaction_h;
  //SpiSlaveTransaction_h = SpiSlaveTransaction::type_id::create("SpiSlaveTransaction_h");
  SpiSlaveSeqItemConverter spiSlaveSeqItemConverter;
  //spiSlaveSeqItemConverter = SpiSlaveSeqItemConverter::type_id::create("spiSlaveSeqItemConverter");
  //spiSlaveSeqItemConverter.toClass(SpiSlaveTransaction_h,dataPacket);
  //ap.write(SpiSlaveTransaction_h);
                            
endtask : read

`endif

