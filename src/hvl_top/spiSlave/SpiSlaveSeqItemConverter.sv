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
  extern static function void fromClass(input spiSlaveTransaction inputConv,
                                         output spiTransferPacketStruct outputConv);
  extern static function void toClass(input spiTransferPacketStruct inputConv,
                                        output spiSlaveTransaction outputConv);
  extern function void fromClass_msb_first(input spiSlaveTransaction inputConv, 
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
function void SpiSlaveSeqItemConverter::fromClass(input spiSlaveTransaction inputConv,
                                                        output spiTransferPacketStruct outputConv);

  outputConv.noOfMISObitsTransfer = inputConv.masterInSlaveOut.size()*CHAR_LENGTH;
  `uvm_info("SpiSlaveSeqItemConverter",
  $sformatf("noOfMISObitsTransfer = \n %p",
  outputConv.noOfMISObitsTransfer),UVM_HIGH)

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
function void SpiSlaveSeqItemConverter::fromClass_msb_first(input spiSlaveTransaction inputConv,
                                                           output spiTransferPacketStruct outputConv);
  
  outputConv.noOfMOSIbitsTransfer = inputConv.masterOutSlaveIn.size()*CHAR_LENGTH;
  
  for(int i=outputConv.noOfMOSIbitsTransfer; i>0; i++) begin
    outputConv.masterOutSlaveIn[i] = inputConv.masterOutSlaveIn[i];
  end

endfunction: fromClass_msb_first

//--------------------------------------------------------------------------------------------
// function:toClass
// converting struct data items into seq_item transactions
//--------------------------------------------------------------------------------------------
function void SpiSlaveSeqItemConverter::toClass(input spiTransferPacketStruct inputConv, 
                                                      output spiSlaveTransaction outputConv);
  outputConv = new();

  // Defining the size of arrays
  outputConv.masterOutSlaveIn = new[inputConv.noOfMOSIbitsTransfer/CHAR_LENGTH];
  //outputConv.masterOutSlaveIn = new[inputConv.noOfMOSIbitsTransfer];
  outputConv.masterInSlaveOut = new[inputConv.noOfMISObitsTransfer/CHAR_LENGTH];
  //outputConv.masterInSlaveOut = new[inputConv.noOfMISObitsTransfer];

  // Storing the values in the respective arrays
  for(int i=0; i<inputConv.noOfMOSIbitsTransfer/CHAR_LENGTH; i++) begin
  //for(int i=0; i<inputConv.noOfMOSIbitsTransfer; i++) begin
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
