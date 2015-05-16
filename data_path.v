`timescale 1ns/1ns
module DataPath(input rst, reg2_read_source, mem_read_write, mem_or_alu, input is_shift, input alu_src, update_z_c, reg_write_signal, stack_push, stack_pop, clk, input [1:0] pc_src, input [1:0] scode, input [2:0] acode, output zero, stack_overflow, output reg carry, output [18:0] instruction);

  reg[11:0] pc = 12'b0;  

  wire[7:0] reg_out_1, reg_out_2; wire alu_carry_out; wire[7:0] alu_result, data_memory_out; wire[11:0] stack_out;
  wire[11:0] incremented_pc;
  wire[11:0] branched_pc;

  assign incremented_pc = pc + 1;
  assign branched_pc =  idex_out_new_pc + {{4{idex_out_ins70[7]}},idex_out_ins70[7:0]};

  always @(posedge clk) begin
    if (update_z_c==1) 
      carry <= alu_carry_out;
      case(exmem_out_MEM_pc_src)
        2'b00: pc <= pc + 1;
        2'b01: pc <= ifid_out_instruction[11:0];
        2'b10: pc <= stack_out;
        2'b11: pc <= branched_pc;
      endcase
  end

  always @(reg_out_1) begin
    $display("reg_out_1:  %b", reg_out_1);
  end

  wire [11:0] ifid_out_new_pc; wire[18:0] ifid_out_instruction;
  IFID ifid(clk, incremented_pc, instruction, ifid_out_new_pc, ifid_out_instruction);

   wire[11:0] idex_out_new_pc; wire[7:0] idex_out_data_1; wire[7:0] idex_out_data_2; wire[7:0] idex_out_ins70; wire[2:0] idex_out_ins1311; wire[2:0] idex_out_ins75;
  wire idex_out_EX_is_shift, idex_out_EX_alu_src, idex_out_EX_update_z_c; wire[1:0] idex_out_EX_scode; wire[2:0] idex_out_EX_acode; wire idex_out_MEM_mem_read_write; wire[1:0] idex_out_MEM_pc_src; wire idex_out_WB_mem_or_alu, idex_out_WB_reg_write_signal;

  IDEX idex(clk, ifid_out_new_pc, reg_out_1, reg_out_2, instruction[7:0], instruction[13:11], idex_out_new_pc, idex_out_data_1, idex_out_data_2, idex_out_ins70, idex_out_ins1311,

            is_shift, alu_src, update_z_c, scode, acode, mem_read_write, pc_src, mem_or_alu, reg_write_signal,

            idex_out_EX_is_shift, idex_out_EX_alu_src, idex_out_EX_update_z_c, idex_out_EX_scode, idex_out_EX_acode, idex_out_MEM_mem_read_write, idex_out_MEM_pc_src, idex_out_WB_mem_or_alu,idex_out_WB_reg_write_signal

          );


  wire[11:0] exmem_out_new_branch_pc; wire[7:0] exmem_out_alu_result; wire [7:0] exmem_out_data_2; wire[2:0] exmem_out_reg_write; wire exmem_out_MEM_mem_read_write; wire [1:0] exmem_out_MEM_pc_src; wire exmem_out_WB_mem_or_alu; wire exmem_out_WB_reg_write_signal;

  EXMEM exmem(clk, branched_pc, alu_result, idex_out_data_2, idex_out_ins1311, exmem_out_new_branch_pc, exmem_out_alu_result, exmem_out_data_2, exmem_out_reg_write, idex_out_MEM_read_write, idex_out_MEM_pc_src, idex_out_WB_mem_or_alu, idex_WB_reg_write_signal, exmem_out_MEM_mem_read_write, exmem_out_MEM_pc_src,exmem_out_WB_mem_or_alu, exmem_out_WB_reg_write_signal);

  wire[7:0] memwb_out_read_data; wire[7:0] memwb_out_alu_result; wire[2:0] memwb_out_reg_write; wire memwb_out_WB_mem_or_alu; wire memwb_out_WB_reg_write_signal;
  
  MEMWB memwb(clk, data_memory_out, exmem_out_alu_result, exmem_out_reg_write, memwb_out_read_data, memwb_out_alu_result, memwb_out_reg_write, exmem_out_WB_mem_or_alu, exmem_out_WB_reg_write_signal, memwb_out_WB_mem_or_alu, memwb_out_WB_reg_write_signal);

  InstructionMemory instruction_memory(rst, pc, instruction);

  RegisterFile register_file(rst, ifid_out_instruction[10:8], reg2_read_source ? ifid_out_instruction[13:11] : ifid_out_instruction[7:5], memwb_out_reg_write, exmem_out_WB_reg_write_signal, clk, memwb_out_WB_mem_or_alu ? memwb_out_alu_result : memwb_out_read_data, reg_out_1, reg_out_2);
  
  ALU alu(rst, idex_out_data_1, (idex_out_EX_alu_src ? idex_out_ins70 : ( idex_out_EX_is_shift ? {5'b0,idex_out_ins70[7:5]} : idex_out_data_2)), carry, idex_out_EX_is_shift, idex_out_EX_update_z_c, idex_out_EX_scode, idex_out_EX_acode, alu_result, zero, alu_carry_out);

  DataMemory data_memory(rst, exmem_out_alu_result, exmem_out_data_2, exmem_out_MEM_mem_read_write, clk, data_memory_out);

  Stack stack(rst, stack_push, stack_pop, clk, pc + {11'b0,1'b1}, stack_overflow, stack_out);

endmodule
