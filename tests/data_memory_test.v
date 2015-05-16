`timescale 1ns/1ns
module DataMemoryTest;
  reg[1:0] temp = 2'b01;
  
  reg[7:0] address = 8'b0;
  reg[7:0] write_data;
  reg read_write = 1;
  wire[7:0] read_data;
  reg clk = 0;
  reg[7:0] i = 8'b0;

  DataMemory mem(address, write_data, read_write, clk, read_data);
  always begin
    #20 clk = ~clk;
  end

  always @(posedge clk) begin
    #5;
    address = address + 1;
    i = i +1;
  end

  initial begin
    $dumpfile("DataMemoryTest.vcd");
    $dumpvars(0, DataMemoryTest);
  end
  
  always @(address) begin
    write_data = i;
    if(address == 8'b00001010) begin
      if(read_write == 0) #5 $finish;
      read_write = 0;
      address = 0;
    end
  end
endmodule
