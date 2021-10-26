`timescale 1ns / 1ps
//***************************************************************//
// File name: transmitEngine.v                                   //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 10/15/2020 03:08:28 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module transmitEngine(
    input clk,              // 100MHz clock
    input reset,            // asynchronous reset with synchronous de-assertion
    input write0,           // load from address decoders
    input [7:0] out_port,   // out_port wire to output data from .coe file
    input [18:0] baud,
    input EIGHT,            // eigth enabled bit
    input PEN,              // parity enable
    input OHEL,             // even/odd parity enable
    output TXRDY,           // TXRDY output from the SSR flop
    output TX               // TX output from the shift register
    );
    wire done;              // done wire from bit counter
    wire doit;              // doit wire for the muxes select
    wire dff_out;           // output wire from the DFF
    wire [7:0] load_out;    // output wire from the LoadReg_8bit
    wire btu;               // btu wire for the muxes select
    wire [1:0] decode_out;  // output wire from the decode

    // Instantiation for the SSR Flip Flop
    // Inputs: clk, reset, S, R
    // Outputs: Q
    SSR_FF ssr( .clk(clk),
                   .reset(reset),
                   .S(done),
                   .R(write0),
                   .Q(TXRDY)
                   );
                   
    // Instantiation for the SR Flip Flop
    // Inputs: clk, reset, S, R
    // Outputs: Q                 
    SR_FF sr( .clk(clk),
               .reset(reset),
               .S(write0),
               .R(done),
               .Q(doit)
               );
    // Instantiation for the D Flip Flop
    // Inputs: clk, reset, D
    // Outputs: Q        
    DFF df( .clk(clk),
            .reset(reset),
            .D(write0),
            .Q(dff_out)
            );
            
    // Instantiation for the bit counter with the baud select mux
    // Inputs: clk, reset, doit, baud_value
    // Outputs: btu
    bitCounter_baud bcb( .clk(clk),
                         .reset(reset),
                         .doit(doit),
                         .baud(baud),
                         .btu(btu)
                         );
    
    // Instantiation for the bit counter
    // Inputs: clk, reset, doit, btu
    // Outputs: done   
    bitCounter bc( .clk(clk),
                   .reset(reset),
                   .doit(doit),
                   .btu(btu),
                   .done(done)
                   );
              
    // Instantiation for the 8 bit loadable register
    // Inputs: clk, reset, load, D
    // Outputs: Q
    LoadReg_8bit ld8( .clk(clk),
                     .reset(reset),
                     .load(write0),
                     .D(out_port),
                     .Q(load_out)
                     );
    
    // Instantiation for the decoder
    // Inputs: clk, reset, eight, pen, ohel, data
    // Outputs: dout
    decode dc( .eight(EIGHT),
               .pen(PEN),
               .ohel(OHEL),
               .data(load_out),
               .dout(decode_out)
               );
    // Instantiation for the shift register
    // Inputs: clk, reset, ld, sh, bit9, bit10, din
    // Outputs: tx
    shiftreg shr( .clk(clk),
                 .reset(reset),
                 .ld(dff_out),
                 .sh(btu),
                 .bit9(decode_out[0]),
                 .bit10(decode_out[1]),
                 .din(load_out[6:0]),
                 .tx(TX)
                 );

endmodule
