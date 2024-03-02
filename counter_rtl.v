// Code your design here
module counter(clk, rst, data, updown, load, data_out);
 
 input clk, rst, load;
 input updown;
 input [3:0] data;
  
  reg [3:0] rand_num;
  
 output reg [3:0] data_out;
 always@(posedge clk)
 begin
   if(rst)
   data_out <= 4'h0;
  else if(load)
   data_out <= data;
  else
    data_out <= ((updown)?(data_out + 1'b1):(data_out -1'b1));
  end
  `ifdef BUGG_CODE
  //bug
  always@(posedge clk)
    begin
      //if(data_out==4)
        data_out='hf;
    end
  `endif
  
 
  


endmodule