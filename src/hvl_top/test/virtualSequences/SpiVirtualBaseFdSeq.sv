`ifndef SPIVIRTUALBASEFDSEQ_INCLUDED_
`define SPIVIRTUALBASEFDSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
//Class:SPI Virtual sequence
// Description:
// This class contains the handle of actual sequencer pointing towards them
//--------------------------------------------------------------------------------------------
class SpiVirtualBaseFdSeq extends uvm_sequence#(uvm_sequence_item);
  `uvm_object_utils(SpiVirtualBaseFdSeq)

   //p sequencer macro declaration 
   `uvm_declare_p_sequencer(SpiVirtualSequencer)
  
   //declaring virtual sequencer handle
   //SpiVirtualSequencer  virtual_seqr_h;

  //--------------------------------------------------------------------------------------------
  // declaring handles for master and slave sequencer and environment config
  //--------------------------------------------------------------------------------------------
  SpiMasterSequencer   spiSlaveSequencer;
  SpiSlaveSequencer   spiSlaveSequencer;
  SpiEnvConfig spiEnvConfig;

  //--------------------------------------------------------------------------------------------
  // Externally defined tasks and functions
  //--------------------------------------------------------------------------------------------
  extern function new(string name="SpiVirtualBaseFdSeq");
  extern task body();

endclass:SpiVirtualBaseFdSeq

//--------------------------------------------------------------------------------------------
//Constructor:new
//
//Paramters:
//name - Instance name of the virtual_sequence
//parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiVirtualBaseFdSeq::new(string name="SpiVirtualBaseFdSeq");
  super.new(name);
endfunction:new

//--------------------------------------------------------------------------------------------
//task:body
//Creates the required ports
//
//Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
task SpiVirtualBaseFdSeq::body();
  if(!uvm_config_db#(SpiEnvConfig) ::get(null,get_full_name(),"SpiEnvConfig",spiEnvConfig)) begin
    `uvm_fatal("CONFIG","cannot get() env_cfg from uvm_config_db.Have you set() it?")
  end

  //declaring no of master sequencer in master agent
  //and slave sequencer in slave agent
  // MSHA: m_seqr_h=new[e_cfg_h.no_of_magent];
  // MSHA: s_seqr_h=new[e_cfg_h.no_of_sagent];

  //dynamic casting of p_sequncer and m_sequencer
  if(!$cast(p_sequencer,m_sequencer))begin
    `uvm_error(get_full_name(),"Virtual sequencer pointer cast failed")
  end
            
  //connecting master sequencer and slave sequencer present in p_sequencer to
  // local master sequencer and slave sequencer 
  spiMasterSequencer=p_sequencer.spiMasterSequencer;
  spiSlaveSequencer=p_sequencer.spiSlaveSequencer;

endtask:body

`endif
