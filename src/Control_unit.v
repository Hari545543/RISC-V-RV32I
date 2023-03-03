`include "Def.v"

module control_unit(clk,reset,load_type_in,opcode_in,funct3_in,funct7_in,werf_contrl,wbmux_contol,stall,aluop,ir_mux,ready_in,op_format_out,bypass_ir1,bypass_ir2,out_u_type,sb_type,out_u_type,reg_u_type_lui,i_type_load);

input [6:0] opcode_in;
input [2:0] funct3_in;
input funct7_in,clk,reset,load_type_in;
output reg werf_contrl;
output reg [1:0] wbmux_contol;
output reg [3:0] aluop;
output reg [1:0] ir_mux;
output stall,out_u_type;
output reg reg_u_type_lui;
output reg [2:0] op_format_out;
output bypass_ir1,bypass_ir2,sb_type;
reg [2:0] op_format;
reg reg_ready_in;
output reg ready_in;
//wire jalr_type;
wire out_u_type;
//wire intermed_op,jtype_op,utype_lui_op,utype_auipc_op;
reg inter_ir_mux;
wire u_type_auipc,b_type,j_type,r_type,s_type,i_type,i_type_jalr,u_type_lui;
output i_type_load;

parameter FETCH = 1'b0,LOAD_STALL = 1'b1;

//assign werf_inter = 

reg STATE,NEXT_STATE;

//assign stall = ((~load_type_in) & (NEXT_STATE == LOAD_STALL));



always@(posedge clk)
begin
//stall = inter_stall;
if(reset)
begin
STATE <= FETCH;
end
else
begin
STATE <= NEXT_STATE;
end
reg_u_type_lui <= u_type_lui;
end
/*
assign jalr_type = (opcode_in[4] & opcode_in[3] & ~opcode_in[2] & ~opcode_in[1] & opcode_in[0]);

assign intermed_op = ((&opcode_in[1:0]) | ((opcode_in[0])& (~opcode_in[1])));
//signal for imm gen
assign jtype_op 	= 	(opcode_in[4] & opcode_in[3] & ~opcode_in[2] & opcode_in[1]);
assign utype_lui_op 	= 	(~opcode_in[4] & opcode_in[3] & opcode_in[2] & ~opcode_in[1] & opcode_in[0]);
assign utype_auipc_op	= 	(~opcode_in[4] & ~opcode_in[3] & opcode_in[2] & ~opcode_in[1] & opcode_in[0]);
assign itype_load_op	=	&(~opcode_in);
*/
//assign

assign r_type		= (~opcode_in[6] & opcode_in[5] & opcode_in[4] & ~opcode_in[3] & ~opcode_in[2] & opcode_in[1] & opcode_in[0]);
assign i_type		= (~opcode_in[6] & ~opcode_in[5] & opcode_in[4] & ~opcode_in[3] & ~opcode_in[2] & opcode_in[1] & opcode_in[0]);
assign i_type_load	= (~opcode_in[6] & ~opcode_in[5] & ~opcode_in[4] & ~opcode_in[3] & ~opcode_in[2] & opcode_in[1] & opcode_in[0]);
assign s_type		= (~opcode_in[6] & opcode_in[5] & ~opcode_in[4] & ~opcode_in[3] & ~opcode_in[2] & opcode_in[1] & opcode_in[0]);
assign b_type		= (opcode_in[6] & opcode_in[5] & ~opcode_in[4] & ~opcode_in[3] & ~opcode_in[2] & opcode_in[1] & opcode_in[0]);
assign i_type_jalr	= (opcode_in[6] & opcode_in[5] & ~opcode_in[4] & ~opcode_in[3] & opcode_in[2] & opcode_in[1] & opcode_in[0]);
assign j_type		= (opcode_in[6] & opcode_in[5] & ~opcode_in[4] & opcode_in[3] & opcode_in[2] & opcode_in[1] & opcode_in[0]) | i_type_jalr;
assign u_type_lui	= (~opcode_in[6] & opcode_in[5] & opcode_in[4] & ~opcode_in[3] & opcode_in[2] & opcode_in[1] & opcode_in[0]);
assign u_type_auipc	= (~opcode_in[6] & ~opcode_in[5] & opcode_in[4] & ~opcode_in[3] & opcode_in[2] & opcode_in[1] & opcode_in[0]);

assign bypass_ir2	= r_type | s_type | b_type;
assign out_u_type	= (u_type_lui | u_type_auipc);
assign bypass_ir1	= ~(j_type | out_u_type);
assign sb_type		= (b_type | s_type);

assign stall = (i_type_load & ~load_type_in);

always@(*)
begin
case(STATE)

FETCH:	begin
	ready_in 	= i_type_jalr;//ready_in to pc
	//op_format	= decoder(opcode_in,intermed_op,jtype_op,utype_lui_op,utype_auipc_op);
	op_format	= encoder_out({u_type_auipc,b_type,j_type,u_type_lui,r_type,s_type,i_type,i_type_load});
	aluop 		= out(op_format,funct3_in,funct7_in);
	werf_contrl 	= (~op_format[1]) | (op_format[0]);
	wbmux_contol 	= funct_wbmux(op_format);
	inter_ir_mux	= (((~op_format[0]) & (~op_format[2])) | ((~op_format[2]) & (~op_format[1])));
	ir_mux		= {2{inter_ir_mux}};
	//load_type_out	= load_type_in;
	if(i_type_jalr)
	begin
		op_format_out 	= `I_type;
	end
	else
	begin
		op_format_out	= op_format;
	end
	/*if(load_type_in)
	begin
	NEXT_STATE 	<=	LOAD_STALL;
	end
	else
	begin*/
	NEXT_STATE 	<=	FETCH;	
	//end
	end

//need to include more after implementing pipeline stages....
LOAD_STALL: 	begin
		
		if(load_type_in)
		begin
		NEXT_STATE 	<=	LOAD_STALL;
		end
		else
		begin
		NEXT_STATE 	<=	FETCH;
		end
		end

endcase
end


function [2:0] encoder_out(input [7:0] encode_out);
begin
case(encode_out)
8'b00000001	:	encoder_out	=	`I_type_load;
8'b00000010	:	encoder_out	=	`I_type;
8'b00000100	:	encoder_out	=	`S_type;
8'b00001000	:	encoder_out	=	`R_type;
8'b00010000	:	encoder_out	=	`U_type_LUI;
8'b00100000	:	encoder_out	=	`J_type;
8'b01000000	:	encoder_out	=	`B_type;
8'b10000000	:	encoder_out	=	`U_type_AUIPC;
endcase
end
endfunction

/*
function [2:0]decoder(input [4:0] op_code,input intermediate_op,input jtype,input utype_lui,input utype_auipc);

begin




if(intermed_op)
begin
  if(jalr_type)
   begin
     decoder = `I_type;
   end
  if(jtype)
   begin
     decoder = `J_type;
   end
  else if(utype_lui)
   begin
     decoder = `U_type_LUI;
   end
  else
   begin
     decoder = `U_type_AUIPC;
   end
end
else
begin
  decoder = op_code[4:2];
end*/
/*
always@(op_code)
begin
case(op_code)

5'b011_00:	decoder = `R_type;

5'b001_00:	decoder = `I_type;

5'b000_00:	decoder = `I_type_load;

5'b010_00:	decoder = `S_type;

5'b110_00:	decoder = `B_type;

5'b110_11:	decoder = `J_type;

5'b011_01:	decoder = `U_type_LUI;

5'b001_01:	decoder = `U_type_AUIPC;

default:	decoder = `INVALID;
endcase
end
endfunction*/

function [3:0] for_aluop_rtype(input [2:0] decode,input funct7);

begin
case(decode)

3'b000:		for_aluop_rtype = alu_op(funct7,`SUB,`ADD);
	
3'b101:		for_aluop_rtype = alu_op(funct7,`SRA,`SRL);

3'b100:		for_aluop_rtype = alu_op(funct7,`ERR,`XOR);

3'b110:		for_aluop_rtype = alu_op(funct7,`ERR,`OR);

3'b111:		for_aluop_rtype = alu_op(funct7,`ERR,`AND);

3'b001:		for_aluop_rtype = alu_op(funct7,`ERR,`SLL);

3'b010:		for_aluop_rtype = alu_op(funct7,`ERR,`SLT);

3'b011:		for_aluop_rtype = alu_op(funct7,`ERR,`SLTU);	

endcase
end
endfunction

function [3:0] for_aluop_itype(input [2:0] decode,input funct7);
begin
case(decode)

3'b000:		for_aluop_itype = `ADD;
	
3'b101:		for_aluop_itype = alu_op(funct7,`SRA,`SRL);

3'b100:		for_aluop_itype = `XOR;

3'b110:		for_aluop_itype = `OR;

3'b111:		for_aluop_itype = `AND;

3'b001:		for_aluop_itype = `SLL;

3'b010:		for_aluop_itype = `SLT;

3'b011:		for_aluop_itype = `SLTU;	

endcase
end
endfunction

function [3:0] alu_op(input funct7_0,input [3:0] operation1,input [3:0] operation2);
begin
if(funct7_0)
	begin
	alu_op = operation1;
	end
else
	begin
	alu_op = operation2;
	end
end
endfunction

function [3:0] out(input [2:0] decode_in,input [2:0]funct3_2_0,input funct7_0_1);
begin
case(decode_in)
		
`R_type:	out = for_aluop_rtype(funct3_2_0,funct7_0_1);

`I_type:	out = for_aluop_itype(funct3_2_0,funct7_0_1);

`I_type_load:	out = `ADD;

`S_type:	out = `ADD;

`B_type:	out = `ADD;

`J_type:	out = `ADD;

`U_type_AUIPC:	out = `ADD;

`U_type_LUI:	out = `ADD;

endcase
end
endfunction

function [1:0] funct_wbmux(input [2:0] funct_2);
begin
if(funct_2[2])
begin
if(funct_2[0])
begin
funct_wbmux = funct_2[1:0];
end
else
begin
funct_wbmux = funct_2[2:1];
end
end
else
begin
funct_wbmux = {funct_2[2],funct_2[2]};
end
end
endfunction




endmodule
