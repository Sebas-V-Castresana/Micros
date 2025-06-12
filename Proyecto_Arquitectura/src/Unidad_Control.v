`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2025 08:41:07 PM
// Design Name: 
// Module Name: Unidad_Control
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


module Unidad_Control(
input clk, rst,
input [31:0] inst, 
output AluControl, InstW, MemW, RegW, PCW, AluSrcB, stype, ltype, ImnSrc, ImmType,
output [1:0] AluSrcA, ResultSrc
    );
    
    parameter Fetch = 4'd0;
    parameter Decode = 4'd1;
    parameter Immediate = 4'd2;
    parameter Utype = 4'd3;
    parameter Store = 4'd4;
    parameter Load = 4'd5;
    parameter AluWB = 4'd6;
    parameter MemAddrs = 4'd7;
    parameter MemWB = 4'd8;
    
    /* Se tienen 4 posibles ops: LOAD, STORE, IMM, REG.
    Se acceden utilizando el opcode (inst[6:0])
    Para IMM: OPCODE = 0010011
    Para LOAD: OPCODE = 0000011
    Para STORE: OPCODE = 0100011
    Para UTYPE: OPCODE = 0110111*/
    
    reg [3:0] State;
    wire [3:0] Next;
    reg [1:0] x;
    wire [6:0] Opcode;
    
    assign Opcode = inst[6:0];
    
    // Mux para escoger la entrada x de la FSM
    always @*
        case(State)
        Decode: x <= {~Opcode[4], Opcode[2]};
        MemAddrs: x <= {1'b0, Opcode[5]}; 
        default: x <= 2'b0;
        endcase
    
    // Logica Secuencial de Memoria
    always @(posedge clk)
    begin
        if (rst)
            State <= 0;
            
        else
            State <= Next;
    end
    
    // Logica Estado Siguiente
    UC_ES LCES(State, x, Next);
    
    // Logica Salidas (Flags)
    assign AluControl = (State == Immediate) & (&inst[14:12]); // 0 -> Suma, 1 -> And
    assign PCW = State == Fetch;
    assign InstW = State == Fetch;
    assign RegW = (State == AluWB) | State[3];
    assign MemW = State == Store;
    assign AluSrcB = ~State[3]&~State[2]&~State[1];
    assign AluSrcA[1] = State == Utype;
    assign AluSrcA[0] = ~State[3]&~State[2]&~State[1];
    assign ResultSrc[0] = State == MemWB;
    assign ResultSrc[1] = ~State[3]&~State[2]&~State[1];
    assign ltype = inst[14] & (State == Load); // 0 -> lw, 1 -> lbu
    assign stype = ~inst[13] & (State == Store); // 0 -> sw, 1 -> sb
    assign  ImnSrc = State == Utype;
    assign ImmType = Opcode[5]&~Opcode[4]; // Para saber que inmediato usar
    
    
endmodule
