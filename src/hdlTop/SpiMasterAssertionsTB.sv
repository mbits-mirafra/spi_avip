`ifndef SPIMASTERASSERTIONSTB_INCLUDED_
`define SPIMASTERASSERTIONSTB_INCLUDED_
//--------------------------------------------------------------------------------------------
// Module : Master Assertions_TB
// Used to write the assertion checks needed for the master
//--------------------------------------------------------------------------------------------

module SpiMasterAssertionsTB;
  import SpiGlobalsPkg::*;

  bit pclk;
  bit sclk;
  bit [NO_OF_SLAVES-1:0]cs;
  bit cpol;
  bit areset;
  bit mosi0;
  //logic mosi0;
  bit mosi1;
  bit mosi2;
  bit mosi3;
  bit miso0;
  bit miso1;
  bit miso2;
  bit miso3;

  int ct2Delay, t2cDelay, baurdate;
  initial begin
    pclk =1;
    sclk =1;
  end
  always #10 pclk = !pclk;
  always #20 sclk = !sclk;
  // Generate/drive SCLK
  
  task sclkGeneratePosedge();
    forever #20 sclk = sclk;
  endtask
  
  task sclkGenerateNegedge();
    forever #20 sclk = !sclk;
  endtask
  
  initial begin
    //Include this to verify if signals are stable
    //ifSignalsAreStable();

    //Include this to verify master cs low check assertion
    //masterCsLowCheck();

   //include this to verify cpol_idle_state_low
   cpolIdleStateLowPositive();
   cpolIdleStateLowNegative();

   //include this to verify cpol_idle_state_high
   cpolIdleStateHighPositive();
   cpolIdleStateHighNegative();

   //Uncomment this when you want to verify cpol 0 and cpha 0
   cpol0Cpha0();
  // cpol_1_cpha_0();
  end

  task ifSignalsAreStable;
    //ifSignalsAreStableNegative1();
    //ifSignalsAreStableNegative2();
    ifSignalsAreStablePositive();
  endtask

  task masterCsLowCheck;
    //masterCsLowCheck_positive();
    //masterCsLowCheckNegative1();
  endtask

  task cpol0Cpha0;
    //cpol0Cpha0Positive();
    cpol0Cpha0Negative1();
  endtask

  task aresetGen(sclkLocal,csLocal,noOfSlaves);
    areset = 0;

    @(posedge pclk);
    if(noOfSlaves == 0) begin
      //cs = 'csLocal;
      cs = '1;
    end
    else begin
      cs[0] = csLocal;
    end
    sclk = sclkLocal; //cpol

    repeat(1) begin
      @(posedge pclk); 
    end
    
    areset = 1;
    $display("aresetGen");
  endtask

  task ifSignalsAreStableNegative1();
    bit[7:0] mosiData;
    bit[7:0] misoData;
    
    //areset generation
    aresetGen(1,1,1);

    //sclk generation
    sclkGenerateNegedge();

    //Randomising mosi and miso data
    $display($time,"POSCLK1");
    @(posedge sclk);
    mosiData = $urandom;
    misoData = $urandom;
    $display($time,"POSCLK2");

    //Driving mosi and miso data
    for(int i=0 ; i<8; i++) begin
      @(posedge sclk);
      mosi0 = mosiData[i];
      miso0 = misoData[i];
    end
  endtask

  task ifSignalsAreStableNegative2();
    
    //Declaring mosi and miso data
    bit[7:0] mosiData;
    bit[7:0] misoData;
    
    //aresetGeneration
    aresetGen(1,1,1);

    //sclk generation
    sclkGenerateNegedge();

    //randomising miso and mosi data
    @(posedge sclk);
    mosiData = $urandom;
    misoData = $urandom;

    for(int i=0 ; i<8; i++) begin
      cs = $urandom;
      @(posedge sclk);
        mosi0 = mosiData[i];
        miso0 = misoData[i];
    end
  endtask
  
  task ifSignalsAreStablePositive();
    bit[7:0] mosiData;
    bit[7:0] misoData;

    //areset generation
    aresetGen(1,1,1);

    // random mosi data
    mosiData = $urandom;
    misoData = $urandom;
    
    //sclk generation
    sclkGeneratePosedge();

    //Driving mosi and miso data
    for(int i=0 ; i<8; i++) begin
      @(posedge sclk);
      mosi0 = mosiData[i];
      miso0 = misoData[i];
    end

  endtask 
 /* 
  task masterCsLowCheck_positive();
    
    //Initialising mosi data
    bit [7:0]mosiData;
    bit [7:0]misoData;
    
    //areset generation
    aresetGen(1,0,1);
    
    //sclk generation
    sclkGenerateNegedge();

    //Random mosi data
    mosiData = $urandom;
    misoData = $urandom;

    //Driving mosi and miso data
    for(int i=0 ; i<8; i++) begin
      @(posedge sclk);
      mosi0 = mosiData[i];
      miso0 = misoData[i];
    end
  endtask : masterCsLowCheck_positive
*/
  task masterCsLowCheckNegative1();
    
    //Initialising mosi data
    bit [7:0]mosiData;
    bit [7:0]misoData;
    
    //areset generation
    aresetGen(1,0,1);
    
    //sclk generation
    sclkGenerateNegedge();

    //Random mosi data
    mosiData = $urandom;
    misoData = $urandom;
  
    //Driving mosi and miso data
    for(int i=0 ; i<8; i++) begin
      //bit mosi_local,miso_local;

      @(posedge sclk);
      //mosi0 = 'miso_local; 

      mosi0 = mosiData[i];
      miso0 = misoData[i];
    end
  endtask : masterCsLowCheckNegative1
  
  task cpolIdleStateLowPositive();
    cs='b1;
    cpol=1'b0;
    sclk=1'b0;
   // for(int i=0 ; i<8; i++) begin
    //  @(posedge pclk);
     //  sclk = !sclk;
    //end
  endtask : cpolIdleStateLowPositive

  task cpolIdleStateLowNegative();
    cs = 'b0;
    //cpol=1'b0;
    sclk=1'b0;
    //for(int i=0 ; i<8; i++) begin
     // @(posedge pclk);
     // sclk = !sclk;
    //end
  endtask

  task cpolIdleStateHighPositive();
    cs='b1;
    cpol=1'b0;
    sclk=1'b0;
    // for(int i=0 ; i<8; i++) begin
    //  @(posedge pclk);
    //  sclk = !sclk;
    //end
  endtask : cpolIdleStateHighPositive

  task cpolIdleStateHighNegative();
    cs = 'b0;
    cpol=1'b0;
    sclk=1'b0;
    //for(int i=0 ; i<8; i++) begin
     // @(posedge pclk);
     // sclk = !sclk;
    //end
  endtask : cpolIdleStateHighNegative


  task cpol0Cpha0Positive;
    bit [7:0]mosiData;
    bit [7:0]misoData;
    aresetGen(1,0,1);
    sclkGenerateNegedge();
        //Driving mosi and miso data
    for(int i=0 ; i<8; i++) begin
      //bit mosi_local,miso_local;

      @(negedge sclk);
      //mosi0 = 'miso_local; 

      mosi0 = mosiData[i];
      miso0 = misoData[i];
    end

  endtask

  task cpol0Cpha0Negative;
    bit [7:0]mosiData;
    bit [7:0]misoData;
    aresetGen(1,0,1);
    sclkGenerateNegedge();
        //Driving mosi and miso data
    for(int i=0 ; i<8; i++) begin
      //bit mosi_local,miso_local;

      @(negedge sclk);
      //mosi0 = 'miso_local; 

      mosi0 = mosiData[i];
      miso0 = misoData[i];
    end

  endtask


  task cpol0Cpha1Positive;
    bit [7:0]mosiData;
    bit [7:0]misoData;
    
    aresetGen(1,1,1);
    
    sclkGenerateNegedge();

    @(posedge sclk);
    mosiData = $urandom;
    misoData = $urandom;
    
    //Driving mosi and miso data
    for(int i=0 ; i<8; i++) begin

      @(negedge sclk);
      //mosi0 = 'miso_local; 
      mosi0 = mosiData[i];
      miso0 = misoData[i];
    end

  endtask

  task cpol0Cpha1Negative;
    bit [7:0]mosiData;
    bit [7:0]misoData;
    aresetGen(1,1,1);
    sclkGenerateNegedge();
        //Driving mosi and miso data
    for(int i=0 ; i<8; i++) begin
      //bit mosi_local,miso_local;

      @(negedge sclk);
      //mosi0 = 'miso_local; 

      mosi0 = mosiData[i];
      miso0 = misoData[i];
    end

  endtask


  task cpol1Cpha0Negative;
    bit [7:0]mosiData;
    bit [7:0]misoData;
    aresetGen(1,0,1);
    sclkGeneratePosedge();
    mosiData=$urandom;
    misoData=$urandom;
        //Driving mosi and miso data
    for(int i=0 ; i<8; i++) begin
      //bit mosi_local,miso_local;

      @(posedge sclk);
      //mosi0 = 'miso_local; 

      mosi0 = mosiData[i];
      miso0 = misoData[i];
    end

  endtask

  
  task cpol0Cpha0Negative1;
    bit [31:0]mosiData;
    bit [31:0]misoData;
    
    $display("HEY-----NEG1");
    aresetGen(1,0,1);
    
    $display($time,"POSCLK1");
    $display("HEY-----NEG2");
    //sclkGenerateNegedge();
    
    $display($time,"POSCLK2");
    $display("HEY-----NEG3");
    //@(posedge sclk);
    mosiData = $urandom;
    misoData = $urandom;
    
    //Driving mosi and miso data
    for(int i=0 ; i<31; i++) begin
      //bit mosi_local,miso_local;

      @(posedge sclk);

      mosi0 = mosiData[i];
      miso0 = misoData[i];
    end

  endtask

  /*master_assertions M_A (.pclk(pclk),
                         .cs(cs),
                         .areset(areset),
                         .sclk(sclk),
                         .mosi0(mosi0),
                         .mosi1(mosi1),
                         .mosi2(mosi2),
                         .mosi3(mosi3),
                         .miso0(miso0),
                         .miso1(miso1),
                         .miso2(miso2),
                         .miso3(miso3));
                         */
endmodule

`endif

