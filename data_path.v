`timescale 1ns/1ns
module DataPath(input rst, reg2_read_source, mem_read, mem_write, mem_or_alu, input is_shift, input alu_src, update_z_c, reg_write_signal, stack_push, stack_pop, clk, input [1:0] pc_src, input [1:0] scode, input [2:0] acode, output zero, stack_overflow, output reg carry, output is_halt, output [18:0] IF_inst);

  reg[11:0] pc = 12'b0;  

  wire[7:0] reg_out_1, reg_out_2; wire alu_carry_out; wire[7:0] alu_result, data_memory_out; wire[11:0] stack_out;
  wire[11:0] incremented_pc;
  wire[11:0] branched_pc;

  wire[18:0] instruction;

  assign incremented_pc = pc + 1;
  assign branched_pc = ID_pc + {{4{ID_inst[7]}},ID_inst[7:0]}; 
  assign is_halt = (MEM_inst == 19'b1111111111111111111);
  always @(posedge clk) begin
    if(is_stall == 1'b0) begin
      if (ID_update_z_c==1)  // should update_z_c be inside or outside of is_stall?
        carry <= alu_carry_out;
      case(EX_pc_src)
        2'b00: pc <= pc + 1;
        2'b01: pc <= IF_inst[11:0];
        2'b10: pc <= stack_out;
        2'b11: pc <= EX_branched_pc;
      endcase
    end
  end

  always @(reg_out_1) begin
    $display("reg_out_1:  %b", reg_out_1);
  end

  /*   IF    */
  reg[11:0] IF_pc; reg[18:0] IF_inst;
  initial begin
    IF_pc = 12'b0;
    IF_inst = 19'b0;
  end
  always @(negedge clk) begin
    IF_pc <= incremented_pc;
    IF_inst <= instruction;
  end

  /*    ID    */
  reg ID_is_shift;   reg ID_alu_src;   reg ID_update_z_c; 
  reg[1:0] ID_scode; reg[2:0] ID_acode; reg ID_mem_read; reg ID_mem_write;
  reg[1:0] ID_pc_src = 2'b0;  reg ID_mem_or_alu; reg ID_reg_write_signal;
  reg[11:0] ID_pc; reg[7:0] ID_data_1; reg[7:0] ID_data_2;
  reg[18:0] ID_inst; 
  
  initial begin
    ID_is_shift = 0; ID_alu_src = 0; ID_update_z_c = 0;
    ID_scode = 2'b0; ID_acode = 3'b0; ID_mem_read = 0; ID_mem_write = 0;
    ID_pc_src = 2'b0; ID_mem_or_alu = 0; ID_reg_write_signal = 0;
    ID_pc = 12'b0; ID_data_1 = 8'b0;  ID_data_2 = 8'b0;
    ID_inst = 19'b0;
  end
  always @(negedge clk) begin
    if(is_stall == 1'b0) begin
      ID_is_shift <= is_shift;
      ID_alu_src <= alu_src;
      ID_update_z_c <= update_z_c;
      ID_scode <= scode;
      ID_acode <= acode;
      ID_mem_read <= mem_read;
      ID_mem_write <= mem_write;
      ID_pc_src <= pc_src;
      ID_mem_or_alu <= mem_or_alu;
      ID_reg_write_signal <= reg_write_signal;
      ID_pc <= IF_pc;
      ID_data_1 <= reg_out_1;
      ID_data_2 <= reg_out_2;
      ID_inst <= IF_inst;
    end else begin
      ID_is_shift = 0; ID_alu_src = 0; ID_update_z_c = 0;
      ID_scode = 2'b0; ID_acode = 3'b0; ID_mem_read = 0; ID_mem_write = 0;
      ID_pc_src = 2'b0; ID_mem_or_alu = 0; ID_reg_write_signal = 0;
      ID_pc = 12'b0; ID_data_1 = 8'b0;  ID_data_2 = 8'b0;
      ID_inst = 19'b0;
    end
  end
 
  /*      EX      */
  reg[11:0] EX_branched_pc;  reg[7:0] EX_alu_result;  
  reg EX_mem_read;
  reg EX_mem_write;   
  reg[1:0] EX_pc_src; reg EX_mem_or_alu;   reg EX_reg_write_signal;
  reg[18:0] EX_inst; reg[7:0] EX_data_2;
  initial begin
    EX_branched_pc = 12'b0;
    EX_alu_result = 8'b0;
    EX_mem_read = 0;
    EX_mem_write = 0;
    EX_pc_src = 2'b0;
    EX_mem_or_alu = 0;
    EX_reg_write_signal = 0;
    EX_inst = 19'b0;
    EX_data_2 = 8'b0;
  end
  always @(negedge clk) begin
    EX_branched_pc <= branched_pc;
    EX_alu_result <= alu_result;
    EX_mem_read <= ID_mem_read;
    EX_mem_write <= ID_mem_write;
    EX_reg_write_signal <= ID_reg_write_signal;
    EX_inst <= ID_inst;
    EX_pc_src <= ID_pc_src;
    EX_mem_or_alu <= ID_mem_or_alu;
    EX_data_2 <= ID_data_2;
  end

  
  /*     MEM     */
    reg[7:0] MEM_alu_result;  reg MEM_reg_write_signal; reg[18:0] MEM_inst; 
    reg MEM_mem_or_alu; reg[7:0] MEM_read_data;
    initial begin
      MEM_alu_result = 8'b0;
      MEM_reg_write_signal = 0;
      MEM_inst = 19'b0;
      MEM_mem_or_alu = 0;
      MEM_read_data = 8'b0;
    end
    always @(negedge clk) begin
      MEM_alu_result <= EX_alu_result;
      MEM_reg_write_signal <= EX_reg_write_signal;
      MEM_inst <= EX_inst;
      MEM_mem_or_alu <= EX_mem_or_alu;
      MEM_read_data <= data_memory_out;
    end
  
  InstructionMemory instruction_memory(rst, pc, instruction);

  
  RegisterFile register_file(rst, IF_inst[10:8], reg2_read_source ? IF_inst[13:11] : IF_inst[7:5], MEM_inst[13:11], MEM_reg_write_signal, clk, MEM_mem_or_alu ? MEM_alu_result : MEM_read_data, reg_out_1, reg_out_2);


  wire[7:0] alu_A; wire[7:0] alu_B;
  ForwardSelector forward_selector(forward_A, forward_B, ID_data_1, EX_alu_result, MEM_mem_or_alu ? MEM_alu_result : MEM_read_data, ( ID_is_shift ? {5'b0,ID_inst[7:5]} : ID_data_2), alu_A, alu_B);
  
  ALU alu(rst, alu_A, (ID_alu_src ? ID_inst[7:0] : alu_B), carry, ID_is_shift, ID_update_z_c, ID_scode, ID_acode, alu_result, zero, alu_carry_out);

  DataMemory data_memory(rst, EX_alu_result, (forward_mem_data == 1'b0 ? EX_data_2 : MEM_alu_result), EX_mem_read, EX_mem_write, clk, data_memory_out);

  Stack stack(rst, stack_push, stack_pop, clk, IF_pc + {11'b0,1'b1}, stack_overflow, stack_out);

  wire[1:0] forward_A; wire[1:0]forward_B; wire forward_mem_data;
  ForwardingUnit forwarding_unit(EX_mem_write, reg2_read_source, EX_reg_write_signal, EX_inst, ID_inst, MEM_reg_write_signal, MEM_inst, forward_A, forward_B, forward_mem_data);

  wire is_stall;
  HazardDetector hazard_detector(ID_mem_read, reg2_read_source, ID_inst, IF_inst, is_stall);

endmodule
