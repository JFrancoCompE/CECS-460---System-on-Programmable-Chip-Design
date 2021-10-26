`timescale 1ns / 1ps
//***************************************************************//
// File name: RX_Engine.v                                        //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 11/09/2020 01:50:55 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module RX_Engine(
    input clk,      // 100MHz clock
    input reset,    // Asynchronous reset with synchronous de-assertion
    input RX,       // 1 bit recieved data
    input EIGHT,    // Eight bit enable
    input PEN,      // Parity enable
    input OHEL,     // Even/Odd enable
    input [18:0] K, // Baud value
    input READS0,   // Clear
    output [7:0] UART_RDATA, // 8 bit UART received data
    output RXRDY,   // RX ready flag
    output PERR,    // Parity error flag
    output FERR,    // Framing error flag
    output OVF      // Overflow error flag
    );
    
    reg [1:0] ps, ns;   // present state and next state
    reg START;      // START bit
    reg DOIT;       // DOIT for the DOIT counter
    
//////////////////////////////////////////////////// FSM    
    always@(posedge clk, posedge reset)
        if(reset) ps <= 2'b0;
        else      ps <= ns;
        
    always@(*)
        case(ps)
            2'b00:
                begin
                    START = 0;
                    DOIT = 0;
                    if(RX)
                        ns <= 2'b00;
                    else if(~RX)
                        ns <= 2'b01;
                end
            2'b01:
                begin
                    START = 1;
                    DOIT = 1;
                    if(~RX & ~BTU)
                        ns <= 2'b01;
                    else if(~RX & BTU)
                        ns <= 2'b10;
                    else if(RX)
                        ns <= 2'b00;
                end
            2'b10:
                begin
                    START = 0;
                    DOIT = 1;
                    if(~DONE)
                        ns <= 2'b10;
                    else if(DONE)
                        ns <= 2'b00;
                end
                    
            default:
                begin
                    ns <= 2'b00;
                    START = 0;
                    DOIT = 0;
                end
       endcase

/////////////////////////////// bit counter for DONE
    reg [3:0] bitcount_Q, bitcount_D;
    reg [3:0] D;
    
    assign DONE = (bitcount_Q == D);
    
    always@(posedge clk, posedge reset)
        if(reset) bitcount_Q <= 4'b0;
        else      bitcount_Q <= bitcount_D;

    always@(*)
        case({DOIT,BTU})
            2'b00: bitcount_D <= 4'b0;
            2'b01: bitcount_D <= 4'b0;
            2'b10: bitcount_D <= bitcount_Q;
            2'b11: bitcount_D <= bitcount_Q + 4'b1;
            default: bitcount_D <= 4'b0;
        endcase
    
    always@(*)
        case({EIGHT,PEN})
            2'b00: D <= 9;
            2'b01: D <= 10;
            2'b10: D <= 10;
            2'b11: D <= 11;
            default: D <= 9;
        endcase
    
/////////////////////////////// bit time counter for BTU
    reg [18:0] bittimecount_D, bittimecount_Q;
    reg [18:0] bittimecount;
    
    assign BTU = (bittimecount_Q == bittimecount);
    
    always@(posedge clk, posedge reset)
        if(reset) bittimecount_Q <= 19'b0;
        else      bittimecount_Q <= bittimecount_D;
    
    always@(*)
        case({DOIT,BTU})
            2'b00: bittimecount_D <= 19'b0;
            2'b01: bittimecount_D <= 19'b0;
            2'b10: bittimecount_D <= bittimecount_Q + 19'b1;
            2'b11: bittimecount_D <= 19'b0;
            default: bittimecount_D <= 19'b0;
        endcase
    
    always@(*)
        if(START) bittimecount <= K >> 1;
        else      bittimecount <= K;  
    
/////////////////////////////// SHIFT REGISTER
    wire SHIFT;
    //reg SDI; // not used
    reg [9:0] Shifter;
    
    assign SHIFT = BTU & ~START;
    
    always@(posedge clk, posedge reset)
        if(reset) Shifter <= 10'b0;     
        else if(SHIFT) Shifter <= {RX, Shifter[9:1]};
        
/////////////////////////////// RIGHT JUSTIFY
    reg [9:0] right_justify;
    
    // Will account for 8 or 7 bits outputs
    assign UART_RDATA = (EIGHT)  ? right_justify[7:0] : {1'b0, right_justify[6:0]};
    // Will account for 8 bits outputs
    //assign UART_RDATA = right_justify[7:0];
    
    always@(*)
        case({EIGHT,PEN})
            2'b00: right_justify <= {2'b11, Shifter[9:2]};
            2'b01: right_justify <= {1'b1,  Shifter[9:1]};
            2'b10: right_justify <= {1'b1,  Shifter[9:1]};
            2'b11: right_justify <= Shifter;
            default: right_justify <= 10'b0;
        endcase

/////////////////////////////// GENERATED PARITY SELECT
    reg top_mux_out;
    reg mid_mux_out;
    reg bot_mux_out;
    
    reg xor1_mux_out;
    
    wire XOR_1;
    wire XOR_2;
    
    // TOP MUX for generated parity select
    always@(*)
        if(EIGHT) top_mux_out <= right_justify[7];
        else      top_mux_out <= 1'b0;
        
    assign XOR_1 = right_justify[6:0] ^ top_mux_out;
     
    always@(*)
        if(OHEL)
            xor1_mux_out <= ~XOR_1;
        else
            xor1_mux_out <=  XOR_1;
            
    assign XOR_2 = xor1_mux_out ^ mid_mux_out;   
        
    // MID MUX for received parity select
    always@(*)
        if(EIGHT) mid_mux_out <= right_justify[8];
        else      mid_mux_out <= right_justify[7];
    // BOT MUX stop bit select
    always@(*)
        case({EIGHT,PEN})
            2'b00: bot_mux_out <= right_justify[7];
            2'b01: bot_mux_out <= right_justify[8];
            2'b10: bot_mux_out <= right_justify[8];
            2'b11: bot_mux_out <= right_justify[9];
            default: bot_mux_out <= 1'b0;
        endcase
            
/////////////////////////////// SR FFs
    //wire RXRDY;
    // SR for RXRDY
    SR_FF sr0( .clk(clk),
               .reset(reset),
               .S(DONE),
               .R(READS0),
               .Q(RXRDY)
               );
    //wire PERR;
    // SR for PERR           
    SR_FF sr1( .clk(clk),
               .reset(reset),
               .S(PEN & XOR_2 & DONE),
               .R(READS0),
               .Q(PERR)
               );               
    //wire FERR;
    // SR for FERR           
    SR_FF sr2( .clk(clk),
               .reset(reset),
               .S(DONE & ~bot_mux_out),
               .R(READS0),
               .Q(FERR)
               );      
    //wire OVF;
    // SR for FERR           
    SR_FF sr3( .clk(clk),
               .reset(reset),
               .S(DONE & RXRDY),
               .R(READS0),
               .Q(OVF)
               );             

endmodule
