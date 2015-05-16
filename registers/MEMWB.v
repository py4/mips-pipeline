`timescale 1ns/1ns
module MEMWB(

input clk, input[7:0] in_read_data, input[7:0] in_alu_result, input[2:0] in_reg_write,
output reg[7:0] out_read_data, output reg[7:0] out_alu_result, output reg[2:0] out_reg_write,

input in_WB_mem_or_alu, in_WB_reg_write_signal,
output reg out_WB_mem_or_alu, out_WB_reg_write_signal
);

  reg[7:0] read_data; reg[7:0] alu_result; reg[2:0] reg_write;  
  reg WB_mem_or_alu, WB_reg_write_signal;

  always @(posedge clk) begin
    out_read_data = read_data;
    out_alu_result = alu_result;
    out_reg_write = reg_write;
  
    read_data = in_read_data;
    alu_result = in_alu_result;
    reg_write = in_reg_write;

    out_WB_mem_or_alu = WB_mem_or_alu;
    out_WB_reg_write_signal = WB_reg_write_signal;
    WB_mem_or_alu = in_WB_mem_or_alu;
    WB_reg_write_signal = in_WB_reg_write_signal;  
  end

endmodule
