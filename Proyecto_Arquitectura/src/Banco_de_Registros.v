`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2025 04:30:09 PM
// Design Name: 
// Module Name: Banco_de_Registros
// Project Name: Microprocesador
// Target Devices: 
// Tool Versions: 
// Description: Banco de registros para procesador uniciclo
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Banco_de_Registros(
input write_enable, clk, rst,
input [4:0] Addrs1, Addrs2, Addrs3,
input [31:0] Data,
output [31:0] R1_out, R2_out
    );
    
    //Se crean los 32 registros del banco
    reg [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12,
    R13, R14, R15, R16, R17, R18, R19, R20, R21, R22, R23, R24, R25,
    R26, R27, R28, R29, R30, R31;
    
    // Celda para registro 0
    always @ (posedge clk)
    begin
        if (rst)
            R0 <= 0; //reset
        else if ((Addrs3 == 5'd0) & write_enable)
            R0 <= Data;  // Guarda los 4 bytes de entrada
        else
            R0 <= R0;  // Condición de memoria
    end
    
    // Se repite para los otros 31 registros
    always @ (posedge clk)
    begin
        if (rst)
            R1 <= 0;
        else if ((Addrs3 == 5'd1) & write_enable)
            R1 <= Data;
        else
            R1 <= R1;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R2 <= 0;
        else if ((Addrs3 == 5'd2) & write_enable)
            R2 <= Data;
        else
            R2 <= R2;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R3 <= 0;
        else if ((Addrs3 == 5'd3) & write_enable)
            R3 <= Data;
        else
            R3 <= R3;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R4 <= 0;
        else if ((Addrs3 == 5'd4) & write_enable)
            R4 <= Data;
        else
            R4 <= R4;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R5 <= 0;
        else if ((Addrs3 == 5'd5) & write_enable)
            R5 <= Data;
        else
            R5 <= R5;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R6 <= 0;
        else if ((Addrs3 == 5'd6) & write_enable)
            R6 <= Data;
        else
            R6 <= R6;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R7 <= 0;
        else if ((Addrs3 == 5'd7) & write_enable)
            R7 <= Data;
        else
            R7 <= R7;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R8 <= 0;
        else if ((Addrs3 == 5'd8) & write_enable)
            R8 <= Data;
        else
            R8 <= R8;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R9 <= 0;
        else if ((Addrs3 == 5'd9) & write_enable)
            R9 <= Data;
        else
            R9 <= R9;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R10 <= 0;
        else if ((Addrs3 == 5'd10) & write_enable)
            R10 <= Data;
        else
            R10 <= R10;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R11 <= 0;
        else if ((Addrs3 == 5'd11) & write_enable)
            R11 <= Data;
        else
            R11 <= R11;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R12 <= 0;
        else if ((Addrs3 == 5'd12) & write_enable)
            R12 <= Data;
        else
            R12 <= R12;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R13 <= 0;
        else if ((Addrs3 == 5'd13) & write_enable)
            R13 <= Data;
        else
            R13 <= R13;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R14 <= 14;
        else if ((Addrs3 == 5'd14) & write_enable)
            R14 <= Data;
        else
            R14 <= R14;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R15 <= 0;
        else if ((Addrs3 == 5'd15) & write_enable)
            R15 <= Data;
        else
            R15 <= R15;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R16 <= 0;
        else if ((Addrs3 == 5'd16) & write_enable)
            R16 <= Data;
        else
            R16 <= R16;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R17 <= 0;
        else if ((Addrs3 == 5'd17) & write_enable)
            R17 <= Data;
        else
            R17 <= R17;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R18 <= 0;
        else if ((Addrs3 == 5'd18) & write_enable)
            R18 <= Data;
        else
            R18 <= R18;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R19 <= 0;
        else if ((Addrs3 == 5'd19) & write_enable)
            R19 <= Data;
        else
            R19 <= R19;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R20 <= 0;
        else if ((Addrs3 == 5'd20) & write_enable)
            R20 <= Data;
        else
            R20 <= R20;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R21 <= 0;
        else if ((Addrs3 == 5'd21) & write_enable)
            R21 <= Data;
        else
            R21 <= R21;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R22 <= 0;
        else if ((Addrs3 == 5'd22) & write_enable)
            R22 <= Data;
        else
            R22 <= R22;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R23 <= 0;
        else if ((Addrs3 == 5'd23) & write_enable)
            R23 <= Data;
        else
            R23 <= R23;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R24 <= 0;
        else if ((Addrs3 == 5'd24) & write_enable)
            R24 <= Data;
        else
            R24 <= R24;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R25 <= 0;
        else if ((Addrs3 == 5'd25) & write_enable)
            R25 <= Data;
        else
            R25 <= R25;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R26 <= 0;
        else if ((Addrs3 == 5'd26) & write_enable)
            R26 <= Data;
        else
            R26 <= R26;
    end
     
    always @ (posedge clk)
    begin
        if (rst)
            R27 <= 0;
        else if ((Addrs3 == 5'd27) & write_enable)
            R27 <= Data;
        else
            R27 <= R27;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R28 <= 0;
        else if ((Addrs3 == 5'd28) & write_enable)
            R28 <= Data;
        else
            R28 <= R28;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R29 <= 0;
        else if ((Addrs3 == 5'd29) & write_enable)
            R29 <= Data;
        else
            R29 <= R29;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R30 <= 0;
        else if ((Addrs3 == 5'd30) & write_enable)
            R30 <= Data;
        else
            R30 <= R30;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            R31 <= 0;
        else if ((Addrs3 == 5'd31) & write_enable)
            R31 <= Data;
        else
            R31 <= R31;
    end
    
    //Se usa un mux como selector de registro a leer
    reg [31:0] mux1;
    always @* begin
        case(Addrs1)
            5'd0: mux1 = R0;
            5'd1: mux1 = R1;
            5'd2: mux1 = R2;
            5'd3: mux1 = R3;
            5'd4: mux1 = R4;
            5'd5: mux1 = R5;
            5'd6: mux1 = R6;
            5'd7: mux1 = R7;
            5'd8: mux1 = R8;
            5'd9: mux1 = R9;
            5'd10: mux1 = R10;
            5'd11: mux1 = R11;
            5'd12: mux1 = R12;
            5'd13: mux1 = R13;
            5'd14: mux1 = R14;
            5'd15: mux1 = R15;
            5'd16: mux1 = R16;
            5'd17: mux1 = R17;
            5'd18: mux1 = R18;
            5'd19: mux1 = R19;
            5'd20: mux1 = R20;
            5'd21: mux1 = R21;
            5'd22: mux1 = R22;
            5'd23: mux1 = R23;
            5'd24: mux1 = R24;
            5'd25: mux1 = R25;
            5'd26: mux1 = R26;
            5'd27: mux1 = R27;
            5'd28: mux1 = R28;
            5'd29: mux1 = R29;
            5'd30: mux1 = R30;
            5'd31: mux1 = R31;    
        endcase
    end
        
        //Se usa un mux como selector de registro a leer
    reg [31:0] mux2;
    always @* begin
        case(Addrs2)
            5'd0: mux2 = R0;
            5'd1: mux2 = R1;
            5'd2: mux2 = R2;
            5'd3: mux2 = R3;
            5'd4: mux2 = R4;
            5'd5: mux2 = R5;
            5'd6: mux2 = R6;
            5'd7: mux2 = R7;
            5'd8: mux2 = R8;
            5'd9: mux2 = R9;
            5'd10: mux2 = R10;
            5'd11: mux2 = R11;
            5'd12: mux2 = R12;
            5'd13: mux2 = R13;
            5'd14: mux2 = R14;
            5'd15: mux2 = R15;
            5'd16: mux2 = R16;
            5'd17: mux2 = R17;
            5'd18: mux2 = R18;
            5'd19: mux2 = R19;
            5'd20: mux2 = R20;
            5'd21: mux2 = R21;
            5'd22: mux2 = R22;
            5'd23: mux2 = R23;
            5'd24: mux2 = R24;
            5'd25: mux2 = R25;
            5'd26: mux2 = R26;
            5'd27: mux2 = R27;
            5'd28: mux2 = R28;
            5'd29: mux2 = R29;
            5'd30: mux2 = R30;
            5'd31: mux2 = R31;    
        endcase
    end
        
    assign R1_out = mux1;
    assign R2_out = mux2;
    
endmodule
