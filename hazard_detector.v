`timescale 1ns/1ns
// TODO: we should have seprate signal for mem read! to prevent nonesence hazard
module HazardDetector(input[18:0] EX_inst, input zero, carry, ID_mem_read, input reg2_read_source, input[18:0] ID_inst, input[18:0] IF_inst, output reg is_stall, output reg is_flush);

  initial begin
    is_stall = 1'b0;
    is_flush = 1'b0;
  end


  // if = 0 id = 0 pc_src = EX_branched_pc

  always @(EX_inst,  ID_mem_read, ID_inst, IF_inst, reg2_read_source) begin
    if(EX_inst[18:16] == 3'b101) begin
      case(EX_inst[15:14])
        2'b00: is_flush = (zero == 1 ? 1 : 0);
        2'b01: is_flush = (zero == 0 ? 1 : 0);
        2'b10: is_flush = (carry == 1 ? 1 : 0);
        2'b11: is_flush = (carry == 0 ? 1 : 0);
      endcase
    end

    if ((ID_mem_read == 1'b1 & ((ID_inst[13:11] == IF_inst[10:8]) | (ID_inst[13:11] == (reg2_read_source ? IF_inst[10:8] : IF_inst[7:5]))) & (ID_inst[15:11] != 3'b000) ) == 1)
      is_stall = 1;
    else
      is_stall = 0;
  end
  
endmodule
