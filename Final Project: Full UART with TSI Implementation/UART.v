`timescale 1ns / 1ps
//***************************************************************//
// File name: UART.v                                             //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 11/12/2020 06:52:36 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module UART(
    input clk,              // 100MHz clock
    input reset,            // Asynchronous reset
    input [3:0] baud_value, // Baud value select
    input RX,               // 1 bit receieved data
    input EIGHT,            // Eight bits input
    input PEN,              // Parity enable input
    input OHEL,             // Even/Odd parity select input
    output TX,              // 1 bit transmitted data
    output reg [15:0] LEDs  // On board LEDs
    );
    wire resetNew;          // Asynchronous reset with synchronous de-assertion
    wire [18:0] K;          // Total baud value
    wire [7:0] UART_RDATA;  // UART received data
    wire RXRDY;             // RX ready flag
    wire FERR;              // Framing error flag
    wire OVF;               // Overflow flag
    wire [15:0] OUT_PORT_wire; // TramelBlaze OUT_PORT wire
    wire TXRDY;             // TX ready flag
    wire [15:0] PORT_ID_wire; // TramelBlaze PORT_ID wire
    wire READ_STROBE_wire;  // TramelBlaze READ_STROBE wire
    wire WRITE_STROBE_wire; // TramelBlaze WRITE_STROBE wire
    wire [15:0] IN_PORT_wire; // TramelBlaze IN_PORT wire
    wire INTERRUPT_wire;    // TramelBlaze INTERRUPT wire
    wire INTERRUPT_ACK_wire; // TramelBlaze INTERRUPT_ACK wire
    wire ped_top_out;       // Top PED output for the RXRDY
    wire ped_bot_out;       // Bottom PED output for the TXRDY
    wire UART_INT;          // UART interrupt
    
    // Combo logic for the UART_INT
    assign UART_INT = ped_top_out | ped_bot_out;
    
    // Combo logic for the UART_DS
    assign IN_PORT_wire = (PORT_ID_wire == 16'h0001) ? {3'b000, OVF, FERR, PERR, TXRDY, RXRDY} : UART_RDATA;

    // Instantiation for the SR Flip Flop
    // Inputs: clk, reset, S, R
    // Outputs: Q
    SR_FF sr_uart( .clk(clk),
                   .reset(resetNew),
                   .S(UART_INT),
                   .R(INTERRUPT_ACK_wire),
                   .Q(INTERRUPT_wire)
                   );
                   
    // Instantiation for the AISO
    // Inputs: clk, reset
    // Outputs: resetNew
    AISO aiso( .clk(clk),
               .reset(reset),
               .resetNew(resetNew)
               );
               
    // Instantiation for the BAUD DECODE
    // Inputs: baud_value
    // Outputs: baud           
    BAUD_DECODE bd( .baud_value(baud_value),
                    .baud(K)
                    );
    
    // Instantiation for the RX Engine
    // Inputs: clk, reset, RX, EIGHT, PEN, OHEL, K, READS0
    // Outputs: UART_RDATA, RXRDY, PERR, FERR, OVF
    RX_Engine rx( .clk(clk),
                  .reset(resetNew),
                  .RX(RX),
                  .EIGHT(EIGHT),
                  .PEN(EIGHT),
                  .OHEL(OHEL),
                  .K(K),
                  .READS0( (PORT_ID_wire == 16'h0000) && READ_STROBE_wire),
                  .UART_RDATA(UART_RDATA),
                  .RXRDY(RXRDY),
                  .PERR(PERR),
                  .FERR(FERR),
                  .OVF(OVF)  
                  );
                  
    // Instantiation for the TX Engine
    // Inputs: clk, reset, write0, out_port, baud, EIGHT, PEN, OHEL
    // Outputs: TXRDY, TX               
    transmitEngine tx( .clk(clk),
                       .reset(resetNew),
                       .write0( (PORT_ID_wire == 16'h0000) && WRITE_STROBE_wire),
                       .out_port( {8'b0,OUT_PORT_wire[7:0]}),
                       .baud(K),
                       .EIGHT(EIGHT),
                       .PEN(PEN),
                       .OHEL(OHEL),
                       .TXRDY(TXRDY),
                       .TX(TX)
                       );
            
    // Instantiation for the TramelBlaze
    // Inputs: CLK, RESET, IN_PORT, INTERRUPT
    // Outputs: OUT_PORT, PORT_ID, READ_STROBE, WRITE_STROBE, INTERRUPT_ACK
    tramelblaze_top tbt( .CLK(clk),
                         .RESET(resetNew),
                         .IN_PORT(IN_PORT_wire),
                         .INTERRUPT(INTERRUPT_wire),
                         .OUT_PORT(OUT_PORT_wire),
                         .PORT_ID(PORT_ID_wire),
                         .READ_STROBE(READ_STROBE_wire),
                         .WRITE_STROBE(WRITE_STROBE_wire),
                         .INTERRUPT_ACK(INTERRUPT_ACK_wire)
                         );
    
    // Instantiation for the PED for the RX engine
    // Inputs: clk, reset, in
    // Outputs: ped
    ped2 ptop( .clk(clk),
               .reset(resetNew),
               .in(RXRDY),
               .ped(ped_top_out)
               );
 
    // Instantiation for the PED for the TX engine
    // Inputs: clk, reset, in
    // Outputs: ped             
    ped2 pbot( .clk(clk),
               .reset(resetNew),
               .in(TXRDY),
               .ped(ped_bot_out)
               );
     
    // Sequential logic for the LEDs           
    always@(posedge clk, posedge resetNew)
        if (resetNew)
            LEDs <= 16'b0;
        else if (PORT_ID_wire == 16'h0001 && WRITE_STROBE_wire)
            LEDs <= OUT_PORT_wire;
endmodule