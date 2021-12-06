`timescale 1ns / 1ps

module MCU_RX(clk,rst,Rx_ena,Rx_in,read_signal,Rx_done_flag,Rx_out
    );
    
    integer current_bit = 0;
    integer i = 0;
    parameter num_bits = 8;
    parameter idle=1'b0 , read=1'b1;
  
    input Rx_in;              //uart reciveved serial input
    input clk, rst, Rx_ena;
    input read_signal;
    
    output reg Rx_done_flag = 0;
    output reg [(num_bits-1):0] Rx_out;
    
    reg current_state, next_state;
    reg ena_read;
    reg start_flag = 1'b1;
    reg [(num_bits-1):0]output_data;
  
    
    
    always @ (posedge clk or posedge rst)    //reset or next state condition
           begin 
              if (rst==1'b1)
                           current_state <= idle;
                 else 
                           current_state <= next_state;
           end
        
    always @ (Rx_in or current_state or Rx_done_flag or Rx_ena)   //where to go for each state
       begin
          case (current_state)
                idle: if (!Rx_in & Rx_ena)   next_state <= read;
                      else                   next_state <= idle;
                read: if (!Rx_done_flag)     next_state <= read;
                      else                   next_state <= idle;
                default                      next_state <= idle;
          endcase
       end  
        
      always @ (current_state or Rx_done_flag)       //what to do in each state
       begin
          case (current_state)
                idle: ena_read <= 1'b0;
                read: ena_read <= 1'b1;
                default ena_read <= 1'b0;                 
          endcase
       end
      
    always @ (posedge read_signal)
        begin 
            if (ena_read == 1'b1) 
              begin
                 Rx_done_flag <= 1'b0;
                 i<=i+1;
            
                    if (start_flag & i==16/2)
                     begin 
                      i<=0;
                      start_flag<=1'b0;
                     end
           
                     else if ((i==16) & (start_flag==1'b0) & (current_bit<num_bits))
                      begin 
                       current_bit<=current_bit+1;
                       i<=0;
                       output_data<={Rx_in,output_data[7:1]};      // start bit is always low and end bit is always high
                      end
                   
                     else if ((i==16) & (Rx_in==1'b1) & (current_bit==num_bits))
                      begin 
                        current_bit<=0;
                        i<=0;
                        start_flag<=1'b0;
                        Rx_done_flag<= 1'b1;
                      end
              end
          end
          
     always @ (posedge(clk))
          begin 
            Rx_out <= output_data;
          end 
          
endmodule
