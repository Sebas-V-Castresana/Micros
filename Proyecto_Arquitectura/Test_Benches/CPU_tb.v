`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2025 11:25:40 PM
// Design Name: 
// Module Name: CPU_tb
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


module CPU_tb;

reg clk, rst;
reg [31:0] inst;
wire [31:0] out;

integer i, file;
parameter SIZE = 32;

CPU_top uut (clk, rst, inst, out);

initial
begin
clk = 1;
rst = 1;
#5 rst = 0;
// Se prueban las 7 posibles instrucciones
inst = 32'h7AA18093; // addi r1 r3 7AA
#35 inst = 32'hF0F0F113; // andi r2 r1 F0F
#40 inst = 32'h00202023; // sw r2 0(r0)
#40 inst = 32'h00200023; // sb r2 0(r0)
#40 inst = 32'h00304183; // lbu r3 3(r0)
#50 inst = 32'h00002203; // lw r4 0(r0)
#50 inst = 32'h7FFFF037; // lui r0, 7FFFF
#40 rst = 1;
#10 rst = 0;

// INSTRUCCIONES DE PROYECTO
inst = 32'h0000B037; // lui r0 0xB
#40 inst = 32'hBCD00013; // addi r0 r0 -1075
#40 inst = 32'h0000A023; // sw r0 0(r1)
#40 inst = 32'h00908013; // addi r0 r1 9 (li r0 9)
#40 inst = 32'h0000A223; // sw r0 4(r1)
#40 inst = 32'h0040A003; // lw r0 4(r1)
#50 inst = 32'h00307013; // andi r0, r0, 3
#40 inst = 32'h0000A423; // sw r0 8(r1)
#40 inst = 32'h06108013; // addi r0 r1 97 (li r0 97)
#40 inst = 32'h000A1623; // sb r0 12(r1)
#40 inst = 32'h00C0C003; // lbu r0 12(r1)
#50 inst = 32'h000A16A3; // sb r0 13(r1)
#40 inst = 32'h00008013; // addi r0 r1 0 (li r0 0)
#40 inst = 32'h00000113; // adadi r2 r0 0 (mv r2 r0)


// Dump de Memoria
file = $fopen ("Dump.txt","w");

$fwrite(file, "Direccion    Valor en hexadecimal\n");

for (i = 0; i < SIZE; i = i + 1)
begin
    if ((i & 'h3) == 'h0)
    begin
    $fwrite (file,"0x%h", i);
    $fwrite (file,"       0x%h", uut.Datos.Mem[i]);
    $display ("     0x%h\n", uut.Datos.Mem[i]);
    end
    
    else if ((i & 'h3) == 'h3)
    begin
    $fwrite (file,"%h\n", uut.Datos.Mem[i]);
    $display ("%h\n", uut.Datos.Mem[i]);
    end
    
    else
    begin
    $fwrite (file,"%h", uut.Datos.Mem[i]);
    $display ("%h", uut.Datos.Mem[i]);
    end
    
end

$fclose (file);

end

always #5 clk =~clk;

endmodule
