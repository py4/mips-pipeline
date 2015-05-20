`timescale 1ns/1ns
// TODO: we should have seprate signal for mem read! to prevent nonesence hazard
module HazardDetector(input ID_mem_read_write, input reg2_read_source, input[18:0] ID_inst, input[18:0] IF_inst, output reg is_stall);

  initial begin
    is_stall = 1'b0;
  end

  always @(ID_mem_read_write, ID_inst, IF_inst) begin
    if ((ID_mem_read_write == 1'b0 & ((ID_inst[13:11] == IF_inst[10:8]) | (ID_inst[13:11] == (reg2_read_source ? IF_inst[10:8] : IF_inst[7:5]))) & (ID_inst[15:11] != 3'b000) ) == 1)
      is_stall = 1;
    else
      is_stall = 0;
  end
  
endmodule
