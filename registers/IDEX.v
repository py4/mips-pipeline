`timescale 1ns/1ns
module IDEX(

input clk, input[11:0] in_new_pc, input[7:0] in_data_1, input[7:0] in_data_2, input[7:0] in_ins70, input[2:0] in_ins1311, 
output reg[11:0] out_new_pc, output reg[7:0] out_data_1, output reg[7:0] out_data_2, output reg[7:0] out_ins70, output reg[2:0] out_ins1311,

input in_EX_is_shift, in_EX_alu_src, in_EX_update_z_c, input[1:0] in_EX_scode, input[2:0] in_EX_acode,
input in_MEM_mem_read_write, input[1:0] in_MEM_pc_src,
input in_WB_mem_or_alu, in_WB_reg_write_signal,
output reg out_EX_is_shift, out_EX_alu_src, out_EX_update_z_c, output reg [1:0] out_EX_scode, output reg[2:0] out_EX_acode,
output reg out_MEM_mem_read_write, output reg[1:0] out_MEM_pc_src,
output reg out_WB_mem_or_alu, out_WB_reg_write_signal

);

  reg new_pc;
  reg[7:0] data_1;reg[7:0] data_2; reg[7:0] ins70; reg[2:0] ins1311;

reg EX_is_shift, EX_alu_src, EX_update_z_c; reg [1:0] EX_scode; reg [2:0] EX_acode;
reg MEM_mem_read_write; reg[1:0] MEM_pc_src;
reg WB_mem_or_alu, WB_reg_write_signal;




  always @(posedge clk) begin
    out_new_pc = new_pc;
    out_data_1 = data_1;
    out_data_2 = data_2;
    out_ins70 = ins70;
    out_ins1311 = ins1311;
    
    new_pc = in_new_pc;
    data_1 = in_data_1;
    data_2 = in_data_2;
    ins70 = in_ins70;
    ins1311 = in_ins1311;


    out_EX_is_shift = EX_is_shift;
    out_EX_alu_src = EX_alu_src;
    out_EX_update_z_c = EX_update_z_c;
    out_EX_scode = EX_scode;
    out_EX_acode = EX_acode;

    out_MEM_mem_read_write = MEM_mem_read_write;
    out_MEM_pc_src = MEM_pc_src;

    out_WB_mem_or_alu = WB_mem_or_alu;
    out_WB_reg_write_signal = WB_reg_write_signal;

    EX_is_shift = in_EX_is_shift;
    EX_alu_src = in_EX_alu_src;
    EX_update_z_c = in_EX_update_z_c;
    EX_scode = in_EX_scode;
    EX_acode = in_EX_acode;

    MEM_mem_read_write = in_MEM_mem_read_write;
    MEM_pc_src = in_MEM_pc_src;

    WB_mem_or_alu = in_WB_mem_or_alu;
    WB_reg_write_signal = in_WB_reg_write_signal;
  end

endmodule
