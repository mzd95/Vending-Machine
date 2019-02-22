module coin_sensor_B(clk , reset, serialIn, write, penny, nickel, dime, quarter, diameter, state);
  
  input clk , reset, serialIn, write;
  output reg penny , nickel, dime, quarter;
  output reg [1:0] state;
  output reg [9:0] diameter;
  reg flag;
  reg [1:0] next_state;
  
  always @(posedge clk)
  begin
    state <= next_state;
    if (state == 2'b10) 
      begin
        next_state <= 2'b00;
        if (diameter >= 10'b1011111010 & diameter <= 10'b1100000101)
          begin
            penny <= 1'b1;
            flag <= 1'b1;
          end
        else if (diameter >= 10'b1101010001 & diameter <= 10'b1101011100)
          begin
            nickel <= 1'b1;
            flag <= 1'b1;
          end
        else if (diameter >= 10'b1011001100 & diameter <= 10'b1011010111)
          begin
            dime <= 1'b1;
            flag <= 1'b1;
          end
        else if (diameter >= 10'b1111001100 & diameter <= 10'b1111010111)
          quarter <= 1'b1;
          flag <= 1'b1;
      end
    if (next_state == 2'b00)
      begin
        diameter <= 10'b0000000000;
        penny <= 1'b0;
        nickel <= 1'b0;
        dime <= 1'b0;
        quarter <= 1'b0;
      end
    if (state == 2'b01 & next_state != 2'b10)
      begin
        diameter <= {diameter[8:0], serialIn};
      end
  end
  
  always @(reset or write)
  begin
    if(~reset)
      begin
        diameter <= 10'b0000000000;
        penny <= 1'b0;
        nickel <= 1'b0;
        dime <= 1'b0;
        quarter <= 1'b0;
        next_state <= 2'b00;
      end
      
    else if (reset)
      case(state)
        2'b00 : 
        begin
          if (write) 
          begin
            next_state <= 2'b01;
          end
        end
        2'b01 :
        begin
          if (~write)
          begin
           next_state <= 2'b10;
          end
        end
        default :
        begin
          next_state <= 2'b00;
          diameter <= 10'b0000000000;
          penny <= 1'b0;
          nickel <= 1'b0;
          dime <= 1'b0;
          quarter <= 1'b0;
        end
      endcase
  end

endmodule
