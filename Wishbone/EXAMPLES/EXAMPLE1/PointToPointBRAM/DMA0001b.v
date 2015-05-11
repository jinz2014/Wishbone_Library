//----------------------------------------------------------------------
//-- Module name:     DMA0001b.v
//--
//-- Description:     A very simple 32-bit DMA unit.  For more infor-
//--                  mation, please refer to the WISHBONE Public Domain
//--                  Library Technical Reference Manual.
//--
//-- History:         Project rewritten:          JZ
//   1 Remove DMODE
//   2 Support burst (1<=length<=8)
//   3 Add task call to aid read/write
//
//-- History:         Project complete:           SEP 19, 2001
//--                                              WD Peterson
//--                                              Silicore Corporation
//----------------------------------------------------------------------

module DMA0001b (
  //-- WISHBONE Signals

  input          ACK_I,
  output  [4:0]  ADR_O,
  input          CLK_I,
  output         CYC_O,
  input  [31:0]  DAT_I,
  output [31:0]  DAT_O,
  input          RST_I,
  output         SEL_O,
  output         STB_O,
  output         WE_O,

   //-- NON-WISHBONE Signals

  input   [1:0]  IA,
  input  [31:0]  ID
);

  parameter BURST_LENGTH = 1;


  wire         INC;    
  wire         INP;    
  wire         TC;     
  reg          TC_R;     
  reg          WE;     
  reg          SAS;    
  reg    [4:0] LADR_O; 
  reg   [31:0] LBDAT;  
  reg   [31:0] LDAT_O; 
  reg   [31:0] CheckBuf [0:31];

  //------------------------------------------------------------------
  //-- CONTROL STATE MACHINE
  //
  // DMA initiates a SINGLE WRITE cycle beginning at the [CLK_I] rising
  // edge immediately after the reset input [RST_I] is negated. After the write cycle is
  // completed, the DMA initiates a SINGLE READ cycle. The write / read cycles repeat
  // indefinitely. Note there is a one-cycle read/write toggle overhead.
  //
  //    ___     ___     ___     ___     ___     ___     ___     ___  
  //   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
  //---+   +---+   +---+   +---+   +---+   +---+   +---+   +---+   +---  (CLK)
  //
  //  Read cyc              write cyc                     read cyc
  //----------+        +----------\\ ----------+        +-------\\-----  (SAS)
  //          |________|                       |________| 
  //
  //
  //------------------------------------------------------------------
  always @ (posedge CLK_I) begin

    // 
    // Note SAS is tied to STB_O and CYC_O, which meets RULE 3.25
    //
    // Set SAS to low when a bus cycle is complete (INP = 1)
    // Set SAS to high when a bus cycle is not complete (INP = 0)
    SAS <= ~RST_I & ~(SAS & INP);  
                                   
    // Togge WE (read <-> write) when a bus cycle is complete (SAS = 0)
    // Keep WE when a bus cycle is not complete (SAS = 1)
    WE  <= ~RST_I & ~(WE ^ SAS);   
  end

  //------------------------------------------------------------------
  // INP is asserted when ACK is asserted in the single-cycle mode 
  // INP is asserted when the number of counts is 7 in the block-cycle mode 
  //------------------------------------------------------------------
  assign INP = (WE & TC | ~WE & TC_R);

  //------------------------------------------------------------------
  //-- Generate the terminal count (carry forward) logic from the
  //-- counter.
  //------------------------------------------------------------------
  assign TC = LADR_O[2:0] == (BURST_LENGTH - 1) ? 1'b1 : 1'b0;

  //------------------------------------------------------------------
  //-- INC gate.
  //------------------------------------------------------------------

  assign INC = ACK_I & SAS;

  //------------------------------------------------------------------
  //-- I/O DREG (Input/Output Data REGister).
  //------------------------------------------------------------------

  always @ (posedge CLK_I) begin
    if (RST_I) begin
      // ireg
      LBDAT <= 32'b0;
      // oreg
      LDAT_O <= ID;
    end

  always @ (posedge CLK_I) begin
    if (RST_I)
      TC_R <= 1'b0;
    else if (SAS & ~WE)
      TC_R <= TC;
  end

  //------------------------------------------------------------------
  //-- AREG (Address REGister) 
  //
  // The highest two address bits generated by the DMA are latched in 
  // response to a reset. This allows each DMA (in a benchmarking system)
  // to target a unique SLAVE. The lower three address bits are generated
  // by a counter that counts from 0x0 to 0x7, and rolls over from 0x7 to 0x0.
  // 
  // After each bus cycle (READ or WRITE) is completed, 
  // the DMA increments its address
  //------------------------------------------------------------------
  always @ (posedge CLK_I) begin
    if (RST_I)
      LADR_O[2:0] <= 3'b0;
    else if (SAS & ~TC_R)
      LADR_O[2:0] <= LADR_O[2:0] + 3'b1;
  end

  always @ (posedge CLK_I) begin
    if (RST_I)
      LADR_O[4:3] <= IA;
    else 
      LADR_O[4:3] <= LADR_O[4:3];
  end

  //------------------------------------------------------------------
  //-- Make the outputs visible to the outside world.  Also connect
  //-- up some of the miscellaneous signals.
  // 
  // Note CYC_O and STB_O are tied to SAS.
  //------------------------------------------------------------------

  assign ADR_O = LADR_O;
  assign CYC_O = SAS;
  assign DAT_O = LDAT_O;
  assign SEL_O = 1'b1;
  assign STB_O = SAS;
  assign WE_O  = WE;


  //-------------------------------------------------
  // Assume no read wait cycle once the first ACK 
  // is asserted for a block read
  //-------------------------------------------------
  task BusCmd;
    input t_WE;
    input  [2:0] t_ADDR;  // upper 2 bits are initialized 
    input [31:0] t_DATA;
    
    reg [5:0] i;

    begin

      i = 0;

      @ (posedge SAS);  // bus cyce start

        LADR_O = t_ADDR; 

        if (t_WE) begin // write

          // feed write data before the clock posedge 
          repeat (BURST_LENGTH) begin
            @ (negedge CLK_I);
            LDAT_O = LDAT_O + 1;

            // Write expected data for data read check
            $display("%d Info : %d write exp read val=%h",
                     $time, i, LDAT_O);

            CheckBuf[i] = LDAT_O;
            i = i + 1;
          end
        end

        else begin     // read

          @ (posedge ACK_I);   // wait for the first asserted ACK_I

          repeat (BURST_LENGTH) begin

            // Master latches DAT_I when ACK_I is asserted
            @ (posedge CLK_I)
              if (ACK_I) begin
                LBDAT = DAT_I;

                // check read data equality
                if (CheckBuf[i] != LBDAT)
                  $display("%d Error: %d exp read val=%h  act read val=%h", 
                     $time, i, CheckBuf[i], LBDAT);

                i = i + 1;
              end
          end
        end

      @ (negedge SAS);  // bus cycle end
    end
  endtask

endmodule 
