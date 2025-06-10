`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2025 12:26:15 PM
// Design Name: 
// Module Name: Extensor_Signo_tb
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


module Extensor_Signo_tb;

reg InmSrc;
reg [19:0] Inm;
wire [31:0] out;

Extensor_de_Signo uut (InmSrc, Inm, out);

// InmSrc se pone en alto si el inmediato es de 20 bits y se carga en la parte superior de out

initial
begin
InmSrc = 0;
Inm = 20'd1075 << 8;
#10 Inm = 20'b10111100110100000000; // -1075
#10 begin
InmSrc = 1;
Inm = 20'd2050; // Mayor a 12 bits
end
# 10 Inm = 20'b11111111011111111110;
end

endmodule
