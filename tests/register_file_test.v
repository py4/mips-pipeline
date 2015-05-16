`timescale 1ns/1ns
module RegisterFileTest;
  reg[2:0] reg_read_1, reg_read_2, reg_write;
  reg read_write = 1, clk = 0;
  reg[7:0] in_data;
  wire[7:0] out_data_1, out_data_2;

  RegisterFile register_file(reg_read_1, reg_read_2, reg_write, read_write, clk, in_data, out_data_1, out_data_2);

  always begin
    #3 clk = ~clk;
  end

  initial begin
    $dumpfile("RegisterFileTest.vcd");
    $dumpvars(0, RegisterFileTest);
    
    read_write = 1;
    in_data = 8'b01011011;
    reg_write = 3'b101;
    
    #5

    in_data = 8'b11000101;
    reg_write = 3'b011;

    #5

    read_write = 0;
    reg_read_1 = 3'b101;
    reg_read_2 = 3'b011;

    #5
    $finish;
  end

endmodule
