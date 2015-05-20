`timescale 1ns/1ns
module ForwardingUnit(input EX_mem_write, ID_reg2_read_source, EX_reg_write_signal, input[18:0] EX_inst, input[18:0] ID_inst, input MEM_reg_write_signal, input[18:0] MEM_inst, output reg[1:0] forward_A, output reg[1:0] forward_B, output reg forward_mem_data);

  initial begin
    forward_A = 2'b00;
    forward_B = 2'b00;
  end
  /* EX hazard */
  always @(EX_reg_write_signal, EX_inst, ID_inst, MEM_reg_write_signal, MEM_inst, EX_mem_write, ID_reg2_read_source) begin
    forward_A = 2'b00;
    forward_B = 2'b00;
    forward_mem_data = 1'b0;

    if(EX_reg_write_signal == 1'b1 & (EX_inst[13:11] != 3'b000) & (EX_inst[13:11] == ID_inst[10:8]))
      forward_A = 2'b01;
   
    if(EX_reg_write_signal & (EX_inst[13:11] != 3'b000) & (EX_inst[13:11] == (ID_reg2_read_source ? ID_inst[10:8] : ID_inst[7:5])))
      forward_B = 2'b01;


  /* MEM hazard */
    if(MEM_reg_write_signal == 1'b1 & (MEM_inst[13:11] != 3'b000) & ~(EX_reg_write_signal == 1'b1 & (EX_inst[13:11] != 3'b000) & (EX_inst[13:11] == ID_inst[10:8])) & (MEM_inst[13:11] == ID_inst[10:8]))
      forward_A = 2'b10;

    if(MEM_reg_write_signal == 1'b1 & (MEM_inst[13:11] != 3'b000)
  & 
~(EX_reg_write_signal & (EX_inst[13:11] != 3'b000) & (EX_inst[13:11] == (ID_reg2_read_source ? ID_inst[10:8] : ID_inst[7:5])))

  &  
  (MEM_inst[13:11] == (ID_reg2_read_source ? ID_inst[10:8] : ID_inst[7:5]))

)
      forward_B = 2'b10;

  /*   MEM to EX forward   */
  if(EX_mem_write == 1'b1 & (MEM_inst[13:11] == EX_inst[13:11]))
    forward_mem_data = 1'b1;
  end

endmodule
