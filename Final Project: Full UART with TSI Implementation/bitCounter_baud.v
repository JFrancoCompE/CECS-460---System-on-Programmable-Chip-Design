`timescale 1ns / 1ps
//***************************************************************//
// File name: bitCounter_baud.v                                  //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 10/15/2020 01:44:00 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module bitCounter_baud(
    input clk,              // 100MHz clock
    input reset,            // asynchronous reset with synchronous de-assertion
    input doit,             // 1/2 of the select for the mux
    input [18:0] baud,
    //input [3:0] baud_value, // baud value select
    output wire btu         // 1/2 of the select for the mux
    );
reg [18:0] Q, D;            // I/O flops
//reg [18:0] baud;            // mux out register named baud

// btu logic will output '1' if counter reaches baud total value, else '0'
assign btu = (Q == baud) ? 1'b1 : 1'b0; 

// Sequential logic of a 19 bit flip flop
always@(posedge clk, posedge reset)
    if(reset)
        Q <= 19'b0;
    else
        Q <= D;

// Combo logic for the bit counter 2to1 mux    
always@(*)
    case ( {doit, btu} )
        2'b00  : D = 19'b0;
        2'b01  : D = 19'b0; 
        2'b10  : D = Q + 19'b1;
        2'b11  : D = 19'b0;
        default: D = 19'b0;
    endcase
    
endmodule
