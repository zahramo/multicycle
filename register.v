`timescale 1ps/1ps
module register (
    clk,
    rst,
    ld,
    clr,
    inp,
    out
    );
    parameter n;
    input clk,
    rst,
    ld,
    clr;
    input [n-1:0]inp;
    output reg [n-1:0]out;

    always @(posedge clk, posedge rst) begin
        if (rst) out <= {(n){1'b0}};
        else begin
            if(clr) out <= {(n){1'b0}};
            else if(ld) out <= inp;
            else out <= out;
        end
    end
endmodule




