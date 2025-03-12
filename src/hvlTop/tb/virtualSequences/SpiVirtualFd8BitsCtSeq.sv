`ifndef SPIVIRTUALFD8BITSCTSEQ_INCLUDED_
`define SPIVIRTUALFD8BITSCTSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Extended class from spi virtual sequence
//--------------------------------------------------------------------------------------------
class SpiVirtualFd8BitsCtSeq extends SpiVirtualBaseFdSeq;
  
  `uvm_object_utils(SpiVirtualFd8BitsCtSeq)

  //declare extended class handles of master and slave sequence
  SpiMasterFd8BitsCtSeq spiMasterFd8BitsCtSeq;
  SpiSlaveFd8BitsCtSeq spiSlaveFd8BitsCtSeq;

  //--------------------------------------------------------------------------------------------
  // Externally defined tasks and functions
  //--------------------------------------------------------------------------------------------
  extern function new(string name="SpiVirtualFd8BitsCtSeq");
  extern task body();

endclass : SpiVirtualFd8BitsCtSeq


//--------------------------------------------------------------------------------------------
//Constructor:new
//
//Paramters:
//name - Instance name of the virtual_sequence
//parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiVirtualFd8BitsCtSeq::new(string name="SpiVirtualFd8BitsCtSeq");
  super.new(name);
endfunction: new

//--------------------------------------------------------------------------------------------
//task:body
//Creates the required ports
//
//Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
task SpiVirtualFd8BitsCtSeq::body();
 super.body(); //Sets up the sub-sequencer pointer

   //crearions master and slave sequence handles here  
   spiMasterFd8BitsCtSeq=SpiMasterFd8BitsCtSeq::type_id::create("spiMasterFd8BitsCtSeq");
   spiSlaveFd8BitsCtSeq=SpiSlaveFd8BitsCtSeq::type_id::create("spiSlaveFd8BitsCtSeq");

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
      // MSHA:  spiSlaveFd8BitsCtSeq.start(s_seqr_h);
      // MSHA:  end
      // MSHA: end

      //starting slave sequencer
      forever begin : SLAVE_SEQ_START
        spiSlaveFd8BitsCtSeq.start(p_sequencer.spiSlaveSequencer);
      end
  join_none
    // TODO(mshariff): Only one Master agent as SPI supports only one Master

    // MSHA: if(e_cfg_h.has_m_agt)begin
    // MSHA: //no_of_magent should be declared in env_config file
    // MSHA: for(int i=0; i<e_cfg_h.no_of_magent; i++)begin
    // MSHA:   //starting master sequencer
    // MSHA:   spiMasterFd8BitsCtSeq.start(m_seqr_h);
    // MSHA:   end
    // MSHA: end

    //starting master sequencer
    repeat(5)begin: MASTER_SEQ_START
      spiMasterFd8BitsCtSeq.start(p_sequencer.spiMasterSequencer);
    end

endtask: body

`endif
