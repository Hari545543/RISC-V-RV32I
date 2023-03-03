`include "Def.v"
module branch_unit(funct3_in,opcode_in,source_1,source_2,branch_out,jal_enab,enable);

input [31:0] source_1,source_2;
input [4:0] opcode_in;//after decode stage
input [2:0] funct3_in;
wire [2:0] alu_op;
reg branch;
output branch_out,jal_enab,enable;
wire beq_op,bne_op,blt_op,bge_op;
wire signed [31:0] signed_rs1,signed_rs2;

//enable and jal_enable need to be declared outside the module in top level module and given to branch predicting unit

assign enable = ((opcode_in[4]) & (opcode_in[3]) & (~opcode_in[2]) & (~opcode_in[1]) & (~opcode_in[0]));
assign jal_enable = ((opcode_in[4]) & (opcode_in[3]) & (!opcode_in[2]) & (opcode_in[1]) & (opcode_in[0]));
assign jalr_enable = ((opcode_in[4]) & (opcode_in[3]) & (!opcode_in[2]) & (~opcode_in[1]) & (opcode_in[0]));
assign jal_enab = jalr_enable;

assign signed_rs1 	= source_1;
assign signed_rs2 	= source_2;
assign beq_op 		= (source_1 == source_2);
assign bne_op 		= (source_1 != source_2);
assign blt_op 		= (signed_rs1 < source_2);
assign bge_op 		= (source_1 >= signed_rs2);
assign bltu_op 		= (source_1 < source_2);
assign bgeu_op 		= (source_1 >= source_2);
/*
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
end*/
assign alu_op = (enable)? funct3_in : 4'bzzzz;

always@(*)
begin
branch = 1'b0;
case(alu_op)

	3'b000: branch 	= beq_op;

	3'b001: branch 	= bne_op;

	3'b100: branch 	= blt_op;

	3'b101: branch 	= bge_op;

	3'b110: branch 	= bltu_op;

	3'b111: branch 	= bgeu_op;

	default: branch = 1'b0;

endcase
end

assign branch_out = branch;

/*
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
*/



endmodule
