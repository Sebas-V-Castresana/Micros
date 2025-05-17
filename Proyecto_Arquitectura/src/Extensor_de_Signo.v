`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2025 08:21:57 PM
// Design Name: 
// Module Name: Extensor_de_Signo
// Project Name: Microprocesador
// Target Devices: 
// Tool Versions: 
// Description: Pasa 12 bits a 32 bits manteniendo el signo
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Extensor_de_Signo(
input [11:0] inmediato,
output [31:0] out
    );
    
    // Antes de extender se debe verificar si el num es neg o pos
    assign out = inmediato[11] ? {inmediato[11], 19'b1111111111111111111, inmediato[10:0]} : {inmediato[11], 19'b0, inmediato[10:0]};
    
endmodule
