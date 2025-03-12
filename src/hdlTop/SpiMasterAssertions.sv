`ifndef SPIMASTERASSERTIONS_INCLUDED_
`define SPIMASTERASSERTIONS_INCLUDED_

//-------------------------------------------------------
// Importing SPI Global Package
//-------------------------------------------------------
import SpiGlobalsPkg::*;

//--------------------------------------------------------------------------------------------
// Interface : Master Assertions
// Used to write the assertion checks needed for the master
//--------------------------------------------------------------------------------------------

interface SpiMasterAssertions(input pclk,
                              input areset,
                              input sclk,
                              input [NO_OF_SLAVES-1:0] cs,
                              input mosi0,
                              input mosi1,
                              input mosi2,
                              input mosi3,
                              input miso0,
                              input miso1,
                              input miso2,
                              input miso3 
                            );

  bit cpol;
  bit cpha;
  
  //-------------------------------------------------------
  // Importing Uvm Package
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh";

  initial begin
    `uvm_info("SpiMasterAssertions","MASTER ASSERTIONS",UVM_LOW);
  end
 
  //-------------------------------------------------------
  // Defining Macro
  //-------------------------------------------------------
  `define SIMPLE_SPI
  //`define DUAL_SPI
  //`define QUAD_SPI
  
  //-------------------------------------------------------
  // Assertion for ifSignalsAreStable
  // When cs is high, the signals sclk, mosi, miso should be stable.
  //-------------------------------------------------------
  property ifSignalsAreStable(logic mosiLocal, logic misoLocal);
    @(posedge pclk) disable iff(!areset)
    cs=='1  |=> $stable(sclk) && $stable(mosiLocal) && $stable(misoLocal);
  endproperty : ifSignalsAreStable

  `ifdef SIMPLE_SPI
    IFSIGNALSARESTABLE_SIMPLE_SPI: assert property (ifSignalsAreStable(mosi0,miso0));
    IFSIGNALSARESTABLE_SIMPLE_SPI_C: cover property (ifSignalsAreStable(mosi0,miso0));    
  `endif
  `ifdef DUAL_SPI
    IFSIGNALSARESTABLE_DUAL_SPI_1_C: assert property (ifSignalsAreStable(mosi0,miso0));
    IFSIGNALSARESTABLE_DUAL_SPI_2_C: assert property (ifSignalsAreStable(mosi1,miso1));
    
    IFSIGNALSARESTABLE_DUAL_SPI_1_C: cover property (ifSignalsAreStable(mosi0,miso0));
    IFSIGNALSARESTABLE_DUAL_SPI_2_C: cover property (ifSignalsAreStable(mosi1,miso1));
  `endif
  `ifdef QUAD_SPI
    IFSIGNALSARESTABLE_QUAD_SPI_1: assert property (ifSignalsAreStable(mosi0,miso0));
    IFSIGNALSARESTABLE_QUAD_SPI_2: assert property (ifSignalsAreStable(mosi1,miso1));
    IFSIGNALSARESTABLE_QUAD_SPI_3: assert property (ifSignalsAreStable(mosi2,miso2));
    IFSIGNALSARESTABLE_QUAD_SPI_4: assert property (ifSignalsAreStable(mosi3,miso3));
       
    IFSIGNALSARESTABLE_QUAD_SPI_1_C: cover property (ifSignalsAreStable(mosi0,miso0));
    IFSIGNALSARESTABLE_QUAD_SPI_2_C: cover property (ifSignalsAreStable(mosi1,miso1));
    IFSIGNALSARESTABLE_QUAD_SPI_3_C: cover property (ifSignalsAreStable(mosi2,miso2));
    IFSIGNALSARESTABLE_QUAD_SPI_4_C: cover property (ifSignalsAreStable(mosi3,miso3));
  `endif

  //-------------------------------------------------------
  // Assertion for mosi_miso_valid
  // when cs is low mosi should be valid from next clock cycle.
  //-------------------------------------------------------
  property mosiMisoValid(logic mosiLocal, logic misoLocal);
    @(posedge pclk) disable iff(!areset)
    cs=='0 |=> !$isunknown(sclk) && !$isunknown(mosiLocal) |-> !$isunknown(misoLocal);
  endproperty : mosiMisoValid
  
  `ifdef SIMPLE_SPI
      CS_LOW_CHECK_SIMPLE_SPI: assert property (mosiMisoValid(mosi0,miso0));
      CS_LOW_CHECK_SIMPLE_SPI_C: cover property (mosiMisoValid(mosi0,miso0));
  `endif
  `ifdef DUAL_SPI
      CS_LOW_CHECK_DUAL_SPI_1: assert property (mosiMisoValid(mosi0,miso0));
      CS_LOW_CHECK_DUAL_SPI_2: assert property (mosiMisoValid(mosi1,miso1));
          
      CS_LOW_CHECK_DUAL_SPI_1_C: cover property (mosiMisoValid(mosi0,miso0));
      CS_LOW_CHECK_DUAL_SPI_2_C: cover property (mosiMisoValid(mosi1,miso1));
  `endif
  `ifdef QUAD_SPI
      CS_LOW_CHECK_QUAD_SPI_1: assert property (mosiMisoValid(mosi0,miso0));
      CS_LOW_CHECK_QUAD_SPI_2: assert property (mosiMisoValid(mosi1,miso1));
      CS_LOW_CHECK_QUAD_SPI_3: assert property (mosiMisoValid(mosi3,miso2));
      CS_LOW_CHECK_QUAD_SPI_4: assert property (mosiMisoValid(mosi3,miso3));
              
      CS_LOW_CHECK_QUAD_SPI_1_C: cover property (mosiMisoValid(mosi0,miso0));
      CS_LOW_CHECK_QUAD_SPI_2_C: cover property (mosiMisoValid(mosi1,miso1));
      CS_LOW_CHECK_QUAD_SPI_3_C: cover property (mosiMisoValid(mosi3,miso2));
      CS_LOW_CHECK_QUAD_SPI_4_C: cover property (mosiMisoValid(mosi3,miso3));
  `endif

  //-------------------------------------------------------
  // Assertion for cpol in idle state
  // when cpol is low, idle state should be logic low
  // when cpol is high,idle state should be logic high
  //-------------------------------------------------------
  property cpolIdleStateCheck;
    @(posedge pclk) disable iff(!areset)
    cs=='1 |-> sclk == cpol;
  endproperty : cpolIdleStateCheck
  CPOL_IDLE_STATE_CHECK: assert property(cpolIdleStateCheck);
    
  CPOL_IDLE_STATE_CHECK_C: cover property(cpolIdleStateCheck);
 
/* 
  //-------------------------------------------------------
  // Assertion for mode_of_cfg_cpol_0_cpha_0
  // when cpol is 0 and cpha is 0,
  // mosi data and miso data should be valid at the same negedge of sclk 
  //-------------------------------------------------------
  property mode_of_cfg_cpol_0_cpha_0(logic mosiLocal,logic misoLocal);
    @(negedge sclk) disable iff(!areset)
    cpol==0 && cpha==0 |-> !$isunknown(mosiLocal) && !$isunknown(misoLocal);
  endproperty: mode_of_cfg_cpol_0_cpha_0

  `ifdef SIMPLE_SPI
    CPOL_0_CPHA_0_SIMPLE_SPI: assert property (mode_of_cfg_cpol_0_cpha_0(mosi0,miso0));
      
    CPOL_0_CPHA_0_SIMPLE_SPI_C: cover property (mode_of_cfg_cpol_0_cpha_0(mosi0,miso0));
  `endif
  `ifdef DUAL_SPI
    CPOL_0_CPHA_0_DUAL_SPI_1: assert property (mode_of_cfg_cpol_0_cpha_0(mosi0,miso0));
    CPOL_0_CPHA_0_DUAL_SPI_2: assert property (mode_of_cfg_cpol_0_cpha_0(mosi1,miso1));
      
    CPOL_0_CPHA_0_DUAL_SPI_1_C: cover property (mode_of_cfg_cpol_0_cpha_0(mosi0,miso0));
    CPOL_0_CPHA_0_DUAL_SPI_2_C: cover property (mode_of_cfg_cpol_0_cpha_0(mosi1,miso1));
  `endif
  `ifdef QUAD_SPI
    CPOL_0_CPHA_0_QUAD_SPI_1: assert property (mode_of_cfg_cpol_0_cpha_0(mosi0,miso0));
    CPOL_0_CPHA_0_QUAD_SPI_2: assert property (mode_of_cfg_cpol_0_cpha_0(mosi1,miso1));
    CPOL_0_CPHA_0_QUAD_SPI_3: assert property (mode_of_cfg_cpol_0_cpha_0(mosi3,miso2));
    CPOL_0_CPHA_0_QUAD_SPI_4: assert property (mode_of_cfg_cpol_0_cpha_0(mosi3,miso3));
      
    CPOL_0_CPHA_0_QUAD_SPI_1_C: cover property (mode_of_cfg_cpol_0_cpha_0(mosi0,miso0));
    CPOL_0_CPHA_0_QUAD_SPI_2_C: cover property (mode_of_cfg_cpol_0_cpha_0(mosi1,miso1));
    CPOL_0_CPHA_0_QUAD_SPI_3_C: cover property (mode_of_cfg_cpol_0_cpha_0(mosi3,miso2));
    CPOL_0_CPHA_0_QUAD_SPI_4_C: cover property (mode_of_cfg_cpol_0_cpha_0(mosi3,miso3));
  `endif

  //-------------------------------------------------------
  // Assertion for mode_of_cfg_cpol_0_cpha_1
  // when cpol is 0 and cpha is 1,
  // mosi data and miso data should be valid at the same negedge of sclk
  //-------------------------------------------------------
  property mode_of_cfg_cpol_0_cpha_1(logic mosiLocal, logic misoLocal);
    @(negedge sclk) disable iff(!areset)
   cpol==0 && cpha==1 |-> !$isunknown(mosiLocal) && !$isunknown(misoLocal);
  endproperty: mode_of_cfg_cpol_0_cpha_1
  
  `ifdef SIMPLE_SPI
    CPOL_0_CPHA_1_SIMPLE_SPI: assert property (mode_of_cfg_cpol_0_cpha_1(mosi0,miso0));
    CPOL_0_CPHA_1_SIMPLE_SPI_C: cover property (mode_of_cfg_cpol_0_cpha_1(mosi0,miso0));
  `endif
  `ifdef DUAL_SPI
    CPOL_0_CPHA_1_DUAL_SPI_1: assert property (mode_of_cfg_cpol_0_cpha_1(mosi0,miso0));
    CPOL_0_CPHA_1_DUAL_SPI_2: assert property (mode_of_cfg_cpol_0_cpha_1(mosi1,miso1));
      
    CPOL_0_CPHA_1_DUAL_SPI_1_C: cover property (mode_of_cfg_cpol_0_cpha_1(mosi0,miso0));
    CPOL_0_CPHA_1_DUAL_SPI_2_C: cover property (mode_of_cfg_cpol_0_cpha_1(mosi1,miso1));
  `endif
  `ifdef QUAD_SPI
    CPOL_0_CPHA_1_QUAD_SPI_1: assert property (mode_of_cfg_cpol_0_cpha_1(mosi0,miso0));
    CPOL_0_CPHA_1_QUAD_SPI_2: assert property (mode_of_cfg_cpol_0_cpha_1(mosi1,miso1));
    CPOL_0_CPHA_1_QUAD_SPI_3: assert property (mode_of_cfg_cpol_0_cpha_1(mosi3,miso2));
    CPOL_0_CPHA_1_QUAD_SPI_4: assert property (mode_of_cfg_cpol_0_cpha_1(mosi3,miso3));
      
    CPOL_0_CPHA_1_QUAD_SPI_1_C: cover property (mode_of_cfg_cpol_0_cpha_1(mosi0,miso0));
    CPOL_0_CPHA_1_QUAD_SPI_2_C: cover property (mode_of_cfg_cpol_0_cpha_1(mosi1,miso1));
    CPOL_0_CPHA_1_QUAD_SPI_3_C: cover property (mode_of_cfg_cpol_0_cpha_1(mosi3,miso2));
    CPOL_0_CPHA_1_QUAD_SPI_4_C: cover property (mode_of_cfg_cpol_0_cpha_1(mosi3,miso3));
  `endif

  //-------------------------------------------------------
  // Assertion for mode_of_cfg_cpol_1_cpha_0
  // when cpol is 1 and cpha is 0,
  // mosi data and miso data should be valid at the same posedge of sclk 
  //-------------------------------------------------------
  property mode_of_cfg_cpol_1_cpha_0(logic mosiLocal,logic misoLocal);
    @(posedge sclk) disable iff(!areset)
    cpol==1 && cpha==0 |-> !$isunknown(mosiLocal) && !$isunkown(misoLocal);
  endproperty: mode_of_cfg_cpol_1_cpha_0
  
  `ifdef SIMPLE_SPI
    CPOL_1_CPHA_0_SIMPLE_SPI: assert property (mode_of_cfg_cpol_1_cpha_0(mosi0,miso0));
    CPOL_1_CPHA_0_SIMPLE_SPI_C: cover property (mode_of_cfg_cpol_1_cpha_0(mosi0,miso0));
  `endif
  `ifdef DUAL_SPI
    CPOL_1_CPHA_0_DUAL_SPI_1: assert property (mode_of_cfg_cpol_1_cpha_0(mosi0,miso0));
    CPOL_1_CPHA_0_DUAL_SPI_2: assert property (mode_of_cfg_cpol_1_cpha_0(mosi1,miso1));
      
    CPOL_1_CPHA_0_DUAL_SPI_1_C: cover property (mode_of_cfg_cpol_1_cpha_0(mosi0,miso0));
    CPOL_1_CPHA_0_DUAL_SPI_2_C: cover property (mode_of_cfg_cpol_1_cpha_0(mosi1,miso1));
  `endif
  `ifdef QUAD_SPI
    CPOL_1_CPHA_0_QUAD_SPI_1: assert property (mode_of_cfg_cpol_1_cpha_0(mosi0,miso0));
    CPOL_1_CPHA_0_QUAD_SPI_2: assert property (mode_of_cfg_cpol_1_cpha_0(mosi1,miso1));
    CPOL_1_CPHA_0_QUAD_SPI_3: assert property (mode_of_cfg_cpol_1_cpha_0(mosi3,miso2));
    CPOL_1_CPHA_0_QUAD_SPI_4: assert property (mode_of_cfg_cpol_1_cpha_0(mosi3,miso3));
      
    CPOL_1_CPHA_0_QUAD_SPI_1_C: cover property (mode_of_cfg_cpol_1_cpha_0(mosi0,miso0));
    CPOL_1_CPHA_0_QUAD_SPI_2_C: cover property (mode_of_cfg_cpol_1_cpha_0(mosi1,miso1));
    CPOL_1_CPHA_0_QUAD_SPI_3_C: cover property (mode_of_cfg_cpol_1_cpha_0(mosi3,miso2));
    CPOL_1_CPHA_0_QUAD_SPI_4_C: cover property (mode_of_cfg_cpol_1_cpha_0(mosi3,miso3));
  `endif
  
  //-------------------------------------------------------
  // Assertion for mode_of_cfg_cpol_1_cpha_1
  // when cpol is 1 and cpha is 1,
  // mosi data and miso data should be valid at the same negedge of sclk 
  //-------------------------------------------------------
  property mode_of_cfg_cpol_1_cpha_1(logic mosiLocal,logic misoLocal);
    @(negedge sclk) disable iff(!areset)
    cpol==1 && cpha==1 |-> !$isunknown(mosiLocal) && !$isunknown(misoLocal);
  endproperty: mode_of_cfg_cpol_1_cpha_1
  
  `ifdef SIMPLE_SPI
    CPOL_1_CPHA_1_SIMPLE_SPI: assert property (mode_of_cfg_cpol_1_cpha_1(mosi0,miso0));
    CPOL_1_CPHA_1_SIMPLE_SPI_C: cover property (mode_of_cfg_cpol_1_cpha_1(mosi0,miso0));
  `endif
  `ifdef DUAL_SPI
    CPOL_1_CPHA_1_DUAL_SPI_1: assert property (mode_of_cfg_cpol_1_cpha_1(mosi0,miso0));
    CPOL_1_CPHA_1_DUAL_SPI_2: assert property (mode_of_cfg_cpol_1_cpha_1(mosi1,miso1));
      
    CPOL_1_CPHA_1_DUAL_SPI_1_C: cover property (mode_of_cfg_cpol_1_cpha_1(mosi0,miso0));
    CPOL_1_CPHA_1_DUAL_SPI_2_C: cover property (mode_of_cfg_cpol_1_cpha_1(mosi1,miso1));
  `endif
  `ifdef QUAD_SP1
    CPOL_1_CPHA_1_QUAD_SPI_1: assert property (mode_of_cfg_cpol_1_cpha_1(mosi0,miso0));
    CPOL_1_CPHA_1_QUAD_SPI_2: assert property (mode_of_cfg_cpol_1_cpha_1(mosi1,miso1));
    CPOL_1_CPHA_1_QUAD_SPI_3: assert property (mode_of_cfg_cpol_1_cpha_1(mosi3,miso2));
    CPOL_1_CPHA_1_QUAD_SPI_4: assert property (mode_of_cfg_cpol_1_cpha_1(mosi3,miso3));
      
    CPOL_1_CPHA_1_QUAD_SPI_1_C: cover property (mode_of_cfg_cpol_1_cpha_1(mosi0,miso0));
    CPOL_1_CPHA_1_QUAD_SPI_2_C: cover property (mode_of_cfg_cpol_1_cpha_1(mosi1,miso1));
    CPOL_1_CPHA_1_QUAD_SPI_3_C: cover property (mode_of_cfg_cpol_1_cpha_1(mosi3,miso2));
    CPOL_1_CPHA_1_QUAD_SPI_4_C: cover property (mode_of_cfg_cpol_1_cpha_1(mosi3,miso3));
  `endif

/*
  // Assertion for if_cs_is_stable_during_transfers
  // cs should be low and stable till data transfer is successful ($stable)
  sequence if_cs_is_stable_during_transfers_s1;
    @(posedge sclk)
    cs == 0;
  endsequence:if_cs_is_stable_during_transfers_s1

  sequence if_cs_is_stable_during_transfers_s2;
    @(posedge sclk)
    $stable(cs)[*8];
  endsequence:if_cs_is_stable_during_transfers_s2

  property if_cs_is_stable_during_transfers;
    @(posedge sclk) disable iff(!areset)
    if_cs_is_stable_during_transfers_s1 |-> if_cs_is_stable_during_transfers_s2;
  endproperty:if_cs_is_stable_during_transfers
  IF_CS_IS_STABLE_DURING_TRANSFERS: assert property (if_cs_is_stable_during_transfers);
 
  // Assertion for successful_data_transfers
  // cs should be low for multiples of 8 clock cycles for successful data transfer
   sequence successful_data_transfers_s1;
    @(posedge sclk)
    (!cs && !$isunknown(mosi0))[*8];
  endsequence:successful_data_transfers_s1

  property successful_data_transfers;
    @(posedge sclk) disable iff(!areset)
    successful_data_transfers_s1;
  endproperty:successful_data_transfers
  SUCCESSFUL_DATA_TRANSFERS: assert property (successful_data_transfers);
*/

endinterface : SpiMasterAssertions

`endif

