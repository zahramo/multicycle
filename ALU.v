`timescale 1ps/1ps
module ALU (
    inp1,
    inp2,
    func,
    out,
    );
    parameter n = 8;
    input [n-1:0]inp1, inp2;
    input [1:0]func;
    output [n-1:0]out;

    parameter  ADD = 3'b00, SUB = 3'b01, 
               AND = 3'b10, NOT = 3'b11;

    assign out = (func == ADD) ? inp1 + inp2 :
                 (func == SUB) ? inp1 - inp2 :
                 (func == AND) ? inp1 & inp2 :
                 (func == NOT) ? ~inp1 :
                 out;         
endmodule