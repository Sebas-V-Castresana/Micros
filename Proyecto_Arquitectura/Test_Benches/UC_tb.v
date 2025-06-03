`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2025 08:02:26 AM
// Design Name: 
// Module Name: UC_tb
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


module UC_tb;

reg clk, rst;
reg [31:0] inst;

wire AluControl, InstW, MemW, RegW, PCW, AluSrcB, stype, ltype, ImnSrc;
wire [1:0] AluSrcA, ResultSrc;

Unidad_Control uut (clk, rst, inst, AluControl, InstW, MemW, RegW, PCW, AluSrcB, stype, ltype,
ImnSrc, AluSrcA, ResultSrc);

initial
begin
clk = 1;
rst = 1;
#5 rst = 0;
inst = 32'hAAA18093; // addi r3 r1 AAA
#35 inst = 32'hAAA1F093; // andi r3 r1 AAA
#40 inst = 32'h0000A183; // lw r3 0(r1)
#50 inst = 32'h0030A023; // sw r3 0(r1)
#40 inst = 32'h0000C183; // lbu r3 0(r1)
#50 inst = 32'h00308023; // sb r3 0(r1)
#40 inst = 32'hAAAAA1B7; // lui r3, AAAAA
end

always #5 clk =~clk;

endmodule
