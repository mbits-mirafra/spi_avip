`ifndef SPIMASTERDRIVERPROXY_INCLUDED_
`define SPIMASTERDRIVERPROXY_INCLUDED_
    
//--------------------------------------------------------------------------------------------
//  Class: SpiMasterDriverProxy
//  Description of the class
//  Driver is written by extending uvm_driver,uvm_driver is inherited from uvm_component, 
//  Methods and TLM port (seq_item_port) are defined for communication between sequencer and driver,
//  uvm_driver is a parameterized class and it is parameterized with the type of the request 
//  sequence_item and the type of the response sequence_item 
//--------------------------------------------------------------------------------------------
class SpiMasterDriverProxy extends uvm_driver#(SpiMasterTransaction);
  `uvm_component_utils(SpiMasterDriverProxy)
  
  SpiMasterTransaction spiMasterTransaction;

  virtual SpiMasterDriverBFM spiMasterDriverBFM;
   
  // Variable: spiMasterAgentConfig
  // Declaring handle for master agent config class 
  SpiMasterAgentConfig spiMasterAgentConfig;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiMasterDriverProxy", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  //extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task driveToBFM(inout spiTransferPacketStruct masterPacketStruct, input spiTransferConfigStruct masterConfigStruct);
  extern virtual function void resetDetected();

endclass : SpiMasterDriverProxy

//--------------------------------------------------------------------------------------------
//  Construct: new
//
//  Parameters:
//  name - SpiMasterDriverProxy
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiMasterDriverProxy::new(string name = "SpiMasterDriverProxy",uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
//  Function: build_phase
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiMasterDriverProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(virtual SpiMasterDriverBFM)::get(this,"","SpiMasterDriverBFM",spiMasterDriverBFM)) begin
    `uvm_fatal("FATAL_MDP_CANNOT_GET_SPIMASTERDRIVERBFM","cannot get() spiMasterDriverBFM");
  end
endfunction : build_phase

//--------------------------------------------------------------------------------------------
//  Function: connect_phase
//  
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiMasterDriverProxy::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

//--------------------------------------------------------------------------------------------
//  Function: end_of_elaboration_phase
//  <Description_here>
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiMasterDriverProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  spiMasterDriverBFM.spiMasterDriverProxy = this;
endfunction  : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
//  Function: start_of_simulation_phase
//  <Description_here>
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
//function void SpiMasterDriverProxy::start_of_simulation_phase(uvm_phase phase);
//  super.start_of_simulation_phase(phase);
//endfunction : start_of_simulation_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// Gets the sequence_item, converts them to struct compatible transactions
// and sends them to the BFM to drive the data over the interface
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task SpiMasterDriverProxy::run_phase(uvm_phase phase);

  bit cpol, cpha;

  super.run_phase(phase);
  //`uvm_info(get_type_name(),"Hey ! It's master dirver proxy-RUN PHASE",UVM_LOW)
  // TODO(mshariff): Decide one among this
  // $cast(cpol_cpha, spiMasterAgentConfig.spiMode);
  //{cpol,cpha} = operationModesEnum'(spiMasterAgentConfig.spiMode);
  {cpol, cpha} = operationModesEnum'(spiMasterAgentConfig.spiMode);

  // Wait for system reset
  spiMasterDriverBFM.waitForReset();

  //`uvm_info(get_type_name(),"Waiting for Reset",UVM_LOW)
  // Drive the IDLE state for SPI interface
  spiMasterDriverBFM.driveIdleState(cpol);

  //`uvm_info(get_type_name(),"Driving Idle State",UVM_LOW)
  // Driving logic
  forever begin
    spiTransferPacketStruct masterPacketStruct;
    spiTransferConfigStruct masterConfigStruct;

    //`uvm_info(get_type_name(),"Calling get next item",UVM_LOW)
    //spiMasterTransaction = new();
    //spiMasterTransaction.masterOutSlaveIn = new [2];
    //`uvm_info(get_type_name(),$sformatf("SpiMasterTransaction = \n %s", spiMasterTransaction.sprint),UVM_LOW)
    seq_item_port.get_next_item(req);
    //`uvm_info(get_type_name(),$sformatf("Received masterPacketStruct from master seqeuncer : , \n %s",
    //                                    req.sprint),UVM_LOW);

    // Wait for IDLE state on SPI interface
    spiMasterDriverBFM.waitForIdleState();

    // MSHA:1010_1011 (AB)

    // MSHA:LSB first - 1 1 0 1 0 1 0 1 
    // MSHA:MSB FIrts - 1 0 1 0 1 0 1 1
    // MSHA:
    // MSHA:req.mosi_data = AB;

    // MSHA:converting to struct 

    // MSHA:bit[no_of_bits_transfer-1:0] mosi_s;

    // MSHA:if(MSB_FIRST)
    // MSHA:  D5
    // MSHA:  mosi_s = flip_version_of(req.mosi_data);

    // MSHA:// LSB First
    // MSHA:for(int i=0; i< no_of_mosi_bits_transfer; i++) begin
    // MSHA:  mosi_dat[i]
    // MSHA:end

    SpiMasterSeqItemConverter::fromClass(req, masterPacketStruct); 
    SpiMasterConfigConverter::fromClass(spiMasterAgentConfig, masterConfigStruct); 

    `uvm_info(get_type_name(),$sformatf("STRUCT MASTERPACKETSTRUCT MOSI : , \n %p",
    masterPacketStruct.masterOutSlaveIn),UVM_HIGH);
    //`uvm_info(get_type_name(),$sformatf("STRUCT masterPacketStruct[1] : , \n %p",
    //masterPacketStruct.masterOutSlaveIn[1]),UVM_LOW);
    `uvm_info(get_type_name(),$sformatf("STRUCT CONFIGURATION : , \n %p",masterConfigStruct),UVM_HIGH);
    driveToBFM(masterPacketStruct, masterConfigStruct);

    SpiMasterSeqItemConverter::toClass(masterPacketStruct, req);
    
    `uvm_info(get_type_name(),$sformatf("Received masterPacketStruct from MASTER DRIVER BFM : , \n %s",
                                        req.sprint()),UVM_LOW)
    seq_item_port.item_done();
  end
endtask : run_phase

//--------------------------------------------------------------------------------------------
// Task: driveToBFM
// This task converts the transcation data masterPacketStruct to struct type and send
// it to the SpiMasterDriverBFM
//--------------------------------------------------------------------------------------------
task SpiMasterDriverProxy::driveToBFM(inout spiTransferPacketStruct masterPacketStruct, input spiTransferConfigStruct masterConfigStruct);

  // TODO(mshariff): Have a way to print the struct values
  // SpiMasterSeqItemConverter::display_struct(masterPacketStruct);
  // string s;
  // s = SpiMasterSeqItemConverter::display_struct(masterPacketStruct);
  // `uvm_info(get_type_name(), $sformatf("masterPacketStruct to drive : \n %s", s), UVM_HIGH);

  //case ({spiMasterAgentConfig.spiMode, spiMasterAgentConfig.shift_dir})
    //{CPOL0_CPHA0,MSB_FIRST}: begin  
  spiMasterDriverBFM.driveMsbFirstPosedge(masterPacketStruct,masterConfigStruct); 
  `uvm_info(get_type_name(),$sformatf("BFM STRUCT MASTERPACKETSTRUCT : , \n %p", masterPacketStruct),UVM_LOW)
  `uvm_info(get_type_name(),$sformatf(" STRUCT CONFIG VALUES : , \n %p",masterConfigStruct),UVM_HIGH);

      // MSHA:if (spiMasterAgentConfig.shift_dir == MSB_FIRST) begin
      // MSHA:  spiMasterDriverBFM.driveMsbFirstPosedge(data);
      // MSHA:  spiMasterDriverBFM.drive_msb_first_neg_edge(data);
      // MSHA:end
      // MSHA:
      // MSHA:else if (spiMasterAgentConfig.shift_dir == LSB_FIRST) begin
      // MSHA:  spiMasterDriverBFM.drive_lsb_first_pos_edge(data);
      // MSHA:  spiMasterDriverBFM.drive_lsb_first_neg_edge(data);
      // MSHA:end

    // MSHA:CPOL0_CPHA1:
    // MSHA:  if (spiMasterAgentConfig.shift_dir == MSB_FIRST) begin
    // MSHA:    spiMasterDriverBFM.driveMsbFirstPosedge(data);
    // MSHA:    spiMasterDriverBFM.drive_msb_first_neg_edge(data);
    // MSHA:  end
    // MSHA:  
    // MSHA:  else if (spiMasterAgentConfig.shift_dir == LSB_FIRST) begin
    // MSHA:    spiMasterDriverBFM.drive_lsb_first_pos_edge(data);
    // MSHA:    spiMasterDriverBFM.drive_lsb_first_neg_edge(data);
    // MSHA:  end

    // MSHA:CPOL1_CPHA0:
    // MSHA:  if (spiMasterAgentConfig.shift_dir == MSB_FIRST) begin
    // MSHA:    spiMasterDriverBFM.driveMsbFirstPosedge(data);
    // MSHA:    spiMasterDriverBFM.drive_msb_first_neg_edge(data);
    // MSHA:  end
    // MSHA:  
    // MSHA:  else if (spiMasterAgentConfig.shift_dir == LSB_FIRST) begin
    // MSHA:    spiMasterDriverBFM.drive_lsb_first_pos_edge(data);
    // MSHA:    spiMasterDriverBFM.drive_lsb_first_neg_edge(data);
    // MSHA:  end

    // MSHA:CPOL1_CPHA1:
    // MSHA:  if (spiMasterAgentConfig.shift_dir == MSB_FIRST) begin
    // MSHA:    spiMasterDriverBFM.driveMsbFirstPosedge(data);
    // MSHA:    spiMasterDriverBFM.drive_msb_first_neg_edge(data);
    // MSHA:  end
    // MSHA:  
    // MSHA:  else if (spiMasterAgentConfig.shift_dir == LSB_FIRST) begin
    // MSHA:    spiMasterDriverBFM.drive_lsb_first_pos_edge(data);
    // MSHA:    spiMasterDriverBFM.drive_lsb_first_neg_edge(data);
    // MSHA:  end

//   CPOL0_CPHA0: drive_cpol_0_cpha_0(data);
//   CPOL0_CPHA1: drive_cpol_0_cpha_1(data);
//   CPOL1_CPHA0: drive_cpol_1_cpha_0(data);
//   CPOL1_CPHA1: drive_cpol_1_cpha_1(data);
  //endcase

endtask: driveToBFM

//--------------------------------------------------------------------------------------------
// Function resetDetected
// This task detect the system reset appliction
//--------------------------------------------------------------------------------------------
function void SpiMasterDriverProxy::resetDetected();
  `uvm_info(get_type_name(), $sformatf("System reset is detected"), UVM_NONE);

  // TODO(mshariff): 
  // Clear the data queues and kill the required threads
endfunction: resetDetected

`endif
