`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2025 01:12:46 PM
// Design Name: 
// Module Name: Alu_tb
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


module Alu_tb;

reg [31:0] A, B;
reg operacion;  // 0 suma, 1 and
wire [31:0] result;

ALU uut (A, B, operacion, result);

initial
begin
A = 32'd20000;
B = 32'd30000;
operacion = 0;
#100
begin
A = 32'b11011011011;
B = 32'b01101101101;
operacion = 1;
end
end

endmodule
