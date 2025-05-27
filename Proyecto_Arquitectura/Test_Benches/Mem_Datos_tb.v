`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2025 12:08:54 AM
// Design Name: 
// Module Name: Mem_Datos_tb
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


module Mem_Datos_tb;

reg clk, rst, we;
reg [31:0] Data;
reg [4:0] Addrs;
wire [31:0] Out;

Memoria_Datos uut (clk, rst, we, Addrs, Data, Out);

initial begin
clk = 1;
rst = 1;
#5 rst = 0;
Addrs = 0;
we = 1;
Data = 32'hAABBCCD0;
end

always #5 clk = ~clk;
always #10 Addrs = Addrs + 4;
always #10 Data = Data + 1;

endmodule
