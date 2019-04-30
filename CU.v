`timescale 1ps/1ps
module CU(
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

    input clk,
    rst;
    input [2:0]OPC;
    output reg IorD,
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
    output reg [1:0] AluOP;

    reg ps, ns;

    parameter  ADD  = 2'b00 , PUSH = 3'b100,
               JMP  = 3'b110, NOT  = 3'b011,
               JZ   = 3'b111, POP  = 3'b101;

    always @(posedge clk, posedge rst)begin
      if(rst) ps <= 4'b0;
      else ps <= ns;
    end

    always @(ps) begin
        IorD = 0;
        memRead = 0;
        memWrite = 0;
        IRWrite = 0;
        SrcA = 0;
        SrcB = 0;
        LdA = 0;
        LdB = 0;
        AluOP = 0; //CHECK
        PCWrite = 0;
        PCSrc = 0;
        tos = 0;
        Push = 0;
        Pop = 0;
        PCWriteCond = 0;
        MtoS = 0;
        case(ps)
        0:  begin
            IorD = 0;
            memRead = 1;
            IRWrite = 1;
            SrcA = 1;
            SrcB = 1;
            AluOP = ADD;
            PCWrite = 1;
            PCSrc = 0;
            tos = 1;
            end
        1:;
        2:  begin
            PCSrc = 1;
            PCWrite = 1;
            end
        3:  begin
            PCSrc = 1;
            PCWriteCond = 1;
            end
        4:  IorD = 1;
        5:  begin
            MtoS = 1;
            Push = 1;
            end
        6:  Pop = 1;
        7:  LdA = 1;
        8:  memWrite = 1;
        9:  begin
            AluOP = OPC[1:0];
            SrcA = 0;
            end
        10: Pop = 1;
        11: LdB = 1;
        12: begin
            AluOP = OPC[1:0];
            SrcA = 0;
            SrcB = 0;
            end
        13: begin
            MtoS = 0;
            Push = 1;
            end
        endcase
    end

    always @(ps, OPC)begin
        case(ps)
        0: ns <= 4'b0001;
        1:  begin
            if (OPC == JMP) ns <= 4'b0010;
            else if (OPC == JZ) ns <= 4'b0011;
            else if (OPC == PUSH) ns <= 4'b0100;
            else ns <= 4'b0110;
            end
        2: ns <= 4'b0;
        3: ns <= 4'b0;
        4: ns <= 4'b0101;
        5: ns <= 4'b0;
        6: ns <= 4'b0111;
        7:  begin
            if (OPC == POP) ns <= 4'b1000;
            else if (OPC == NOT) ns <= 4'b1001;
            else ns <= 4'b1010;
            end
        8: ns <= 4'b0;
        9: ns <= 4'b1101;
        10: ns <= 4'b1011;
        11: ns <= 4'b1100;
        12: ns <= 4'b1101;
        13: ns <= 4'b0;
        default:ns<=ns;
        endcase
    end

endmodule
