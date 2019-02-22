class random_input ;
        rand reg [9:0] d ;
        constraint c1 {(d >= 10'b1011001100 & d <= 10'b1011010111) | (d >= 10'b1101010001 & d <= 10'b1101011100) 
        | (d >= 10'b1011111010 & d <= 10'b1100000101) | 
        (d >= 10'b1111001100 & d <= 10'b1111010111) ;}
        
        rand reg reset;
        constraint c2 {
                reset dist {0:=5, 1:=95} ;
        }
        
        rand reg [1:0] product;
        constraint c3 {
                product dist {2'b00:=25, 2'b01:=25, 2'b10:=25, 2'b11:=25};
        }
        
        rand reg buy;
        constraint c4 {
                buy dist {0:=7, 1:=3};
        }
endclass

module VendMachine_svtm();
  reg clk, reset, enable, serialIn;
  reg [1:0] product;
  reg buy;
  wire [6:0] digit1, digit0;
  wire penny, nickle, dime, quarter;
  wire [9:0] diameter;
  wire error;
  wire [1:0] pro;
  wire [7:0] credit;
  VendMachine_B DUTVM(clk, reset, enable, serialIn, product, buy, digit1, digit0, penny, nickle, dime, quarter, diameter, error, pro, credit);
  
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
  
  initial
  begin
    random_input rb;
    myCoverGroup cg;
    rb = new();
    cg = new();
    
    clk <= 1'b1;
    reset <= 1'b0;
    enable <= 1'b0;
    buy <= 1'b0;
    product <= 2'b00;
    #20 reset <= 1'b1;
    enable <= 1'b1;
    
    forever
    begin
      assert(rb.randomize())
      #20
      write_bits(rb.d);
      #20
      enable <= 1'b0;
      product <= rb.product;
      reset <= rb.reset;
      #20
      buy <= rb.buy;
      #20
      buy <= 1'b0;
      #80
      enable <= 1'b1;
    end
  end
  
  always #10 clk <= ~clk;
endmodule
