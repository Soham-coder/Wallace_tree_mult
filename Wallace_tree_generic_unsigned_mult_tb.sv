// Code your testbench here
// or browse Examples
module tb_wallace;
  parameter WORD_SIZE = 23;
  reg clk;
  reg [WORD_SIZE-1:0] x, y;
  wire [2*WORD_SIZE-1:0] p;
  wire [2*WORD_SIZE-1:0] actual_p = x*y;
  //product p1(clk,p,{1'b1,x[51:0]},{1'b1,y[51:0]});
  product_gen #(.WORD_SIZE(WORD_SIZE)) p1(clk,p,x,y);
  initial begin
    clk = 0;
    $monitor("x-%h,y-%h,p-%h,p_ac-%h,time-%t",x,y,p,actual_p,$realtime);
    x = 'h234567;
    y = 'h654321;
  end
  initial begin
    #100000;
    $finish;
  end
  always 
  #1 clk = ~clk;
  initial begin
    $dumpvars;
    $dumpfile("dump.vcd");
  end
endmodule
  