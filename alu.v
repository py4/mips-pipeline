`timescale 1ns/1ns

module ALU(input rst, input signed [7:0] A, input signed [7:0] B, input carry_in, input is_shift, update_z_c, input [1:0] scode, input [2:0] acode, output reg [7:0] R, output reg zero, carry_out);

  function get_carry_out; input [7:0] A, B, C;
    get_carry_out = (A[7]&B[7]) | (A[7]^B[7])&~C[7];
  endfunction



  reg [8:0] temp;
  reg [15:0] temp2;
  reg [7:0] neg_B;
  initial begin
    zero = 0;
    carry_out = 0;
  end
  always @(A, B, scode, acode) begin
    neg_B = -B;
    case(is_shift)
      1'b0: begin
        case(acode)
          3'b000: begin
            temp = A + B;
            if(update_z_c == 1)
              carry_out = get_carry_out(A, B, temp);
          end
          3'b001: begin
            temp = A + B + carry_in; 
            if(update_z_c == 1)
              carry_out = get_carry_out(A, B+carry_in, temp);
          end
          3'b010: begin
            temp = A + ~B + 1;
            if(update_z_c == 1)
              carry_out = get_carry_out(A, -B, temp);
          end
          3'b011: begin
            temp = A + ~B + 1 - carry_in;
            if(update_z_c == 1)
              carry_out = get_carry_out(A, -B + carry_in, temp);
          end

          3'b100: temp = A & B;
          3'b101: temp = A | B;
          3'b110: temp = A ^ B;
          3'b111: temp = ~(A & B);
        endcase
        R = temp[7:0];
      end
      1'b1: 
        if(B == 8'b0)
          R = A;
        else begin
          case(scode)
            2'b00: begin
              carry_out = A[8-B];
              R = A <<< B;
            end
            2'b01: begin
              carry_out = A[B-1];
              R = A >>> B;
            end
            2'b10: begin
              temp2 = {A,A} << (B);
              R = temp2[15:8];
              carry_out = A[7-B];
            end
            2'b11: begin
              temp2 = {A,A} >> (B);
              R = temp2[7:0];
              carry_out = A[B-1];
            end
          endcase
        end
    endcase
    if(update_z_c == 1)
      zero = (R == 8'b0);
  end
endmodule
