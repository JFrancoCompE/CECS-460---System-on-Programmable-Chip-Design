`timescale 1ns / 1ps
//***************************************************************//
// File name: RX_Engine_tb.v                                     //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 11/10/2020 08:08:31 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module RX_Engine_tb;
	reg clk;
	reg reset;
	reg READS0;
	reg RX;
	reg EIGHT;
	reg PEN;
	reg OHEL;
	reg [18:0] K;

	wire [7:0] UART_RDATA;
	wire RXRDY;
	wire PERR;
	wire FERR;
	wire OVF;

	RX_Engine uut (
		.clk(clk),
		.reset(reset),
		.READS0(READS0),
		.RX(RX),
		.EIGHT(EIGHT),
		.PEN(PEN),
		.OHEL(OHEL),
		.K(K),
		.UART_RDATA(UART_RDATA),
		.RXRDY(RXRDY),
		.PERR(PERR),
		.FERR(FERR),
		.OVF(OVF)
	);
	
	

   always #5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		READS0 = 0;
		RX = 1;
		EIGHT = 1;
		PEN = 0;
		OHEL = 0;
		K = 109 - 1;
		
		#100;
        reset = 0;
        RX = 0; 
        
        // START
        wait (uut.BTU == 1);
        wait (uut.BTU == 0);
        RX = 1'b0;
    
        // 1
        wait (uut.BTU == 1);
        wait (uut.BTU == 0);
        RX = 1'b1;
        
        // 10
        wait (uut.BTU == 1);
        wait (uut.BTU == 0);
        RX = 1'b0;
    
        // 101
        wait (uut.BTU == 1);
        wait (uut.BTU == 0);
        RX = 1'b1;
    
        // 1010_
        wait (uut.BTU == 1);
        wait (uut.BTU == 0);
        RX = 1'b0;
    
        // 1010_1
        wait (uut.BTU == 1);
        wait (uut.BTU == 0);
        RX = 1'b1;
    
        // 1010_10
        wait (uut.BTU == 1);
        wait (uut.BTU == 0);
        RX = 1'b0;
    
        // 1010_101
        wait (uut.BTU == 1);
        wait (uut.BTU == 0);
        RX = 1'b1;
    
        // 1010_1010
        wait (uut.BTU == 1);
        wait (uut.BTU == 0);
        RX = 1'b0;
    
        // STOP bit
        wait (uut.BTU == 1);
        wait (uut.BTU == 0);
        RX = 1'b1;
    
        wait (uut.DONE == 1);  //wait until byte is done being received.
        #400;
        $stop;
    
        end
endmodule