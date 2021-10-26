`timescale 1ns / 1ps
//***************************************************************//
// File name: transmitEngine_tb.v                                //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 10/17/2020 01:50:05 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module transmitEngine_tb;
    reg clk;
    reg reset;
    reg write0;
    reg [7:0] out_port;
    reg [18:0] baud;
    reg EIGHT;
    reg PEN;
    reg OHEL;
    wire TXRDY;
    wire TX;
    
    transmitEngine uut( .clk(clk),
                    .reset(reset),
                    .write0(write0),
                    .out_port(out_port),
                    .baud(baud),
                    .EIGHT(EIGHT),
                    .PEN(PEN),
                    .OHEL(OHEL),
                    .TXRDY(TXRDY),
                    .TX(TX)
                    );
    
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        baud = 19'd109;
        EIGHT = 1;
        PEN = 1;
        OHEL = 1;
        out_port = 8'b00000111;
        write0 = 0;
        
        #100;
        reset = 0;
        
        #100;
        write0 = 1;
        #10;
        write0 = 0;
        
    end
    
endmodule
