`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2020 11:55:41 AM
// Design Name: 
// Module Name: RX_Engine_tb_tramel
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RX_Engine_tb_tramel;

	// Inputs
	reg clk;
	reg reset;
	reg READS0;
	reg RX;
	reg EIGHT;
	reg PEN;
	reg OHEL;
	reg [18:0] K;

	// Outputs
	wire [7:0] UART_RDATA;
	wire RXRDY;
	wire PERR;
	wire FERR;
	wire OVF;

    reg [0:0] mem [0:999_999];
    integer i;
    
	// Instantiate the Unit Under Test (UUT)
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
        clk = 0;
        reset = 1;
        READS0 = 0;
        RX = 0;
        EIGHT = 1;
        PEN = 0;
        OHEL = 0;
        K = 109;
        
        $readmemb("output.txt",mem);
        #100
        reset = 0;
        
        for(i = 0; i < 1_000_000; i = i + 1);begin
            #100
            RX = mem[i];
        end
        
       // @(negedge clk) READS0 = 1;
        //@(negedge clk) READS0 = 0;
    end
    
    
endmodule
