`ifndef SPIMASTERTRANSACTION_INCLUDED_
`define SPIMASTERTRANSACTION_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiMasterTransaction
// Description of the class
// This class holds the data items required to drive stimulus to dut
// and also holds methods that manipulate those data items
//--------------------------------------------------------------------------------------------
class SpiMasterTransaction extends uvm_sequence_item;
  
  //register with factory so we can override with uvm method in future if necessary.

  `uvm_object_utils(SpiMasterTransaction)

  //input signals
  rand bit [CHAR_LENGTH-1:0]masterOutSlaveIn[];
  rand bit [NO_OF_SLAVES-1:0] cs;
  bit [CHAR_LENGTH-1:0] masterInSlaveOut[];
  rand bit [CHAR_LENGTH/2-1:0]mosi0[];
  rand bit [CHAR_LENGTH/2-1:0]mosi1[];
       bit [CHAR_LENGTH/2-1:0]miso0[];
       bit [CHAR_LENGTH/2-1:0]miso1[];
  //--------------------------------------------------------------------------------------------
  // Constraints for SPI
  //--------------------------------------------------------------------------------------------

 constraint mosi_c { masterOutSlaveIn.size() > 0 ;
                     masterOutSlaveIn.size() < MAXIMUM_BITS/CHAR_LENGTH;}

 // constraint dual_spi_bits{foreach(mosi0[i])
 //                          if (i%2==0) 
 //                             mosi0[i]%2==0;
 //                          else
 //                             mosi0[i]%2!=0;}


  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiMasterTransaction");
  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);
endclass : SpiMasterTransaction

//--------------------------------------------------------------------------------------------
//  Construct: new
//  initializes the class object
//
//  Parameters:
//  name - SpiMasterTransaction
//--------------------------------------------------------------------------------------------
function SpiMasterTransaction::new(string name = "SpiMasterTransaction");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// do_copy method
//--------------------------------------------------------------------------------------------

function void SpiMasterTransaction::do_copy (uvm_object rhs);
  SpiMasterTransaction spiMasterTxCopyObj;
  
  if(!$cast(spiMasterTxCopyObj,rhs)) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
  end
  super.do_copy(rhs);

  cs = spiMasterTxCopyObj.cs;
  masterInSlaveOut = spiMasterTxCopyObj.masterInSlaveOut;
  masterOutSlaveIn = spiMasterTxCopyObj.masterOutSlaveIn;

endfunction : do_copy

//--------------------------------------------------------------------------------------------
// do_compare method
//--------------------------------------------------------------------------------------------
function bit  SpiMasterTransaction::do_compare (uvm_object rhs,uvm_comparer comparer);
  SpiMasterTransaction spiMasterTxCompareObj;

  if(!$cast(spiMasterTxCompareObj,rhs)) begin
  `uvm_fatal("FATAL_SpiMasterTransaction_DO_COMPARE_FAILED","cast of the rhs object failed")
  return 0;
  end

  return super.do_compare(rhs,comparer) &&
  masterOutSlaveIn== spiMasterTxCompareObj.masterOutSlaveIn &&
  masterInSlaveOut== spiMasterTxCompareObj.masterInSlaveOut;
endfunction : do_compare

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void SpiMasterTransaction::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field( "cs", cs , 2,UVM_BIN);
  foreach(masterOutSlaveIn[i]) begin
    printer.print_field($sformatf("masterOutSlaveIn[%0d]",i),this.masterOutSlaveIn[i],8,UVM_HEX);
  end
  foreach(masterInSlaveOut[i]) begin
    printer.print_field($sformatf("masterInSlaveOut[%0d]",i),this.masterInSlaveOut[i],8,UVM_HEX);
  end
  foreach(mosi0[i]) begin
    printer.print_field($sformatf("mosi0[%0d]",i),this.mosi0[i],4,UVM_HEX);
  end
  foreach(mosi1[i]) begin
    printer.print_field($sformatf("mosi1[%0d]",i),this.mosi1[i],4,UVM_HEX);
  end
  foreach(miso0[i]) begin
    printer.print_field($sformatf("miso0[%0d]",i),this.miso0[i],4,UVM_HEX);
  end
  foreach(miso1[i]) begin
    printer.print_field($sformatf("miso1[%0d]",i),this.miso1[i],4,UVM_HEX);
  end

endfunction : do_print

`endif

