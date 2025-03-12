`ifndef SPIENV_INCLUDED_
`define SPIENV_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiEnv
// Description:
// SpiEnvironment contains SpiSlaveAgent_top,SpiMasterAgent_top and SpiVirtualSequencer
//--------------------------------------------------------------------------------------------
class SpiEnv extends uvm_env;
  `uvm_component_utils(SpiEnv)
  
  // Variable: spiEnvConfig
  // Declaring SpiEnvironment configuration handle
  SpiEnvConfig spiEnvConfig;
  
  // Variable: spiScoreboard
  // declaring scoreboard handle
  SpiScoreboard spiScoreboard;
  
  // Variable: spiVirtualSequencer
  // declaring handle for virtual sequencer
  SpiVirtualSequencer spiVirtualSequencer;
  
  // Variable: spiSlaveAgent
  // Declaring slave handles
  SpiSlaveAgent spiSlaveAgent[];

  // Variable: spiMasterAgent
  // declaring master agent handle
  SpiMasterAgent spiMasterAgent;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiEnv", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : SpiEnv

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
// name - SpiEnv
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiEnv::new(string name = "SpiEnv",uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// Description:
// Create required components
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiEnv::build_phase(uvm_phase phase);
  super.build_phase(phase);

  `uvm_info(get_full_name(),"SpiEnv: build_phase",UVM_LOW);

  if(!uvm_config_db #(SpiEnvConfig)::get(this,"","SpiEnvConfig",spiEnvConfig)) begin
   `uvm_fatal("FATAL_SPI_ENV_CONFIG", $sformatf("Couldn't get the SpiEnvConfig from config_db"))
  end

  spiMasterAgent=SpiMasterAgent::type_id::create("spiMasterAgent",this);

  spiSlaveAgent = new[spiEnvConfig.noOfSlaves];
  foreach(spiSlaveAgent[i]) begin
    spiSlaveAgent[i] = SpiSlaveAgent::type_id::create($sformatf("spiSlaveAgent[%0d]",i),this);
  end

  if(spiEnvConfig.hasVirtualSequencer) begin
    spiVirtualSequencer = SpiVirtualSequencer::type_id::create("spiVirtualSequencer",this);
  end

  if(spiEnvConfig.hasScoreboard) begin
    spiScoreboard = SpiScoreboard::type_id::create("spiScoreboard",this);
  end
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// Description:
// To connect driver and sequencer
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiEnv::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if(spiEnvConfig.hasVirtualSequencer) begin
    spiVirtualSequencer.spiMasterSequencer = spiMasterAgent.spiMasterSequencer;
    foreach(spiSlaveAgent[i]) begin
      spiVirtualSequencer.spiSlaveSequencer = spiSlaveAgent[i].spiSlaveSequencer;
    end
  end

  //connecting analysis port to analysis fifo
  
  spiSlaveAgent[0].spiSlaveMonitorProxy.slaveAnalysisPort.connect(spiScoreboard.slaveAnalysisFIFO.analysis_export);

  spiMasterAgent.spiMasterMonitorProxy.masterAnalysisPort.connect(spiScoreboard.masterAnalysisFIFO.analysis_export);
endfunction : connect_phase

`endif

