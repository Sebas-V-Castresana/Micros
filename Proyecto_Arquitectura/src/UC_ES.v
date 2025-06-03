`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/01/2025 10:11:54 PM
// Design Name: 
// Module Name: UC_ES
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


module UC_ES(
input [3:0] Q,
input [1:0] x,
output [3:0] State
    );
    
    // Logica combinacional estado siguiente FSM
    
    assign State[0] = ~Q[3]&~Q[2]&~Q[1]&~Q[0] | ~Q[3]&~Q[2]&~Q[1]&(x[1] | x[0]) | Q[2]&Q[1]&Q[0]&~x[0];
    assign State[1] = ~Q[3]&~Q[2]&Q[0] | ~Q[2]&Q[1]&~Q[0];
    assign State[2] = ~Q[2]&Q[1] | ~Q[3]&Q[0]&(Q[1] | ~Q[2]&x[1]);
    assign State[3] = ~Q[3]&Q[2]&~Q[1]&Q[0];
    
endmodule
