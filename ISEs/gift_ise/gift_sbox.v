`timescale 1ns / 1ps

module gift_sbox(
    input [7:0] in,
    output [7:0] out
    );
    assign out[3:0] = (in[3:0] == 4'h0) ? 4'h1 :
                            (in[3:0] == 4'h1) ? 4'ha :
                            (in[3:0] == 4'h2) ? 4'h4 :
                            (in[3:0] == 4'h3) ? 4'hc :
                            (in[3:0] == 4'h4) ? 4'h6 :
                            (in[3:0] == 4'h5) ? 4'hf :
                            (in[3:0] == 4'h6) ? 4'h3 :
                            (in[3:0] == 4'h7) ? 4'h9 :
                            (in[3:0] == 4'h8) ? 4'h2 :
                            (in[3:0] == 4'h9) ? 4'hd :
                            (in[3:0] == 4'ha) ? 4'hb :
                            (in[3:0] == 4'hb) ? 4'h7 :
                            (in[3:0] == 4'hc) ? 4'h5 :
                            (in[3:0] == 4'hd) ? 4'h0 :
                            (in[3:0] == 4'he) ? 4'h8 : 4'he;
    assign out[7:4] = (in[7:4] == 4'h0) ? 4'h1 :
                            (in[7:4] == 4'h1) ? 4'ha :
                            (in[7:4] == 4'h2) ? 4'h4 :
                            (in[7:4] == 4'h3) ? 4'hc :
                            (in[7:4] == 4'h4) ? 4'h6 :
                            (in[7:4] == 4'h5) ? 4'hf :
                            (in[7:4] == 4'h6) ? 4'h3 :
                            (in[7:4] == 4'h7) ? 4'h9 :
                            (in[7:4] == 4'h8) ? 4'h2 :
                            (in[7:4] == 4'h9) ? 4'hd :
                            (in[7:4] == 4'ha) ? 4'hb :
                            (in[7:4] == 4'hb) ? 4'h7 :
                            (in[7:4] == 4'hc) ? 4'h5 :
                            (in[7:4] == 4'hd) ? 4'h0 :
                            (in[7:4] == 4'he) ? 4'h8 : 4'he; 
endmodule
