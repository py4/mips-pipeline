`timescale 1ns/1ns
module InstructionMemory(input rst, input[11:0] address, output reg[18:0] instruction);
  reg[18:0] instructions[4095:0];

  initial begin
    $readmemb("instructions.mips", instructions);
  end

  always @(address) begin
    instruction = instructions[address];
  end
endmodule

