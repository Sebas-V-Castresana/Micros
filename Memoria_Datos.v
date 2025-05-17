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
input clk, rst, write_enable, type,
input [5:0] Addrs,
input [31:0] Data_in,
output reg [31:0] Data_out
    );

    // Tamaño max va a ser de 32 bytes -> 32*8 = 256 bits
    reg [7:0] Mem [31:0];
    
    // Se crean las celdas de memoria
    reg [7:0] mux0;
    
    always @*
    begin
        case(Addrs)
            5'd0: mux0 <= Data_in[7:0];
            
            default: mux0 <= Mem[0];
            
        endcase
    end
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[0] <= 0;
            
        else if (write_enable)
            Mem[0] <= mux0;
        
        else
            Mem[0] <= Mem[0];
        
    end
    
    reg [7:0] mux1;
    wire [7:0] Data1;
    
    always @*
    begin
        case(Addrs)
            5'd0: mux1 <= Data_in[15:8];
            5'd1: mux1 <= Data_in[7:0];
            
            default: mux1 <= Mem[1];
            
        endcase
    end
    
    assign Data1 = type ? Data_in[7:0] : mux1;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[1] <= 0;
            
        else if (write_enable)
            Mem[1] <= Data1;
        
        else
            Mem[1] <= Mem[1];
        
    end
    
    reg [7:0] mux2;
    wire [7:0] Data2;
    
    always @*
    begin
        case(Addrs)
            5'd0: mux2 <= Data_in[23:16];
            5'd1: mux2 <= Data_in[15:8];
            5'd2: mux2 <= Data_in[7:0];
            
            default: mux2 <= Mem[2];
            
        endcase
    end
    
    assign Data2 = type ? Data_in[7:0] : mux2;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[2] <= 0;
            
        else if (write_enable)
            Mem[2] <= Data2;
        
        else
            Mem[2] <= Mem[2];
        
    end
    
    reg [7:0] mux3;
    wire [7:0] Data3;
    
    always @*
    begin
        case(Addrs)
            5'd0: mux3 <= Data_in[31:24];
            5'd1: mux3 <= Data_in[23:16];
            5'd2: mux3 <= Data_in[15:8];
            5'd3: mux3 <= Data_in[7:0];
            
            default: mux3 <= Mem[3];
            
        endcase
    end
    
    assign Data3 = type ? Data_in[7:0] : mux3;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[3] <= 0;
            
        else if (write_enable)
            Mem[3] <= Data3;
        
        else
            Mem[3] <= Mem[3];
        
    end
    
    reg [7:0] mux4;
    wire [7:0] Data4;
    
    always @*
    begin
        case(Addrs)
            5'd1: mux4 <= Data_in[31:24];
            5'd2: mux4 <= Data_in[23:16];
            5'd3: mux4 <= Data_in[15:8];
            5'd4: mux4 <= Data_in[7:0];
            
            default: mux4 <= Mem[4];
            
        endcase
    end
    
    assign Data4 = type ? Data_in[7:0] : mux4;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[4] <= 0;
            
        else if (write_enable)
            Mem[4] <= Data4;
        
        else
            Mem[4] <= Mem[4];
        
    end
    
    reg [7:0] mux5;
    wire [7:0] Data5;
    
    always @*
    begin
        case(Addrs)
            5'd2: mux5 <= Data_in[31:24];
            5'd3: mux5 <= Data_in[23:16];
            5'd4: mux5 <= Data_in[15:8];
            5'd5: mux5 <= Data_in[7:0];
            
            default: mux5 <= Mem[5];
            
        endcase
    end
    
    assign Data5 = type ? Data_in[7:0] : mux5;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[5] <= 0;
            
        else if (write_enable)
            Mem[5] <= Data5;
        
        else
            Mem[5] <= Mem[5];
        
    end
    
    reg [7:0] mux6;
    wire [7:0] Data6;
    
    always @*
    begin
        case(Addrs)
            5'd3: mux6 <= Data_in[31:24];
            5'd4: mux6 <= Data_in[23:16];
            5'd5: mux6 <= Data_in[15:8];
            5'd6: mux6 <= Data_in[7:0];
            
            default: mux6 <= Mem[6];
            
        endcase
    end
    
    assign Data6 = type ? Data_in[7:0] : mux6;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[6] <= 0;
            
        else if (write_enable)
            Mem[6] <= Data6;
        
        else
            Mem[6] <= Mem[6];
        
    end
    
    reg [7:0] mux7;
    wire [7:0] Data7;
    
    always @*
    begin
        case(Addrs)
            5'd4: mux7 <= Data_in[31:24];
            5'd5: mux7 <= Data_in[23:16];
            5'd6: mux7 <= Data_in[15:8];
            5'd7: mux7 <= Data_in[7:0];
            
            default: mux7 <= Mem[7];
            
        endcase
    end
    
    assign Data7 = type ? Data_in[7:0] : mux7;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[7] <= 0;
            
        else if (write_enable)
            Mem[7] <= Data7;
        
        else
            Mem[7] <= Mem[7];
        
    end
    
    reg [7:0] mux8;
    wire [7:0] Data8;
    
    always @*
    begin
        case(Addrs)
            5'd5: mux8 <= Data_in[31:24];
            5'd6: mux8 <= Data_in[23:16];
            5'd7: mux8 <= Data_in[15:8];
            5'd8: mux8 <= Data_in[7:0];
            
            default: mux8 <= Mem[8];
            
        endcase
    end
    
    assign Data8 = type ? Data_in[7:0] : mux8;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[8] <= 0;
            
        else if (write_enable)
            Mem[8] <= Data8;
        
        else
            Mem[8] <= Mem[8];
        
    end
    
    reg [7:0] mux9;
    wire [7:0] Data9;
    
    always @*
    begin
        case(Addrs)
            5'd6: mux9 <= Data_in[31:24];
            5'd7: mux9 <= Data_in[23:16];
            5'd8: mux9 <= Data_in[15:8];
            5'd9: mux9 <= Data_in[7:0];
            
            default: mux9 <= Mem[9];
            
        endcase
    end
    
    assign Data9 = type ? Data_in[7:0] : mux9;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[9] <= 0;
            
        else if (write_enable)
            Mem[9] <= Data9;
        
        else
            Mem[9] <= Mem[9];
        
    end
    
    reg [7:0] mux10;
    wire [7:0] Data10;
    
    always @*
    begin
        case(Addrs)
            5'd7: mux10 <= Data_in[31:24];
            5'd8: mux10 <= Data_in[23:16];
            5'd9: mux10 <= Data_in[15:8];
            5'd10: mux10 <= Data_in[7:0];
            
            default: mux10 <= Mem[10];
            
        endcase
    end
    
    assign Data10 = type ? Data_in[7:0] : mux10;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[10] <= 0;
            
        else if (write_enable)
            Mem[10] <= Data10;
        
        else
            Mem[10] <= Mem[10];
        
    end
    
    reg [7:0] mux11;
    wire [7:0] Data11;
    
    always @*
    begin
        case(Addrs)
            5'd8: mux11 <= Data_in[31:24];
            5'd9: mux11 <= Data_in[23:16];
            5'd10: mux11 <= Data_in[15:8];
            5'd11: mux11 <= Data_in[7:0];
            
            default: mux11 <= Mem[11];
            
        endcase
    end
    
    assign Data11 = type ? Data_in[7:0] : mux11;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[11] <= 0;
            
        else if (write_enable)
            Mem[11] <= Data11;
        
        else
            Mem[11] <= Mem[11];
        
    end
    
    reg [7:0] mux12;
    wire [7:0] Data12;
    
    always @*
    begin
        case(Addrs)
            5'd9: mux12 <= Data_in[31:24];
            5'd10: mux12 <= Data_in[23:16];
            5'd11: mux12 <= Data_in[15:8];
            5'd12: mux12 <= Data_in[7:0];
            
            default: mux12 <= Mem[12];
            
        endcase
    end
    
    assign Data12 = type ? Data_in[7:0] : mux10;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[12] <= 0;
            
        else if (write_enable)
            Mem[12] <= Data12;
        
        else
            Mem[12] <= Mem[12];
        
    end
    
    reg [7:0] mux13;
    wire [7:0] Data13;
    
    always @*
    begin
        case(Addrs)
            5'd10: mux13 <= Data_in[31:24];
            5'd11: mux13 <= Data_in[23:16];
            5'd12: mux13 <= Data_in[15:8];
            5'd13: mux13 <= Data_in[7:0];
            
            default: mux13 <= Mem[13];
            
        endcase
    end
    
    assign Data13 = type ? Data_in[7:0] : mux13;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[13] <= 0;
            
        else if (write_enable)
            Mem[13] <= Data13;
        
        else
            Mem[13] <= Mem[13];
        
    end
    
    reg [7:0] mux14;
    wire [7:0] Data14;
    
    always @*
    begin
        case(Addrs)
            5'd11: mux14 <= Data_in[31:24];
            5'd12: mux14 <= Data_in[23:16];
            5'd13: mux14 <= Data_in[15:8];
            5'd14: mux14 <= Data_in[7:0];
            
            default: mux14 <= Mem[14];
            
        endcase
    end
    
    assign Data14 = type ? Data_in[7:0] : mux14;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[14] <= 0;
            
        else if (write_enable)
            Mem[14] <= Data14;
        
        else
            Mem[14] <= Mem[14];
        
    end
    
    reg [7:0] mux15;
    wire [7:0] Data15;
    
    always @*
    begin
        case(Addrs)
            5'd12: mux15 <= Data_in[31:24];
            5'd13: mux15 <= Data_in[23:16];
            5'd14: mux15 <= Data_in[15:8];
            5'd15: mux15 <= Data_in[7:0];
            
            default: mux15 <= Mem[15];
            
        endcase
    end
    
    assign Data15 = type ? Data_in[7:0] : mux15;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[15] <= 0;
            
        else if (write_enable)
            Mem[15] <= Data15;
        
        else
            Mem[15] <= Mem[15];
        
    end
    
    reg [7:0] mux16;
    wire [7:0] Data16;
    
    always @*
    begin
        case(Addrs)
            5'd13: mux16 <= Data_in[31:24];
            5'd14: mux16 <= Data_in[23:16];
            5'd15: mux16 <= Data_in[15:8];
            5'd16: mux16 <= Data_in[7:0];
            
            default: mux16 <= Mem[16];
            
        endcase
    end
    
    assign Data16 = type ? Data_in[7:0] : mux16;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[16] <= 0;
            
        else if (write_enable)
            Mem[16] <= Data16;
        
        else
            Mem[16] <= Mem[16];
        
    end
    
    reg [7:0] mux17;
    wire [7:0] Data17;
    
    always @*
    begin
        case(Addrs)
            5'd14: mux17 <= Data_in[31:24];
            5'd15: mux17 <= Data_in[23:16];
            5'd16: mux17 <= Data_in[15:8];
            5'd17: mux17 <= Data_in[7:0];
            
            default: mux17 <= Mem[17];
            
        endcase
    end
    
    assign Data17 = type ? Data_in[7:0] : mux17;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[17] <= 0;
            
        else if (write_enable)
            Mem[17] <= Data17;
        
        else
            Mem[17] <= Mem[17];
        
    end
    
    reg [7:0] mux18;
    wire [7:0] Data18;
    
    always @*
    begin
        case(Addrs)
            5'd15: mux18 <= Data_in[31:24];
            5'd16: mux18 <= Data_in[23:16];
            5'd17: mux18 <= Data_in[15:8];
            5'd18: mux18 <= Data_in[7:0];
            
            default: mux18 <= Mem[18];
            
        endcase
    end
    
    assign Data18 = type ? Data_in[7:0] : mux18;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[18] <= 0;
            
        else if (write_enable)
            Mem[18] <= Data18;
        
        else
            Mem[18] <= Mem[18];
        
    end
    
    reg [7:0] mux19;
    wire [7:0] Data19;
    
    always @*
    begin
        case(Addrs)
            5'd16: mux19 <= Data_in[31:24];
            5'd17: mux19 <= Data_in[23:16];
            5'd18: mux19 <= Data_in[15:8];
            5'd19: mux19 <= Data_in[7:0];
            
            default: mux19 <= Mem[19];
            
        endcase
    end
    
    assign Data19 = type ? Data_in[7:0] : mux19;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[19] <= 0;
            
        else if (write_enable)
            Mem[19] <= Data19;
        
        else
            Mem[19] <= Mem[19];
        
    end
    
    reg [7:0] mux20;
    wire [7:0] Data20;
    
    always @*
    begin
        case(Addrs)
            5'd17: mux20 <= Data_in[31:24];
            5'd18: mux20 <= Data_in[23:16];
            5'd19: mux20 <= Data_in[15:8];
            5'd20: mux20 <= Data_in[7:0];
            
            default: mux20 <= Mem[20];
            
        endcase
    end
    
    assign Data20 = type ? Data_in[7:0] : mux20;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[20] <= 0;
            
        else if (write_enable)
            Mem[20] <= Data20;
        
        else
            Mem[20] <= Mem[20];
        
    end
    
    reg [7:0] mux21;
    wire [7:0] Data21;
    
    always @*
    begin
        case(Addrs)
            5'd18: mux21 <= Data_in[31:24];
            5'd19: mux21 <= Data_in[23:16];
            5'd20: mux21 <= Data_in[15:8];
            5'd21: mux21 <= Data_in[7:0];
            
            default: mux21 <= Mem[21];
            
        endcase
    end
    
    assign Data21 = type ? Data_in[7:0] : mux21;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[21] <= 0;
            
        else if (write_enable)
            Mem[21] <= Data21;
        
        else
            Mem[21] <= Mem[21];
        
    end
    
    reg [7:0] mux22;
    wire [7:0] Data22;
    
    always @*
    begin
        case(Addrs)
            5'd19: mux22 <= Data_in[31:24];
            5'd20: mux22 <= Data_in[23:16];
            5'd21: mux22 <= Data_in[15:8];
            5'd22: mux22 <= Data_in[7:0];
            
            default: mux22 <= Mem[22];
            
        endcase
    end
    
    assign Data22 = type ? Data_in[7:0] : mux22;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[22] <= 0;
            
        else if (write_enable)
            Mem[22] <= Data22;
        
        else
            Mem[22] <= Mem[22];
        
    end
    
    reg [7:0] mux23;
    wire [7:0] Data23;
    
    always @*
    begin
        case(Addrs)
            5'd20: mux23 <= Data_in[31:24];
            5'd21: mux23 <= Data_in[23:16];
            5'd22: mux23 <= Data_in[15:8];
            5'd23: mux23 <= Data_in[7:0];
            
            default: mux23 <= Mem[23];
            
        endcase
    end
    
    assign Data23 = type ? Data_in[7:0] : mux23;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[23] <= 0;
            
        else if (write_enable)
            Mem[23] <= Data23;
        
        else
            Mem[23] <= Mem[23];
        
    end
    
    reg [7:0] mux24;
    wire [7:0] Data24;
    
    always @*
    begin
        case(Addrs)
            5'd21: mux24 <= Data_in[31:24];
            5'd22: mux24 <= Data_in[23:16];
            5'd23: mux24 <= Data_in[15:8];
            5'd24: mux24 <= Data_in[7:0];
            
            default: mux24 <= Mem[24];
            
        endcase
    end
    
    assign Data24 = type ? Data_in[7:0] : mux24;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[24] <= 0;
            
        else if (write_enable)
            Mem[24] <= Data24;
        
        else
            Mem[24] <= Mem[24];
        
    end
    
    reg [7:0] mux25;
    wire [7:0] Data25;
    
    always @*
    begin
        case(Addrs)
            5'd22: mux25 <= Data_in[31:24];
            5'd23: mux25 <= Data_in[23:16];
            5'd24: mux25 <= Data_in[15:8];
            5'd25: mux25 <= Data_in[7:0];
            
            default: mux25 <= Mem[25];
            
        endcase
    end
    
    assign Data25 = type ? Data_in[7:0] : mux25;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[25] <= 0;
            
        else if (write_enable)
            Mem[25] <= Data25;
        
        else
            Mem[25] <= Mem[25];
        
    end
    
    reg [7:0] mux26;
    wire [7:0] Data26;
    
    always @*
    begin
        case(Addrs)
            5'd23: mux26 <= Data_in[31:24];
            5'd24: mux26 <= Data_in[23:16];
            5'd25: mux26 <= Data_in[15:8];
            5'd26: mux26 <= Data_in[7:0];
            
            default: mux26 <= Mem[26];
            
        endcase
    end
    
    assign Data26 = type ? Data_in[7:0] : mux26;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[26] <= 0;
            
        else if (write_enable)
            Mem[26] <= Data26;
        
        else
            Mem[26] <= Mem[26];
        
    end
    
    reg [7:0] mux27;
    wire [7:0] Data27;
    
    always @*
    begin
        case(Addrs)
            5'd24: mux27 <= Data_in[31:24];
            5'd25: mux27 <= Data_in[23:16];
            5'd26: mux27 <= Data_in[15:8];
            5'd27: mux27 <= Data_in[7:0];
            
            default: mux27 <= Mem[27];
            
        endcase
    end
    
    assign Data27 = type ? Data_in[7:0] : mux27;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[27] <= 0;
            
        else if (write_enable)
            Mem[27] <= Data27;
        
        else
            Mem[27] <= Mem[27];
        
    end
    
    reg [7:0] mux28;
    wire [7:0] Data28;
    
    always @*
    begin
        case(Addrs)
            5'd25: mux28 <= Data_in[31:24];
            5'd26: mux28 <= Data_in[23:16];
            5'd27: mux28 <= Data_in[15:8];
            5'd28: mux28 <= Data_in[7:0];
            
            default: mux28 <= Mem[28];
            
        endcase
    end
    
    assign Data28 = type ? Data_in[7:0] : mux28;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[28] <= 0;
            
        else if (write_enable)
            Mem[28] <= Data28;
        
        else
            Mem[28] <= Mem[28];
        
    end
    
    reg [7:0] mux29;
    wire [7:0] Data29;
    
    always @*
    begin
        case(Addrs)
            5'd26: mux29 <= Data_in[31:24];
            5'd27: mux29 <= Data_in[23:16];
            5'd28: mux29 <= Data_in[15:8];
            5'd29: mux29 <= Data_in[7:0];
            
            default: mux29 <= Mem[29];
            
        endcase
    end
    
    assign Data29 = type ? Data_in[7:0] : mux29;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[29] <= 0;
            
        else if (write_enable)
            Mem[29] <= Data29;
        
        else
            Mem[29] <= Mem[29];
        
    end
    
    reg [7:0] mux30;
    wire [7:0] Data30;
    
    always @*
    begin
        case(Addrs)
            5'd27: mux30 <= Data_in[31:24];
            5'd28: mux30 <= Data_in[23:16];
            5'd29: mux30 <= Data_in[15:8];
            5'd30: mux30 <= Data_in[7:0];
            
            default: mux30 <= Mem[30];
            
        endcase
    end
    
    assign Data30 = type ? Data_in[7:0] : mux30;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[30] <= 0;
            
        else if (write_enable)
            Mem[30] <= Data30;
        
        else
            Mem[30] <= Mem[30];
        
    end
    
    reg [7:0] mux31;
    wire [7:0] Data31;
    
    always @*
    begin
        case(Addrs)
            5'd28: mux31 <= Data_in[31:24];
            5'd29: mux31 <= Data_in[23:16];
            5'd30: mux31 <= Data_in[15:8];
            5'd31: mux31 <= Data_in[7:0];
            
            default: mux31 <= Mem[31];
            
        endcase
    end
    
    assign Data31 = type ? Data_in[7:0] : mux31;
    
    always @(posedge clk)
    begin
        if (rst)
            Mem[31] <= 0;
            
        else if (write_enable)
            Mem[31] <= Data31;
        
        else
            Mem[31] <= Mem[31];
        
    end
    
    // Modulo de lectura
    wire [31:0] Data_read;
    
    assign Data_read = type ? {24'b0, Mem[Addrs]} : {Mem[Addrs], Mem[Addrs + 1], Mem[Addrs + 2], Mem[Addrs + 3]};
    
    always @(posedge clk)
    begin
    if (rst)
        Data_out <= 0;
        
    else if (!write_enable)
        Data_out <= Data_read;
    
    else
        Data_out <= Data_out;
    
    end
    
endmodule
