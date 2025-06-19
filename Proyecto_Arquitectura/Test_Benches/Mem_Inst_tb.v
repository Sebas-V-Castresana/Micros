`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2025 22:56:32
// Design Name: 
// Module Name: MemoriaIns_tb
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


`timescale 1ns / 1ps

module tb_MemoriaInstrucciones;

    reg [31:0] address;
    wire [31:0] inst;

    MemoriaInstrucciones uut (
        .address(address),
        .inst(inst)
    );

    integer i;

    initial begin
        // Recorrer direcciones con instrucciones cargadas (hasta 52)
        for (i = 0; i <= 52; i = i + 4) begin
            address = i;
            #5; // Tiempo suficiente para observar en el waveform
        end

        // Última dirección cargada: 52, pero puedes expandir si llenas más memoria
        #10;
        $finish;
    end

endmodule
