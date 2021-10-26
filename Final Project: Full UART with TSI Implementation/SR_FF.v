`timescale 1ns / 1ps
//***************************************************************//
// File name: SR_FF.v                                            //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 09/23/2020 01:01:30 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module SR_FF(
    input clk,      // 100MHz clock
    input reset,    // Asynchronous reset with synchronous de-assertion    
    input S,        // SET input for the SR flop
    input R,        // RESET input for the SR flop
    output reg Q    // Output for SR flip flop
    );
    
    // Sequential logic
    always@(posedge clk, posedge reset)
        if (reset)      // If reset
            Q <= 1'b0;  // Q <= 0
        else if (S)     // else if S
            Q <= 1'b1;  // Q <= 1
        else if (R)     // else if R
            Q <= 1'b0;  // R <= 0
        else            // else
            Q <= Q;     // Q <= Q
    
endmodule
