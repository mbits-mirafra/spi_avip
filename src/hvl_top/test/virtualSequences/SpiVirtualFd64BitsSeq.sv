`ifndef SPIVIRTUALFD64BITSSEQ_INCLUDED_
`define SPIVIRTUALFD64BITSSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Extended class from spi virtual sequence
//--------------------------------------------------------------------------------------------
class SpiVirtualFd64BitsSeq extends SpiVirtualBaseFdSeq;
  
  `uvm_object_utils(SpiVirtualFd64BitsSeq)

  //declare extended class handles of master and slave sequence
  
  SpiMasterFd64BitsSeq spiMasterFd64BitsSeq;
  SpiSlaveFd64BitsSeq spiSlaveFd64BitsSeq;

  //--------------------------------------------------------------------------------------------
  // Externally defined tasks and functions
  //--------------------------------------------------------------------------------------------
  extern function new(string name="SpiVirtualFd64BitsSeq");
  extern task body();

endclass : SpiVirtualFd64BitsSeq

//--------------------------------------------------------------------------------------------
//Constructor:new
//
//Paramters:
//name - Instance name of the virtual_sequence
//parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiVirtualFd64BitsSeq::new(string name="SpiVirtualFd64BitsSeq");
  super.new(name);
endfunction: new

//--------------------------------------------------------------------------------------------
//task:body
//Creates the required ports
//
//Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
task SpiVirtualFd64BitsSeq::body();
 super.body(); //Sets up the sub-sequencer pointer

   //crearions master and slave sequence handles here  
   spiMasterFd64BitsSeq=SpiMasterFd64BitsSeq::type_id::create("spiMasterFd64BitsSeq");
   spiSlaveFd64BitsSeq=SpiSlaveFd64BitsSeq::type_id::create("spiSlaveFd64BitsSeq");

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
      // MSHA:  spiSlaveFd64BitsSeq.start(s_seqr_h);
      // MSHA:  end
      // MSHA: end

      //starting slave sequencer
      forever begin : SLAVE_SEQ_START
        spiSlaveFd64BitsSeq.start(p_sequencer.spiSlaveSequencer);
      end
  join_none
    //has_m_agt should be declared in env_config file
    // TODO(mshariff): Only one Master agent as SPI supports only one Master

    // MSHA: if(e_cfg_h.has_m_agt)begin
    // MSHA: //no_of_magent should be declared in env_config file
    // MSHA: for(int i=0; i<e_cfg_h.no_of_magent; i++)begin
    // MSHA:   //starting master sequencer
    // MSHA:   spiMasterFd64BitsSeq.start(m_seqr_h);
    // MSHA:   end
    // MSHA: end

    //starting master sequencer
    repeat(5)begin : MASTER_SEQ_START
      spiMasterFd64BitsSeq.start(p_sequencer.spiMasterSequencer);
    end

endtask: body

`endif
