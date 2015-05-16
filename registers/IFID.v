`timescale 1ns/1ns
module IFID(input clk, input[11:0] in_new_pc, input[18:0] in_instruction, output reg [11:0] out_new_pc, output reg[18:0] out_instruction);

  reg new_pc, instruction;
  always @(posedge clk) begin
    out_new_pc = new_pc;
    out_instruction = instruction;
    new_pc = in_new_pc;
    instruction = in_instruction;
  end

endmodule
