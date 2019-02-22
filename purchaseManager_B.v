module purchaseManager_B(clk, reset, buy, product, credit, apple, banana, carrot, date, error, pro);
  input clk, reset;
  input buy;
  input [1:0] product;
  input [7:0] credit;
  output reg apple, banana, carrot, date, error;
  output reg [1:0] pro;
  reg count;
  
  always @(posedge clk)
  begin
    if (count == 1'b1)
      begin
       apple <= 1'b0;
       banana <= 1'b0;
       carrot <= 1'b0;
       date <= 1'b0;
       error <= 1'b0;
     end
  end
  
  always @(reset or buy or product)
  begin
    if (~reset)
      begin
        apple <= 1'b0;
        banana <= 1'b0;
        carrot <= 1'b0;
        date <= 1'b0;
        error <= 1'b0;
      end
      
    else if (reset & buy)
      pro <= product;
    
    else if (reset & ~buy)
      begin
        count <= 1'b1;
        if ((pro == 2'b00) & (credit < 8'b01001011))
          error <= 1'b1;
        else if ((pro == 2'b00) & (credit >= 8'b01001011))
          apple <= 1'b1;
        else if ((pro == 2'b01) & (credit < 8'b00010100))
          error <= 1'b1;
        else if ((pro == 2'b01) & (credit >= 8'b00010100))
          banana <= 1'b1;
        else if ((pro == 2'b10) & (credit < 8'b00011110))
          error <= 1'b1;
        else if ((pro == 2'b10) & (credit >= 8'b00011110))
          carrot <= 1'b1;
        else if ((pro == 2'b11) & (credit < 8'b00101000))
          error <= 1'b1;
        else if ((pro == 2'b11) & (credit >= 8'b00101000))
          date <= 1'b1;
        else error <= 1'b1;
      end

  end
  
endmodule
