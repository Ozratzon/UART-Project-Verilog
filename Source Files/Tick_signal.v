`timescale 1ns / 1ps

module Tick_signal(
    input clk,
    input [15:0] baudrate,
    input rst,
    output tick_out
    );
    reg [15:0] baudrate_reg = 0;
    
    always @(posedge (clk))
         begin 
           if (tick_out) baudrate_reg <= 16'b1;
             else baudrate_reg <= baudrate_reg + 1'b1;
             end
          
           assign tick_out = (baudrate_reg == baudrate) ? 1'b1:1'b0;    
endmodule
