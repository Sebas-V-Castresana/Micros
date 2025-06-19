`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2025 10:18:49 AM
// Design Name: 
// Module Name: Reg_tb
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


module Reg_tb;

reg we, clk, rst;
reg [4:0] Addrs1, Addrs2, Addrs3; // Lect: 1 y 2, Escrt: 3
reg [31:0] Data;
wire [31:0] R1_out, R2_out;

Banco_de_Registros uut (we, clk, rst, Addrs1, Addrs2, Addrs3, Data, R1_out, R2_out);

initial begin

rst = 1;
clk = 1;
Addrs1 = 0;
Addrs2 = 0;
Addrs3 = 0;
we = 0;
Data = 0;
#5 rst = 0;
end

always #5 clk = ~clk;

// Cada dos ciclos de reloj se varian los addrss
always #20 Addrs1 = Addrs1 + 1;
always #20 Addrs2 = Addrs2 + 1;
always #20 Addrs3 = Addrs3 + 1;
always #20 Data = Data + 1;

// Cada ciclo se cambia el write enable
always #10 we = ~we;

// Se deberia ver un 0 en los 3 address y despues el valor escrito
// hasta llegar al final del banco

endmodule
