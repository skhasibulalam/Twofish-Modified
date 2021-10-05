module decralp (
	input [7:0] in1, in2, in3, in4,
	input clk,
	input [255:0] key,
	input [3:0] r,
	//input rst;
	output reg [7:0] out1, out2, out3, out4);
//wire [255:0] key;
//assign key=256'hf4_4d_7a_15_c9_99_1a_9f_85_40_ff_23_98_a8_b2_b1_52_b7_5d_11_54_f3_f7_d3_c2_cc_2c_22_10_16_23_30;
genvar k;
wire [7:0] imd5[0:3];
generate
	for (k=0; k<8; k=k+1)
	begin
		xor(imd5[0][k], in1[k], key[k+224-8*r]);
		xor(imd5[1][k], in2[k], key[k+232-8*r]);
		xor(imd5[2][k], in3[k], key[k+240-8*r]);
		xor(imd5[3][k], in4[k], key[k+248-8*r]);
	end
endgenerate
reg [7:0] imd4[0:3];
always@(posedge clk)
begin
if (r==0||r==8)
	begin
		imd4 [0][7:0]<={imd5 [0][0],imd5 [0][7:1]};
		imd4 [1][7:0]<={imd5 [1][0],imd5 [1][7:1]};
		imd4 [2][7:0]<={imd5 [2][0],imd5 [2][7:1]};
		imd4 [3][7:0]<={imd5 [3][0],imd5 [3][7:1]};
	end
else if (r==1||r==9)
	begin
		imd4 [0][7:0]<={imd5 [0][1:0],imd5 [0][7:2]};
		imd4 [1][7:0]<={imd5 [1][1:0],imd5 [1][7:2]};
		imd4 [2][7:0]<={imd5 [2][1:0],imd5 [2][7:2]};
		imd4 [3][7:0]<={imd5 [3][1:0],imd5 [3][7:2]};
	end
else if (r==2||r==10)
	begin
		imd4 [0][7:0]<={imd5 [0][2:0],imd5 [0][7:3]};
		imd4 [1][7:0]<={imd5 [1][2:0],imd5 [1][7:3]};
		imd4 [2][7:0]<={imd5 [2][2:0],imd5 [2][7:3]};
		imd4 [3][7:0]<={imd5 [3][2:0],imd5 [3][7:3]};
	end
else if (r==3||r==11)
	begin
		imd4 [0][7:0]<={imd5 [0][3:0],imd5 [0][7:4]};
		imd4 [1][7:0]<={imd5 [1][3:0],imd5 [1][7:4]};
		imd4 [2][7:0]<={imd5 [2][3:0],imd5 [2][7:4]};
		imd4 [3][7:0]<={imd5 [3][3:0],imd5 [3][7:4]};
	end
else if (r==4||r==12)
	begin
		imd4 [0][7:0]<={imd5 [0][4:0],imd5 [0][7:5]};
		imd4 [1][7:0]<={imd5 [1][4:0],imd5 [1][7:5]};
		imd4 [2][7:0]<={imd5 [2][4:0],imd5 [2][7:5]};
		imd4 [3][7:0]<={imd5 [3][4:0],imd5 [3][7:5]};
	end
else if (r==5||r==13)
	begin
		imd4 [0][7:0]<={imd5 [0][5:0],imd5 [0][7:6]};
		imd4 [1][7:0]<={imd5 [1][5:0],imd5 [1][7:6]};
		imd4 [2][7:0]<={imd5 [2][5:0],imd5 [2][7:6]};
		imd4 [3][7:0]<={imd5 [3][5:0],imd5 [3][7:6]};
	end
else if (r==6||r==14)
	begin
		imd4 [0][7:0]<={imd5 [0][6:0],imd5 [0][7]};
		imd4 [1][7:0]<={imd5 [1][6:0],imd5 [1][7]};
		imd4 [2][7:0]<={imd5 [2][6:0],imd5 [2][7]};
		imd4 [3][7:0]<={imd5 [3][6:0],imd5 [3][7]};
	end
else
	begin
		imd4 [0][7:0]<=imd5 [0][7:0];
		imd4 [1][7:0]<=imd5 [1][7:0];
		imd4 [2][7:0]<=imd5 [2][7:0];
		imd4 [3][7:0]<=imd5 [3][7:0];
	end
end
/*generate
	for (k=0; k<4; k=k+1)
	begin
		assign imd4 [k][0] = imd5 [k][7];
		assign imd4 [k][1] = imd5 [k][6];
		assign imd4 [k][2] = imd5 [k][5];
		assign imd4 [k][3] = imd5 [k][4];
		assign imd4 [k][4] = imd5 [k][3];
		assign imd4 [k][5] = imd5 [k][2];
		assign imd4 [k][6] = imd5 [k][1];
		assign imd4 [k][7] = imd5 [k][0];
	end
endgenerate*/

wire [7:0] a1, a2, a3, a4;
wire [7:0] b1, b2, b3, b4;
wire [7:0] x1, x2, x3, x4;
reg [7:0] y1, y2, y3, y4;
wire [7:0] z1, z2, z3, z4;
assign a1 = imd4 [0];
assign a2 = imd4 [1];
assign a3 = imd4 [2];
assign a4 = imd4 [3];
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

wire [7:0] p1, p2, p3, p4;
reg [7:0] q1, q2, q3, q4;
wire [7:0] r1, r2, r3, r4;
assign p1=y1<<1;
assign p2=y2<<1;
assign p3=y3<<1;
assign p4=y4<<1;
always@(posedge clk)
begin
	if (y1[7]==1)
	begin
	q1=(p1^8'h1B);
	end
	else
	begin
	q1=p1;
	end
	if (y2[7]==1)
	begin
	q2=(p2^8'h1B);
	end
	else
	begin
	q2=p2;
	end
	if (y3[7]==1)
	begin
	q3=(p3^8'h1B);
	end
	else
	begin
	q3=p3;
	end
	if (y4[7]==1)
	begin
	q4=(p4^8'h1B);
	end
	else
	begin
	q4=p4;
	end
end
assign r1=(q1^a1);
assign r2=(q2^a2);
assign r3=(q3^a3);
assign r4=(q4^a4);

wire [7:0] s1, s2, s3, s4;
reg [7:0] t1, t2, t3, t4;
wire [7:0] u1, u2, u3, u4;
assign s1=q1<<1;
assign s2=q2<<1;
assign s3=q3<<1;
assign s4=q4<<1;
always@(posedge clk)
begin
	if (q1[7]==1)
	begin
	t1=(s1^8'h1B);
	end
	else
	begin
	t1=s1;
	end
	if (q2[7]==1)
	begin
	t2=(s2^8'h1B);
	end
	else
	begin
	t2=s2;
	end
	if (q3[7]==1)
	begin
	t3=(s3^8'h1B);
	end
	else
	begin
	t3=s3;
	end
	if (q4[7]==1)
	begin
	t4=(s4^8'h1B);
	end
	else
	begin
	t4=s4;
	end
end
assign u1=(t1^a1);
assign u2=(t2^a2);
assign u3=(t3^a3);
assign u4=(t4^a4);

wire [7:0] d1, d2, d3, d4;
reg [7:0] e1, e2, e3, e4;
wire [7:0] f1, f2, f3, f4;
assign d1=r1<<1;
assign d2=r2<<1;
assign d3=r3<<1;
assign d4=r4<<1;
always@(posedge clk)
begin
	if (r1[7]==1)
	begin
	e1=(d1^8'h1B);
	end
	else
	begin
	e1=d1;
	end
	if (r2[7]==1)
	begin
	e2=(d2^8'h1B);
	end
	else
	begin
	e2=d2;
	end
	if (r3[7]==1)
	begin
	e3=(d3^8'h1B);
	end
	else
	begin
	e3=d3;
	end
	if (r4[7]==1)
	begin
	e4=(d4^8'h1B);
	end
	else
	begin
	e4=d4;
	end
end
assign f1=(e1^a1);
assign f2=(e2^a2);
assign f3=(e3^a3);
assign f4=(e4^a4);

wire [7:0] g1, g2, g3, g4;
reg [7:0] h1, h2, h3, h4;
wire [7:0] i1, i2, i3, i4;
assign g1=z1<<1;
assign g2=z2<<1;
assign g3=z3<<1;
assign g4=z4<<1;
always@(posedge clk)
begin
	if (z1[7]==1)
	begin
	h1=(g1^8'h1B);
	end
	else
	begin
	h1=g1;
	end
	if (z2[7]==1)
	begin
	h2=(g2^8'h1B);
	end
	else
	begin
	h2=g2;
	end
	if (z3[7]==1)
	begin
	h3=(g3^8'h1B);
	end
	else
	begin
	h3=g3;
	end
	if (z4[7]==1)
	begin
	h4=(g4^8'h1B);
	end
	else
	begin
	h4=g4;
	end
end
assign i1=(h1^a1);
assign i2=(h2^a2);
assign i3=(h3^a3);
assign i4=(h4^a4);

wire [7:0] j1, j2, j3, j4;
reg [7:0] k1, k2, k3, k4;
wire [7:0] l1, l2, l3, l4;
assign j1=h1<<1;
assign j2=h2<<1;
assign j3=h3<<1;
assign j4=h4<<1;
always@(posedge clk)
begin
	if (h1[7]==1)
	begin
	k1=(j1^8'h1B);
	end
	else
	begin
	k1=j1;
	end
	if (h2[7]==1)
	begin
	k2=(j2^8'h1B);
	end
	else
	begin
	k2=j2;
	end
	if (h3[7]==1)
	begin
	k3=(j3^8'h1B);
	end
	else
	begin
	k3=j3;
	end
	if (h4[7]==1)
	begin
	k4=(j4^8'h1B);
	end
	else
	begin
	k4=j4;
	end
end
assign l1=(k1^a1);
assign l2=(k2^a2);
assign l3=(k3^a3);
assign l4=(k4^a4);

wire [7:0] m1, m2, m3, m4;
reg [7:0] n1, n2, n3, n4;
assign m1=i1<<1;
assign m2=i2<<1;
assign m3=i3<<1;
assign m4=i4<<1;
always@(posedge clk)
begin
	if (i1[7]==1)
	begin
	n1=(m1^8'h1B);
	end
	else
	begin
	n1=m1;
	end
	if (i2[7]==1)
	begin
	n2=(m2^8'h1B);
	end
	else
	begin
	n2=m2;
	end
	if (i3[7]==1)
	begin
	n3=(m3^8'h1B);
	end
	else
	begin
	n3=m3;
	end
	if (i4[7]==1)
	begin
	n4=(m4^8'h1B);
	end
	else
	begin
	n4=m4;
	end
end
assign b1=(n1^f2^l3^u4);
assign b2=(u1^n2^f3^l4);
assign b3=(l1^u2^n3^f4);
assign b4=(f1^l2^u3^n4);
wire [7:0] bimd4[0:3];
assign bimd4 [0] = b1;
assign bimd4 [1] = b2;
assign bimd4 [2] = b3;
assign bimd4 [3] = b4;

wire [3:0] imd3[0:7];
generate
	for (k=0; k<4; k=k+1)
	begin
		assign imd3 [4][k] = bimd4 [0][k];
		assign imd3 [5][k] = bimd4 [0][k+4];
		assign imd3 [6][k] = bimd4 [1][k];
		assign imd3 [7][k] = bimd4 [1][k+4];
		assign imd3 [0][k] = bimd4 [2][k];
		assign imd3 [1][k] = bimd4 [2][k+4];
		assign imd3 [2][k] = bimd4 [3][k];
		assign imd3 [3][k] = bimd4 [3][k+4];
	end
endgenerate
wire [63:0] sbox[0:3];
assign sbox[0]=64'h0123456789ABCDEF;
assign sbox[1]=64'h543210EDCBA9876F;
assign sbox[2]=64'hBA9EDC601572438F;
assign sbox[3]=64'hEDC01245B3A6987F;
wire [3:0] imd2[0:7];
generate
	for (k=0; k<8; k=k+1)
	begin
		assign imd2 [k][0] = sbox [ {key[8*(r+2*k)+1],key[8*(r+2*k)]} ] [4*imd3 [k]];
		assign imd2 [k][1] = sbox [ {key[8*(r+2*k)+1],key[8*(r+2*k)]} ] [4*imd3 [k]+1];
		assign imd2 [k][2] = sbox [ {key[8*(r+2*k)+1],key[8*(r+2*k)]} ] [4*imd3 [k]+2];
		assign imd2 [k][3] = sbox [ {key[8*(r+2*k)+1],key[8*(r+2*k)]} ] [4*imd3 [k]+3];
	end
endgenerate
wire [7:0] splimd1[0:3];
generate
	for (k=0; k<4; k=k+1)
	begin
		assign splimd1 [0][k]	= imd2 [0][k];
		assign splimd1 [0][k+4] = imd2 [1][k];
		assign splimd1 [1][k]	= imd2 [2][k];
		assign splimd1 [1][k+4] = imd2 [3][k];
		assign splimd1 [2][k]	= imd2 [4][k];
		assign splimd1 [2][k+4] = imd2 [5][k];
		assign splimd1 [3][k]	= imd2 [6][k];
		assign splimd1 [3][k+4] = imd2 [7][k];
	end
endgenerate
wire [7:0] imd1[0:3];
generate
	for (k=0; k<8; k=k+1)
	begin
		xor(imd1[0][k], splimd1[0][k], key[k+8*r]);
		xor(imd1[1][k], splimd1[1][k], key[k+8+8*r]);
		xor(imd1[2][k], splimd1[2][k], key[k+16+8*r]);
		xor(imd1[3][k], splimd1[3][k], key[k+24+8*r]);
	end
endgenerate
always@(posedge clk)
begin
	out1=imd1[0];
	out2=imd1[1];
	out3=imd1[2];
	out4=imd1[3];
end
endmodule
