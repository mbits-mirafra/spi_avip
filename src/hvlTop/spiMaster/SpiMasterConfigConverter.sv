`ifndef SPIMASTERCONFIGCONVERTER_INCLUDED_
`define SPIMASTERCONFIGCONVERTER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiMasterConfigConverterzo
// Description:
// class for converting master_config configurations into struct configurations
//--------------------------------------------------------------------------------------------
class SpiMasterConfigConverter extends uvm_object;
  `uvm_object_utils(SpiMasterConfigConverter)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiMasterConfigConverter");

  extern static function void fromClass(input SpiMasterAgentConfig inputConv, 
                                        output spiTransferConfigStruct outputConv);

  //extern static function void toClass(input spiTransferConfigStruct input_conv, output master_tx outputConv_h);
  extern function void do_print(uvm_printer printer);

endclass : SpiMasterConfigConverter

//--------------------------------------------------------------------------------------------
// Construct: new
//
//
//
// Parameters:
//
//  name - SpiMasterConfigConverter
//--------------------------------------------------------------------------------------------
function SpiMasterConfigConverter::new(string name = "SpiMasterConfigConverter");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// function: fromClass
// converting master_config configurations into structure configurations
//--------------------------------------------------------------------------------------------
function void SpiMasterConfigConverter::fromClass(input SpiMasterAgentConfig inputConv,
                                                   output spiTransferConfigStruct outputConv);
    bit cpol;
    bit cpha;
    {cpol,cpha} = operationModesEnum'(inputConv.spiMode);
    outputConv.c2t = inputConv.c2tdelay;
    outputConv.t2c = inputConv.t2cdelay;
    outputConv.baudrateDivisor = inputConv.getBaudrateDivisor();
    `uvm_info("conv_bd",$sformatf("bd = \n %p",outputConv.baudrateDivisor),UVM_LOW)
    outputConv.cpol = cpol;
    outputConv.cpha = cpha;
    outputConv.msbFirst = shiftDirectionEnum'(inputConv.shiftDirection);
    outputConv.wdelay = inputConv.wdelay;

endfunction: fromClass 

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void SpiMasterConfigConverter::do_print(uvm_printer printer);

  spiTransferConfigStruct masterConfigStruct;
  super.do_print(printer);
  printer.print_field( "c2t", masterConfigStruct.c2t , $bits(masterConfigStruct.c2t),UVM_DEC);
  printer.print_field( "t2c", masterConfigStruct.t2c , $bits(masterConfigStruct.t2c),UVM_DEC);
  printer.print_field( "baudrateDivisor", masterConfigStruct.baudrateDivisor , $bits(masterConfigStruct.baudrateDivisor),UVM_DEC);
  printer.print_field( "cpol", masterConfigStruct.cpol , $bits(masterConfigStruct.cpol),UVM_DEC);
  printer.print_field( "cphase", masterConfigStruct.cpha , $bits(masterConfigStruct.cpha),UVM_DEC);
  printer.print_field( "msbFirst", masterConfigStruct.msbFirst , $bits(masterConfigStruct.msbFirst),UVM_BIN);

endfunction : do_print

`endif

