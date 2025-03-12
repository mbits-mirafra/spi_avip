`ifndef SPISLAVEAGENT_INCLUDED_
`define SPISLAVEAGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
//  Class: SpiSlaveAgent
//  This agent has sequencer, driver_proxy, monitor_proxy for SPI  
//--------------------------------------------------------------------------------------------
class SpiSlaveAgent extends uvm_agent;
  `uvm_component_utils(SpiSlaveAgent)

  // Variable: spiSlaveAgentConfig;
  // Handle for slave agent configuration
  SpiSlaveAgentConfig spiSlaveAgentConfig;

  // Variable: spiSlaveSequencer;
  // Handle for slave sequencer
  SpiSlaveSequencer spiSlaveSequencer;

  // Variable: spiSlaveDriverProxy
  // Handle for slave driver proxy
  SpiSlaveDriverProxy spiSlaveDriverProxy;

  // Variable: spiSlaveMonitorProxy
  // Handle for slave monitor proxy
  SpiSlaveMonitorProxy spiSlaveMonitorProxy;

  // Variable: SpiSlaveCoverage
  // Decalring a handle for SpiSlaveCoverage
  SpiSlaveCoverage spiSlaveCoverage;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSlaveAgent", uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : SpiSlaveAgent

//--------------------------------------------------------------------------------------------
//  Construct: new
//
//  Parameters:
//  name - instance name of the  SpiSlaveAgent
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiSlaveAgent::new(string name = "SpiSlaveAgent", uvm_component parent);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
//  Function: build_phase
//  Creates the required ports, gets the required configuration from config_db
//
//  Parameters:
//  phase - stores the current phase
//--------------------------------------------------------------------------------------------
function void SpiSlaveAgent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!uvm_config_db #(SpiSlaveAgentConfig)::get(this,"","SpiSlaveAgentConfig",spiSlaveAgentConfig)) begin
   `uvm_fatal("FATAL_SA_AGENT_CONFIG", $sformatf("Couldn't get the SpiSlaveAgentConfig from config_db"))
  end

  // TODO(mshariff): Print the values of the SpiSlaveAgentConfig
  // Have a print method in master_agent_config class and call it from here
  //`uvm_info(get_type_name(), $sformatf("The SpiSlaveAgentConfig.slave_id = %0d", spiSlaveAgentConfig.slave_id), UVM_LOW);

   if(spiSlaveAgentConfig.isActive == UVM_ACTIVE) begin
     spiSlaveDriverProxy = SpiSlaveDriverProxy::type_id::create("spiSlaveDriverProxy",this);
     spiSlaveSequencer=SpiSlaveSequencer::type_id::create("spiSlaveSequencer",this);
   end

   spiSlaveMonitorProxy = SpiSlaveMonitorProxy::type_id::create("spiSlaveMonitorProxy",this);

   if(spiSlaveAgentConfig.hasCoverage) begin
    spiSlaveCoverage = SpiSlaveCoverage::type_id::create("spiSlaveCoverage",this);
   end
  
  
endfunction : build_phase

//--------------------------------------------------------------------------------------------
//  Function: connect_phase 
//  <Description_here>
//
//  Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------

function void SpiSlaveAgent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  
  if(spiSlaveAgentConfig.isActive == UVM_ACTIVE) begin
    spiSlaveDriverProxy.spiSlaveAgentConfig = spiSlaveAgentConfig;
    spiSlaveSequencer.spiSlaveAgentConfig = spiSlaveAgentConfig;
    spiSlaveCoverage.spiSlaveAgentConfig = spiSlaveAgentConfig;
    
    // Connecting the ports
    spiSlaveDriverProxy.seq_item_port.connect(spiSlaveSequencer.seq_item_export);
  end
  
    // TODO(mshariff): 
    // connect monitor port to coverage
    
    if(spiSlaveAgentConfig.hasCoverage)begin
      spiSlaveCoverage.spiSlaveAgentConfig=spiSlaveAgentConfig;
      spiSlaveMonitorProxy.slaveAnalysisPort.connect(spiSlaveCoverage.analysis_export);
   end

  spiSlaveMonitorProxy.spiSlaveAgentConfig = spiSlaveAgentConfig;


endfunction: connect_phase

`endif
