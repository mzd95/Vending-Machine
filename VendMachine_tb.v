module VendMachine_tb();
  reg clk, reset, enable, serialIn;
  reg [1:0] product;
  reg buy;
  wire [6:0] digit1, digit0;
  wire penny, nickle,dime, quarter;
  wire [9:0] diameter;
  wire error;
  wire [1:0] pro;
  wire [7:0] credit;
  
  VendMachine_B VB(clk, reset, enable, serialIn, product, buy, digit1, digit0, penny, nickle, dime, quarter, diameter, error, pro, credit);
  
  function [9:0] rando;
    input [9:0] min;
    input [9:0] max;
    rando = min + {$random} % (max-min);
  endfunction
  
  task write_bits;
    input [9:0] data;
    reg [4:0] i;
    for (i=0; i<10; i=i+1)
    begin
      @(posedge clk);
      serialIn <= data[9-i];
    end
  endtask
  
  covergroup myCoverGroup @(clk);
    PENNY : coverpoint penny;
    NICKLE : coverpoint nickle;
    DIME : coverpoint dime;
    QUARTER : coverpoint quarter;
    CREDIT : coverpoint credit {
                               bins zero = {[0:4]};
                               bins one = {[5:9]};
                               bins two = {[10:24]};
                               bins three = {[25:39]};
                               bins four = {[40:59]};
                               bins five = {[60:74]};
                               bins six = {[75:255]};
                               }
    ERROR : coverpoint error;
    PRO : coverpoint pro;
    CROSS_COVERAGE : cross PRO, ERROR;
  endgroup
  
  always #10 clk <= ~clk;
  
  initial begin
    myCoverGroup cg;
    cg = new();
    clk <= 1'b1;
    reset <= 1'b0;
    enable <= 1'b0;
    product <= 2'b00;
    buy <= 1'b0;
    #30
    reset <= 1'b1;
    #20
    enable <= 1'b1;
    #20
    write_bits(rando(10'b1011111010, 10'b1100000101));
    #20
    enable <= 1'b0;
    #60
    buy <= 1'b1;
    #20
    buy <= 1'b0;
    #80
    enable <= 1'b1;
    #20
    write_bits(rando(10'b1011110000, 10'b1011111010));
    #20
    enable <= 1'b0;
    #80
    enable <= 1'b1;
    #20
    write_bits(rando(10'b1011001100, 10'b1011010000));
    #20
    enable <= 1'b0;
    #80
    enable <= 1'b1;
    #20
    write_bits(rando(10'b1111010000, 10'b1111010111));
    #20
    enable <= 1'b0;
    product <= 2'b11;
    #20
    product <= 2'b01;
    #60
    buy <= 1'b1;
    #20
    buy <= 1'b0;
    #60
    product <= 2'b00;
    #60
    buy <= 1'b1;
    enable <= 1'b1;
    #20
    write_bits(rando(10'b1101010001,10'b1101011100));
    #20
    enable <= 1'b0;
    product <= 2'b11;
    #80
    buy <= 1'b1;
    #20
    buy <= 1'b0;
    #40
    enable <= 1'b1;
    #20
    write_bits(rando(10'b1011001100, 10'b1011010111));
    #20
    enable <= 1'b0;
    product <= 2'b10;
    #60
    buy <= 1'b1;
  end
  
endmodule
