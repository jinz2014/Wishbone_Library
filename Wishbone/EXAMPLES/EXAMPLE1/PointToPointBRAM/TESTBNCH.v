//----------------------------------------------------------------------
//-- Module name:     TESTBNCH.v
//--
//-- Description:     Test bench for ICN0001b.VHD.
//--
//-- History:         Project complete:           SEP 20, 2001
//--                                              WD Peterson
//--                                              Silicore Corporation
//--
//-- Release:         Notice is hereby given that this document is not
//--                  copyrighted, and has been placed into the public
//--                  domain.  It may be freely copied and distributed
//--                  by any means.
//--
//-- Disclaimer:      In no event shall Silicore Corporation be liable
//--                  for incidental, consequential, indirect or special
//--                  damages resulting from the use of this file.  The
//--                  user assumes all responsibility for its use.
//--
//----------------------------------------------------------------------

`timescale 1ns/1ps
`define READ  0
`define WRITE 1

module TESTBNCH;

    //------------------------------------------------------------------
    //-- Define some local signals to assign values and observe.
    //------------------------------------------------------------------

    reg           EXTCLK;
    reg           EXTTST; 
    wire          EACK;
    wire   [2:0]  EADR;
    wire  [31:0]  EDRD;
    wire  [31:0]  EDWR;
    wire          ESTB;
    wire          EWE;

    parameter PERIOD = 100;

    ICN0001b ICN (
      .EXTCLK  ( EXTCLK),
      .EXTTST  ( EXTTST),
      .EACK    ( EACK),
      .EADR    ( EADR),
      .EDRD    ( EDRD),
      .EDWR    ( EDWR),
      .ESTB    ( ESTB),
      .EWE     ( EWE)
    );


    //------------------------------------------------------------------
    //-- Test process.
    //------------------------------------------------------------------

    initial begin
      EXTCLK = 1'b0;
      EXTTST = 1'b1;
      #(PERIOD);
      EXTTST = 1'b0;
      repeat (8) begin
        ICN.U01.BusCmd(`WRITE, 0, 32'b0);
        ICN.U01.BusCmd(`READ , 0, 32'bx);
      end
      $finish;
    end

    always #(PERIOD / 2) EXTCLK = ~EXTCLK;


endmodule

