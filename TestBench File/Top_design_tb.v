`timescale 1ns / 1ps
`define cp 8
`define baudrate 8680.5
`define MONITOR_STR_1 "%d: Tx_in = %b, Tx_out = %b , Rx_in=%b | Rx_out%b" 

module Top_design_tb(
    );
    reg [7:0] Tx_in;
    reg clk,Tx_ena,Rx_ena,rst;
    wire Tx_out,led0,led1,led2,led3,Rx_in;
    wire [7:0] Rx_out;
     
    Top_design UUT (clk,Tx_ena,Rx_ena,rst,Tx_in,Tx_out,led0,led1,led2,led3,Rx_in,Rx_out);
    /*module Top_design(
    input clk,Tx_ena,Rx_ena,
    input [7:0] Tx_in, 
    output Tx_out,led0,led1,led2,led3, 
    output [7:0] Rx_out  
    );*/
    
    initial begin 
    $monitor(`MONITOR_STR_1,$time, Tx_in,Tx_out,Rx_in,Rx_out);
    end
    
    initial begin 
    clk = 1'b0;
    forever begin 
         #(`cp/2);
         clk = ~clk;
    end 
    end
    
    initial begin
    rst = 1'b1; 
    #(`cp);
    rst = 1'b0; Tx_in = 8'b00000101; Tx_ena = 1'b1;  Rx_ena = 1'b1; 
    #(`baudrate);
   
     end
           
endmodule
