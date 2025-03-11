`ifndef SPISLAVETRANSACTION_INCLUDED_
`define SPISLAVETRANSACTION_INCLUDED_

//--------------------------------------------------------------------------------------------
//  Class: SpiSlaveTransaction
//  It's a transaction class that holds the SPI data items for generating the stimulus
//--------------------------------------------------------------------------------------------
class SpiSlaveTransaction extends uvm_sequence_item;
  `uvm_object_utils(SpiSlaveTransaction)

  //-------------------------------------------------------
  // Instantiating SPI signals
  //-------------------------------------------------------
  rand bit [CHAR_LENGTH-1:0]masterInSlaveOut[];

  bit [CHAR_LENGTH-1:0] masterOutSlaveIn[];
  rand bit [CHAR_LENGTH/2-1:0]miso0[];
  rand bit [CHAR_LENGTH/2-1:0]miso1[];
       bit [CHAR_LENGTH/2-1:0]mosi0[];
       bit [CHAR_LENGTH/2-1:0]mosi1[];

  //--------------------------------------------------------------------------------------------
  // Constraints for SPI
  //--------------------------------------------------------------------------------------------

  constraint miso_c { masterInSlaveOut.size() > 0 ;
                      masterInSlaveOut.size() < MAXIMUM_BITS/CHAR_LENGTH;}

  constraint max_bits_miso{foreach(masterInSlaveOut[i])
                                    masterInSlaveOut[i]%8 ==0;}
  constraint dual_spi_bits_even{foreach(miso0[i])
                              miso0[i]%2==0;}
  constraint dual_spi_bits_odd{foreach(miso1[i])
                              miso1[i]%2!=0;}
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiSlaveTransaction");
  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function void do_print(uvm_printer printer);

endclass : SpiSlaveTransaction

//--------------------------------------------------------------------------------------------
//  Construct: new
//  initializes the class object
//  Parameters: 
//  instance name of the slave template
//  Constructs the SpiSlaveTransaction object
//  
//  Parameters:
//  name - SpiSlaveTransaction
//--------------------------------------------------------------------------------------------
function SpiSlaveTransaction::new(string name = "SpiSlaveTransaction");
  super.new(name);  
endfunction : new

//--------------------------------------------------------------------------------------------
//do_copy method
//--------------------------------------------------------------------------------------------

function void SpiSlaveTransaction::do_copy (uvm_object rhs);
  SpiSlaveTransaction rhs_;

  if(!$cast(rhs_,rhs)) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
  end

  super.do_copy(rhs);

  masterInSlaveOut = rhs_.masterInSlaveOut;
  masterOutSlaveIn = rhs_.masterOutSlaveIn;

endfunction : do_copy


 //-------------------------------------------------------
 //  do_compare method
 //-------------------------------------------------------
function bit SpiSlaveTransaction::do_compare (uvm_object rhs,uvm_comparer comparer);
  SpiSlaveTransaction rhs_;
  if(!$cast(rhs_,rhs)) begin
    `uvm_fatal("do_compare","cast of the rhs object failed")
     return 0;
  end

  // TODO(mshariff): Redo this logic, keeping in mind the arrays
  return super.do_compare(rhs,comparer) &&
  masterInSlaveOut== rhs_.masterInSlaveOut &&
  masterOutSlaveIn== rhs_.masterOutSlaveIn;
endfunction : do_compare

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void SpiSlaveTransaction::do_print(uvm_printer printer);
  super.do_print(printer);
  foreach(masterInSlaveOut[i]) begin
    printer.print_field($sformatf("masterInSlaveOut[%0d]",i),this.masterInSlaveOut[i],8,UVM_HEX);
  end
  foreach(masterOutSlaveIn[i]) begin
    printer.print_field($sformatf("masterOutSlaveIn[%0d]",i),this.masterOutSlaveIn[i],8,UVM_HEX);
  end
  foreach(miso0[i]) begin
    printer.print_field($sformatf("miso0[%0d]",i),this.miso0[i],4,UVM_HEX);
  end
  foreach(miso1[i]) begin
    printer.print_field($sformatf("miso1[%0d]",i),this.miso1[i],4,UVM_HEX);
  end
  foreach(mosi0[i]) begin
    printer.print_field($sformatf("mosi0[%0d]",i),this.mosi0[i],4,UVM_HEX);
  end
  foreach(mosi1[i]) begin
    printer.print_field($sformatf("mosi1[%0d]",i),this.mosi1[i],4,UVM_HEX);
  end
endfunction : do_print

`endif
