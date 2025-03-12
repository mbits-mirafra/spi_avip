`ifndef SPIVIRTUALFDMSBSEQ_INCLUDED_
`define SPIVIRTUALFDMSBSEQ_INCLUDED_

//--------------------------------------------------------------------------------------------
// Extended class from spi virtual sequence
//--------------------------------------------------------------------------------------------
class SpiVirtualFdMsbSeq extends SpiVirtualBaseFdSeq;
  
  `uvm_object_utils(SpiVirtualFdMsbSeq)

  //declare extended class handles of master and slave sequence
  SpiMasterFdMsbSeq spiMasterFdMsbSeq;
  SpiSlaveFdMsbSeq spiSlaveFdMsbSeq;

  //--------------------------------------------------------------------------------------------
  // Externally defined tasks and functions
  //--------------------------------------------------------------------------------------------
  extern function new(string name="SpiVirtualFdMsbSeq");
  extern task body();

endclass : SpiVirtualFdMsbSeq

//--------------------------------------------------------------------------------------------
//Constructor:new
//
//Paramters:
//name - Instance name of the virtual_sequence
//parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiVirtualFdMsbSeq::new(string name="SpiVirtualFdMsbSeq");
  super.new(name);
endfunction: new

//--------------------------------------------------------------------------------------------
//task:body
//Creates the required ports
//
//Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
task SpiVirtualFdMsbSeq::body();
 super.body(); //Sets up the sub-sequencer pointer
 
 //crearions master and slave sequence handles here  
 spiMasterFdMsbSeq=SpiMasterFdMsbSeq::type_id::create("spiMasterFdMsbSeq");
 spiSlaveFdMsbSeq=SpiSlaveFdMsbSeq::type_id::create("spiSlaveFdMsbSeq");

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
      // MSHA:  spiSlaveFdMsbSeq.start(s_seqr_h);
      // MSHA:  end
      // MSHA: end

      //starting slave sequencer
      forever begin: SLAVE_SEQ_START
        spiSlaveFdMsbSeq.start(p_sequencer.spiSlaveSequencer);
      end
    join_none
    //has_m_agt should be declared in env_config file
    // TODO(mshariff): Only one Master agent as SPI supports only one Master

    // MSHA: if(e_cfg_h.has_m_agt)begin
    // MSHA: //no_of_magent should be declared in env_config file
    // MSHA: for(int i=0; i<e_cfg_h.no_of_magent; i++)begin
    // MSHA:   //starting master sequencer
    // MSHA:   spiMasterFdMsbSeq.start(m_seqr_h);
    // MSHA:   end
    // MSHA: end

    //starting master sequencer
    repeat(5)begin: MASTER_SEQ_START
      spiMasterFdMsbSeq.start(p_sequencer.spiMasterSequencer);
    end

endtask: body

`endif
