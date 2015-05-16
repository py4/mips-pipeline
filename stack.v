`timescale 1ns/1ns
module Stack(input rst, push_sig, pop_sig, clk, input[11:0] push_data, output reg overflow, output reg [11:0] pop_data);
  
  initial begin
    overflow <= 0;
  end

  reg[11:0] data[7:0];
  reg[3:0] stack_pointer = 4'b0;
  
  always @(stack_pointer) begin
    if(stack_pointer != 4'b0) begin
        pop_data = data[stack_pointer - 1];
    end 
  end
  
  always @(posedge clk) begin
  //always @(posedge push_sig) begin
    if(push_sig) begin
      if(stack_pointer == 4'b1000) begin
        overflow <= 1;
      end else begin
        data[stack_pointer] <= push_data;
        stack_pointer <= stack_pointer + 1;
      end
    end
  end
  always @(posedge clk) begin
    if(pop_sig) begin
      if(stack_pointer != 4'b0) begin
        //pop_data <= data[stack_pointer - 1];
        stack_pointer <= stack_pointer - 1;
      end
    end
  end

  integer i;
  initial begin
    for(i = 0; i < 8; i = i + 1) begin: loop2
      $dumpvars(0, data[i]);
    end
  end
  
endmodule
