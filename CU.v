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

    reg [3:0]ps, ns;

    parameter  ADD  = 2'b00 , PUSH = 3'b100,
               JMP  = 3'b110, NOT  = 3'b011,
               JZ   = 3'b111, POP  = 3'b101,
               ADDO = 3'b000, SUBO = 3'b001,
               ANDO = 3'b010;

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
        4:  begin
            IorD = 1;
            memRead = 1;
            end
        5:  begin
            MtoS = 1;
            Push = 1;
            end
        6:  Pop = 1;
        7:  LdA = 1;
        8:  begin
            memWrite = 1;
            IorD = 1;
            end
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

    always @(ps, OPC, posedge clk)begin
        case(ps)
        0: ns <= 4'b0001; //1
        1:  begin
            if (OPC == JMP) ns <= 4'b0010; //2
            else if (OPC == JZ) ns <= 4'b0011; //3
            else if (OPC == PUSH) ns <= 4'b0100; //4
            else if (OPC == POP || OPC == NOT || OPC == ADDO || OPC == ANDO || OPC == SUBO) ns <= 4'b0110; //6
            else ns <= 4'b0001; //change
            end
        2: ns <= 4'b0; //0
        3: ns <= 4'b0; //0
        4: ns <= 4'b0101; //5
        5: ns <= 4'b0; //0
        6: ns <= 4'b0111; //7
        7:  begin
            if (OPC == POP) ns <= 4'b1000; //8
            else if (OPC == NOT) ns <= 4'b1001; //9
            else ns <= 4'b1010; //10
            end
        8: ns <= 4'b0; //0
        9: ns <= 4'b1101; //13
        10: ns <= 4'b1011; //11
        11: ns <= 4'b1100; //12
        12: ns <= 4'b1101; //13
        13: ns <= 4'b0; //0
        default:ns<=ns;
        endcase
    end

endmodule
