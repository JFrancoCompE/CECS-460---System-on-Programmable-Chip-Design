`timescale 1ns / 1ps
//***************************************************************//
// File name: bitCounter.v                                       //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 10/15/2020 01:30:52 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module bitCounter(
    input clk,  // 100MHz clock 
    input reset,// asynchronous reset with synchronous de-assertion
    input doit, // 1/2 of the select for the mux
    input btu,  // 1/2 of the select for the mux
    output done // output done if counter reaches 4'd11
    );
    reg [3:0] D, Q; // 4 bit I/O flops
    
    // done logic will output '1' if counter reaches 4'd11, else '0'
    assign done = (Q == 4'b1011)? 1'b1: 1'b0;
       
    // Sequential logic
    always@(posedge clk, posedge reset)
        if(reset)
            Q <= 4'b0;
        else
            Q <= D;
    
    // Combo logic for 2to1 mux
    always@(*)
        case ( {doit, btu} )
            2'b00  : D = 1'b0;
            2'b01  : D = 1'b0; 
            2'b10  : D = Q;
            2'b11  : D = Q + 4'b1;
            default: D = 4'b0;
        endcase

endmodule
