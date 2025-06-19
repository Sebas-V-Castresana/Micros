`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 03:35:19 PM
// Design Name: 
// Module Name: MemoriaInstrucciones
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


module MemoriaInstrucciones (
    input [31:0] address,          // Dirección de instrucción (5 bits para 32 posiciones)
    output reg [31:0] inst // Instrucción de 32 bits
);

    reg [31:0] memoria[0:63]; // Memoria de 32 posiciones de 32 bits

    initial begin
        memoria[0]  = 32'h0000B037; // lui r0 0xB              
        memoria[4]  = 32'hBCD00013; // addi r0 r0 -1075        
        memoria[8]  = 32'h0000A023; // sw r0 0(r1)             
        memoria[12] = 32'h00908013; // addi r0 r1 9 (li r0 9)  
        memoria[16] = 32'h0000A223; // sw r0 4(r1)             
        memoria[20] = 32'h0040A003; // lw r0 4(r1)             
        memoria[24] = 32'h00307013; // andi r0, r0, 3          
        memoria[28] = 32'h0000A423; // sw r0 8(r1)             
        memoria[32] = 32'h06108013; // addi r0 r1 97 (li r0 97)
        memoria[36] = 32'h000A1623; // sb r0 12(r1)            
        memoria[40] = 32'h00C0C003; // lbu r0 12(r1)           
        memoria[44] = 32'h000A16A3; // sb r0 13(r1)            
        memoria[48] = 32'h00008013; // addi r0 r1 0 (li r0 0)          
        memoria[52] = 32'h00000113; // addi r2 r0 0 (mv r2 r0)        
    end

    always @(*) begin
        inst = memoria[address];
    end
endmodule