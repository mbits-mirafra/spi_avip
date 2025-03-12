`ifndef SPIMASTERAGENTCONFIG_INCLUDED_
`define SPIMASTERAGENTCONFIG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: SpiMasterAgentConfig
// Used as the configuration class for master agent, for configuring number of slaves and number
// of active passive agents to be created
//--------------------------------------------------------------------------------------------
class SpiMasterAgentConfig extends uvm_object;
  `uvm_object_utils(SpiMasterAgentConfig)

  // Variable: isActive
  // Used for creating the agent in either passive or active mode
  uvm_active_passive_enum isActive=UVM_ACTIVE;  

  // Variable: noOfSlaves
  // Used for specifying the number of slaves connected to 
  // this master over SPI interface
  int noOfSlaves;

  // Variable: spiMode 
  // Used for setting the opeartion mode 
  rand operationModesEnum spiMode;

  // Variable: shiftDirection
  // Shifts the data, LSB first or MSB first
  rand shiftDirectionEnum shiftDirection;

  // Variable: c2tdelay
  // Delay between CS assertion to clock generation
  // Used for setting the setup time 
  // Default value is 1
  //int c2tdelay = 1;
  rand int c2tdelay;

  // Variable: t2cdelay
  // Delay between end of clock to CS de-assertion
  // Used for setting the hold time 
  // Default value is 1
  //int t2cdelay = 1;
  rand int t2cdelay;

  // Variable: wdelay
  // Delay between the transfers 
  // Used for setting the time required between 2 transfers 
  // in terms of SCLK 
  // Default value is 1
  //int wdelay = 1;
  rand int wdelay;
  
  // Variable: primaryPrescalar
  // Used for setting the primary prescalar value for baudrateDivisor
  rand protected bit[2:0] primaryPrescalar;

  // Variable: secondaryPrescalar
  // Used for setting the secondary prescalar value for baudrateDivisor
  rand protected bit[2:0] secondaryPrescalar;

  // Variable: baudrateDivisor_divisor
  // Defines the date rate 
  //
  // baudrateDivisor_divisor = (secondaryPrescalar+1) * (2 ** (primaryPrescalar+1))
  // baudrate = busclock / baudrateDivisor_divisor;
  //
  // Default value is 2
  protected int baudrateDivisor;

  // Variable: hasCoverage
  // Used for enabling the master agent coverage
  bit hasCoverage;

  //spiTypeEnum enum declared in global pakage for simple,dual,quad 
  spiTypeEnum spiType;

  constraint c2t_c{c2tdelay dist {[1:10]:=94, [11:$]:/6};}
  constraint t2c_c{t2cdelay dist {[1:10]:=94, [11:$]:/6};}
  constraint wdely_c{wdelay dist {[1:10]:=98, [11:$]:/2};}
  constraint delay_c{ c2tdelay>0; 
                      t2cdelay>0;
                      wdelay>0;
                    }
  constraint primaryPrescalar_c{primaryPrescalar dist {[0:1]:=80,[2:7]:/20};}
  constraint secondaryPrescalar_c{secondaryPrescalar dist {[0:1]:=80,[2:7]:/20};}

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "SpiMasterAgentConfig");
  extern function void do_print(uvm_printer printer);
  extern function void setBaudrateDivisor(int primaryPrescalar, int secondaryPrescalar);
  extern function int getBaudrateDivisor();
  extern function void post_randomize();
endclass : SpiMasterAgentConfig

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - SpiMasterAgentConfig
//--------------------------------------------------------------------------------------------
function SpiMasterAgentConfig::new(string name = "SpiMasterAgentConfig");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
function void SpiMasterAgentConfig::do_print(uvm_printer printer);
  super.do_print(printer);


  printer.print_string ("isActive",isActive.name());
  printer.print_field ("noOfSlaves",noOfSlaves,$bits(noOfSlaves), UVM_DEC);
  printer.print_string ("spiMode",spiMode.name());
  printer.print_string ("shiftDirection",shiftDirection.name());
  printer.print_field ("c2tdelay",c2tdelay, $bits(c2tdelay), UVM_DEC);
  printer.print_field ("t2cdelay",t2cdelay, $bits(t2cdelay), UVM_DEC);
  printer.print_field ("wdelay",wdelay, $bits(wdelay), UVM_DEC);
  printer.print_field ("primaryPrescalar",primaryPrescalar, 3, UVM_DEC);
  printer.print_field ("secondaryPrescalar",secondaryPrescalar, 3, UVM_DEC);
  printer.print_field ("baudrateDivisor",baudrateDivisor, 32, UVM_DEC);
  printer.print_field ("hasCoverage",hasCoverage, 1, UVM_DEC);
  printer.print_string ("spiType",spiType.name());
  
endfunction : do_print

//--------------------------------------------------------------------------------------------
// Function: setBaudrateDivisor
// Sets the baudrate divisor value from primaryPrescalar and secondaryPrescalar

// baudrateDivisor_divisor = (secondaryPrescalar+1) * (2 ** (primaryPrescalar+1))
// baudrate = busclock / baudrateDivisor_divisor;
//
// Parameters:
//  primaryPrescalar - Primary prescalar value for baudrate calculation
//  secondaryPrescalar - Secondary prescalar value for baudrate calculation
//--------------------------------------------------------------------------------------------
function void SpiMasterAgentConfig::setBaudrateDivisor(int primaryPrescalar, int secondaryPrescalar);
  this.primaryPrescalar = primaryPrescalar;
  this.secondaryPrescalar = secondaryPrescalar;

  baudrateDivisor = (this.secondaryPrescalar + 1) * (2 ** (this.primaryPrescalar + 1));

endfunction : setBaudrateDivisor

function void SpiMasterAgentConfig::post_randomize();
  setBaudrateDivisor(this.primaryPrescalar,this.secondaryPrescalar);
endfunction: post_randomize

function int SpiMasterAgentConfig::getBaudrateDivisor();
  return(this.baudrateDivisor);
endfunction: getBaudrateDivisor

`endif

