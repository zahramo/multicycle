`timescale 1ps/1ps
module DP(
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

    input clk,
    rst;
    output [2:0]OPC;
    input IorD,
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
    input [1:0] AluOP;

   	wire[4:0] pcIn, pcOut, add;
   	wire[7:0] data, IRreg, MDRreg, pcEx, dIn, dOut, Aout, Bout, Zout, Ain, Bin, alu, aluReg;
   	wire zero, pcLd;

   	mux2 #(5) m1 (
    .sel(pcSrc),
    .inp1(alu),
    .inp2(IRreg[4:0]),
    .out(pcIn)
    );

   	register #(5) PC (
    .clk(clk),
    .rst(rst),
    .ld(pcLd),
    .clr(0), //ok?
    .inp(pcIn),
    .out(pcOut)
    );

   	mux2 #(5) m2 (
    .sel(IorD),
    .inp1(pcOut),
    .inp2(IRreg[4:0]),
    .out(add)
    );

    Memory Mem (
    .address(add),
    .writeData(Aout),
    .readData(data),
    .memWrite(memWrite),
    .memRead(memRead)
    );

    register #(8) IR (
    .clk(clk),
    .rst(rst),
    .ld(IRWrite),
    .clr(0), //ok?
    .inp(data),
    .out(IRreg)
    );

    register #(8) MDR (
    .clk(clk),
    .rst(rst),
    .ld(1'b1),
    .clr(0), //ok?
    .inp(data),
    .out(MDRreg)
    );

    mux2 #(8) m3 (
    .sel(MtoS),
    .inp1(aluReg),
    .inp2(MDRreg),
    .out(dIn)
    );

    Stack stack (
    .d_in(dIn),
    .clk(clk),
    .rst(rst),
    .push(push),
    .pop(pop),
    .tos(tos),
    .d_out(dOut)
    );

    register #(8) A (
    .clk(clk),
    .rst(rst),
    .ld(LdA),
    .clr(0), //ok?
    .inp(dOut),
    .out(Aout)
    );

    register #(8) B (
    .clk(clk),
    .rst(rst),
    .ld(LdB),
    .clr(0), //ok?
    .inp(dOut),
    .out(Bout)
    );

    register #(8) Z (
    .clk(clk),
    .rst(rst),
    .ld(1'b1),
    .clr(0), //ok?
    .inp(dOut),
    .out(Zout)
    );

    mux2 #(8) m4 (
    .sel(SrcA),
    .inp1(Aout),
    .inp2(pcEx),
    .out(Ain)
    );

    mux2 #(8) m5 (
    .sel(SrcB),
    .inp1(Bout),
    .inp2(1'b1),
    .out(Bin)
    );

    ALU Alu (
    .inp1(Ain),
    .inp2(Bin),
    .func(AluOP),
    .out(alu)
    );

    register #(8) AluOut (
    .clk(clk),
    .rst(rst),
    .ld(1'b1),
    .clr(0), //ok?
    .inp(alu),
    .out(aluReg)
    );

    Concatenator extend (
    .inp(pcOut),
    .concatPart(3'b000),
    .out(pcEx)
    );

    assign pcLd = (zero & PCWriteCond)| PCWrite;
    assign zero = (Zout == 8'b00000000)?1'b1:1'b0; //correct?
    assign OPC = IRreg[7:5];

    endmodule



