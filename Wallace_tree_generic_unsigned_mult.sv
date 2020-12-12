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
  
  //wire [28:0] temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp9,temp10; //diagonal m
  //wire [28:0] temp11,temp12,temp13,temp14,temp15,temp16,temp17,temp18,temp19,temp20;
  //wire [28:0] temp21,temp22,temp23,temp24,temp25,temp26,temp27,temp28,temp29;
  
  
  wire [WORD_SIZE-1:0] ptemp[WORD_SIZE-1:1];

  ///wire [28:0] ptemp1,ptemp2,ptemp3,ptemp4,ptemp5,ptemp6,ptemp7,ptemp8,ptemp9,ptemp10;
//vertical p
  ///wire [28:0] ptemp11,ptemp12,ptemp13,ptemp14,ptemp15,ptemp16,ptemp17,ptemp18,ptemp19,ptemp20;
  ///wire [28:0] ptemp21,ptemp22,ptemp23,ptemp24,ptemp25,ptemp26,ptemp27,ptemp28;
//row r1 (clk,ptemp1, temp1, sum[0], min, 29'b00000000000000000000000000000, q[0]);
  row_gen #(.WORD_SIZE(WORD_SIZE)) r_first (clk,ptemp[1], temp[1], sum[0], min, {WORD_SIZE{1'b0}}, q[0]);
  
  genvar c;
  generate 
    for(c=2;c<=WORD_SIZE-1;c++) begin:row_inst
      row_gen #(.WORD_SIZE(WORD_SIZE)) r_intermediate (clk, ptemp[c], temp[c], sum[c-1], temp[c-1], ptemp[c-1], q[c-1]);
    end
  endgenerate

//row r2 (clk,ptemp2, temp2, sum[1], temp1, ptemp1, q[1]);
//row r3 (clk,ptemp3, temp3, sum[2], temp2, ptemp2, q[2]);
//row r4 (clk,ptemp4, temp4, sum[3], temp3, ptemp3, q[3]);
//row r5 (clk,ptemp5, temp5, sum[4], temp4, ptemp4, q[4]);
//row r6 (clk,ptemp6, temp6, sum[5], temp5, ptemp5, q[5]);
//row r7 (clk,ptemp7, temp7, sum[6], temp6, ptemp6, q[6]);
//row r8 (clk,ptemp8, temp8, sum[7], temp7, ptemp7, q[7]);
//row r9 (clk,ptemp9, temp9, sum[8], temp8, ptemp8, q[8]);
//row r10(clk,ptemp10, temp10, sum[9], temp9, ptemp9, q[9]);
//row r11(clk,ptemp11, temp11, sum[10], temp10, ptemp10, q[10]);
//row r12(clk,ptemp12, temp12, sum[11], temp11, ptemp11, q[11]);
//row r13(clk,ptemp13, temp13, sum[12], temp12, ptemp12, q[12]);
//row r14(clk,ptemp14, temp14, sum[13], temp13, ptemp13, q[13]);
//row r15(clk,ptemp15, temp15, sum[14], temp14, ptemp14, q[14]);
//row r16(clk,ptemp16, temp16, sum[15], temp15, ptemp15, q[15]);
//row r17(clk,ptemp17, temp17, sum[16], temp16, ptemp16, q[16]);
//row r18(clk,ptemp18, temp18, sum[17], temp17, ptemp17, q[17]);
//row r19(clk,ptemp19, temp19, sum[18], temp18, ptemp18, q[18]);
//row r20(clk,ptemp20, temp20, sum[19], temp19, ptemp19, q[19]);
//row r21(clk,ptemp21, temp21, sum[20], temp20, ptemp20, q[20]);
//row r22(clk,ptemp22, temp22, sum[21], temp21, ptemp21, q[21]);
//row r23(clk,ptemp23, temp23, sum[22], temp22, ptemp22, q[22]);
//row r24(clk,ptemp24, temp24, sum[23], temp23, ptemp23, q[23]);
//row r25(clk,ptemp25, temp25, sum[24], temp24, ptemp24, q[24]);
//row r26(clk,ptemp26, temp26, sum[25], temp25, ptemp25, q[25]);
//row r27(clk,ptemp27, temp27, sum[26], temp26, ptemp26, q[26]);
//row r28(clk,ptemp28, temp28, sum[27], temp27, ptemp27, q[27]);

  row_gen #(.WORD_SIZE(WORD_SIZE)) r_last (clk,sum[2*WORD_SIZE-1:WORD_SIZE], temp[WORD_SIZE], sum[WORD_SIZE-1], temp[WORD_SIZE-1], ptemp[WORD_SIZE-1], q[WORD_SIZE-1]);
  
//row r29(clk,sum[57:29], temp29, sum[28], temp28, ptemp28, q[28]);

always@(posedge clk)
begin
  sum1<=sum;
end


endmodule

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

//wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10;
//wire c11,c12,c13,c14,c15,c16,c17,c18,c19,c20;
//wire c21,c22,c23,c24,c25,c26,c27,c28;
wire c[WORD_SIZE-1:1];

block b_first (clk,sum,c[1],mout[0],min[0],ppi[0],q,1'b0);
genvar d;
  generate 
    for(d=2;d<=WORD_SIZE-1;d++) begin:block_inst
      block  b_intermediate (clk, ppo[d-2], c[d], mout[d-1], min[d-1], ppi[d-1], q, c[d-1]);
    end
endgenerate
/*block b2 (clk,ppo[0], c2, mout[1], min[1], ppi[1], q, c1);
block b3 (clk,ppo[1], c3, mout[2], min[2], ppi[2], q, c2);
block b4 (clk,ppo[2], c4, mout[3], min[3], ppi[3], q, c3);
block b5 (clk,ppo[3], c5, mout[4], min[4], ppi[4], q, c4);
block b6 (clk,ppo[4], c6, mout[5], min[5], ppi[5], q, c5);
block b7 (clk,ppo[5], c7, mout[6], min[6], ppi[6], q, c6);
block b8 (clk,ppo[6], c8, mout[7], min[7], ppi[7], q, c7);
block b9 (clk,ppo[7], c9, mout[8], min[8], ppi[8], q, c8);
block b10(clk,ppo[8], c10, mout[9], min[9], ppi[9], q, c9);
block b11(clk,ppo[9], c11, mout[10], min[10], ppi[10], q, c10);
block b12(clk,ppo[10], c12, mout[11], min[11], ppi[11], q, c11);
block b13(clk,ppo[11], c13, mout[12], min[12], ppi[12], q, c12);
block b14(clk,ppo[12], c14, mout[13], min[13], ppi[13], q, c13);
block b15(clk,ppo[13], c15, mout[14], min[14], ppi[14], q, c14);
block b16(clk,ppo[14], c16, mout[15], min[15], ppi[15], q, c15);
block b17(clk,ppo[15], c17, mout[16], min[16], ppi[16], q, c16);
block b18(clk,ppo[16], c18, mout[17], min[17], ppi[17], q, c17);
block b19(clk,ppo[17], c19, mout[18], min[18], ppi[18], q, c18);
block b20(clk,ppo[18], c20, mout[19], min[19], ppi[19], q, c19);
block b21(clk,ppo[19], c21, mout[20], min[20], ppi[20], q, c20);
block b22(clk,ppo[20], c22, mout[21], min[21], ppi[21], q, c21);
block b23(clk,ppo[21], c23, mout[22], min[22], ppi[22], q, c22);
block b24(clk,ppo[22], c24, mout[23], min[23], ppi[23], q, c23);
block b25(clk,ppo[23], c25, mout[24], min[24], ppi[24], q, c24);
block b26(clk,ppo[24], c26, mout[25], min[25], ppi[25], q, c25);
block b27(clk,ppo[25], c27, mout[26], min[26], ppi[26], q, c26);
block b28(clk,ppo[26], c28, mout[27], min[27], ppi[27], q, c27);*/
  block b_last (clk,ppo[WORD_SIZE-2], ppo[WORD_SIZE-1], mout[WORD_SIZE-1], min[WORD_SIZE-1], ppi[WORD_SIZE-1], q, c[WORD_SIZE-1]);


always@(posedge clk)
begin
  ppo1<=ppo;
  mout1<=mout;
  sum1<=sum;
end

endmodule
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