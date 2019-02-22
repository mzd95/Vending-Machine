module piggyBank_B(clk, reset, penny, nickel, dime, quarter, apple, banana, carrot, date, credit);
  input clk, reset;
  input penny, nickel, dime, quarter; //1cent, 5cents, 10cents, 25cents
  input apple, banana, carrot, date;
  output reg [7:0] credit;
  reg state, next_state;
  
  always @(posedge clk)
  begin
    state <= next_state;
  end
  
  always @(reset or penny or nickel or dime or quarter or apple or banana or carrot or date)
  begin
    if (~reset)
      begin
        credit <= 8'b00000000;
      end
    
    else if (reset)
      begin
        if (penny)
          credit <= credit + 8'b00000001;
        else if (nickel)
          credit <= credit + 8'b00000101;
        else if (dime)
          credit <= credit + 8'b00001010;
        else if (quarter)
          credit <= credit + 8'b00011001;
        else if (apple)
          credit <= credit - 8'b01001011;
        else if (banana)
          credit <= credit - 8'b00010100;
        else if (carrot)
          credit <= credit - 8'b00011110;
        else if (date)
          credit <= credit - 8'b00101000;
      end
  end
    
endmodule

