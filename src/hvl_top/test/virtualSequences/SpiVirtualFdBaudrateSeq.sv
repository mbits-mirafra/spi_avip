`ifndef SPIVIRTUALFDBAUDRATESEQ_INCLUDED_
`define SPIVIRTUALFDBAUDRATESEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Extended class from spi virtual sequence
//--------------------------------------------------------------------------------------------
class SpiVirtualFdBaudrateSeq extends SpiVirtualBaseFdSeq;
  
  `uvm_object_utils(SpiVirtualFdBaudrateSeq)
  //declare extended class handles of master and slave sequence

  SpiMasterFdBaudrateSeq spiMasterFdBaudrateSeq;
  SpiSlaveFdBaudrateSeq spiSlaveFdBaudrateSeq;
  
  //--------------------------------------------------------------------------------------------
  // Externally defined tasks and functions
  //--------------------------------------------------------------------------------------------
  extern function new(string name="SpiVirtualFdBaudrateSeq");
  extern task body();

endclass : SpiVirtualFdBaudrateSeq

//--------------------------------------------------------------------------------------------
//Constructor:new
//
//Paramters:
//name - Instance name of the virtual_sequence
//parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiVirtualFdBaudrateSeq::new(string name="SpiVirtualFdBaudrateSeq");
  super.new(name);
endfunction: new

//--------------------------------------------------------------------------------------------
//task:body
//Creates the required ports
//
//Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
task SpiVirtualFdBaudrateSeq::body();
 super.body(); //Sets up the sub-sequencer pointer
 
 //crearions master and slave sequence handles here  
 spiMasterFdBaudrateSeq=SpiMasterFdBaudrateSeq::type_id::create("spiMasterFdBaudrateSeq");
 spiSlaveFdBaudrateSeq=SpiSlaveFdBaudrateSeq::type_id::create("spiSlaveFdBaudrateSeq");
 
 //configuring no of masters and starting master sequencers
 
 fork
 // TODO(mshariff): We need to connect the slaves with caution
 // as only ONe slave can drive on MISO line
 // so the sequences need to be started based on the System configurations

 // MSHA: //has_s_agt should be declared in env_config file
 // MSHA: if(e_cfg_h.has_s_agt) begin 
 // MSHA:   //no_of_sagent should be declared in env_config file
 // MSHA: for(int i=0; i<e_cfg_h.no_of_sagent; i++)begin
 // MSHA:   //starting slave sequencer
 // MSHA:  spiSlaveFdBaudrateSeq.start(s_seqr_h);
 // MSHA:  end
 // MSHA: end

 //starting slave sequencer
 
 forever begin : SLAVE_SEQ_START
   spiSlaveFdBaudrateSeq.start(p_sequencer.spiSlaveSequencer);
 end
 join_none
   //has_m_agt should be declared in env_config file
   // TODO(mshariff): Only one Master agent as SPI supports only one Master

   // MSHA: if(e_cfg_h.has_m_agt)begin
   // MSHA: //no_of_magent should be declared in env_config file
   // MSHA: for(int i=0; i<e_cfg_h.no_of_magent; i++)begin
   // MSHA:   //starting master sequencer
   // MSHA:   spiMasterFdBaudrateSeq.start(m_seqr_h);
   // MSHA:   end
   // MSHA: end

   //starting master sequencer
   repeat(5)begin : MASTER_SEQ_START
     spiMasterFdBaudrateSeq.start(p_sequencer.spiMasterSequencer);
   end
 
endtask: body

`endif
