//----------------------------------------------------------------------
//-- Module name:     ARB0001a.v
//--
//-- Description:     A four level, round-robin arbiter.  For more infor-
//--                  mation, please refer to the WISHBONE Public Domain
//--                  Library Technical Reference Manual.
//--
//-- History:         Project rewritten with Verilog by JZ 
//-- History:         Project complete:           SEP 14, 2001
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


module ARB0001b (
  input         CLK,
  input         RST,
  input         CYC3,
  input         CYC2,
  input         CYC1,
  input         CYC0,

  output        COMCYC,
  output [1:0]  GNT,
  output        GNT3,
  output        GNT2,
  output        GNT1,
  output        GNT0
);



    //------------------------------------------------------------------
    //-- Define internal signals.
    //------------------------------------------------------------------

    reg  [1:0] LMAS;  // last granted master 
    reg        EDGE;       
    reg        LASMAS;    
    reg        LGNT0;      
    reg        LGNT1;      
    reg        LGNT2;      
    reg        LGNT3;      

    wire [1:0] LGNT;
    wire       BEG;        
    wire       LCOMCYC;    

    //------------------------------------------------------------------
    // Round-robin arbitration logic (registered output).
    //
    // Recall that LMAS keeps the last granted state 
    // 
    // Initially if CYC0, CYC1, CYC2, CYC3 are all asserted, the arbitor 
    // grant request by MASTER #1 
    //------------------------------------------------------------------

    always @ (posedge CLK) begin
      LGNT0 <= (~RST & ~LCOMCYC & LMAS == 2'b00 & ~CYC3 & ~CYC2 & ~CYC1 & CYC0) | 
               (~RST & ~LCOMCYC & LMAS == 2'b01 & ~CYC3 & ~CYC2         & CYC0) |  
               (~RST & ~LCOMCYC & LMAS == 2'b10 & ~CYC3                 & CYC0) | 
               (~RST & ~LCOMCYC & LMAS == 2'b11 &                       & CYC0) | 
               (~RST &  LCOMCYC & LGNT0); 

      LGNT1 <= (~RST & ~LCOMCYC & LMAS == 2'b00                         & CYC1) | 
               (~RST & ~LCOMCYC & LMAS == 2'b01 & ~CYC2 & ~CYC3 & ~CYC0 & CYC1) |  
               (~RST & ~LCOMCYC & LMAS == 2'b10 & ~CYC3 & ~CYC0         & CYC1) | 
               (~RST & ~LCOMCYC & LMAS == 2'b11 & ~CYC0                 & CYC1) | 
               (~RST &  LCOMCYC & LGNT1); 

      LGNT2 <= (~RST & ~LCOMCYC & LMAS == 2'b00 & ~CYC1                 & CYC2) | 
               (~RST & ~LCOMCYC & LMAS == 2'b01                         & CYC2) |
               (~RST & ~LCOMCYC & LMAS == 2'b10 & ~CYC3 & ~CYC0 & ~CYC1 & CYC2) | 
               (~RST & ~LCOMCYC & LMAS == 2'b11 & ~CYC0 & ~CYC1         & CYC2) | 
               (~RST &  LCOMCYC & LGNT2); 

      LGNT3 <= (~RST & ~LCOMCYC & LMAS == 2'b00 & ~CYC1 & ~CYC2         & CYC3) | 
               (~RST & ~LCOMCYC & LMAS == 2'b01 & ~CYC2                 & CYC3) |
               (~RST & ~LCOMCYC & LMAS == 2'b10                         & CYC3) |
               (~RST & ~LCOMCYC & LMAS == 2'b11 & ~CYC0 & ~CYC1 & ~CYC2 & CYC3) | 
               (~RST &  LCOMCYC & LGNT3); 
    end

    //------------------------------------------------------------------
    //-- LASMAS state machine.
    //------------------------------------------------------------------


    // In the beginning, bus has not been granted to the request by a MASTER
    assign BEG = ( CYC3 | CYC2 | CYC1 | CYC0 ) & ~LCOMCYC;


    // LASMAS is asserted only for one clock cycle (~EDGE) if there is 
    // an ungranted bus request
    always @ (posedge CLK) begin
      LASMAS <= BEG & ~EDGE & ~LASMAS;

      // When EDGE is asserted, it will not be desserted until bus request has been
      // granted (i.e. BEG = 0).
      EDGE   <= BEG & ~EDGE & LASMAS | BEG & EDGE & ~LASMAS;
    end
      

    //------------------------------------------------------------------
    // COMCYC logic.
    //
    // It indicates whether the bus is busy or free. It is asserted
    // whenever a MASTER has both requested and been granted the bus
    // by the arbiter. The signal is also used by the interconnection, 
    // which is external to the arbiter
    //------------------------------------------------------------------
    assign LCOMCYC = ( CYC3 & LGNT3 ) | ( CYC2 & LGNT2 ) | 
                     ( CYC1 & LGNT1 ) | ( CYC0 & LGNT0 );

    //------------------------------------------------------------------
    //-- Encoder logic. 
    //
    // Note only one of the four grants is asserted at any time
    //
    // LGNT = {00} if LGNT0 = 1
    // LGNT = {01} if LGNT1 = 1
    // LGNT = {10} if LGNT2 = 1
    // LGNT = {11} if LGNT3 = 1
    //------------------------------------------------------------------

    assign LGNT[1] =   LGNT3 | LGNT2;
    assign LGNT[0] =   LGNT3 | LGNT1;

    //------------------------------------------------------------------
    //-- LMAS state register to remeber the last granted state
    //------------------------------------------------------------------
    always @ (posedge CLK) begin
      if (RST) begin
        LMAS <= 2'b00;
      end
      else if (LASMAS) begin
        LMAS <= LGNT; 
      end
    end


    //------------------------------------------------------------------
    //-- Make local signals visible outside of the entity.
    //------------------------------------------------------------------
    assign COMCYC = LCOMCYC;
    assign GNT    = LGNT;
    assign GNT3   = LGNT3;
    assign GNT2   = LGNT2;
    assign GNT1   = LGNT1;
    assign GNT0   = LGNT0;

endmodule 
