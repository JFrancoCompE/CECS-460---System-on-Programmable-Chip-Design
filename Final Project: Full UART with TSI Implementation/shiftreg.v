`timescale 1ns / 1ps
//***************************************************************//
// File name: shiftreg.v                                         //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 10/13/2020 02:26:05 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module shiftreg(
    input       clk,    // 100MHz clock
    input       reset,  // asynchronous reset with synchronous de-assertion
    input       ld,     // load enable
    input       sh,     // shift enable
    input       bit9,   // bit 9
    input       bit10,  // bit 10
    input [6:0] din,    // data in
    output wire tx      // output transmitted 1 bit data
    );
    reg   [10:0] Shifter; // shifting register
    
    ///////////////
    // define transmit out
    ///////////////
    assign tx = Shifter[0]; // tx will be output based on Shifter[0]
    
    ///////////////
    // define shift register
    ///////////////
    // Sequential logic for the shift register
    always@(posedge clk, posedge reset)
        if(reset) Shifter <= 11'h7FF;                        else   
        if(ld)    Shifter <= {bit10, bit9, din[6:0], 2'b01}; else
        if(sh)    Shifter <= {1'b1, Shifter[10:1]};          else
                  Shifter <= Shifter;
endmodule