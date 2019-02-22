module sevenSegDispMngr_B(clk, reset, apple, banana, carrot, date, error, credit, digit1, digit0, special, counter, state);
  input clk, reset;
  input apple, banana, carrot, date, error;
  input [7:0] credit;
  output reg [6:0] digit1, digit0;
  output reg [7:0] special;
  output reg state;
  output reg [2:0] counter;
  wire [6:0] out1, out0, out3, out2;
  
  seg_decoder_B A(credit[7:4],out1);
  seg_decoder_B B(credit[3:0],out0);
  seg_decoder_B C(special[7:4],out3);
  seg_decoder_B D(special[3:0],out2);
  
  always @(posedge clk)
  begin
    if (~state)
      begin
        digit1 <= out1;
        digit0 <= out0;
        counter <= 3'b000;
      end
    else if (state)
      begin
        digit1 <= out3;
        digit0 <= out2;
        if (counter<3'b101)
          counter <= counter+3'b001;
        else if (counter==3'b101)
          state <= 1'b0;
      end
  end
  
  always @(reset or apple or banana or carrot or date or error)
  begin
    if (~reset)
      begin
        special <= 8'b00000000;
        state <= 1'b0;
      end
      
    else if (reset)
      begin
        if (apple)
          begin
            special <= 8'b10101010;
            state <= 1'b1;
          end
        else if (banana)
          begin
            special <= 8'b10111011;
            state <= 1'b1;
          end
        else if (carrot)
          begin
            special <= 8'b11001100;
            state <= 1'b1;
          end
        else if (date)
          begin
            special <= 8'b11011101;
            state <= 1'b1;
          end
        else if (error)
          begin
            special <= 8'b11101110;
            state <= 1'b1;
          end
      end
  end
endmodule
