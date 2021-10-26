`timescale 1ns / 1ps
//****************************************************************//
// File name: UART_tf.v
//
// Created by       Rosswell Tiongco on <12/19/18>.
// Copyright © 2018 Rosswell Tiongco. All rights reserved.
//
//
// In submitting this file for class work at CSULB
// I am confirming that this is my work and the work
// of no one else. In submitting this code I acknowledge that
// plagiarism in student project work is subject to dismissal
// from the class.
//****************************************************************//

module UART_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [3:0] baud_value;
	reg EIGHT;
	reg PEN;
	reg OHEL;
	reg RX;

	// Outputs
	wire TX;
	wire [15:0] LEDs;

	// Instantiate the Unit Under Test (UUT)
	UART uut (
		.clk(clk),
		.reset(reset),
		.baud_value(baud_value),
		.EIGHT(EIGHT),
		.PEN(PEN),
		.OHEL(OHEL),
		.RX(RX),
		.TX(TX),
		.LEDs(LEDs)
	);


    
   always #5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
        baud_value = 4'b1011;
		RX = 1;
		EIGHT = 1;
		PEN = 0;
		OHEL = 0;


		// Wait 100 ns for global reset to finish
		#100;

      reset = 0;
      RX = 0; //start

      //Receive 0xAE

//      //d0
//      wait (uut.rx.BTU == 1);
//      wait (uut.rx.BTU == 0);
//      RX = 1'b0;

//      //d1
//      wait (uut.rx.BTU == 1);
//      wait (uut.rx.BTU == 0);
//      RX = 1'b1;

//      //d2
//      wait (uut.rx.BTU == 1);
//      wait (uut.rx.BTU == 0);
//      RX = 1'b1;

//      //d3
//      wait (uut.rx.BTU == 1);
//      wait (uut.rx.BTU == 0);
//      RX = 1'b1;

//      //d4
//      wait (uut.rx.BTU == 1);
//      wait (uut.rx.BTU == 0);
//      RX = 1'b0;

//      //d5
//      wait (uut.rx.BTU == 1);
//      wait (uut.rx.BTU == 0);
//      RX = 1'b1;

//      //d6
//      wait (uut.rx.BTU == 1);
//      wait (uut.rx.BTU == 0);
//      RX = 1'b0;

//      //d7
//      wait (uut.rx.BTU == 1);
//      wait (uut.rx.BTU == 0);
//      RX = 1'b1;

//      //Parity 10101110 *1*
//      wait (uut.rx.BTU == 1);
//      wait (uut.rx.BTU == 0);
//      RX = 1'b0;

//      //Stop
//      wait (uut.rx.BTU == 1);
//      wait (uut.rx.BTU == 0);
//      RX = 1'b1;

//      wait (uut.rx.DONE == 1);  //wait until byte is done being received.
//      #400;
//      $stop;

//		// Add stimulus here

	end

endmodule