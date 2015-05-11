//----------------------------------------------------------------------
//-- Module name:     ARB00001d.v
//--
//-- Description:     A four level, round-robin arbiter. It arbitrates
//                    on every clock cycle if any of CYC1, CYC2, CYC3, 
//                    CYC4 are asserted. 
//
//                    At next cycle, GNT contains the previous updated arbitration state.
//                    If no CYCs are asserted, then the master state is not updated.
//
//                    The output COMCYC indicates the completion of
//                    a valid arbitration. 
//
//--
//-- History:         Project rewritten using assign statement for next master
//                    state JZ 8/20/11
//--
//----------------------------------------------------------------------


module ARB0001d (
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
    
   wire       BEG;        
   reg        LCOMCYC;
   reg        LGNT0, LGNT1, LGNT2, LGNT3;
   wire [1:0] LGNT;

    //------------------------------------------------------------------
    // Assign statement coding style
    //------------------------------------------------------------------
    always @ (posedge CLK) begin
      LGNT0 <= (~RST & BEG & LGNT == 2'b00 & ~CYC3 & ~CYC2 & ~CYC1 & CYC0) | 
               (~RST & BEG & LGNT == 2'b01 & ~CYC3 & ~CYC2         & CYC0) |  
               (~RST & BEG & LGNT == 2'b10 & ~CYC3                 & CYC0) | 
               (~RST & BEG & LGNT == 2'b11 &                       & CYC0) |
               (~RST & ~BEG & LGNT0);

      LGNT1 <= (~RST & BEG & LGNT == 2'b00                         & CYC1) | 
               (~RST & BEG & LGNT == 2'b01 & ~CYC2 & ~CYC3 & ~CYC0 & CYC1) |  
               (~RST & BEG & LGNT == 2'b10 & ~CYC3 & ~CYC0         & CYC1) | 
               (~RST & BEG & LGNT == 2'b11 & ~CYC0                 & CYC1) |
               (~RST & ~BEG & LGNT1);

      LGNT2 <= (~RST & BEG & LGNT == 2'b00 & ~CYC1                 & CYC2) | 
               (~RST & BEG & LGNT == 2'b01                         & CYC2) |
               (~RST & BEG & LGNT == 2'b10 & ~CYC3 & ~CYC0 & ~CYC1 & CYC2) | 
               (~RST & BEG & LGNT == 2'b11 & ~CYC0 & ~CYC1         & CYC2) |
               (~RST & ~BEG & LGNT2);

      LGNT3 <= (~RST & BEG & LGNT == 2'b00 & ~CYC1 & ~CYC2         & CYC3) | 
               (~RST & BEG & LGNT == 2'b01 & ~CYC2                 & CYC3) |
               (~RST & BEG & LGNT == 2'b10                         & CYC3) |
               (~RST & BEG & LGNT == 2'b11 & ~CYC0 & ~CYC1 & ~CYC2 & CYC3) |
               (~RST & ~BEG & LGNT3);
    end

   always @ (posedge CLK) begin
     LCOMCYC <= ~RST & BEG;
   end

   assign BEG = ( CYC3 | CYC2 | CYC1 | CYC0 );

    //------------------------------------------------------------------
    //-- Make local signals visible outside of the entity.
    //------------------------------------------------------------------
    assign COMCYC = LCOMCYC ;

    assign LGNT[1] =   LGNT3 | LGNT2;
    assign LGNT[0] =   LGNT3 | LGNT1;
    assign GNT  = LGNT;
    assign GNT0 = LGNT0;
    assign GNT1 = LGNT1;
    assign GNT2 = LGNT2;
    assign GNT3 = LGNT3;

endmodule 

