`timescale 1ns/1ns
module DataPath(input rst, reg2_read_source, mem_read_write, mem_or_alu, input is_shift, input alu_src, update_z_c, reg_write_signal, stack_push, stack_pop, clk, input [1:0] pc_src, input [1:0] scode, input [2:0] acode, output zero, stack_overflow, output reg carry, output [18:0] instruction);

  reg[11:0] pc = 12'b0;
  wire[7:0] reg_out_1, reg_out_2;
  wire alu_carry_out;
  wire[7:0] alu_result, data_memory_out;
  wire[11:0] stack_out;
  reg x; 
  
  always @(posedge clk) begin
    if (update_z_c==1) 
      carry <= alu_carry_out;
      case(pc_src)
        2'b00: pc <= pc + 1;
        2'b01: pc <= instruction[11:0];
        2'b10: pc <= stack_out;
        2'b11: pc <= pc + 1 + {{4{instruction[7]}},instruction[7:0]};
      endcase
  end

  always @(reg_out_1) begin
    $display("reg_out_1:  %b", reg_out_1);
  end

  InstructionMemory instruction_memory(rst, pc, instruction);

  RegisterFile register_file(rst, instruction[10:8], reg2_read_source ? instruction[13:11] : instruction[7:5], instruction[13:11],reg_write_signal, clk, mem_or_alu ? alu_result : data_memory_out, reg_out_1, reg_out_2);
  
  ALU alu(rst, reg_out_1, (alu_src ? instruction[7:0] : ( is_shift ? {5'b0,instruction[7:5]} : reg_out_2)), carry, is_shift, update_z_c, scode, acode, alu_result, zero, alu_carry_out);

  DataMemory data_memory(rst, alu_result, reg_out_2, mem_read_write, clk, data_memory_out);

  Stack stack(rst, stack_push, stack_pop, clk, pc + {11'b0,1'b1}, stack_overflow, stack_out);

endmodule
