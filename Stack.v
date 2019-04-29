`timescale 1ps/1ps
module Stack (
    d_in,
    clk,
    rst,
    push,
    pop,
    tos,
    d_out
    );
    parameter WORD = 8, LENGTH = 64, POINTERL = 6;
    input [WORD-1:0]d_in;
    input clk,
    rst,
    push,
    pop,
    tos;
    output reg [WORD-1:0]d_out;
    reg [WORD-1:0]st[LENGTH-1:0];
    reg [POINTERL-1:0]stackPointer;

    always @(posedge clk, posedge rst) begin
        if (rst) stackPointer <= {(POINTERL){1'b0}};
        else begin
            if(push) begin 
                stackPointer = stackPointer + 1;
                st[stackPointer] <= d_in;
            end
            else if(pop) begin 
                d_out <= st[stackPointer];
                stackPointer = stackPointer - 1;
            end
            else if(tos) begin 
                d_out <= st[stackPointer];
            end
            else d_out <= d_out;
        end
    end
                      
endmodule
