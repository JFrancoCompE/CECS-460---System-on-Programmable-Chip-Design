`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2020 03:51:38 PM
// Design Name: 
// Module Name: mux_4to1
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


module mux_4to1(
    input clk, reset,
    input sel,
    input btu,
    output btu,
    output done
    );
    reg D1, D2;
    reg Q1, Q2;
    
    assign done = (D2 == 4'd11)? 1'b1: 1'b0;
       
    // Sequential logic
    always@(posedge clk, posedge reset)
        if(reset)
            begin
                Q1 <= 1'b0; // Q <= 0
                Q2 <= 1'b0;
            end
        else
            begin
                Q1 <= D1;     // Q <= D
                Q2 <= D2;
            end
   
    always@(*)
        case ( {btu,sel} )
            2'b00  : begin D1 = 1'b0;
                           D2 = 1'b0;
                     end
            2'b01  : begin D1 = 1'b0;
                           D2 = 1'b0;
                     end
            2'b10  : begin D1 = Q1 + 1'b1;
                           D2 = Q2;
                     end
            2'b11  : begin D1 = 1'b0;
                           D2 = Q2 + 1'b1;
                     end
            default: begin D1 = 1'b0;
                           D2 = 1'b0;
                     end
        endcase
   
endmodule

