`ifndef SPIVIRTUALFD8BITSSEQ_INCLUDED_
`define SPIVIRTUALFD8BITSSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Extended class from spi virtual sequence
//--------------------------------------------------------------------------------------------
class SpiVirtualFd8BitsSeq extends SpiVirtualBaseFdSeq;
  `uvm_object_utils(SpiVirtualFd8BitsSeq)

  // declare extended class handles of master and slave sequence
  SpiMasterFd8BitsSeq spiMasterFd8BitsSeq;
  SpiSlaveFd8BitsSeq spiSlaveFd8BitsSeq;
  
  //--------------------------------------------------------------------------------------------
  // Externally defined tasks and functions
  //--------------------------------------------------------------------------------------------
  extern function new(string name="SpiVirtualFd8BitsSeq");
  extern task body();

endclass : SpiVirtualFd8BitsSeq

//--------------------------------------------------------------------------------------------
//Constructor:new
//
//Paramters:
//name - Instance name of the virtual_sequence
//parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiVirtualFd8BitsSeq::new(string name="SpiVirtualFd8BitsSeq");
  super.new(name);
endfunction: new

//--------------------------------------------------------------------------------------------
//task:body
//Creates the required ports
//
//Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
task SpiVirtualFd8BitsSeq::body();
 super.body(); //Sets up the sub-sequencer pointer

   //crearions master and slave sequence handles here  
   spiMasterFd8BitsSeq=SpiMasterFd8BitsSeq::type_id::create("spiMasterFd8BitsSeq");
   spiSlaveFd8BitsSeq=SpiSlaveFd8BitsSeq::type_id::create("spiSlaveFd8BitsSeq");

   //spiMasterFd8BitsSeq.req.print();
  
 
   //configuring no of masters and starting master sequencers

  fork 
      // TODO(mshariff): We need to connect the slaves with caution
      // as only ONe slave can drive on MISO line
      // so the sequences need to be started based on the System configurations

      // MSHA: //has_s_agt should be declared in env_config file
      // MSHA: if(e_cfg_h.has_s_agt) begin 
      // MSHA:   //no_of_sagent should be declared in env_config file
      // MSHA:   for(int i=0; i<e_cfg_h.no_of_sagent; i++) begin
      // MSHA:     //starting slave sequencer
      // MSHA:     spiSlaveFd8BitsSeq.start(s_seqr_h);
      // MSHA:   end
      // MSHA: end

      //starting slave sequencer with respective to p_sequencer declared in virtual seq base
      forever begin : SLAVE_SEQ_START
        spiSlaveFd8BitsSeq.start(p_sequencer.spiSlaveSequencer);
      end
    join_none
      //has_m_agt should be declared in env_config file
      // TODO(mshariff): Only one Master agent as SPI supports only one Master
      // MSHA:if(e_cfg_h.has_m_agt) begin
      // MSHA:  //no_of_magent should be declared in env_config file
      // MSHA:  for(int i=0; i<e_cfg_h.no_of_magent; i++) begin
      // MSHA:    //starting master sequencer
      // MSHA:    spiMasterFd8BitsSeq.start(m_seqr_h);
      // MSHA:  end
      // MSHA:end

      //starting master sequencer with respective to p_sequencer declared in virtual seq base
      

      repeat(5) begin : MASTER_SEQ_START
        spiMasterFd8BitsSeq.start(p_sequencer.spiMasterSequencer);
      end

endtask: body

`endif
