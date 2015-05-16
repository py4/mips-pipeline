`timescale 1ns/1ns
module DataMemory(input rst, input[7:0] address, input[7:0] write_data, input read_write, clk, output reg[7:0] read_data);

  reg[7:0] data[255:0];

  always @(posedge clk) begin
    if(read_write & clk)
      data[address] <= write_data;
  end

  always @(address, read_write) begin
    if(read_write == 0) read_data = data[address];
  end

  integer i;
  initial begin
    for(i = 0; i < 6; i = i + 1) begin: loop
      $dumpvars(0, data[100+i]);
    end
  end

endmodule
