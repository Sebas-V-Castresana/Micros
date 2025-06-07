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
input ImnSrc,
input [19:0] inmediato,
output [31:0] out
    );
    
    wire [31:0] twelve_bits, vingt_bits;
    // Antes de extender se debe verificar si el num es neg o pos
    assign twelve_bits = inmediato[19] ? {inmediato[19], 20'b11111111111111111111, inmediato[18:8]} : {inmediato[19], 20'b0, inmediato[18:8]};
    assign vingt_bits = inmediato[19] ? {inmediato[19:0], 12'b111111111111} : {inmediato[19:0], 12'b0};
    
    assign out = ImnSrc ? vingt_bits : twelve_bits;
    
endmodule
