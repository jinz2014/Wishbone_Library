//----------------------------------------------------------------------
//-- Module name:     ARB00001c.v
//--
//-- Description:     A four level, round-robin arbiter. It arbitrates
//                    on every clock cycle if any of CYC1, CYC2, CYC3, 
//                    CYC4 are asserted. 
//
//                    At next cycle, GNT contains the previous updated arbitration state.
//                    If no CYCn are asserted, then the master state is not updated.
//
//                    The output COMCYC indicates the completion of
//                    a valid arbitration.
//
//--
//-- History:         Project rewritten using casex statement for next master
//                    state JZ 8/18/11
//--
//----------------------------------------------------------------------


module ARB0001c (
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
    reg  [1:0] c_LGNT;
    reg  [1:0] r_LGNT;
   reg         LCOMCYC;



    //------------------------------------------------------------------
    // Case statement coding style
    //------------------------------------------------------------------
   always @ (*) begin
     case (r_LGNT)
       2'd0:  
       begin
         casex ({CYC3, CYC2, CYC1, CYC0})
           4'bxxx1: c_LGNT = 2'd1;
           4'bxx10: c_LGNT = 2'd2;
           4'bx100: c_LGNT = 2'd3;
           4'b1000: c_LGNT = 2'd4;

           default: c_LGNT = r_LGNT;
         endcase
       end

       2'd1:  
       begin
         casex ({CYC3, CYC2, CYC1, CYC0})
           4'b0001: c_LGNT = 2'd1;
           4'bxx1x: c_LGNT = 2'd2;
           4'bx10x: c_LGNT = 2'd3;
           4'b100x: c_LGNT = 2'd4;
           default: c_LGNT = r_LGNT;
         endcase
       end

       2'd2: 
       begin
         casex ({CYC3, CYC2, CYC1, CYC0})
           4'b00x1: c_LGNT = 2'd1;
           4'b0010: c_LGNT = 2'd2;
           4'bx1xx: c_LGNT = 2'd3;
           4'b10xx: c_LGNT = 2'd4;
           default: c_LGNT = r_LGNT;
         endcase
       end

       2'd3:
       begin
         casex ({CYC3, CYC2, CYC1, CYC0})
           4'b0xx1: c_LGNT = 2'd1;
           4'b0x10: c_LGNT = 2'd2;
           4'b0100: c_LGNT = 2'd3;
           4'b1xxx: c_LGNT = 2'd4;
           default: c_LGNT = r_LGNT;
         endcase
       end

       default: c_LGNT = r_LGNT;
     endcase
   end

   always @ (posedge CLK) begin
     if (RST) 
       r_LGNT <= 2'd0;
     else if (BEG)
       r_LGNT <= c_LGNT;
   end

   always @ (posedge CLK) begin
     if (RST) 
       LCOMCYC <= 1'b0;
     else
       LCOMCYC <= BEG;
   end

   assign BEG = ( CYC3 | CYC2 | CYC1 | CYC0 );

    //------------------------------------------------------------------
    //-- Make local signals visible outside of the entity.
    //------------------------------------------------------------------
    assign COMCYC = LCOMCYC ;
    assign GNT    = r_LGNT;
    assign GNT0 = r_LGNT == 2'd0 ? 1'b1 : 1'b0;
    assign GNT1 = r_LGNT == 2'd1 ? 1'b1 : 1'b0;
    assign GNT2 = r_LGNT == 2'd2 ? 1'b1 : 1'b0;
    assign GNT3 = r_LGNT == 2'd3 ? 1'b1 : 1'b0;

endmodule 
