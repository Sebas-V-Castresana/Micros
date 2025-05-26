`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2025 09:26:32 PM
// Design Name: 
// Module Name: Memoria_Datos
// Project Name: Microprocesador
// Target Devices: 
// Tool Versions: 
// Description: Memoria de Datos para el micro, guarda los datos del programa
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Memoria_Datos(
input clk, rst, write_enable,
input [4:0] Addrs,
input [31:0] Data_in,
output [31:0] Data_out
    );
    
    // El manejo de que se escriba un word (4 bytes) o 1 byte lo hace la CU

    // Tamaño max va a ser de 24 bytes
    reg [7:0] Mem [23:0];
    
    // Se crean los 4 posibles Addrs
    wire [4:0] AddrsP1, AddrsP2, AddrsP3;
    
    assign AddrsP1 = Addrs + 5'd1;
    assign AddrsP2 = Addrs + 5'd2;
    assign AddrsP3 = Addrs + 5'd3;
    /*
    // Banderas para controlar el enable de los registros individuales
    wire flag0, flag1, flag2, flag3, flag4, flag5, flag6, flag7, flag8, flag9, flag10, flag11,
    flag12, flag13, flag14, flag15, flag16, flag17, flag18, flag19, flag20, flag21, flag22, flag23;
    
    assign flag0 = write_enable & (Addrs == 0);
    assign flag1 = write_enable & ((Addrs == 1) | (Addrs == 0));
    assign flag2 = write_enable & ((Addrs == 2) | (Addrs == 1) | (Addrs == 0));
    assign flag3 = write_enable & ((Addrs == 3) | (Addrs == 2) | (Addrs == 1) | (Addrs == 0));
    
     
    
    assign Data_out[3:0] = {flag0, flag1, flag2, flag3};
    
    
    // Se crean las celdas de memoria*/
    integer i;
    
    always @(posedge clk)
    begin
    if (rst)
        for (i = 0; i < 24; i = i + 1)
            Mem[i] <= 0;
    else if (write_enable)
    begin
        Mem[Addrs] <= Data_in[31:24];
        Mem[AddrsP1] <= Data_in[23:16];
        Mem[AddrsP2] <= Data_in[15:8];
        Mem[AddrsP3] <= Data_in[7:0];
    end
    end
    
    assign Data_out = {Mem[Addrs], Mem[AddrsP1], Mem[AddrsP2], Mem[AddrsP3]};
    
endmodule
