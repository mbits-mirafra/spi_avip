`ifndef SPIVIRTUALFDRANDSEQ_INCLUDED_
`define SPIVIRTUALFDRANDSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Extended class from spi virtual sequence
//--------------------------------------------------------------------------------------------
class SpiVirtualFdRandSeq extends SpiVirtualBaseFdSeq;
  
  `uvm_object_utils(SpiVirtualFdRandSeq)

  //declare extended class handles of master and slave sequence
  SpiMasterFdRandSeq spiMasterFdRandSeq;
  SpiSlaveFdRandSeq spiSlaveFdRandSeq;

  //--------------------------------------------------------------------------------------------
  // Externally defined tasks and functions
  //--------------------------------------------------------------------------------------------
  extern function new(string name="SpiVirtualFdRandSeq");
  extern task body();

endclass : SpiVirtualFdRandSeq

//--------------------------------------------------------------------------------------------
//Constructor:new
//
//Paramters:
//name - Instance name of the virtual_sequence
//parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiVirtualFdRandSeq::new(string name="SpiVirtualFdRandSeq");
  super.new(name);
endfunction: new

//--------------------------------------------------------------------------------------------
//task:body
//Creates the required ports
//
//Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
task SpiVirtualFdRandSeq::body();
   //creations master and slave sequence handles here  
   spiMasterFdRandSeq = SpiMasterFdRandSeq::type_id::create("spiMasterFdRandSeq");
   spiSlaveFdRandSeq = SpiSlaveFdRandSeq::type_id::create("spiSlaveFdRandSeq");
 
   super.body(); //Sets up the sub-sequencer pointer


  fork
      // TODO(mshariff): We need to connect the slaves with caution
      // as only ONe slave can drive on MISO line
      // so the sequences need to be started based on the System config_cpol0_cpha0_msb_c2t_t2c_baudrate

      //starting slave sequencer
      forever begin: SLAVE_SEQ_START
        spiSlaveFdRandSeq.start(p_sequencer.spiSlaveSequencer);
      end
  join_none

    //has_m_agt should be declared in env_config file
    // TODO(mshariff): Only one Master agent as SPI supports only one Master

    // MSHA: if(e_cfg_h.has_m_agt)begin
    // MSHA: //no_of_magent should be declared in env_config file
    // MSHA: for(int i=0; i<e_cfg_h.no_of_magent; i++)begin
    // MSHA:   //starting master sequencer
    // MSHA:   spi_fd_config_cpol0_cpha0_msb_c2t_t2c_baudrate_master_seq_h.start(m_seqr_h);
    // MSHA:   end
    // MSHA: end

    //starting master sequencer
    repeat(5)begin: MASTER_SEQ_START
      spiMasterFdRandSeq.start(p_sequencer.spiMasterSequencer);
    end

endtask: body

`endif
