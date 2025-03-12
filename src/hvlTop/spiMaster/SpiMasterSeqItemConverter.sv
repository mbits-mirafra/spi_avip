`ifndef SPIMASTERSEQITEMCONVERTER_INCLUDED_
`define SPIMASTERSEQITEMCONVERTER_INCLUDED_

//--------------------------------------------------------------------------------------------
// class : SpiMasterSeqItemConverter
// Description:
// class converting seq_item transactions into struct data items and viceversa
//--------------------------------------------------------------------------------------------

class SpiMasterSeqItemConverter extends uvm_object;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiMasterSeqItemConverter");
  extern static function void fromClass(input SpiMasterTransaction inputConv,
                                         output spiTransferPacketStruct outputConv);
  extern static function void toClass(input spiTransferPacketStruct inputConv,
                                        output SpiMasterTransaction outputConv);
  extern function void fromClassMsbFirst(input SpiMasterTransaction inputConv, 
                                            output spiTransferPacketStruct outputConv);
  extern function void do_print(uvm_printer printer);

endclass : SpiMasterSeqItemConverter

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - SpiMasterSeqItemConverter
//--------------------------------------------------------------------------------------------
function SpiMasterSeqItemConverter::new(string name = "SpiMasterSeqItemConverter");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// function: fromClass
// converting seq_item transactions into struct data items
//--------------------------------------------------------------------------------------------
function void SpiMasterSeqItemConverter::fromClass(input SpiMasterTransaction inputConv,
                                                   output spiTransferPacketStruct outputConv);

  outputConv.noOfMosiBitsTransfer = inputConv.masterOutSlaveIn.size()*CHAR_LENGTH;
  `uvm_info("masterSeqItemConvClass",
  $sformatf("noOfMosiBitsTransfer = \n %p",
  outputConv.noOfMosiBitsTransfer),UVM_HIGH)

  for(int i=0; i<inputConv.masterOutSlaveIn.size(); i++) begin
    `uvm_info("masterSeqItemConvClass",
    $sformatf(" SpiMasterTransaction_inputConv masterOutSlaveIn = \n %p",
    inputConv.masterOutSlaveIn[i]),UVM_HIGH)
    outputConv.masterOutSlaveIn[i][CHAR_LENGTH-1:0] = inputConv.masterOutSlaveIn[i];    
    
    `uvm_info("masterSeqItemConvClass",
    $sformatf("outputConv_masterOutSlaveIn = \n %p",outputConv.masterOutSlaveIn),UVM_HIGH)
  end

  // MSHA: for(int i=0; i<outputConv.noOfMosiBitsTransfer; i++) begin
  // MSHA:   //outputConv.masterOutSlaveIn[i][j] = inputConv.masterOutSlaveIn[i];
  // MSHA:   //{<<byte{outputConv.masterOutSlaveIn[i]}} = inputConv.masterOutSlaveIn[i];
  // MSHA:   {{outputConv.masterOutSlaveIn[i]}} = inputConv.masterOutSlaveIn[i];
  // MSHA:   //outputConv.masterInSlaveOut[i] = inputConv.masterInSlaveOut[i];
  // MSHA: end

  outputConv.cs = inputConv.cs;

endfunction: fromClass 

//--------------------------------------------------------------------------------------------
// function: fromClass
// converting seq_item transactions into struct data items when msb is high
//--------------------------------------------------------------------------------------------
function void SpiMasterSeqItemConverter::fromClassMsbFirst(input SpiMasterTransaction inputConv,
                                                           output spiTransferPacketStruct outputConv);
  
  outputConv.noOfMosiBitsTransfer = inputConv.masterOutSlaveIn.size()*CHAR_LENGTH;
  
  for(int i=outputConv.noOfMosiBitsTransfer; i>0; i++) begin
    outputConv.masterOutSlaveIn[i] = inputConv.masterOutSlaveIn[i];
  end

endfunction: fromClassMsbFirst

//--------------------------------------------------------------------------------------------
// function:toClass
// converting struct data items into seq_item transactions
//--------------------------------------------------------------------------------------------
function void SpiMasterSeqItemConverter::toClass(input spiTransferPacketStruct inputConv, 
                                                 output SpiMasterTransaction outputConv);
  outputConv = new();

  // Defining the size of arrays
  outputConv.masterOutSlaveIn = new[inputConv.noOfMosiBitsTransfer/CHAR_LENGTH];
  outputConv.masterInSlaveOut = new[inputConv.noOfMisoBitsTransfer/CHAR_LENGTH];

  // Storing the values in the respective arrays
  for(int i=0; i<inputConv.noOfMosiBitsTransfer/CHAR_LENGTH; i++) begin
    outputConv.masterOutSlaveIn[i] = inputConv.masterOutSlaveIn[i][CHAR_LENGTH-1:0];
    `uvm_info("masterSeqItemConvClass",
    $sformatf("To class masterOutSlaveIn = \n %p",outputConv.masterOutSlaveIn[i]),UVM_HIGH)
    outputConv.masterInSlaveOut[i] = inputConv.masterInSlaveOut[i][CHAR_LENGTH-1:0];
    `uvm_info("masterSeqItemConvClass",
    $sformatf("To class masterInSlaveOut = \n %p",outputConv.masterOutSlaveIn[i]),UVM_HIGH)
  end

  outputConv.cs = inputConv.cs;
  
endfunction: toClass

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void SpiMasterSeqItemConverter::do_print(uvm_printer printer);

  spiTransferPacketStruct packetStruct;
  super.do_print(printer);

  foreach(packetStruct.cs[i]) begin
    printer.print_field( "cs", packetStruct.cs , 2,UVM_BIN);
  end

  foreach(packetStruct.masterOutSlaveIn[i]) begin
    printer.print_field($sformatf("masterOutSlaveIn[%0d]",i),packetStruct.masterOutSlaveIn[i],8,UVM_HEX);
  end

  foreach(packetStruct.masterInSlaveOut[i]) begin
    printer.print_field($sformatf("masterInSlaveOut[%0d]",i,),packetStruct.masterInSlaveOut[i],8,UVM_HEX);
  end

endfunction : do_print

`endif
