`timescale 1ns / 1ps
//***************************************************************//
// File name: UART_TSI_TOP.v                                     //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 12/08/2020 01:57:41 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module UART_TSI_TOP(
    input clk,              // 100MHz clock
    input reset,            // Synchronous reset
    input [3:0] baud_value, // Baud value select
    input RX,               // 1 bit receieved data
    input EIGHT,            // Eight bits input
    input PEN,              // Parity enable input
    input OHEL,             // Even/Odd parity select input
    output TX,              // 1 bit transmitted data
    output [15:0] LEDs      // On board LEDs
    );
    
    wire clk_wire;              // 100MHz clock
    wire reset_wire;            // Synchronous reset 
    wire [3:0] baud_value_wire; // Baud value select
    wire RX_wire;               // 1 bit receieved data
    wire EIGHT_wire;            // Eight bits input
    wire PEN_wire;              // Parity enable input
    wire OHEL_wire;             // Even/Odd parity select input
    wire TX_wire;               // 1 bit transmitted data
    wire [15:0] LEDs_wire;      // On board LEDs
    
    TSI tsi_instance( .clk_I(clk),
                      .reset_I(reset),
                      .baud_value_I(baud_value),
                      .EIGHT_I(EIGHT),
                      .PEN_I(PEN),
                      .OHEL_I(OHEL),
                      .RX_I(RX),
                      .TX_I(TX_wire),
                      .LEDs_I(LEDs_wire),
                       
                      .clk_O(clk_wire),
                      .reset_O(reset_wire),
                      .baud_value_O(baud_value_wire),
                      .EIGHT_O(EIGHT_wire),
                      .PEN_O(PEN_wire),
                      .OHEL_O(OHEL_wire),
                      .RX_O(RX_wire),
                      .TX_O(TX),
                      .LEDs_O(LEDs)                      
                      );
 
    UART uart_instance( .clk(clk_wire),
                        .reset(reset_wire),
                        .baud_value(baud_value_wire),
                        .EIGHT(EIGHT_wire),
                        .PEN(PEN_wire),
                        .OHEL(OHEL_wire),
                        .RX(RX_wire),
                        .TX(TX_wire),
                        .LEDs(LEDs_wire) 
                        );
endmodule
