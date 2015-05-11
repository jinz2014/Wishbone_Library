`timescale 1ns/1ps

module TESTBNCH;

  wire          ACK_O;
  wire [31:0]   DAT_O;
  reg   [2:0]   ADR_I;
  reg           CLK_I;
  reg  [31:0]   DAT_I;
  reg           STB_I;
  reg           WE_I;

  reg   [31:0]  i;

  MEM0003a TBENCH (
    ACK_O,
    ADR_I,
    CLK_I,
    DAT_I,
    DAT_O,
    STB_I,
    WE_I
  );

  initial begin
    CLK_I = 0;
    STB_I = 0;
    WE_I  = 0;

    // sequential write
    for (i = 0; i < 256; i = i + 1) begin
      @ (negedge CLK_I) begin
        STB_I = 1;
        WE_I  = 1;
        DAT_I = i;
        ADR_I = i;
      end
    end

    // disable write
    repeat (10) begin
      @ (negedge CLK_I) begin
        STB_I = 0;
        WE_I  = 1;
      end
    end

    // sequential read
    for (i = 0; i < 256; i = i + 1) begin
      @ (negedge CLK_I) begin
        STB_I = 1;
        WE_I  = 0;
        DAT_I = 'bx;
        ADR_I = i;
      end
    end

    // disable read
    repeat (10) begin
      @ (negedge CLK_I) begin
        STB_I = 0;
        WE_I  = 0;
      end
    end

    // random read/write
    for (i = 0; i < 256; i = i + 1) begin
      @ (negedge CLK_I) begin
        STB_I = i[0] ^ i[2] ^ i[5] ^ i[7];
        WE_I  = i[1] ^ i[3] ^ i[4] ^ i[6];
        DAT_I = i;
        ADR_I = i;
      end
    end

    $finish;

  end



  always #10 CLK_I = ~CLK_I;

endmodule 




