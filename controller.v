`timescale 1ns/1ns
module Controller(input rst, zero, carry, clk, input is_halt, input[18:0] instruction, output reg reg2_read_source, mem_read_write, mem_or_alu, output reg  is_shift, output reg alu_src, update_z_c, reg_write_signal, stack_push, stack_pop, output reg [1:0] pc_src, output reg [1:0] scode, output reg [2:0] acode);
  
  initial begin
    update_z_c <= 0; reg2_read_source <= 0; mem_read_write <= 0; mem_or_alu <= 0; is_shift <= 0;
    alu_src <= 0; reg_write_signal <= 0; stack_push <= 0; stack_pop <= 0; pc_src <= 2'b0; scode <= 2'b0; acode <= 3'b0;
  end

  always @(posedge clk, instruction) begin //instruction commented
    //#1;
    reg2_read_source <= 0; mem_read_write <= 0; mem_or_alu <= 0; is_shift <= 0; alu_src <= 0; reg_write_signal <= 0; stack_push <= 0; stack_pop <= 0; pc_src <= 2'b0; scode <= 2'b0; acode <= 3'b0; update_z_c <= 0;

    $display(">>> alu src:  %d", alu_src);
    $display(">>> current instruction: %b", instruction);
    //if(instruction == 19'b1111111111111111111) begin
    if(is_halt == 1'b1) begin 
      #5 $finish;
    end

    if(instruction[18:17] == 2'b00) begin
      $display(">>> normal R type!");
      $display(">>> alu src:  %d", alu_src);
      update_z_c <= 1;
      acode <= instruction[16:14];
      is_shift <= 0;
      alu_src <= 0;
      mem_or_alu <= 1;
      reg_write_signal <= 1;
    end
    
    if(instruction[18:17] == 2'b01) begin
      $display(">>> immediate R type!");
      update_z_c <= 1;
      acode <= instruction[16:14];
      is_shift <= 0;
      alu_src <= 1;
      mem_or_alu <= 1;
      reg_write_signal <= 1;
    end

    if(instruction[18:16] == 3'b110) begin
      $display(">>> shifting");
      scode <= instruction[15:14];
      is_shift <= 1;
      mem_or_alu <= 1;
      reg_write_signal <= 1;
      update_z_c <= 1;
    end

    if(instruction[18:16] == 3'b100) begin
      $display(">>> memory");
      reg2_read_source <= 1;
      mem_or_alu <= 0;
      alu_src <= 1;
      if(instruction[15:14] == 2'b00) begin //load
        mem_read_write <= 0;
        reg_write_signal <= 1;
      end else if(instruction[15:14] == 2'b01) begin // store
        mem_read_write <= 1;
      end
    end

    if(instruction[18:16] == 3'b101) begin
      $display(">>> beq");
      case(instruction[15:14])
        2'b00: pc_src <= (zero == 1 ? 2'b11 : 2'b00);
        2'b01: pc_src <= (zero == 0 ? 2'b11 : 2'b00);
        2'b10: pc_src <= (carry == 1 ? 2'b11 : 2'b00);
        2'b11: pc_src <= (carry == 0 ? 2'b11 : 2'b00);
      endcase
    end

    if(instruction[18:15] == 4'b1110) begin // jump without condition
      $display(">>> jump without condition!");
      if(instruction[14] == 1) stack_push <= 1; // jsb
      pc_src <= 2'b01; //jmp
    end

    if(instruction[18:13] == 6'b111100) begin // ret
      $display(">>> RET!");
      pc_src <= 2'b10;
      stack_pop <= 1;
    end
  end

endmodule

