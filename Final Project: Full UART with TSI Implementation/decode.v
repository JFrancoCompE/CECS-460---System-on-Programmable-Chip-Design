`timescale 1ns / 1ps
//***************************************************************//
// File name: decode.v                                           //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 10/13/2020 02:46:50 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module decode(
    input eight,            // eighth bit enable
    input pen,              // parity enable
    input ohel,             // even/odd parity enable
    input [7:0] data,       // recieving data
    output reg [1:0] dout   // data out
    );
    
    // Combo logic for the decoder
    always@(*)
        case({eight,pen,ohel})
            3'b000: dout = 2'b11;                   // [ 1, 1 ]
            3'b001: dout = 2'b11;                   // [ 1, 1 ]
            3'b010: dout = {1'b1, ^data[6:0]};      // [ 1, even parity 6-0 ]
            3'b011: dout = {1'b1, ~^data[6:0]};     // [ 1, odd  parity 6-0 ]
            3'b100: dout = {1'b1, data[7]};         // [ 1, data7 ]
            3'b101: dout = {1'b1, data[7]};         // [ 1, data7 ]
            3'b110: dout = {^data[7:0], data[7]};   // [ even parity 7-0, data7 ]
            3'b111: dout = {~^data[7:0], data[7]};  // [ odd parity 7-0 , data7 ]
            default:dout = 2'b00;                   // [ 0, 0 ]
        endcase

endmodule
