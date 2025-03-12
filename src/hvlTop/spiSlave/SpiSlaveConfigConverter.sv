`ifndef SPISLAVECONFIGCONVERTER_INCLUDED_
`define SPISLAVECONFIGCONVERTER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiSlaveConfigConverter
// Description:
// class for converting slave_cfg configurations into struct configurations
//--------------------------------------------------------------------------------------------
class SpiSlaveConfigConverter extends uvm_object;
  `uvm_object_utils(SpiSlaveConfigConverter)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSlaveConfigConverter");
  extern static function void fromClass(input SpiSlaveAgentConfig inputConv ,
                                        output spiTransferConfigStruct outputConv);
  extern function void do_print(uvm_printer printer);

endclass : SpiSlaveConfigConverter

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - SpiSlaveConfigConverter
//--------------------------------------------------------------------------------------------
function SpiSlaveConfigConverter::new(string name = "SpiSlaveConfigConverter");
  super.new(name);
endfunction : new


//--------------------------------------------------------------------------------------------
// function: fromClass
// converting slave_cfg configurations into structure configurations
//--------------------------------------------------------------------------------------------
function void SpiSlaveConfigConverter::fromClass(input SpiSlaveAgentConfig inputConv ,
                                                 output spiTransferConfigStruct outputConv);

  {outputConv.cpol, outputConv.cpha} = operationModesEnum'(inputConv.spiMode);
  outputConv.msbFirst = shiftDirectionEnum'(inputConv.shiftDirection);

endfunction: fromClass 

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void SpiSlaveConfigConverter::do_print(uvm_printer printer);

  spiTransferConfigStruct configStruct;
  super.do_print(printer);
  printer.print_field( "c2t", configStruct.c2t , $bits(configStruct.c2t),UVM_DEC);
  printer.print_field( "t2c", configStruct.t2c , $bits(configStruct.t2c),UVM_DEC);
  printer.print_field( "wdelay", configStruct.wdelay , $bits(configStruct.wdelay),UVM_DEC);
  printer.print_field( "baudrateDivisor", configStruct.baudrateDivisor , $bits(configStruct.baudrateDivisor),UVM_DEC);
  printer.print_field( "cpol", configStruct.cpol , $bits(configStruct.cpol),UVM_DEC);
  printer.print_field( "cphase", configStruct.cpha , $bits(configStruct.cpha),UVM_DEC);

endfunction : do_print

`endif

