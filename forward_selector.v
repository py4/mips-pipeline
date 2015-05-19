`timescale 1ns/1ns
module ForwardSelector(input[1:0] forward_A, input[1:0] forward_B, input[7:0] ID_data_1, input[7:0] EX_alu_result, input[7:0] mem_or_alu_data, input[7:0] ID_data_2, output reg[7:0] alu_A, output reg[7:0] alu_B);
 
  initial begin
    alu_A = ID_data_1;
    alu_B = ID_data_2;
  end
 
  always @(forward_A, forward_B, ID_data_1, EX_alu_result, mem_or_alu_data, ID_data_2) begin
    case(forward_A)
      2'b00: alu_A = ID_data_1;
      2'b01: alu_A = EX_alu_result;
      2'b10: alu_A = mem_or_alu_data;
    endcase
    
    case(forward_B)
      2'b00: alu_B = ID_data_2;
      2'b01: alu_B = EX_alu_result;
      2'b10: alu_B = mem_or_alu_data;
    endcase
  end

endmodule
