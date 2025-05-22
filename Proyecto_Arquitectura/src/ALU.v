`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2025 09:02:47 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
input [31:0] A, B,
input Sel,
output [31:0] Data_out
    );
    
    // No se considera la resta pues se trabaja con complemento a 2
    // Sel = 1, es una suma, Sel + 0 es un and con un inmediato
    wire [31:0] suma, iand;
    
    assign suma = A + B;
    // En caso de que se tenga una resta se le sum
    assign iand = A & B;
 
    assign Data_out = Sel ? suma : iand;
    
endmodule
