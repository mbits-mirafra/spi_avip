`ifndef SPISCOREBOARD_INCLUDED_
`define SPISCOREBOARD_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiScoreboard
// Scoreboard the data getting from monitor port that goes into the implementation port
//--------------------------------------------------------------------------------------------
class SpiScoreboard extends uvm_scoreboard;
  `uvm_component_utils(SpiScoreboard)
  
  //Variable : spiMasterTransaction
  //declaring master transaction handle
  SpiMasterTransaction spiMasterTransaction;
  
  //Variable : spiSlaveTransaction
  //declaring slave transaction handle
  SpiSlaveTransaction spiSlaveTransaction;
  
  //Variable : spiEnvConfig
  //declaring env config handle
  SpiEnvConfig spiEnvConfig;

  //Variable : masterAnalysisFIFO
  //declaring analysis fifo
  uvm_tlm_analysis_fifo#(SpiMasterTransaction) masterAnalysisFIFO;
 
  //Variable : slaveAnalysisFIFO
  //declaring analysis fifo
  uvm_tlm_analysis_fifo#(SpiSlaveTransaction) slaveAnalysisFIFO;
  
  //Variable spiMasterTransactionCount
  //to keep track of number of transaction for master spi
  int spiMasterTransactionCount = 0;

  //Variable spiSlaveTransactionCount
  //to keep track of number of transaction for slave spi
  int spiSlaveTransactionCount = 0;

  //Variable byteDataCompareVerifiedMosiCount
  //to keep track of number of byte wise compared verified mosi data
  int byteDataCompareVerifiedMosiCount = 0;

  //Variable byteDataCompareVerifiedMisoCount
  //to keep track of number of byte wise compared verified miso data
  int byteDataCompareVerifiedMisoCount = 0;

  //Variable byteDataCompareFailedMosiCount
  //to keep track of number of byte wise compared failed mosi data
  int byteDataCompareFailedMosiCount = 0;

  //Variable byteDataCompareFailedMisoCount
  //to keep track of number of byte wise compared failed miso data
  int byteDataCompareFailedMisoCount = 0;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiScoreboard", uvm_component parent = null);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void check_phase (uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);
endclass : SpiScoreboard

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - SpiScoreboard
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function SpiScoreboard::new(string name = "SpiScoreboard", uvm_component parent = null);
  super.new(name, parent);
  masterAnalysisFIFO = new("masterAnalysisFIFO",this);
  slaveAnalysisFIFO = new("slaveAnalysisFIFO",this);
endfunction : new



//--------------------------------------------------------------------------------------------
// Task: run_phase
// All the comparision are done
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task SpiScoreboard::run_phase(uvm_phase phase);

 super.run_phase(phase);

 forever begin
 
 `uvm_info(get_type_name(),$sformatf("before calling analysis fifo get method"),UVM_HIGH)
 masterAnalysisFIFO.get(spiMasterTransaction);
 // TODO(mshariff): Keep a track on master transaction
 spiMasterTransactionCount++;
 
 `uvm_info(get_type_name(),$sformatf("after calling analysis fifo get method"),UVM_HIGH) 
 `uvm_info(get_type_name(),$sformatf("printing spiMasterTransaction, \n %s",spiMasterTransaction.sprint()),UVM_HIGH)

 slaveAnalysisFIFO .get(spiSlaveTransaction);
 // TODO(mshariff): Keep a track on slave transaction
 spiSlaveTransactionCount++;
 
 `uvm_info(get_type_name(),$sformatf("after calling analysis fifo get method"),UVM_HIGH) 
 `uvm_info(get_type_name(),$sformatf("printing spiSlaveTransaction, \n %s",spiSlaveTransaction.sprint()),UVM_HIGH)
 
 // MSHA:   Displpay even the SLave id - it must be in the packet 
 
 // MSHA:   // TODO(mshariff): 
 // MSHA:   // Once you get the transcations, do the comparision per byte basis
 // MSHA:   // Master MOSI with Slave MISO and
 // MSHA:   // SLave MISO with Master MOSI
 // MSHA:   // Also, no_of_mosi_bits and no_of_miso_bits
  
  
 
  // Data comparision for MOSI 
  if (spiMasterTransaction.masterOutSlaveIn.size() == spiSlaveTransaction.masterOutSlaveIn.size())begin 
   `uvm_info (get_type_name(), $sformatf ("Size of MOSI data from Master and Slave is equal"),UVM_HIGH);
  end
  else begin
   `uvm_error (get_type_name(),$sformatf("Size of MOSI data from Master and Slave is not equal"));
  end

  foreach(spiMasterTransaction.masterOutSlaveIn[i]) begin
     if(spiMasterTransaction.masterOutSlaveIn[i] != spiSlaveTransaction.masterOutSlaveIn[i]) begin
       `uvm_error("ERROR_SC_MOSI_DATA_MISMATCH", 
                 $sformatf("Master MOSI[%0d] = 'h%0x and Slave MOSI[%0d] = 'h%0x", 
                           i, spiMasterTransaction.masterOutSlaveIn[i],
                           i, spiSlaveTransaction.masterOutSlaveIn[i]) );
       byteDataCompareFailedMosiCount++;
     end
     else begin
       `uvm_info("SB_MOSI_DATA_MATCH", 
                 $sformatf("Master MOSI[%0d] = 'h%0x and Slave MOSI[%0d] = 'h%0x", 
                           i, spiMasterTransaction.masterOutSlaveIn[i],
                           i, spiSlaveTransaction.masterOutSlaveIn[i]), UVM_HIGH);
                           
       byteDataCompareVerifiedMosiCount++;
     end
    end   

  // TODO(mshariff): Do a similar work for MISO

   if (spiSlaveTransaction.masterInSlaveOut.size() == spiMasterTransaction.masterInSlaveOut.size()) begin
      `uvm_info (get_type_name(), $sformatf ("Size of MISO data from Master and Slave is equal"),UVM_HIGH);
    end
   else begin
      `uvm_error (get_type_name(),$sformatf("Size of MISO data in Master and Slave is not equal"));
   end

  foreach(spiSlaveTransaction.masterInSlaveOut[i]) begin
      if(spiSlaveTransaction.masterInSlaveOut[i] != spiMasterTransaction.masterInSlaveOut[i]) begin
        `uvm_error("ERROR_SC_MISO_DATA_MISMATCH", 
                  $sformatf("Slave MISO[%0d] = 'h%0x and Master MISO[%0d] = 'h%0x", 
                            i, spiSlaveTransaction.masterInSlaveOut[i],
                            i, spiMasterTransaction.masterInSlaveOut[i]) );
        byteDataCompareFailedMisoCount++;
      end
      else begin
        `uvm_info("SB_MISO_DATA_MATCH", 
                  $sformatf("Slave MISO[%0d] = 'h%0x and Master MISO[%0d] = 'h%0x", 
                            i, spiSlaveTransaction.masterInSlaveOut[i],
                            i, spiMasterTransaction.masterInSlaveOut[i]), UVM_HIGH);
        byteDataCompareVerifiedMisoCount++;
      end
    end

// Done this part in report phase
// MSHA:   // TODO(mshariff): After comparisions, keep a track of the sno of comparisions done
  end

endtask : run_phase

//--------------------------------------------------------------------------------------------
// Function: check_phase
// Display the result of simulation
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiScoreboard::check_phase(uvm_phase phase);
  super.check_phase(phase);

  // TODO(mshariff): Banner as discussed
  // `uvm_info (get_type_name(),$sformatf(" Scoreboard Check Phase is starting"),UVM_HIGH); 
  $display(" ");
  $display("-------------------------------------------- ");
  $display("SCOREBOARD CHECK PHASE");
  $display("-------------------------------------------- ");
  $display(" ");
// TODO(mshariff): Check the following:

// 1. Check if the comparisions counter is NON-zero
//    A non-zero value indicates that the comparisions never happened and throw error
  
  if ((byteDataCompareVerifiedMosiCount != 0)&&(byteDataCompareFailedMosiCount == 0)) begin
	  `uvm_info (get_type_name(), $sformatf ("all mosi comparisions are succesful"),UVM_NONE);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("byteDataCompareVerifiedMosiCount :%0d",
                                            byteDataCompareVerifiedMosiCount),UVM_NONE);
	  `uvm_info (get_type_name(), $sformatf ("byteDataCompareFailedMosiCount : %0d", 
                                            byteDataCompareFailedMosiCount),UVM_NONE);
    `uvm_error (get_type_name(), $sformatf ("comparisions of mosi not happened"));
  end

  if ((byteDataCompareVerifiedMisoCount != 0)&&(byteDataCompareFailedMisoCount == 0) ) begin
	  `uvm_info (get_type_name(), $sformatf ("all miso comparisions are succesful"),UVM_NONE);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("byteDataCompareVerifiedMisoCount :%0d",
                                            byteDataCompareVerifiedMisoCount),UVM_NONE);
	  `uvm_info (get_type_name(), $sformatf ("byteDataCompareFailedMisoCount : %0d", 
                                            byteDataCompareFailedMisoCount),UVM_NONE);
  end

// 2. Check if master packets received are same as slave packets received
//    To Make sure that we have equal number of master and slave packets
  
 if (spiMasterTransactionCount == spiSlaveTransactionCount ) begin
    `uvm_info (get_type_name(), $sformatf ("master and slave have equal no. of transactions"),UVM_HIGH);
  end
  else begin
    `uvm_info (get_type_name(), $sformatf ("spiMasterTransactionCount : %0d",spiMasterTransactionCount ),UVM_HIGH);
    `uvm_info (get_type_name(), $sformatf ("spiSlaveTransactionCount : %0d",spiSlaveTransactionCount ),UVM_HIGH);
    `uvm_error (get_type_name(), $sformatf ("master and slave doesnot have same no. of transactions"));
  end 


// 3. Analyis fifos must be zero - This will indicate that all the packets have been compared
//    This is to make sure that we have taken all packets from both FIFOs and made the
//    comparisions
   
  if (masterAnalysisFIFO.size() == 0)begin
    // TODO(mshariff): Chnage the info's to errors
     `uvm_info (get_type_name(), $sformatf ("Master analysis FIFO is empty"),UVM_HIGH);
  end
  else begin
     `uvm_info (get_type_name(), $sformatf ("masterAnalysisFIFO:%0d",masterAnalysisFIFO.size() ),UVM_HIGH);
     `uvm_error (get_type_name(), $sformatf ("Master analysis FIFO is not empty"));
  end
  if (slaveAnalysisFIFO.size()== 0)begin
    // TODO(mshariff): Chnage the info's to errors
     `uvm_info (get_type_name(), $sformatf ("Slave analysis FIFO is empty"),UVM_HIGH);
  end
  else begin
     `uvm_info (get_type_name(), $sformatf ("slaveAnalysisFIFO:%0d",slaveAnalysisFIFO.size()),UVM_HIGH);
     `uvm_error (get_type_name(),$sformatf ("Slave analysis FIFO is not empty"));
  end

endfunction : check_phase

//--------------------------------------------------------------------------------------------
// Function: report_phase
// Display the result of simulation
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void SpiScoreboard::report_phase(uvm_phase phase);
  super.report_phase(phase);
  //`uvm_info("scoreboard",$sformatf("Scoreboard Report"),UVM_HIGH);
  
  // TODO(mshariff): Print the below items:
  // TODO(mshariff): Banner as discussed
  $display(" ");
  $display("-------------------------------------------- ");
  $display("SCOREBOARD REPORT PHASE");
  $display("-------------------------------------------- ");
  $display(" ");
  // Total number of packets received from the Master
  `uvm_info (get_type_name(),$sformatf("No. of transactions from master:%0d",
                             spiMasterTransactionCount),UVM_NONE);

  //Total number of packets received from the Slave (with their ID)
  `uvm_info (get_type_name(),$sformatf("No. of transactions from slave:%0d", 
                             spiSlaveTransactionCount),UVM_NONE);
  
//  //Number of mosi comparisions done
//  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise mosi comparisions:%0d",
//                 byteDataCompareVerifiedMosiCount+byteDataCompareFailedMosiCount),UVM_HIGH);
//  //Number of miso comparisions done
//  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise miso comparisions:%0d",
//                 byteDataCompareVerifiedMisoCount+byteDataCompareFailedMisoCount),UVM_HIGH);
  
  //Number of mosi comparisios passed
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise mosi comparisions passed:%0d",
                byteDataCompareVerifiedMosiCount),UVM_NONE);

  //Number of miso comparisios passed
  `uvm_info (get_type_name(),$sformatf("Total no. of byte wise miso comparisions passed:%0d",
                byteDataCompareVerifiedMisoCount),UVM_NONE);
  
  //Number of mosi compariosn failed
  `uvm_info (get_type_name(),$sformatf("No. of byte wise mosi comparision failed:%0d",
                byteDataCompareFailedMosiCount),UVM_NONE);

  //Number of miso compariosn failed
  `uvm_info (get_type_name(),$sformatf("No. of byte wise miso comparision failed:%0d",
                byteDataCompareFailedMisoCount),UVM_NONE);

endfunction : report_phase

`endif
