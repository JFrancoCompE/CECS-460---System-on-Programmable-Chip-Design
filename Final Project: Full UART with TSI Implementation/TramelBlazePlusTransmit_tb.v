`timescale 1ns / 1ps
//***************************************************************//
// File name: TramelBlazePlusTransmit_tb.v                       //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 10/17/2020 01:26:55 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module TramelBlazePlusTransmit_tb;
    reg clk;
    reg reset;
    reg [3:0] baud_value;
    reg EIGHT;
    reg PEN;
    reg OHEL;
    wire TX;
    wire [15:0] LEDs;

    TramelBlazePlusTransmit tbpt( .clk(clk),
                                  .reset(reset),
                                  .baud_value(baud_value),
                                  .EIGHT(EIGHT),
                                  .PEN(PEN),
                                  .OHEL(OHEL),
                                  .TX(TX),
                                  .LEDs(LEDs)
                                  );
                      
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        baud_value = 4'b1011;
        EIGHT = 1;
        PEN = 0;
        OHEL = 0;
        
        #100;
        reset = 0;
    end
    
endmodule
