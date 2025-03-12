`ifndef SPIMASTERMONITORPROXY_INCLUDED_
`define SPIMASTERMONITORPROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
//  Class: SpiMasterMonitorProxy
//  
//  Monitor is written by extending uvm_monitor,uvm_monitor is inherited from uvm_component, 
//  A monitor is a passive entity that samples the DUT signals through virtual interface and 
//  converts the signal level activity to transaction level,monitor samples DUT signals but does not drive them.
//  Monitor should have analysis port (TLM port) and virtual interface handle that points to DUT signal
//--------------------------------------------------------------------------------------------
class SpiMasterMonitorProxy extends uvm_component; 
  `uvm_component_utils(SpiMasterMonitorProxy)
  
  // Variable: spiMasterAgentConfig
  // Declaring handle for master agent config class 
  SpiMasterAgentConfig spiMasterAgentConfig;
    
  //declaring analysis port for the monitor port
  uvm_analysis_port #(SpiMasterTransaction) masterAnalysisPort;
  
  //Declaring Virtual Monitor BFM Handle
  virtual SpiMasterMonitorBFM spiMasterMonitorBFM;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiMasterMonitorProxy", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  // MSHA: extern virtual task sample_from_bfm(SpiMasterTransaction packet);
  //extern virtual task sampleRead_from_bfm(spiTransferPacketStruct packet);
  extern virtual function void resetDetected();
  extern virtual task sampleRead(spiTransferPacketStruct packetStruct);

endclass : SpiMasterMonitorProxy

//--------------------------------------------------------------------------------------------
//  Construct: new
//
//  Parameters:
//  name - SpiMasterMonitorProxy
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiMasterMonitorProxy::new(string name = "SpiMasterMonitorProxy",uvm_component parent);
  super.new(name, parent);
  
  masterAnalysisPort = new("masterAnalysisPort",this);

endfunction : new

//--------------------------------------------------------------------------------------------
//  Function: build_phase
//  <Description_here>
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiMasterMonitorProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!uvm_config_db#(virtual SpiMasterMonitorBFM)::get(this,"","SpiMasterMonitorBFM",spiMasterMonitorBFM)) begin
     `uvm_fatal("FATAL_SMP_MON_BFM",$sformatf("Couldn't get S_MON_BFM in SpiMasterMonitorProxy"));  
  end 
  
endfunction : build_phase

//--------------------------------------------------------------------------------------------
//  Function: connect_phase
//  <Description_here>
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
// MSHA:function void SpiMasterMonitorProxy::connect_phase(uvm_phase phase);
// MSHA:
// MSHA: 
// MSHA:endfunction : connect_phase

//--------------------------------------------------------------------------------------------
//  Function: end_of_elaboration_phase
//  <Description_here>
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiMasterMonitorProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  spiMasterMonitorBFM.spiMasterMonitorProxy = this;
endfunction  : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
//  Function: start_of_simulation_phase
//  <Description_here>
//
//  // TODO(mshariff): Have a way to print the struct values
//  // SpiMasterSeqItemConverter::display_struct(packet);
//  // string s;
//  // s = SpiMasterSeqItemConverter::display_struct(packet);
//  // `uvm_info(get_type_name(), $sformatf("Packet to drive : \n %s", s), UVM_HIGH);
//
//  case ({spiMasterAgentConfig.spiMode, spiMasterAgentConfig.shift_dir})
//
//    {CPOL0_CPHA0,MSB_FIRST}: spiMasterMonitorBFM.drive_the_miso_data();
//
//  endcase
//
//endtask: sampleRead_from_bfm

//--------------------------------------------------------------------------------------------
// Function resetDetected
// This task detect the system reset appliction
//--------------------------------------------------------------------------------------------
function void SpiMasterMonitorProxy::resetDetected();
  `uvm_info(get_type_name(), $sformatf("System reset is detected"), UVM_NONE);

  // TODO(mshariff): 
  // Clear the data queues and kill the required thsampleReads
endfunction: resetDetected


//--------------------------------------------------------------------------------------------
// Task: run_phase
// Calls tasks defined in SpiMasterMonitorBFM 
//--------------------------------------------------------------------------------------------
task SpiMasterMonitorProxy::run_phase(uvm_phase phase);
  SpiMasterTransaction spiMasterTransaction;

  `uvm_info(get_type_name(), $sformatf("Inside the SpiMasterMonitorProxy"), UVM_LOW);

  spiMasterTransaction = SpiMasterTransaction::type_id::create("spiMasterTransaction");

  // Wait for system reset
  spiMasterMonitorBFM.waitForSystemReset();

  // Wait for the IDLE state of SPI interface
  spiMasterMonitorBFM.waitForIdleState();

  // Driving logic
  forever begin
    spiTransferPacketStruct masterPacketStruct;
    spiTransferConfigStruct masterConfigStruct;

    SpiMasterTransaction masterClonePacket;

    // Wait for transfer to start
    spiMasterMonitorBFM.waitForTransferStart();

    // TODO(mshariff): Have a way to print the struct values
    // SpiMasterSeqItemConverter::display_struct(packet);
    // string s;
    // s = SpiMasterSeqItemConverter::display_struct(packet);
    // `uvm_info(get_type_name(), $sformatf("Packet to drive : \n %s", s), UVM_HIGH);

    SpiMasterConfigConverter::fromClass(spiMasterAgentConfig, masterConfigStruct); 

    spiMasterMonitorBFM.sampleData(masterPacketStruct, masterConfigStruct);

    SpiMasterSeqItemConverter::toClass(masterPacketStruct, spiMasterTransaction);

   `uvm_info(get_type_name(),$sformatf("Received packet from MASTER MONITOR BFM : , \n %s",
                                        spiMasterTransaction.sprint()),UVM_HIGH)

    // Clone and publish the cloned item to the subscribers
    $cast(masterClonePacket, spiMasterTransaction.clone());
    `uvm_info(get_type_name(),$sformatf("Sending packet via analysis_port : , \n %s",
                                        masterClonePacket.sprint()),UVM_HIGH)
    masterAnalysisPort.write(masterClonePacket);

  end
endtask : run_phase 

//-------------------------------------------------------
// Task : sampleRead
// Captures the MOSI and MISO data sampled.
//-------------------------------------------------------
//task SpiMasterMonitorProxy::sampleRead(bit [DATA_WIDTH-1:0]data_mosi,
//                               bit [DATA_WIDTH-1:0]data_miso,
//                               bit [DATA_WIDTH-1:0]count);
task SpiMasterMonitorProxy::sampleRead(spiTransferPacketStruct packetStruct);
  
 // if(count >= DATA_WIDTH && count >= DATA_WIDTH ) begin
 //   `uvm_info(get_type_name(), $sformatf("MOSI is = %d",data_mosi), UVM_LOW);
 //   `uvm_info(get_type_name(), $sformatf("MISO is = %d",data_miso), UVM_LOW);     
 // end
 // else begin
 //   `uvm_error(get_type_name(),"Either MOSI data or MISO data is less than the charachter length mentioned");
 // end
 

  //SpiMasterTransaction SpiMasterTransaction_h;
  //SpiMasterTransaction_h = SpiMasterTransaction::type_id::create("SpiMasterTransaction_h");
  SpiMasterSeqItemConverter spiMasterSeqItemConverter;
  //spiMasterSeqItemConverter = SpiMasterSeqItemConverter::type_id::create("spiMasterSeqItemConverter");
  //spiMasterSeqItemConverter.toClass(SpiMasterTransaction_h,packetStruct);
  //ap.write(SpiMasterTransaction_h);
                            
endtask : sampleRead

`endif

