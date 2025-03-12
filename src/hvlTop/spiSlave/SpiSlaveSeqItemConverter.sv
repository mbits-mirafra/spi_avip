`ifndef SPISLAVESEQITEMCONVERTER_INCLUDED_
`define SPISLAVESEQITEMCONVERTER_INCLUDED_

//--------------------------------------------------------------------------------------------
// class : SpiSlaveSeqItemConverter
// Description:
// class converting seq_item transactions into struct data items and viceversa
//--------------------------------------------------------------------------------------------

class SpiSlaveSeqItemConverter extends uvm_object;
  
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSlaveSeqItemConverter");
  extern static function void fromClass(input SpiSlaveTransaction inputConv,
                                        output spiTransferPacketStruct outputConv);
  extern static function void toClass(input spiTransferPacketStruct inputConv,
                                      output SpiSlaveTransaction outputConv);
  extern function void fromClass_msb_first(input SpiSlaveTransaction inputConv, 
                                           output spiTransferPacketStruct outputConv);
  extern function void do_print(uvm_printer printer);

endclass : SpiSlaveSeqItemConverter

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - SpiSlaveSeqItemConverter
//--------------------------------------------------------------------------------------------
function SpiSlaveSeqItemConverter::new(string name = "SpiSlaveSeqItemConverter");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// function: fromClass
// converting seq_item transactions into struct data items
//--------------------------------------------------------------------------------------------
function void SpiSlaveSeqItemConverter::fromClass(input SpiSlaveTransaction inputConv,
                                                        output spiTransferPacketStruct outputConv);

  outputConv.noOfMisoBitsTransfer = inputConv.masterInSlaveOut.size()*CHAR_LENGTH;
  `uvm_info("SpiSlaveSeqItemConverter",
  $sformatf("noOfMisoBitsTransfer = \n %p",
  outputConv.noOfMisoBitsTransfer),UVM_HIGH)

  for(int i=0; i<inputConv.masterInSlaveOut.size(); i++) begin
    //outputConv.masterInSlaveOut = outputConv.masterInSlaveOut << CHAR_LENGTH;
    outputConv.masterInSlaveOut[i][CHAR_LENGTH-1:0] = inputConv.masterInSlaveOut[i];    
    `uvm_info("SpiSlaveSeqItemConverter",
    $sformatf("outputConv_masterInSlaveOut = \n %p",outputConv.masterInSlaveOut),UVM_HIGH)
    //outputConv.masterInSlaveOut[i] = inputConv.masterInSlaveOut[i];    
  end

endfunction: fromClass 

//--------------------------------------------------------------------------------------------
// function: fromClass
// converting seq_item transactions into struct data items when msb is high
//--------------------------------------------------------------------------------------------
function void SpiSlaveSeqItemConverter::fromClass_msb_first(input SpiSlaveTransaction inputConv,
                                                           output spiTransferPacketStruct outputConv);
  
  outputConv.noOfMosiBitsTransfer = inputConv.masterOutSlaveIn.size()*CHAR_LENGTH;
  
  for(int i=outputConv.noOfMosiBitsTransfer; i>0; i++) begin
    outputConv.masterOutSlaveIn[i] = inputConv.masterOutSlaveIn[i];
  end

endfunction: fromClass_msb_first

//--------------------------------------------------------------------------------------------
// function:toClass
// converting struct data items into seq_item transactions
//--------------------------------------------------------------------------------------------
function void SpiSlaveSeqItemConverter::toClass(input spiTransferPacketStruct inputConv, 
                                                output SpiSlaveTransaction outputConv);
  outputConv = new();

  // Defining the size of arrays
  outputConv.masterOutSlaveIn = new[inputConv.noOfMosiBitsTransfer/CHAR_LENGTH];
  //outputConv.masterOutSlaveIn = new[inputConv.noOfMosiBitsTransfer];
  outputConv.masterInSlaveOut = new[inputConv.noOfMisoBitsTransfer/CHAR_LENGTH];
  //outputConv.masterInSlaveOut = new[inputConv.noOfMisoBitsTransfer];

  // Storing the values in the respective arrays
  for(int i=0; i<inputConv.noOfMosiBitsTransfer/CHAR_LENGTH; i++) begin
  //for(int i=0; i<inputConv.noOfMosiBitsTransfer; i++) begin
    outputConv.masterOutSlaveIn[i] = inputConv.masterOutSlaveIn[i][CHAR_LENGTH-1:0];
    outputConv.masterInSlaveOut[i] = inputConv.masterInSlaveOut[i][CHAR_LENGTH-1:0];
  //  outputConv.masterOutSlaveIn[i] = inputConv.masterOutSlaveIn[i];
  //  outputConv.masterInSlaveOut[i] = inputConv.masterInSlaveOut[i];
  end
  
endfunction: toClass

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void SpiSlaveSeqItemConverter::do_print(uvm_printer printer);

  spiTransferPacketStruct configStruct;
  super.do_print(printer);

  foreach(configStruct.cs[i]) begin
    printer.print_field( "cs", configStruct.cs , 2,UVM_BIN);
  end

  foreach(configStruct.masterOutSlaveIn[i]) begin
    printer.print_field($sformatf("masterOutSlaveIn[%0d]",i),configStruct.masterOutSlaveIn[i],8,UVM_HEX);
  end

  foreach(configStruct.masterInSlaveOut[i]) begin
    printer.print_field($sformatf("masterInSlaveOut[%0d]",i,),configStruct.masterInSlaveOut[i],8,UVM_HEX);
  end

endfunction : do_print

`endif
