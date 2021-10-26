`timescale 1ns / 1ps
//***************************************************************//
// File name: transmitEngine.v                                   //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 11/12/2020 07:11:02 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module BAUD_DECODE(
    input [3:0] baud_value,
    output reg [18:0] baud
    );
      
    always@(*)
        case(baud_value)            // BAUD RATE VALUES
            4'b0000: baud = 333333; // 300
            4'b0001: baud = 83333;  // 1200
            4'b0010: baud = 41667;  // 2400
            4'b0011: baud = 20833;  // 4800
            4'b0100: baud = 10417;  // 9600
            4'b0101: baud = 5208;   // 19200
            4'b0110: baud = 2604;   // 38400
            4'b0111: baud = 1736;   // 57600
            4'b1000: baud = 868;    // 115200
            4'b1001: baud = 434;    // 230400
            4'b1010: baud = 217;    // 460800
            4'b1011: baud = 109;    // 92160
            default: baud = 0;      // 0
        endcase
endmodule