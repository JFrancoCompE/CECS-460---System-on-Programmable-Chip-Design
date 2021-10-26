`timescale 1ns / 1ps
//***************************************************************//
// File name: TSI.v                                              //
//                                                               //
// Created by       Jesus Franco                                 //
// Copyright © 2020 Jesus Franco on 12/08/2020 01:42:08 PM       //
//                                                               //
//                                                               //
// In submitting this file for class work at CSULB               //
// I am confirming that this is my work and the work             //
// of no one else. In submitting this code I acknowledge that    //
// plagiarism in student project work is subject to dismissal.   //
// from the class                                                //
// Dependencies:                                                 //
//***************************************************************//

module TSI(
    input       clk_I,
    input       reset_I,
    input [3:0] baud_value_I,
    input       EIGHT_I, PEN_I, OHEL_I,
    input       RX_I,
    input       TX_I,
    input [15:0] LEDs_I,
    
    output       clk_O,
    output       reset_O,
    output [3:0] baud_value_O,
    output       EIGHT_O, PEN_O, OHEL_O,
    output       RX_O,
    output       TX_O,
    output [15:0] LEDs_O
    );

    BUFG clk( .I(clk_I),
              .O(clk_O)
              );
                   
    IBUF reset( .I(reset_I),
                .O(reset_O)
                );
                     
    IBUF baud_value[3:0]( .I(baud_value_I),
                          .O(baud_value_O)
                          );
                               
    IBUF EIGHT( .I(EIGHT_I),
                .O(EIGHT_O)
                 );
   
    IBUF PEN( .I(PEN_I),
              .O(PEN_O)
              ); 
                            
    IBUF OHEL( .I(OHEL_I),
               .O(OHEL_O)
               );
                    
    IBUF RX( .I(RX_I),
             .O(RX_O)
             );
                                    
    OBUF TX( .I(TX_I),
             .O(TX_O)
             );   
             
    OBUF LEDs[15:0]( .I(LEDs_I),
                     .O(LEDs_O)
                     );                  
                          
endmodule
