//`include "Def.v"
/*
module  decoder(instr,source_1,source_2,dest,decoder_out);
input [31:0]instr;
output [4:0]source_1,source_2,dest;
output reg [7:0] decoder_out;

assign source_1 = instr[19:15];
assign source_2 = instr[24:20];
assign dest = instr[11:7];

parameter last_fourbits = 2'b00,jalr_load_fourbits = 2'b01,jal_last_fourbits = 2'b11;

always@(instr)
begin
   case(instr[6:2])

	{`R_type,last_fourbits}:	decoder_out 	=	{instr[30],instr[14:12],`R_type_out};
	
	{`I_type,last_fourbits}: 	decoder_out 	=	{instr[30],instr[14:12],`I_type_out};

	{`I_type_load,last_fourbits}: 	decoder_out 	=	{instr[30],instr[14:12],`I_type_load_out};

	{`S_type,last_fourbits}: 	decoder_out 	=	{instr[30],instr[14:12],`S_type_out};

	{`B_type,last_fourbits}: 	decoder_out 	=	{instr[30],instr[14:12],`B_type_out};

	{`J_type,jal_last_fourbits}: 	decoder_out 	=	{instr[30],instr[14:12],`J_type_JAL};

	{`J_type,jalr_load_fourbits}: 	decoder_out 	=	{instr[30],instr[14:12],`I_type_JALR};

	{`U_type_LUI,jalr_load_fourbits}: decoder_out 	=	{instr[30],instr[14:12],`U_type_LUI_out};

	{`U_type_AUIPC,jalr_load_fourbits}: decoder_out 	=	{instr[30],instr[14:12],`U_type_AUIPC_out};

	default : decoder_out = {4'b0_000,`R_type_out};

   endcase
end
endmodule
*/

//instruction decoder with pipeline register1(stall)
module decoder(instr_in,bypass_stall,clk,reset,stall,pc_imm_in,pc_4_in,wrong_predict_in,/*branching*/,source_reg_1,source_reg_2,dest_reg,opcode_out,funct_3_out,funct_7_out,load_itype,instr_out,pc_imm_out,pc_4_out);

input		[31:0]		instr_in,pc_imm_in,pc_4_in;
input				clk,stall,wrong_predict_in,reset,bypass_stall;
output reg	[4:0]		source_reg_1,source_reg_2,dest_reg;
output reg	[6:0] 		opcode_out;
output reg	[2:0]		funct_3_out;
output reg	[6:0]		funct_7_out;
output reg	[24:0]		instr_out;
reg 		[31:0]		decode_instr,inter_decode,decode_instr_inter;
reg bypass_in;
output load_itype;
output reg [31:0] pc_imm_out,pc_4_out;
//wire [31:0] b_type;

assign load_itype	=	(~instr_in[6] & ~instr_in[5] & ~instr_in[4] & ~instr_in[3] & ~instr_in[2] & instr_in[1] & instr_in[0]);
assign stall_in		=	(stall | wrong_predict_in | reset);
//assign b_type = {{20{instr_in[31]}},instr_in[7],instr_in[30:25],instr_in[11:8],1'b0};
//assign j_type = {{12{instr_in[31]}},instr_in[19:12],instr_in[20],instr_in[30:21],1'b0};
/*
always@(branching_in or imm_in or b_type)
begin
case(branching_in)
1'b0: imm_out = imm_in;

1'b1: imm_out = b_type;

default : imm_out = imm_in;
endcase
end
*/
always@(*)
begin
//inter_decode	=	decode_instr;
decode_instr	= 	32'h0000_0013;
case(stall_in)

	1'b1:	begin
		decode_instr_inter	= 	32'h0000_0013;
		end

	1'b0:	begin
		//decode_instr	= 	32'h0000_0013;
		decode_instr_inter 	= 	instr_in;
		end 

	default:decode_instr_inter	= 	instr_in;

endcase
		if(~bypass_stall)
		begin
		decode_instr	= 	decode_instr_inter;// addi x0,x0,x0
		end
		else
		begin
		decode_instr	= 	inter_decode;
		end
end

always@(posedge clk)
begin

//enable_in = ((instr_in[4]) & (decode_instr[3]) & (~opcode_in[2]) & (~opcode_in[1]) & (~opcode_in[0]));
pc_imm_out	<=	pc_imm_in;
pc_4_out	<=	pc_4_in;
source_reg_1 	<= 	decode_instr[19:15];
source_reg_2 	<= 	decode_instr[24:20];
dest_reg 	<= 	decode_instr[11:7];
opcode_out 	<= 	decode_instr[6:0];
funct_3_out 	<= 	decode_instr[14:12];
funct_7_out 	<= 	decode_instr[31:25];
instr_out 	<= 	decode_instr[31:7];
inter_decode	<=	decode_instr;
end
endmodule

