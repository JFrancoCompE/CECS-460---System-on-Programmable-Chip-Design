`timescale 1ns / 1ps
//***************************************************************//
// File name: DFF.v                                              //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 10/13/2020 03:46:36 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module DFF(
    input clk,   // 100MHz clock
    input reset, // Asynchronous reset with synchronous de-assertion
    input D,     // holding value
    output reg Q // output value
    );

    // Sequential logic
    always@(posedge clk, posedge reset)
        if(reset)       // if reset
            Q <= 1'b0; // Q <= 0
        else
            Q <= D;     // Q <= D

endmodule
