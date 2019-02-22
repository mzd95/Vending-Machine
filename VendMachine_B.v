module VendMachine_B(clk, reset, enable, serialIn, product, buy, digit1, digit0, penny, nickle, dime, quarter, diameter, error, pro, credit);
  input clk, reset, enable, serialIn;
  input [1:0] product;
  input buy;
  output reg [6:0] digit1, digit0;
  output reg penny, nickle, dime, quarter;
  output reg [9:0] diameter;
  output reg error;
  output reg [1:0] pro;
  output reg [7:0] credit;
  wire pen, nic, dim, qua;
  wire [9:0] dia;
  wire [1:0] sta;
  wire apple, banana, carrot, date;
  wire [7:0] cre;
  wire err;
  wire [6:0] d1, d0;
  wire [1:0] p;
  
  coin_sensor_B coin(clk, reset, serialIn, enable, pen, nic, dim, qua, dia, sta);
  piggyBank_B pBank(clk, reset, pen, nic, dim, qua, apple, banana, carrot, date, cre);
  purchaseManager_B pMngr(clk, reset, buy, product, cre, apple, banana, carrot, date, err, p);
  sevenSegDispMngr_B Disp(clk, reset, apple, banana, carrot, date, err, cre, d1, d0);
  
  always @(reset)
  begin
    if (~reset) 
    begin
      assign digit1 = d1;
      assign digit0 = d0;
      assign penny = pen;
      assign nickle = nic;
      assign dime =dim;
      assign quarter = qua;
      assign diameter = dia;
      assign error = err;
      assign pro = p;
      assign credit = cre;
    end
  end
  
endmodule
