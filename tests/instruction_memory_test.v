`timescale 1ns/1ns
module InstructionMemoryTest;

  reg[11:0] address = 12'b0;
  wire[18:0] instruction;

  InstructionMemory inst_memory(address, instruction);

  initial begin
    $dumpfile("InstructionMemoryTest.vcd");
    $dumpvars(0, InstructionMemoryTest);
     
    forever begin
      #10;
      address = address + 1;
      if(address == 12'b000000001111) $finish;
    end
  end
  
endmodule
