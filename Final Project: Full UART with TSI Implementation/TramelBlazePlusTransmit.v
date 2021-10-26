`timescale 1ns / 1ps
//***************************************************************//
// File name: TramelBlazePlusTransmit.v                          //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 10/15/2020 07:49:34 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module TramelBlazePlusTransmit(
    input clk,              // 100Mhz clock
    input reset,            // asynchronous reset
    input [3:0] baud_value, // baud select value
    input EIGHT,            // eighth enabled bit
    input PEN,              // parity enable
    input OHEL,             // even/odd parity enable
    output TX,              // 1 bit transmitted data signal
    output reg [15:0] LEDs  // on board LEDs
    );
    wire resetNew;             // asynchronous reset with synchronous de-assertion
    wire ped_out;              // positive edge detect wire
    wire txrdy_wire;           // txrdy wire from transmitEngine.v
    wire [15:0] PORT_ID_wire;  // Port_ID wire from tramelblaze_top.v
    wire WRITE_STROBE_wire;    // Write_Strobe wire from tramelblaze_top.v
    wire [15:0] out_port_wire; // out_port wire for outputting data from .coe file from tramelblaze_top
    wire [15:0] IN_PORT_wire;  // IN_PORT_wire from tramelblaze_top
    wire INTERRUPT_ACK_wire;   // INTERRUPT_ACK wire from tramelblaze_top.v
    wire INTERRUPT_wire;       // INTERRUPT_wire from tramelblaze_top.v
    wire READ_STROBE_wire;     // READ_STROBE wire from tramelblaze_top.v
    wire load;                 // load wire for CSULB CSULB CECS 460 address decoder
    wire load_LEDs;            // load wire for LED address decoder
    
    wire [18:0] K;
    
    // assign load for transmitted ASCII letters
    assign load = ( (PORT_ID_wire == 16'h0000) && WRITE_STROBE_wire) ? 1'b1: 1'b0;
    
    // assign load for transmitted LEDs
    assign load_LEDs =( (PORT_ID_wire == 16'h0002) && WRITE_STROBE_wire) ? 1'b1: 1'b0;
    
    // Instantiation for AISO
    // Inputs: clk, reset
    // Outputs: resetNew
    AISO aiso( .clk(clk),
               .reset(reset),
               .resetNew(resetNew)
               );
    
    // Instantiation for the postive edge detect
    // Inputs: clk, reset, in
    // Outputs: ped           
    ped2 ped( .clk(clk),
              .reset(resetNew),
              .in(txrdy_wire),
              .ped(ped_out)
              );
    // Instantiation for the SR Flip Flop
    // Inputs: clk, reset, S, R
    // Outputs: Q          
    SR_FF sr( .clk(clk),
              .reset(resetNew),
              .S(ped_out),
              .R(INTERRUPT_ACK_wire),
              .Q(INTERRUPT_wire)
              );
     
    BAUD_DECODE swag( .baud_value(baud_value),
                      .baud(K)
                      );           

    // Instantiation for transmitEngine
    // Inputs: clk, reset, write0, out_port, baud_value, EIGHT, PEN, OHEL
    // Outputs: TXRDY, TX
    transmitEngine te( .clk(clk),
                       .reset(resetNew),
                       .write0(load),
                       .out_port({8'b0,out_port_wire[7:0]}),
                       .baud(K),
                       .EIGHT(EIGHT),
                       .PEN(PEN),
                       .OHEL(OHEL),
                       .TXRDY(txrdy_wire),
                       .TX(TX)
                       );
                       
    // Instantiation for tramelblaze_top
    // Inputs: CLK, RESET, IN_PORT, INTERRUPT, INSTRUCTION
    // Outputs: OUT_PORT, PORT_ID, READ_STROBE, WRITE_STROBE, INTERRUPT_ACK, ADDRESS
    tramelblaze_top tbt( .CLK(clk),
                         .RESET(resetNew),
                         .IN_PORT(IN_PORT_wire),
                         .INTERRUPT(INTERRUPT_wire),
                         .OUT_PORT(out_port_wire),
                         .PORT_ID(PORT_ID_wire),
                         .READ_STROBE(READ_STROBE_wire),
                         .WRITE_STROBE(WRITE_STROBE_wire),
                         .INTERRUPT_ACK(INTERRUPT_ACK_wire)
                         );
    
    // sequential logic for LEDs as a form of a loading register            
    always@(posedge clk, posedge resetNew)
        if(resetNew)
            LEDs <= 16'h0001; // set LED to the LSB
        else if( load_LEDs) // load for the LEDs
            LEDs <= out_port_wire; // out put shifted LEDs
        else LEDs <= LEDs; // else, LEDs remain the same
            
endmodule
