`timescale 1ns / 1ps
//***************************************************************//
// File name: LoadReg_8bit.v                                     //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 10/13/2020 03:44:22 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module LoadReg_8bit(
    input clk,          // 100MHz clock
    input reset,        // Asynchronous reset with synchronous de-assertion
    input load,         // load enable for flop
    input [7:0] D,     // holding value
    output reg [7:0] Q // output value
    );

// Sequential logic
always@(posedge clk, posedge reset)
    if(reset)       // if reset
        Q <= 8'b0; // Q <= 0
    else if(load)   // else if load
        Q <= D;     // Q <= D
    else            // else
        Q <= Q;     // Q <= Q
        
endmodule
