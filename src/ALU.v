`include "Def.v"

module alu_riscv(operand_1,operand_2,aluop,out);

input	[31:0]	operand_1,operand_2;
input	[3:0]	aluop;

output reg [31:0] out;
//reg 	[31:0]	alu_operand,operand1_select;
wire 	[31:0] 	addr_in,sub_in,xor_in,or_in,and_in,sll_in,srl_in,sra_in;
wire 		slt_in,sltu_in;
wire signed [31:0] rs_op1;

/*
always@(*)
begin

case(irmux1_in)

2'b00: operand1_select 	= operand_1;
2'b01: operand1_select 	= execute_bypass_in;
2'b10: operand1_select 	= wb_bypass_in;
2'b11: operand1_select 	= operand_1;

default: operand1_select = operand_1;
endcase
end

always@(*)
begin

case(irmux2_in)

2'b00: alu_operand 	= operand_2;
2'b01: alu_operand 	= execute_bypass_in;
2'b10: alu_operand 	= wb_bypass_in;
2'b11: alu_operand 	= imm;

default: alu_operand 	= operand_2;
endcase
end
*/
assign rs_op1 	= 	operand_1;
assign addr_in 	= 	operand_1 + operand_2;
assign sub_in 	= 	operand_1 - operand_2;
assign xor_in 	= 	operand_1 ^ operand_2;
assign or_in 	= 	operand_1 | operand_2;
assign and_in 	= 	operand_1 & operand_2;
assign sll_in	= 	operand_1 << operand_2[4:0];
assign srl_in 	= 	operand_1 >> operand_2[4:0];
assign sra_in 	= 	operand_1 >>> operand_2[4:0];


assign slt_in 	=  	(rs_op1 < operand_2);
assign sltu_in 	= 	(operand_1 < operand_2);



always @(*)
begin
   out = 32'h0000_0000;
   case(aluop)
	`ADD: 	out 	= 	addr_in;
	`SUB: 	out 	= 	sub_in;
	`XOR: 	out 	= 	xor_in;	
	`OR: 	out 	= 	or_in;	
	`AND: 	out 	= 	and_in;	
	`SLL: 	out 	= 	sll_in;	
	`SRL: 	out 	= 	srl_in;	
	`SRA: 	out 	= 	sra_in;
	`SLT: 	out 	= 	{31'b0,slt_in};	
	`SLTU: 	out 	= 	{31'b0,sltu_in};
   endcase
end

endmodule
/*

module store_unit(mem_wr,funct3_in,enable,addr_in,rs2_in,addr_in,addr_out,rs2_out,wb_mask_out,addr_out,wr_req_out);

input mem_wr,enable;
input [31:0] rs2_in,addr_in;
input [1:0] funct3_in;
output reg [31:0] rs2_out;
output reg [3:0] wb_mask_out;
output [31:0] addr_out;
output wr_req_out;
reg [3:0] byte_mask,half_word_mask;
reg [31:0] byte_out,half_word_out;

assign addr_out = {addr_in[31:2],2'b0};
assign wr_req_out = mem_wr;

always@(addr_in or mem_wr)
begin
case(addr_in[1:0])

2'b00: byte_mask = {3'b0,mem_wr};
2'b01: byte_mask = {2'b0,mem_wr,1'b0};
2'b10: byte_mask = {1'b0,mem_wr,2'b0};
2'b11: byte_mask = {mem_wr,3'b0};
endcase
end

always@(addr_in or mem_wr)
begin
case(addr_in[1])

1'b0: half_word_mask = {2'b0,{2{mem_wr}}};
1'b1: half_word_mask = {{2{mem_wr}},2'b0};
endcase
end


always@(addr_in or mem_wr)
begin
case(addr_in[1:0])

2'b00: byte_out = {8'b0,8'b0,8'b0,rs2_in[7:0]};
2'b01: byte_out = {16'b0,rs2_in[15:8],8'b0};
2'b10: byte_out = {8'b0,rs2_in[23:16],8'b0,8'b0};
2'b11: byte_out = {rs2_in[31:24],8'b0,8'b0,8'b0};
endcase
end

always@(addr_in or mem_wr)
begin
case(addr_in[1])

1'b0: half_word_out = {16'b0,rs2_in[15:0]};
1'b1: half_word_out = {rs2_in[31:16],16'b0};
endcase
end

always@(funct3_in or byte_mask or half_word_mask or mem_wr)
begin
case(funct3_in)

2'b00: wb_mask_out = byte_mask;
2'b01: wb_mask_out = half_word_mask;
default: wb_mask_out = {4{mem_wr}};
endcase
end

always@(funct3_in or byte_out or rs2_in or half_word_out)
begin
case(funct3_in)

2'b00: rs2_out = byte_out;
2'b01: rs2_out = half_word_out;
default: rs2_out = rs2_in;
endcase
end

endmodule


module load_unit(load_funct3_in,load_in,data_in,iaddr_in,load_output);

input [31:0] data_in;
input [2:0] load_funct3_in;
input load_in;
input [1:0] iaddr_in;

output reg [31:0] load_output;
reg [7:0] byte_pos;
reg [15:0] half_word_pos;
reg byte_sign,half_word_sign;

always@(data_in or iaddr_in)
begin
case(iaddr_in)

2'b00:	byte_pos = data_in[7:0];
2'b01: 	byte_pos = data_in[15:8];
2'b10: 	byte_pos = data_in[23:16];
2'b11: 	byte_pos = data_in[31:24];

endcase
end

always@(data_in or iaddr_in)
begin
case(iaddr_in[1])

1'b0:	half_word_pos = data_in[15:0];
1'b1: 	half_word_pos = data_in[31:16];

endcase
end


always@(load_funct3_in or data_in)
begin
case(load_funct3_in[2])

1'b0:	begin
	byte_sign = byte_pos[7];
	half_word_sign = half_word_pos[15];
	end

1'b1: 	begin
	byte_sign = 1'b0;
	half_word_sign = 1'b0;
	end

endcase
end

always@(*)
begin
case(load_funct3_in[1:0])

2'b00:	load_output = {{24{byte_sign}},byte_pos};
2'b01:	load_output = {{16{half_word_sign}},half_word_pos};
2'b10:	load_output = data_in;
2'b11:	load_output = data_in;
endcase
end

endmodule


module branch_unit(funct3_in,opcode_in,source_1,source_2,branch_out,jalr_enable);

input [31:0] source_1,source_2;
input [4:0] opcode_in;
input [2:0] funct3_in;
reg [3:0] alu_op;
output jalr_enable;
output reg branch_out;
reg [3:0] aluop;
wire beq_op,bne_op,blt_op,bge_op,jal_op,enable,jal_enable;
wire signed [31:0] signed_rs1,signed_rs2;

assign enable = ((opcode_in[4]) & (opcode_in[3]) & (!opcode_in[2]) & (!opcode_in[1]) & (!opcode_in[0]));
assign jal_enable = ((opcode_in[4]) & (opcode_in[3]) & (!opcode_in[2]) & (opcode_in[1]) & (opcode_in[0]));
assign jalr_enable = ((opcode_in[4]) & (opcode_in[3]) & (!opcode_in[2]) & (!opcode_in[1]) & (opcode_in[0]));

assign signed_rs1 	= source_1;
assign signed_rs2 	= source_2;
assign beq_op 		= (source_1 == source_2);
assign bne_op 		= (source_1 != source_2);
assign blt_op 		= (signed_rs1 < source_2);
assign bge_op 		= (source_1 >= signed_rs2);
assign bltu_op 		= (source_1 < source_2);
assign bgeu_op 		= (source_1 >= source_2);

always@(funct3_in)
begin

case(funct3_in)

3'b000:	aluop = `BEQ;
3'b001:	aluop = `BNE;
3'b100:	aluop = `BLT;
3'b101:	aluop = `BGE;
3'b110:	aluop = `BLTU;
3'b111:	aluop = `BGEU;
default: aluop = 4'bzzzz;
endcase

alu_op = (enable)? aluop : 4'bzzzz;
end


always@(*)
begin

case(alu_op)

	`BEQ: branch_out 	= beq_op;

	`BNE: branch_out 	= bne_op;

	`BLT: branch_out 	= blt_op;

	`BGE: branch_out 	= bge_op;

	`BLTU: branch_out 	= bltu_op;

	`BGEU: branch_out 	= bgeu_op;

	default: branch_out 	= 1'b0;

endcase
end

always@(jalr_enable)
begin
if(jalr_enable)
begin
branch_out = 1'b1;
end
else
begin
branch_out = 1'b0;
end
end

always@(jal_enable)
begin
if(jal_enable)
begin
branch_out = 1'b1;
end
else
begin
branch_out = 1'b0;
end
end



endmodule

//2-bit dynamic branch prediction
module branch_prediction_unit(clk,reset, branch_in,branch_taken_out);

input clk, branch_in,reset;
output branch_taken_out;

parameter SLT = 2'b00,LT = 2'b01,NLT = 2'b10, SNLT = 2'b11;

reg [1:0] STATE,NEXT_STATE;

//STATE = SLT;

task taken_branch(input branching,input [1:0] NS_logic_1,input [1:0] NS_logic_2,output reg [1:0] NS);
begin
case(branching)

1'b0: NS = NS_logic_2;
1'b1: NS= NS_logic_1;
default: NS= NS_logic_1;

endcase
end
endtask

always@(posedge clk)
begin
if(reset)
begin
STATE <= SLT;
end
else
begin
STATE <= NEXT_STATE;
end
end

always@(STATE or branch_in)
begin
case(STATE)

SLT: 	taken_branch(branch_in,SLT,LT,NEXT_STATE);

LT: 	taken_branch(branch_in,SLT,NLT,NEXT_STATE);

NLT: 	taken_branch(branch_in,LT,SNLT,NEXT_STATE);

SNLT: 	taken_branch(branch_in,NLT,SNLT,NEXT_STATE);

//default: NEXT_STATE = SLT;
endcase
end


assign branch_taken_out = ((STATE == SLT) | (STATE == LT));

endmodule




*/









