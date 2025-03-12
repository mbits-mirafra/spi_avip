`ifndef SPISLAVEASSERTIONSTB_INCLUDED_
`define SPISLAVEASSERTIONSTB_INCLUDED_

//--------------------------------------------------------------------------------------------
// Module:      SpiSlaveAssertionsTB
// Description: Includes interface   
//--------------------------------------------------------------------------------------------

module SpiSlaveAssertionsTB;

  import SpiGlobalsPkg::*; 

  bit pclk;
  bit sclk;
  bit [NO_OF_SLAVES-1:0] cs;
  bit areset;
  bit mosi0;
  bit mosi1;
  bit mosi2;
  bit mosi3;
  bit miso0;
  bit miso1;
  bit miso2;
  bit miso3;
 
  int ct2Delay, t2cDelay, baudrate;
  
  // pclk generation
  initial begin 
    pclk =0;
    sclk =0;
  end
  always #10 pclk = ~pclk;
  always #10 sclk = ~sclk;
  
  task sclkGeneratePosedge();
    forever #20 sclk = sclk;
  endtask

  task sclkGenerateNegedge();
    forever #20 sclk = !sclk;
  endtask
  
  // sclk generation
  //always begin
    // @(posedge pclk) sclk = ~sclk;
  //end
  
  task aresetGenerate(sclkLocal,csLocal,noOfSlaves);
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
    $display("aresetGenerate");
  endtask 

  // Calling tasks 

  initial begin
    $display("SpiSlaveAssertionsTB");
    //ifSignalsAreStableNegative1();
    //ifSignalsAreStableNegative2();
    //ifSignalsAreStablePositive();
    //  slaveMiso0ValidSeqPositive;
    //   cpol1Cpha0Positive();
    cpol1Cpha0Negative();
  end

 /* task aresetGenerate(sclkLocal,csLocal,noOfSlaves);
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

  endtask
  */
  task ifSignalsAreStableNegative1();
    bit[7:0] mosiData;
    bit[7:0] misoData;
    $display("ASSERTION_DEBUG","IF_SIGNALS_ARE_STABLE");
    
    cs ='1;
    areset = 1'b0;
    
    @(posedge sclk);
    mosiData = $urandom;
    misoData = $urandom;
    $display("ASSERTION_DEBUG","mosiData = 'h%0x", mosiData);
    $display("ASSERTION_DEBUG","misoData = 'h%0x", misoData);

    for(int i=0 ; i<8; i++) begin
      @(posedge sclk);
        mosi0 = mosiData[i];
        miso0 = misoData[i];
    end
  endtask

  task ifSignalsAreStableNegative2();
    bit[7:0] mosiData;
    bit[7:0] misoData;
    $display("ASSERTION_DEBUG","IF_SIGNALS_ARE_STABLE");
    areset = 1'b1;
    
    @(posedge sclk);
    mosiData = $urandom;
    misoData = $urandom;
    $display("ASSERTION_DEBUG","mosiData = 'h%0x", mosiData);
    $display("ASSERTION_DEBUG","misoData = 'h%0x", misoData);

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
    $display("ASSERTION_DEBUG","TEST1");
    cs = '1;
    // random mosi data
    mosiData = $urandom;
    misoData = $urandom;
    $display("ASSERTION_DEBUG","mosiData = 'h%0x", mosiData);
    $display("ASSERTION_DEBUG","misoData = 'h%0x", misoData);
    //@(posedge pclk) sclk = sclk;
    //sclk = sclk;
    sclkGeneratePosedge();
    for(int i=0 ; i<8; i++) begin
      @(posedge sclk);
      mosi0 = mosiData[i];
      miso0 = misoData[i];
    end

    cs[0]=1'b1;
    $display("ASSERTION_DEBUG","TEST1_DONE");
    // MSHA:    repeat(5) begin
    // MSHA:  //  @(posedge sclk);
    // MSHA:    mosi0 = 1'b1;
    // MSHA:    //{mosi0, mosi1, mosi2, mosi3,
    // MSHA:        //miso0, miso1, miso2, miso3} = $urandom;
    // MSHA:      end  
    // MSHA:    $display("ASSERTION_DEBUG"," mosi0=%d",mosi0);
  endtask 

  
  task slaveMiso0ValidSeqPositive();
    //bit[7:0] mosiData;
    bit[7:0] misoData;
    $display("ASSERTION_DEBUG","SLAVE_MISO0_VALID_SEQ");
    
    cs =0;
    //areset = 1'b0;
    
    @(posedge sclk);
    //mosiData = $urandom;
    misoData = $urandom;
    //$display("ASSERTION_DEBUG","mosiData = 'h%0x", mosiData);
    $display("ASSERTION_DEBUG","misoData = 'h%0x", misoData);

    for(int i=0 ; i<8; i++) begin
      @(posedge sclk);
        //mosi0 = mosiData[i];
        miso0 = misoData[i];
    end
  endtask
 
task cpol0Cpha0Positive;
    bit [7:0]mosiData;
    bit [7:0]misoData;
    aresetGenerate(1,0,1);
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

  task cpol0Cpha0Negative1;
    bit [31:0]mosiData;
    bit [31:0]misoData;
    
    $display("HEY-----NEG1");
    aresetGenerate(1,0,1);
    
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
  
  task cpol0Cpha1Positive;
    bit [7:0]mosiData;
    bit [7:0]misoData;
    aresetGenerate(1,0,1);
    sclkGenerateNegedge();

    @(posedge sclk)
    mosiData = $urandom;
    misoData = $urandom;

        //Driving mosi and miso data
    for(int i=0 ; i<8; i++) begin
      //bit mosi_local,miso_local;

      @(negedge sclk);
      //mosi0 = 'miso_local; 
      mosi0 = mosiData[i];
      miso0 = misoData[i];
    end

  endtask
  
  task cpol1Cpha0Positive;
    bit [7:0]mosiData;
    bit [7:0]misoData;
    aresetGenerate(1,0,1);
    //sclkGenerateNegedge();
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
    aresetGenerate(1,0,1);
   // sclkGeneratePosedge();
    mosiData=$urandom;
    misoData=$urandom;
        //Driving mosi and miso data
    for(int i=0 ; i<8; i++) begin
      //bit mosi_local,miso_local;

      @(negedge sclk);
      //mosi0 = 'miso_local; 

      mosi0 = mosiData[i];
      miso0 = misoData[i];
    end

  endtask

  initial begin 
    //$monitor("SpiSlaveAssertionsTB,%0t: pclk=%0d, sclk=%0d, areset=%0d, cs=%0d, mosi0=%0d, miso0=%0d",$time, pclk, sclk, areset, cs, mosi0, miso0);
    $display("SpiSlaveAssertionsTB");
  end

   // Instantiation of slave assertion module
   /*slave_assertions slave_assertions_h (.pclk(pclk),
                                       .sclk(sclk),
                                       .cs(cs),
                                       .areset(areset),
                                       .mosi0(mosi0),
                                       .mosi1(mosi1),
                                       .mosi2(mosi2),
                                       .mosi3(mosi3),
                                       .miso0(miso0),
                                       .miso1(miso1),
                                       .miso2(miso2),
                                       .miso3(miso3) );
                                       */
endmodule : SpiSlaveAssertionsTB

`endif
