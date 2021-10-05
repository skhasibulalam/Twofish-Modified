module encralp (
	input [7:0] in1, in2, in3, in4,
	input clk,
	input [3:0] r,
	input [255:0] key,
	//input rst;
	output reg [7:0] out1, out2, out3, out4);
//wire [255:0] key;
//assign key=256'hf4_4d_7a_15_c9_99_1a_9f_85_40_ff_23_98_a8_b2_b1_52_b7_5d_11_54_f3_f7_d3_c2_cc_2c_22_10_16_23_30;
genvar k;
wire [7:0] imd1[0:3];
generate
	for (k=0; k<8; k=k+1)
	begin
		xor(imd1[0][k], in1[k], key[k+8*r]);
		xor(imd1[1][k], in2[k], key[k+8+8*r]);
		xor(imd1[2][k], in3[k], key[k+16+8*r]);
		xor(imd1[3][k], in4[k], key[k+24+8*r]);
	end
endgenerate
wire [3:0] splimd1[0:7];
generate
	for (k=0; k<4; k=k+1)
	begin
		assign splimd1 [0][k] = imd1 [0][k];
		assign splimd1 [1][k] = imd1 [0][k+4];
		assign splimd1 [2][k] = imd1 [1][k];
		assign splimd1 [3][k] = imd1 [1][k+4];
		assign splimd1 [4][k] = imd1 [2][k];
		assign splimd1 [5][k] = imd1 [2][k+4];
		assign splimd1 [6][k] = imd1 [3][k];
		assign splimd1 [7][k] = imd1 [3][k+4];
	end
endgenerate
wire [63:0] sbox[0:3];
assign sbox[0]=64'h0123456789ABCDEF;//0123456789ABCDEF
assign sbox[1]=64'h0987654321FEDCBA;//543210EDCBA9876F
assign sbox[2]=64'h0CBAFED159632478;//BA9EDC601572438F
assign sbox[3]=64'h0FED753214896ABC;//EDC01245B3A6987F
wire [3:0] imd2[0:7];
generate
	for (k=0; k<8; k=k+1)
	begin
		assign imd2 [k][0] = sbox [ {key[8*(r+2*k)+1],key[8*(r+2*k)]} ] [4*splimd1[k]];
		assign imd2 [k][1] = sbox [ {key[8*(r+2*k)+1],key[8*(r+2*k)]} ] [4*splimd1[k]+1];
		assign imd2 [k][2] = sbox [ {key[8*(r+2*k)+1],key[8*(r+2*k)]} ] [4*splimd1[k]+2];
		assign imd2 [k][3] = sbox [ {key[8*(r+2*k)+1],key[8*(r+2*k)]} ] [4*splimd1[k]+3];
	end
endgenerate
wire [7:0] imd3[0:3];
generate
	for (k=0; k<4; k=k+1)
	begin
		assign imd3 [0][k]	= imd2 [4][k];
		assign imd3 [0][k+4]	= imd2 [5][k];
		assign imd3 [1][k]	= imd2 [6][k];
		assign imd3 [1][k+4]	= imd2 [7][k];
		assign imd3 [2][k]	= imd2 [0][k];
		assign imd3 [2][k+4]	= imd2 [1][k];
		assign imd3 [3][k]	= imd2 [2][k];
		assign imd3 [3][k+4]	= imd2 [3][k];
	end
endgenerate

wire [7:0] a1, a2, a3, a4;
wire [7:0] b1, b2, b3, b4;
wire [7:0] x1, x2, x3, x4;
reg [7:0] y1, y2, y3, y4;
wire [7:0] z1, z2, z3, z4;
assign a1 = imd3 [0];
assign a2 = imd3 [1];
assign a3 = imd3 [2];
assign a4 = imd3 [3];
assign x1=a1<<1;
assign x2=a2<<1;
assign x3=a3<<1;
assign x4=a4<<1;
always@(posedge clk)
begin
	if (a1[7]==1)
	begin
	y1=(x1^8'h1B);
	end
	else
	begin
	y1=x1;
	end
	if (a2[7]==1)
	begin
	y2=(x2^8'h1B);
	end
	else
	begin
	y2=x2;
	end
	if (a3[7]==1)
	begin
	y3=(x3^8'h1B);
	end
	else
	begin
	y3=x3;
	end
	if (a4[7]==1)
	begin
	y4=(x4^8'h1B);
	end
	else
	begin
	y4=x4;
	end
end
assign z1=(y1^a1);
assign z2=(y2^a2);
assign z3=(y3^a3);
assign z4=(y4^a4);
assign b1=(y1^z2^a3^a4);
assign b2=(a1^y2^z3^a4);
assign b3=(a1^a2^y3^z4);
assign b4=(z1^a2^a3^y4);
wire [7:0] bimd3 [0:3];
assign bimd3 [0]= b1;
assign bimd3 [1]= b2;
assign bimd3 [2]= b3;
assign bimd3 [3]= b4;

reg [7:0] imd4[0:3];
always@(posedge clk)
begin
if (r==0||r==8)
	begin
		imd4 [0][7:0]<={bimd3 [0][6:0],bimd3 [0][7]};
		imd4 [1][7:0]<={bimd3 [1][6:0],bimd3 [1][7]};
		imd4 [2][7:0]<={bimd3 [2][6:0],bimd3 [2][7]};
		imd4 [3][7:0]<={bimd3 [3][6:0],bimd3 [3][7]};
	end
else if (r==1||r==9)
	begin
		imd4 [0][7:0]<={bimd3 [0][5:0],bimd3 [0][7:6]};
		imd4 [1][7:0]<={bimd3 [1][5:0],bimd3 [1][7:6]};
		imd4 [2][7:0]<={bimd3 [2][5:0],bimd3 [2][7:6]};
		imd4 [3][7:0]<={bimd3 [3][5:0],bimd3 [3][7:6]};
	end
else if (r==2||r==10)
	begin
		imd4 [0][7:0]<={bimd3 [0][4:0],bimd3 [0][7:5]};
		imd4 [1][7:0]<={bimd3 [1][4:0],bimd3 [1][7:5]};
		imd4 [2][7:0]<={bimd3 [2][4:0],bimd3 [2][7:5]};
		imd4 [3][7:0]<={bimd3 [3][4:0],bimd3 [3][7:5]};
	end
else if (r==3||r==11)
	begin
		imd4 [0][7:0]<={bimd3 [0][3:0],bimd3 [0][7:4]};
		imd4 [1][7:0]<={bimd3 [1][3:0],bimd3 [1][7:4]};
		imd4 [2][7:0]<={bimd3 [2][3:0],bimd3 [2][7:4]};
		imd4 [3][7:0]<={bimd3 [3][3:0],bimd3 [3][7:4]};
	end
else if (r==4||r==12)
	begin
		imd4 [0][7:0]<={bimd3 [0][2:0],bimd3 [0][7:3]};
		imd4 [1][7:0]<={bimd3 [1][2:0],bimd3 [1][7:3]};
		imd4 [2][7:0]<={bimd3 [2][2:0],bimd3 [2][7:3]};
		imd4 [3][7:0]<={bimd3 [3][2:0],bimd3 [3][7:3]};
	end
else if (r==5||r==13)
	begin
		imd4 [0][7:0]<={bimd3 [0][1:0],bimd3 [0][7:2]};
		imd4 [1][7:0]<={bimd3 [1][1:0],bimd3 [1][7:2]};
		imd4 [2][7:0]<={bimd3 [2][1:0],bimd3 [2][7:2]};
		imd4 [3][7:0]<={bimd3 [3][1:0],bimd3 [3][7:2]};
	end
else if (r==6||r==14)
	begin
		imd4 [0][7:0]<={bimd3 [0][0],bimd3 [0][7:1]};
		imd4 [1][7:0]<={bimd3 [1][0],bimd3 [1][7:1]};
		imd4 [2][7:0]<={bimd3 [2][0],bimd3 [2][7:1]};
		imd4 [3][7:0]<={bimd3 [3][0],bimd3 [3][7:1]};
	end
else
	begin
		imd4 [0][7:0]<=bimd3 [0][7:0];
		imd4 [1][7:0]<=bimd3 [1][7:0];
		imd4 [2][7:0]<=bimd3 [2][7:0];
		imd4 [3][7:0]<=bimd3 [3][7:0];
	end
end
/*generate
	for (k=0; k<4; k=k+1)
	begin
		assign imd4 [k][0] = imd3 [k][7];
		assign imd4 [k][1] = imd3 [k][6];
		assign imd4 [k][2] = imd3 [k][5];
		assign imd4 [k][3] = imd3 [k][4];
		assign imd4 [k][4] = imd3 [k][3];
		assign imd4 [k][5] = imd3 [k][2];
		assign imd4 [k][6] = imd3 [k][1];
		assign imd4 [k][7] = imd3 [k][0];
	end
endgenerate*/
wire [7:0] imd5[0:3];
generate
	for (k=0; k<8; k=k+1)
	begin
		xor(imd5[0][k], imd4[0][k], key[k+224-8*r]);
		xor(imd5[1][k], imd4[1][k], key[k+232-8*r]);
		xor(imd5[2][k], imd4[2][k], key[k+240-8*r]);
		xor(imd5[3][k], imd4[3][k], key[k+248-8*r]);
	end
endgenerate
always@(posedge clk)
begin
	out1=imd5[0];
	out2=imd5[1];
	out3=imd5[2];
	out4=imd5[3];
end
endmodule
