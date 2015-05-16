`timescale 1ns/1ns
module EXMEM(

input clk, input[11:0] in_new_branch_pc, input in_zero, input[7:0] in_alu_result, input[7:0] in_data_2, input[2:0] in_reg_write,
output reg[11:0] out_new_branch_pc, output reg out_zero, output reg[7:0] out_alu_result, output reg[7:0] out_data_2, output reg[2:0] out_reg_write,

input in_MEM_mem_read_write, input[1:0] in_MEM_pc_src,
input in_WB_mem_or_alu, in_WB_reg_write_signal,
output reg out_MEM_mem_read_write, output reg[1:0] out_MEM_pc_src,
output reg out_WB_mem_or_alu, out_WB_reg_write_signal


);

  reg[11:0] new_branch_pc; reg zero; reg[7:0] alu_result; reg[7:0] data_2;
  reg[2:0] reg_write;
  
  reg MEM_mem_read_write; reg[1:0] MEM_pc_src;
  reg WB_mem_or_alu, WB_reg_write_signal;


  always @(posedge clk) begin
    out_new_branch_pc = new_branch_pc;
    out_zero = zero;
    out_alu_result = alu_result;
    out_data_2 = data_2;
    out_reg_write = reg_write;
    
    new_branch_pc = in_new_branch_pc;
    zero = in_zero;
    alu_result = in_alu_result;
    data_2 = in_data_2;
    reg_write = in_reg_write;
  
    out_MEM_mem_read_write = MEM_mem_read_write;
    out_MEM_pc_src = MEM_pc_src;
    out_WB_mem_or_alu = WB_mem_or_alu;
    out_WB_reg_write_signal = WB_reg_write_signal;

    MEM_mem_read_write = in_MEM_mem_read_write;
    MEM_pc_src = in_MEM_pc_src;
    WB_mem_or_alu = in_WB_mem_or_alu;
    WB_reg_write_signal = in_WB_reg_write_signal;  
  end
  

endmodule
