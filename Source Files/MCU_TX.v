`timescale 1ns / 1ps

module MCU_TX(clk,rst,Tx_ena,Tx_in,write_signal,Tx_done_flag,Tx_out
    );
    
    integer current_bit = 0;
    integer i = 0;
    
    parameter num_bits = 8;
    parameter idle=1'b0 , write=1'b1;
  
    input [(num_bits-1):0] Tx_in;
    input clk, rst, Tx_ena;          //tx recive 8 bit and transmit 1 bit at the time
    input write_signal;
    
    output reg Tx_done_flag = 0;
    output reg Tx_out;
    
    reg current_state, next_state;
    reg ena_write;
    reg start_flag = 1'b1;
    reg [(num_bits+1):0]output_data;
  
    
    
    always @ (posedge clk or posedge rst)    //reset or next state condition
           begin 
              if (rst==1'b1)
                           current_state  <= idle;
                 else 
                           current_state  <= next_state;
           end
        
    always @ (Tx_in or current_state or Tx_done_flag or Tx_ena)   //where to go for each state
       begin
          case (current_state)
                idle: if (Tx_ena)          next_state = write;
                      else                 next_state = idle;
                write: if (!Tx_done_flag)     next_state = write;
                      else                 next_state = idle;
                default                    next_state = idle;
          endcase
       end  
        
      always @ (current_state or Tx_done_flag)       //what to do in each state
       begin
          case (current_state)
                idle: ena_write     <= 1'b0;     // 10bit x 16    //tx [0][00000011][1]    
                write: ena_write    <= 1'b1;
                default ena_write   <= 1'b0;                 
          endcase
       end
      
    always @ (posedge write_signal)
        begin 
          //output_data<={1'b0,Tx_in,1'b1};
            if (ena_write == 1'b1)   
              begin
                 Tx_done_flag      <= 1'b0;
                 i              <=i+1;
                     
                     if ((Tx_done_flag==1'b0) & (start_flag==1'b1)) 
                      begin
                       output_data         <={1'b1,Tx_in[7:0],1'b0};   
                       //Tx_out              <=1'b0;
                       start_flag          <=1'b0;
                      end
                       
                     else if ((i==16) & (start_flag==1'b0) & (current_bit<(num_bits+1)))    //start flag for initial 
                      begin
                       i                   <=0;
                       current_bit         <=current_bit+1;  
                      // Tx_out                         <=output_data[0];
                       output_data         <={1'b0,output_data[9:1]};                     
                            // start bit is always low and end bit is always high
                      end
                   
                     else if ((i==16) & (current_bit==(num_bits+1)))
                      begin 
                        i                  <=0;
                        current_bit        <=0;
                        //Tx_out             <=1'b1;
                        Tx_done_flag          <=1'b1; 
                      end
              end
          end
          
     always @ (posedge(clk))
          begin 
            Tx_out                         <=output_data[0];
          end 
          
endmodule