`timescale 1ns / 1ps

//1/115.2kbp = 8.6805us => 8680.55 ns
//1/125MHz = 8ns
//(8680.55ns/16(parts))/8ns = 67.8 = 68

`define baud_rate 16'd68

module Top_design(
    input clk,Tx_ena,Rx_ena,rst,
    input [7:0] Tx_in, 
    output Tx_out,led0,led1,led2,led3,
    output Rx_in,
    output [7:0] Rx_out  
    );

  reg counter;
  wire read_signal;
  wire Rx_done_flag;
  wire Tx_done_flag;
  wire write_signal;
  //wire Rx_in;
  
  assign Rx_in = Tx_out; // map Tx_out to Rx_in 
  assign write_signal = read_signal; 
  // assign tick signal to read and write signal 
  // while controling the read and write process 
  // using TX_ena and Rx_ena (enable) 
 
//1st stage 
MCU_TX UUT_Tx (clk,rst,Tx_ena,Tx_in,write_signal,Tx_done_flag,Tx_out);

// 2nd stage 
MCU_RX UUT_Rx (clk,rst,Rx_ena,Rx_in,read_signal,Rx_done_flag,Rx_out);

Tick_signal UUT_Tick (clk,`baud_rate,rst,read_signal);

assign led0 = (Rx_done_flag == 1'b1) ? Rx_out[0]:1'b0;
assign led1 = (Rx_done_flag == 1'b1) ? Rx_out[1]:1'b0;
assign led2 = (Rx_done_flag == 1'b1) ? Rx_out[2]:1'b0;
assign led3 = (Rx_done_flag == 1'b1) ? Rx_out[3]:1'b0;


endmodule