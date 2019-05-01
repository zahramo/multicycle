`timescale 1ps/1ps

module stackMultiCycle(
	clk,
	rst);
input clk,rst;

wire IorD,
    memRead,
    memWrite,
    IRWrite,
    SrcA,
    SrcB,
    LdA,
    LdB,
    PCWrite,
    PCSrc,
    tos,
    Push,
    Pop,
    PCWriteCond,
    MtoS;

wire[2:0] opc;
wire[1:0] AluOP;

	DP dp(
    clk,
    rst,
	IorD,
    memRead,
    memWrite,
    IRWrite,
    SrcA,
    SrcB,
    LdA,
    LdB,
    AluOP,
    PCWrite,
    PCSrc,
    tos,
    Push,
    Pop,
    PCWriteCond,
    MtoS,
	OPC
    );

    CU cu(
    clk,
    rst,
    OPC,
    IorD,
    memRead,
    memWrite,
    IRWrite,
    SrcA,
    SrcB,
    LdA,
    LdB,
    AluOP,
    PCWrite,
    PCSrc,
    tos,
    Push,
    Pop,
    PCWriteCond,
    MtoS
    );

    endmodule