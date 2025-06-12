`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2025 10:25:34 PM
// Design Name: 
// Module Name: CPU_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CPU_top(
input clk, rst,
output [31:0] out
    );
    
    // Buses principales del CPU
    wire [31:0] WriteData, ReadData;
    reg [31:0] Result, inst_reg;
    
    // Unidad de Control y sus banderas
    wire AluControl, InstW, MemW, RegW, PCW, AluSrcB, stype, ltype, ImmSrc, ImmType;
    wire [1:0] AluSrcA, ResultSrc;
    
    Unidad_Control UC (clk, rst, inst_reg, AluControl, InstW, MemW, RegW, PCW, 
    AluSrcB, stype, ltype, ImmSrc, ImmType, AluSrcA, ResultSrc);
    
    // Registro PC
    reg [31:0] PC;
    
    always @(posedge clk)
    begin
    if (rst)
        PC <= 0;
        
    else if (PCW)
        PC <= Result;
    end
    
    // Memoria de Instrucciones
    wire [31:0] inst;
    
    MemoriaInstrucciones Instrucciones (PC, inst);
    
    always @(posedge clk)
    begin
    if (rst)
        inst_reg <= 0;
        
    else if (InstW)
        inst_reg <= inst;
    end
    
    // Memoria de Datos
    reg [31:0] Data_reg;
    wire [31:0] Data;
    
    assign Data = ltype ? {24'd0, ReadData[31:24]} : ReadData;
    
    always @(posedge clk)
    begin
    if (rst)
        Data_reg <= 0;
        
    else
        Data_reg <= Data;
    end
    
    Memoria_Datos Datos(clk, rst, MemW, stype, Result[4:0], WriteData, ReadData);
    
    // Banco de Registros
    wire [31:0] R1_out, R2_out;
    reg [31:0] R1_reg, R2_reg;
    
    assign WriteData = R2_reg;
    
    Banco_de_Registros Registers(RegW, clk, rst, inst_reg[19:15], inst_reg[24:20], inst_reg[11:7],
    Result, R1_out, R2_out);
    
    always @(posedge clk)
    begin
    if (rst)
        R1_reg <= 0;
        
    else
        R1_reg <= R1_out;
    end
    
    always @(posedge clk)
    begin
    if (rst)
        R2_reg <= 0;
        
    else
        R2_reg <= R2_out;
    end
    
    // Extensor de Signo
    wire [19:0] Imm;
    wire [31:0] ExtImm;
    
    assign Imm = ImmType ? {inst_reg[31:25], inst_reg[11:7], 8'd0} : inst_reg[31:12];
    
    Extensor_de_Signo ExtSign(ImmSrc, Imm, ExtImm);
    
    // Alu
    reg [31:0] SrcA, AluOut;
    wire [31:0] SrcB, AluResult;
    
    assign SrcB = AluSrcB ? 31'd4 : ExtImm;
    
    always @*
    case(AluSrcA)
        2'b00: SrcA = R1_reg;
        2'b01: SrcA = PC;
        2'b10: SrcA = 2'b0;
        2'b11: SrcA = 2'b0;
    endcase
    
    ALU CPU_ALU(SrcA, SrcB, AluControl, AluResult);
    
    always @(posedge clk)
    begin
    if (rst)
        AluOut <= 0;
    
    else
        AluOut <= AluResult;
    end
    
    // Mux Result
    always @*
    case(ResultSrc)
        2'd0: Result = AluOut;
        2'd1: Result = Data_reg;
        2'd2: Result = AluResult;
        2'd3: Result = 0;
    endcase
    
    assign out = Result;
    
endmodule
