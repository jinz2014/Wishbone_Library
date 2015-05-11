//----------------------------------------------------------------------
//-- Module name:     MEM0003a.v
//--
//-- Description:     An 8 x 32-bit memory interface with a WISHBONE
//--                  SLAVE interface for a Xilinx block RAM.  
//--                  For more information, please refer to the WISHBONE
//--                  Public Domain Library Technical Reference Manual.
//--
//--
//-- History:         Project modified:           AUG 21, 2011
//--                                              JZ
//----------------------------------------------------------------------

module MEM0003a (
  output          ACK_O,
  input   [2:0]   ADR_I,
  input           CLK_I,
  input  [31:0]   DAT_I,
  output [31:0]   DAT_O,
  input           STB_I,
  input           WE_I
);

   // ------------------------------------------------------------------
   // -- Instantiate the Xilinx bram 
   // ------------------------------------------------------------------
   
  wire  [3:0]   LADR;
  wire          LACK_O;
  wire [31:0]   LDAT_O;
  wire          WE;
  reg           STB_R;

  bram08x32 U00 (
    .addra  (LADR),
    .clka   (CLK_I),
    .dina   (DAT_I),
    .wea    (WE),
    .douta  (LDAT_O)
  );

  // ------------------------------------------------------------------
  // -- Form the internal address bus for connection to the RAM.
  // -- Xilinx doesn't support an 8 x 32-bit distributed RAM...
  // -- only a 16 x 32-bit RAM. This means that the most significant 
  // -- address bit must be set to zero.
  // --
  // -- But Xilinx BRAM has no such limitation.
  // ------------------------------------------------------------------ 
  assign LADR = {1'b0, ADR_I[2:0]};

  // ------------------------------------------------------------------
  // -- Generate the write enable signal.
  // ------------------------------------------------------------------
  assign WE = STB_I & WE_I;

  //------------------------------------------------------------------
  //-- Generate the [ACK_O] acknowledge signal.  Since Xilinx BRAM
  //-- has one-cycle read latency, the [ACK_O] signal is asserted 
  //-- a cycle after the [STB_I] signal is asserted.
  //    ___     ___     ___     ___     ___     ___     ___     ___  
  //   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
  //---+   +---+   +---+   +---+   +---+   +---+   +---+   +---+   +---  (CLK)
  //           ________________
  //           |               | 
  //-----------+               +----------\\ ------------  (M CYC_O)
  //           ________________
  //           |               | 
  //-----------+               +----------\\ ------------  (M STB_O)
  //                   ________
  //                   |       |
  //-------------------+       +----------\\ ------------  (S ACK_O)
  //
  //=====================================================================
  //
  // Asynchronous slave
  //           ________
  //           |       | 
  //-----------+       +----------\\ ------------  (M CYC_O)
  //           ________
  //           |       | 
  //-----------+       +----------\\ ------------  (M STB_O)
  //           ________
  //           |       |
  //-----------+       +----------\\ ------------  (S ACK_O)
  //------------------------------------------------------------------
  assign LACK_O = WE | STB_R & STB_I;

  // -- if read enabled 
  always @ (posedge CLK_I) begin
    STB_R <= ~WE_I & STB_I;
  end

  //------------------------------------------------------------------
  //-- Make some of the local signals visible outside of the entity.
  //------------------------------------------------------------------
    
  assign ACK_O = LACK_O;
  assign DAT_O = LDAT_O;

endmodule 
