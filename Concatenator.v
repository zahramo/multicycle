`timescale 1ps/1ps
module Concatenator (
    inp,
    concatPart,
    out
    );
    parameter NINP;
    parameter NCONCATPART;
    input [NINP-1:0]inp;
    input [NCONCATPART-1:0] concatPart;
    output [NCONCATPART+NINP-1:0]out;
    assign out = {concatPart, inp};
endmodule




