// Code your testbench here
// or browse Examples
module tb_top(clk,rst,ld,updn,data,rd_data);
  
  output reg clk,rst;
  output reg ld,updn;
  output reg [3:0] data; 
  input wire [3:0]rd_data;
  
  reg [1:0] scenario;
  reg [7:0] num_rpt;
  reg [3:0] load_data;
  
  counter cnt(.clk(clk),
              .rst(rst),
              .data(data),
              .updown(updn),
              .load(ld),
              .data_out(rd_data)
             );
 
  // Initial rest 
  initial 
    begin
      clk  = 1'b0;
      rst  = 1'b0;
      ld   = 1'b0;
      updn = 1'b0;
      data = 4'd0; 
    end
  
  //Clock generation logic
  always 
    begin
      #10 clk = ~clk;
    end
  
  // Reset generation logic
  initial 
    begin
      @(posedge clk);
      rst = 1;
      @(posedge clk);
      rst = 0;
    end  
  
  task generator();
    scenario = $urandom_range(0,3);
    num_rpt  = $urandom_range(0,15);
    if (scenario == 2 || scenario == 3) 
      begin
        load_data = 'h4;//$urandom();
      end
    $display ($time," GEN:: scenario %0d num_rpt %0d load_data %0d",scenario,num_rpt,load_data);
    
  endtask
  
  
  task driver();
    @(posedge clk);
   // $display(" Inside driver %0d",scenario);
    case(scenario) 
    0: begin
       updn = 1'b1;
       repeat (num_rpt) 
        begin  
         @(posedge clk); 
          $display($time," DRV:: data_out %0h rst %0d updn %0d ld 0d",rd_data,rst,updn,ld);  
        end    
       end     
    1: begin
       updn = 1'b0;
       repeat (num_rpt) 
        begin  
         @(posedge clk); 
          $display($time," DRV:: data_out %0h rst %0d updn %0d ld %0d",rd_data,rst,updn,ld);  
        end  
       end
    2: begin
       	ld   = 1'b1;
        updn = 1'b1;
       	data = load_data;
        @(posedge clk);
       	ld   = 1'b0;
        repeat (num_rpt) 
        begin  
         @(posedge clk); 
          $display($time," DRV:: data_out %0h rst %0d updn %0d ld %0d",rd_data,rst,updn,ld);  
        end 
       end
    3: begin
        updn = 1'b0;
       	ld   = 1'b1;
       	data = load_data;
        @(posedge clk);
       	ld   = 1'b0;
        repeat (num_rpt) 
        begin  
         @(posedge clk); 
          $display($time," DRV:: data_out %0h rst %0d updn %0d ld %0d",rd_data,rst,updn,ld);  
        end     

       end
    endcase
  endtask

  task monitor();
//    forever 
//      begin

    $monitor($time," Monitor:: data_out %0h updn %0d ld %0d",rd_data,updn,ld);  
//                @(posedge clk);
//      end
      
  endtask
  
  task chk();

    reg[3:0] init_data;
    reg[3:0] final_data;
    reg[3:0] curr_data;

    if ($isunknown(rd_data)) begin
      $error(" Error data is x ");
      $finish(2);
    end
    repeat(1)    @(posedge clk);
       init_data = rd_data;

    $display ($time," init_data %h",init_data);
    if (scenario == 0) begin
      final_data = init_data + num_rpt;
             curr_data = rd_data;	
      $display ($time," expected_data %h",final_data);
    end
    else if (scenario == 1) begin
      final_data = init_data - num_rpt;
             curr_data = rd_data;	
      $display ($time," expected_data %h",final_data);      
    end
    else if (scenario == 2) begin
      final_data = load_data + num_rpt;
      curr_data = load_data;	
      @(posedge clk);
      $display ($time," expected_data %h",final_data);  
    end
    else if (scenario == 3) begin
      final_data = load_data - num_rpt;
      curr_data = load_data;	
      @(posedge clk);
      $display ($time," expected_data %h",final_data);  
    end
    
    repeat (num_rpt) begin
      @(posedge clk);
      if (scenario == 0 || scenario == 2)begin
        curr_data=curr_data+1;
        if(curr_data!=rd_data) 
          $error (" ERROR! Expected value is %h actual value %h",curr_data,rd_data);
      end
      else begin 
        curr_data=curr_data-1;
         if(curr_data!=rd_data) 
           $error (" ERROR! Expected value is %h actual value %h",curr_data,rd_data);
      end
      $display ($time," Final val %h rd_data %h curr_val %h",final_data,rd_data,curr_data);
    end
    
    if (final_data != rd_data) 
      begin
        $error (" ERROR! Expected value is %h actual value %h",final_data,rd_data);
      end
  endtask
  
  
  always @(rd_data) 
    begin
      $display ($time," rd_data %h", rd_data);
    end
  
  task run();
    @(negedge rst);
     $display ($time," Reset done");//   -- Try removing wait statement ? what happens 

    fork
     generator();
     driver();
     monitor();
     chk();
    join
    $finish(2);
  endtask
  
  initial 
    begin
      run();
    end


    initial 
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end 
  
  
endmodule