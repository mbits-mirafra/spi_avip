`ifndef SPIMASTERAGENT_INCLUDED_
`define SPIMASTERAGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiMasterAgent
// This agent is a configurable with respect to configuration which can create active and passive components
// It contains testbench components like sequencer,driver_proxy and monitor_proxy for SPI
//--------------------------------------------------------------------------------------------
class SpiMasterAgent extends uvm_agent;
  `uvm_component_utils(SpiMasterAgent)

  // Variable: spiMasterAgentConfig
  // Declaring handle for master agent configuration class 
  SpiMasterAgentConfig spiMasterAgentConfig;

  // Varible: spiMasterSequencer 
  // Handle for slave seuencer
  SpiMasterSequencer spiMasterSequencer;
  
  // Variable: spiMasterDriverProxy
  // Creating a Handle formaster driver proxy 
  SpiMasterDriverProxy spiMasterDriverProxy;

  // Variable: spiMasterMonitorProxy
  // Declaring a handle for master monitor proxy 
  SpiMasterMonitorProxy spiMasterMonitorProxy;
  
  // MSHA: // Variable: SpiMasterCoverage
  // MSHA: // Decalring a handle for SpiMasterCoverage
  SpiMasterCoverage spiMasterCoverage;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiMasterAgent", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
endclass : SpiMasterAgent

//--------------------------------------------------------------------------------------------
//  Construct: new
//
//  Parameters:
//  name - instance name of the SpiMasterAgent
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiMasterAgent::new(string name="SpiMasterAgent", uvm_component parent);
  super.new(name,parent);
endfunction : new

//--------------------------------------------------------------------------------------------
//  Function: build_phase
//  Creates the required ports, gets the required configuration from confif_db
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiMasterAgent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!uvm_config_db #(SpiMasterAgentConfig)::get(this,"","SpiMasterAgentConfig",spiMasterAgentConfig)) begin
    `uvm_fatal("FATAL_MA_CANNOT_GET_SPIMASTERAGENT_CONFIG","cannot get spiMasterAgentConfig from uvm_config_db");
  end

  // Print the values of the SpiMasterAgentConfig
  // Have a print method in SpiMasterAgentConfig class and call it from here
  //`uvm_info(get_type_name(), $sformat("The SpiMasterAgentConfig.master_id =%d",spiMasterAgentConfig.master_id),UVM_LOW);
  
  if(spiMasterAgentConfig.isActive == UVM_ACTIVE) begin
    spiMasterDriverProxy=SpiMasterDriverProxy::type_id::create("spiMasterDriverProxy",this);
    spiMasterSequencer=SpiMasterSequencer::type_id::create("spiMasterSequencer",this);
  end

  spiMasterMonitorProxy=SpiMasterMonitorProxy::type_id::create("spiMasterMonitorProxy",this);

  if(spiMasterAgentConfig.hasCoverage) begin
    spiMasterCoverage = SpiMasterCoverage::type_id::create("spiMasterCoverage",this);
  end
endfunction : build_phase

//--------------------------------------------------------------------------------------------
//  Function: connect_phase 
//  Connecting master driver, master monitor and master sequencer for configuration
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiMasterAgent::connect_phase(uvm_phase phase);
  if(spiMasterAgentConfig.isActive == UVM_ACTIVE) begin
    spiMasterDriverProxy.spiMasterAgentConfig = spiMasterAgentConfig;
    spiMasterSequencer.spiMasterAgentConfig = spiMasterAgentConfig;

    //Connecting the ports
    spiMasterDriverProxy.seq_item_port.connect(spiMasterSequencer.seq_item_export);
  end
  
  if(spiMasterAgentConfig.hasCoverage) begin
    // MSHA: spiMasterCoverage.spiMasterAgentConfig = spiMasterAgentConfig;
     spiMasterCoverage.spiMasterAgentConfig = spiMasterAgentConfig;
    // TODO(mshariff): 
    // connect monitor port to coverage

    spiMasterMonitorProxy.masterAnalysisPort.connect(spiMasterCoverage.analysis_export);
  end

  spiMasterMonitorProxy.spiMasterAgentConfig = spiMasterAgentConfig;

endfunction: connect_phase

`endif

