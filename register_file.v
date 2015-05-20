`timescale 1ns/1ns
module RegisterFile(input rst, input[2:0] reg_read_1, input [2:0] reg_read_2, input [2:0] reg_write, input reg_write_signal, clk, input[7:0] in_data, output reg [7:0] out_data_1, output reg [7:0] out_data_2);
  
  reg[7:0] registers[7:0];
  always @(posedge clk) begin
    if(reg_write_signal & clk) begin
      registers[reg_write] <= in_data;
    end
  end
  
  initial begin
    out_data_1 = registers[reg_read_1];
    out_data_2 = registers[reg_read_2];
    registers[0] = 0; //$R0
  end
  
  always @(reg_read_1, reg_read_2, registers[reg_read_1], registers[reg_read_2]) begin
    out_data_1 = registers[reg_read_1];
    out_data_2 = registers[reg_read_2];
    registers[0] = 0; //$R0
  end
  
  integer i;
  always @(clk) begin
    for(i = 0; i < 8; i = i + 1) begin: loop
      $display("register[%d]:  %b", i, registers[i]);
    end
  end

  initial begin
    for(i = 0; i < 8; i = i + 1) begin: loop2
      $dumpvars(0, registers[i]);
    end
  end
  
  
endmodule
