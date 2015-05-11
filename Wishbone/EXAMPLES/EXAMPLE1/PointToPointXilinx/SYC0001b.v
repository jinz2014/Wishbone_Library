
module SYC0001b (

  //-- WISHBONE Interface
  output CLK_O,
  output RST_O,

  //-- NON-WISHBONE Signals
  input EXTCLK,
  input EXTTST

);


  reg DLY;
  reg RST;

  //-----------------------------------------------
  // A reset generator
  //
  // cyc 1. DLY = RST = 0 when EXTTST = 1
  //
  // cyc 2. RST = 1 when EXTTST = 0 and DLY = 0 
  //
  // cyc 3. RST = 0(~RST) when EXTTST = 0 and DLY = 0 
  //        DLY = 1 when EXTTST = 0 and DLY != RST(see cyc2)
  //
  // cyc 4+. DLY = 1 and RST = 0 
  //-----------------------------------------------
  always @ (posedge EXTCLK) begin

    DLY <= ~EXTTST & (DLY ^ RST);

    RST <= ~EXTTST & ~DLY & ~RST;

  end

  assign CLK_O = EXTCLK; 
  assign RST_O = RST;

endmodule 
