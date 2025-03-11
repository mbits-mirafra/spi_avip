`ifndef SPIVIRTUALFDCPOL0CPHA0SEQ_INCLUDED_
`define SPIVIRTUALFDCPOL0CPHA0SEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Extended class from spi virtual sequence
//--------------------------------------------------------------------------------------------
class SpiVirtualFdCpol0Cpha0Seq extends SpiVirtualBaseFdSeq;
  
  `uvm_object_utils(SpiVirtualFdCpol0Cpha0Seq)

  //declare extended class handles of master and slave sequence
  SpiMasterFdCpol0Cpha0Seq spiMasterFdCpol0Cpha0Seq;
  SpiSlaveFdCpol0Cpha0Seq spiSlaveFdCpol0Cpha0Seq;

  //--------------------------------------------------------------------------------------------
  // Externally defined tasks and functions
  //--------------------------------------------------------------------------------------------
  extern function new(string name="SpiVirtualFdCpol0Cpha0Seq");
  extern task body();

endclass : SpiVirtualFdCpol0Cpha0Seq

//--------------------------------------------------------------------------------------------
//Constructor:new
//
//Paramters:
//name - Instance name of the virtual_sequence
//parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiVirtualFdCpol0Cpha0Seq::new(string name="SpiVirtualFdCpol0Cpha0Seq");
  super.new(name);
endfunction: new

//--------------------------------------------------------------------------------------------
//task:body
//Creates the required ports
//
//Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
task SpiVirtualFdCpol0Cpha0Seq::body();
 super.body(); //Sets up the sub-sequencer pointer

   //crearions master and slave sequence handles here  
   spiMasterFdCpol0Cpha0Seq=SpiMasterFdCpol0Cpha0Seq::type_id::create("spiMasterFdCpol0Cpha0Seq");
   spiSlaveFdCpol0Cpha0Seq=SpiSlaveFdCpol0Cpha0Seq::type_id::create("spiSlaveFdCpol0Cpha0Seq");

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
      // MSHA:  spiSlaveFdCpol0Cpha0Seq.start(s_seqr_h);
      // MSHA:  end
      // MSHA: end

      //starting slave sequencer
      forever begin: SLAVE_SEQ_START
        spiSlaveFdCpol0Cpha0Seq.start(p_sequencer.spiSlaveSequencer);
      end
  join_none
    //has_m_agt should be declared in env_config file
    // TODO(mshariff): Only one Master agent as SPI supports only one Master

    // MSHA: if(e_cfg_h.has_m_agt)begin
    // MSHA: //no_of_magent should be declared in env_config file
    // MSHA: for(int i=0; i<e_cfg_h.no_of_magent; i++)begin
    // MSHA:   //starting master sequencer
    // MSHA:   spiMasterFdCpol0Cpha0Seq.start(m_seqr_h);
    // MSHA:   end
    // MSHA: end

    //starting master sequencer
    repeat(5)begin: MASTER_SEQ_START
      spiMasterFdCpol0Cpha0Seq.start(p_sequencer.spiMasterSequencer);
    end
endtask: body

`endif
