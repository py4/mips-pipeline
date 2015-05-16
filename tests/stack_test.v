`timescale 1ns/1ns
module StackTest;
  reg push_sig = 1, pop_sig = 0, clk = 0;
  reg[11:0] push_data = 12'b0;
  wire overflow;
  wire [11:0] pop_data;

  Stack stack(push_sig, pop_sig, clk, push_data, overflow, pop_data);

  always begin
    #3 clk = ~clk;
  end
  
  always @(posedge clk) begin
    #4
    push_data = push_data + 1;
    if(push_data == 12'b000000001010) begin
      if(pop_sig == 1) $finish;
      else begin
        pop_sig = 1;
        push_sig = 0;
        push_data = 12'b0;
      end
    end
  end

  initial begin
    $dumpfile("StackTest.vcd");
    $dumpvars(0, StackTest);
  end

endmodule

