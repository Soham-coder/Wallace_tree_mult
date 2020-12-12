//////////PRODUCT//////////
module product_gen
#(
parameter WORD_SIZE=29
)
(
  input wire clk,
  output reg[2*WORD_SIZE-1:0] sum1,
  input wire[WORD_SIZE-1:0] min,
  input wire[WORD_SIZE-1:0]q
);

  wire[2*WORD_SIZE-1:0] sum;
  
  
  wire [WORD_SIZE-1:0] temp[WORD_SIZE:1];
  wire [WORD_SIZE-1:0] ptemp[WORD_SIZE-1:1];

  
  row_gen #(.WORD_SIZE(WORD_SIZE)) r_first (clk,ptemp[1], temp[1], sum[0], min, {WORD_SIZE{1'b0}}, q[0]);
  
  genvar c;
  generate 
    for(c=2;c<=WORD_SIZE-1;c++) begin:row_inst
      row_gen #(.WORD_SIZE(WORD_SIZE)) r_intermediate (clk, ptemp[c], temp[c], sum[c-1], temp[c-1], ptemp[c-1], q[c-1]);
    end
  endgenerate
  
  row_gen #(.WORD_SIZE(WORD_SIZE)) r_last (clk,sum[2*WORD_SIZE-1:WORD_SIZE], temp[WORD_SIZE], sum[WORD_SIZE-1], temp[WORD_SIZE-1], ptemp[WORD_SIZE-1], q[WORD_SIZE-1]);
  


always@(posedge clk)
begin
  sum1<=sum;
end


endmodule


//////////ROW_GEN///////////
module row_gen
#(
parameter WORD_SIZE = 29
)
(
input wire clk,
output reg[WORD_SIZE-1:0] ppo1,
output reg[WORD_SIZE-1:0] mout1,
output reg sum1,
input wire[WORD_SIZE-1:0] min,
input wire[WORD_SIZE-1:0] ppi,
input wire q
);

wire[28:0] ppo;
wire[28:0] mout;
wire sum;


wire c[WORD_SIZE-1:1];

block b_first (clk,sum,c[1],mout[0],min[0],ppi[0],q,1'b0);

genvar d;
  generate 
    for(d=2;d<=WORD_SIZE-1;d++) begin:block_inst
      block  b_intermediate (clk, ppo[d-2], c[d], mout[d-1], min[d-1], ppi[d-1], q, c[d-1]);
    end
endgenerate

block b_last (clk,ppo[WORD_SIZE-2], ppo[WORD_SIZE-1], mout[WORD_SIZE-1], min[WORD_SIZE-1], ppi[WORD_SIZE-1], q, c[WORD_SIZE-1]);


always@(posedge clk)
begin
  ppo1<=ppo;
  mout1<=mout;
  sum1<=sum;
end

endmodule

/////////BLOCK///////////

module block(
input wire clk,
output reg ppo1, //output partial product term
output reg cout1, //output carry out
output reg mout1, //output multiplicand term
input wire min, //input multiplicand term
input wire ppi, //input partial product term
input wire q, //input multiplier term
input wire cin //input carry in
);

wire ppo;
wire cout;
wire mout;

wire temp;
and(temp,min,q);
full_adder FA(clk,ppo,cout,ppi,temp,cin);
or(mout,min,1'b0);

always@(posedge clk)
begin
  ppo1<=ppo;
  cout1<=cout;
  mout1<=mout; 
  
end

endmodule

//1 bit Full Adder
module full_adder(
input wire clk,
output reg sum1,
output reg cout1,
input wire in1,
input wire in2,
input wire cin
);

wire sum;
wire cout;

wire temp1;
wire temp2;
wire temp3;
xor(sum,in1,in2,cin);
and(temp1,in1,in2);
and(temp2,in1,cin);
and(temp3,in2,cin);
or(cout,temp1,temp2,temp3);

always@(posedge clk)
begin
  sum1<=sum;
  cout1<=cout;
end

endmodule