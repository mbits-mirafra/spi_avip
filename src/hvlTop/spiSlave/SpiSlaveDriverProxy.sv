`ifndef SPISLAVEDRIVERPROXY_INCLUDED_
`define SPISLAVEDRIVERPROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
//  Class: SpiSlaveDriverProxy
//  This is the proxy driver on the HVL side
//  It receives the transactions and converts them to task calls for the HDL driver
//--------------------------------------------------------------------------------------------
class SpiSlaveDriverProxy extends uvm_driver#(SpiSlaveTransaction);
  `uvm_component_utils(SpiSlaveDriverProxy)

  // Variable: SpiSlaveDriverBFM;
  // Handle for spiSlaveDriverBFM
  virtual SpiSlaveDriverBFM spiSlaveDriverBFM;

  //  SpiSlaveSeqItemConverter  spiSlaveSeqItemConverter;

  // Variable: spiSlaveAgentConfig;
  // Handle for slave agent configuration
  SpiSlaveAgentConfig spiSlaveAgentConfig;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSlaveDriverProxy", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  //extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task driveToBFM(inout spiTransferPacketStruct packet, input spiTransferConfigStruct slaveConfigStruct);
  extern virtual function void resetDetected();

endclass : SpiSlaveDriverProxy

//--------------------------------------------------------------------------------------------
//  Construct: new
//  Initializes memory for new object
//
//  Parameters:
//  name - SpiSlaveDriverProxy
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSlaveDriverProxy::new(string name = "SpiSlaveDriverProxy", uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
//  Function: build_phase
//  SpiSlaveDriverBFM congiguration is obtained in build phase
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiSlaveDriverProxy::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!uvm_config_db #(virtual SpiSlaveDriverBFM)::get(this,"","SpiSlaveDriverBFM",spiSlaveDriverBFM)) begin
    `uvm_fatal("FATAL_SDP_CANNOT_GET_SpiSlaveDriverBFM","cannot get() spiSlaveDriverBFM");
  end

  //  spiSlaveSeqItemConverter = SpiSlaveSeqItemConverter::type_id::create("spiSlaveSeqItemConverter");
endfunction : build_phase

//--------------------------------------------------------------------------------------------
//  Function: connect_phase
//  Connects driver_proxy and driver_bfm
//
//  Parameters:
//  phase - stores the current phase
//--------------------------------------------------------------------------------------------
function void SpiSlaveDriverProxy::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
//  spiSlaveDriverBFM = spiSlaveAgentConfig.spiSlaveDriverBFM;
endfunction : connect_phase

//-------------------------------------------------------
//Function: end_of_elaboration_phase
//Description: connects driver_proxy and driver_bfm
//
// Parameters:
//  phase - stores the current phase
//-------------------------------------------------------
function void SpiSlaveDriverProxy::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  spiSlaveDriverBFM.spiSlaveDriverProxy = this;
endfunction : end_of_elaboration_phase

//--------------------------------------------------------------------------------------------
//  Function: start_of_simulation_phase
//  <Description_here>
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
//function void SpiSlaveDriverProxy::start_of_simulation_phase(uvm_phase phase);
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
task SpiSlaveDriverProxy::run_phase(uvm_phase phase);

  super.run_phase(phase);

  // Wait for system reset
  spiSlaveDriverBFM.waitForSystemReset();

  // Wait for the IDLE state of SPI interface
  spiSlaveDriverBFM.waitForIdleState();

  // Driving logic
  forever begin
    spiTransferPacketStruct slavePacketStruct;
    spiTransferConfigStruct slaveConfigStruct;

    // Wait for transfer to start
    spiSlaveDriverBFM.waitForTransferStart();

    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(),$sformatf("Received packet from slave sequencer : , \n %s",
                                        req.sprint()),UVM_HIGH)

    SpiSlaveSeqItemConverter::fromClass(req, slavePacketStruct); 
    SpiSlaveConfigConverter::fromClass(spiSlaveAgentConfig, slaveConfigStruct); 

    driveToBFM(slavePacketStruct, slaveConfigStruct);

    SpiSlaveSeqItemConverter::toClass(slavePacketStruct, req);
    `uvm_info(get_type_name(),$sformatf("Received packet from SLAVE DRIVER BFM : , \n %s",
                                        req.sprint()),UVM_LOW)

    seq_item_port.item_done();
  end
endtask : run_phase

//--------------------------------------------------------------------------------------------
// Task: driveToBFM
// This task converts the transcation data packet to struct type and send
// it to the SpiSlaveDriverBFM
//--------------------------------------------------------------------------------------------
task SpiSlaveDriverProxy::driveToBFM(inout spiTransferPacketStruct packet, input spiTransferConfigStruct slaveConfigStruct);

  // TODO(mshariff): Have a way to print the struct values
  // SpiSlaveSeqItemConverter::display_struct(packet);
  // string s;
  // s = SpiSlaveSeqItemConverter::display_struct(packet);
  // `uvm_info(get_type_name(), $sformatf("Packet to drive : \n %s", s), UVM_HIGH);

//  case ({spiSlaveAgentConfig.spi_mode, spiSlaveAgentConfig.shift_dir})

   // {CPOL0_CPHA0,MSB_FIRST}: spiSlaveDriverBFM.driveMisoData(packet,slaveConfigStruct);
  
   `uvm_info(get_type_name(),$sformatf("Before DRIVING DATA TO DRIVER BFM STRUCT DATA PACKET : , \n %p",
                                        packet),UVM_HIGH)
    
  spiSlaveDriverBFM.driveMisoData(packet,slaveConfigStruct);
  `uvm_info(get_type_name(),$sformatf("BFM STRUCT DATA : , \n %p",
                                        packet),UVM_MEDIUM)
  if(packet.noOfMisoBitsTransfer == packet.noOfMosiBitsTransfer) begin
    `uvm_info("DEBUG_SpiSlaveDriverProxy","MOSI AND MISO TRANSFER BITS SIZE IS SAME",UVM_HIGH)
  end
  else begin
    `uvm_error("DEBUG_SpiSlaveDriverProxy","MOSI AND MISO TRANSFER SIZE IS DIFFERENT")
  end


//  endcase

endtask: driveToBFM

//--------------------------------------------------------------------------------------------
// Function resetDetected
// This task detect the system reset appliction
//--------------------------------------------------------------------------------------------
function void SpiSlaveDriverProxy::resetDetected();
  `uvm_info(get_type_name(), "System reset is detected", UVM_NONE);

  // TODO(mshariff): 
  // Clear the data queues and kill the required threads
endfunction: resetDetected

`endif

