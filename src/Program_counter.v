
/*
module prog_counter(clk,immbj,jt,pcmux,pc);

input [31:0]immbj,jt;
input clk;
input [1:0]pcmux;
output reg[31:0] pc;

always@(posedge clk)
begin
   case(pcmux)
	   
	  2'b11 : pc = pc + 4;
	  
	  2'b10 : pc = pc + immbj;

	  2'b01 : pc = jt;
	   
	  2'b00 : pc = 32'h0000_0000;
	  
	  default: pc = pc + 4;
   endcase
end
endmodule
*/

/*
module prog_counter(reset_in,pc_mux,trap_ret_in,jt,ready_in,trap_address_in,branch_in,pc_plus_4_out,pc_in,misaligned_instr_out,pc_out,pc_mux_out);
	
input [31:0]	jt,trap_ret_in,trap_address_in,pc_in;
input reset_in,branch_in,ready_in;
input [1:0] pc_mux;
output [31:0] pc_out,pc_plus_4_out;
output [31:0] pc_mux_out;
output misaligned_instr_out;
reg [31:0] pc_mux_intermediate;
wire [31:0] pc_plus_4_intermediate,inter_pc,next_pc;

parameter Boot_addr = 32'h0000_0000;

assign pc_plus_4_intermediate = pc_in + 4;
assign pc_plus_4_out = pc_plus_4_intermediate;
assign next_pc = (branch_in)? jt: pc_plus_4_intermediate;

always@(branch_in or pc_plus_4_intermediate or jt )
begin

case(branch_in)

1'b0:	next_pc = pc_plus_4_intermediate;

1'b1:	next_pc = jt;

endcase
end

always@(pc_mux or next_pc or trap_address_in or trap_ret_in)
begin

case(pc_mux)

2'b00:	pc_mux_intermediate = Boot_addr;

2'b01:	pc_mux_intermediate = trap_ret_in;

2'b10:	pc_mux_intermediate = trap_address_in;

2'b11:	pc_mux_intermediate = next_pc;

default: pc_mux_intermediate = Boot_addr;
endcase
end

assign pc_mux_out = pc_mux_intermediate;
assign inter_pc = (ready_in) ? pc_mux_intermediate : pc_out;

assign pc_out = (reset_in)? Boot_addr : inter_pc;

assign misaligned_instr_out = next_pc[1] & branch_in;

endmodule
*/
/*
module prog_count(pc_mux,add_mux,clk,immbj,trap_ret_in,trap_address_in,pc_plus_4_out,pc);

input [1:0] pc_mux,add_mux;
input clk;
input [31:0] immbj,trap_ret_in,trap_address_in;

output [31:0] pc_plus_4_out,pc;
wire [31:0] add_intermed;
reg [31:0] pc_intermed;
parameter plus_4_in = 32'h0000_0004;
//always@(add_mux or )

//assign add_intermed = (add_mux)? immbj : 32'h0000_0004;
always@(add_mux or immbj)

assign addr_in = add_intermed;
assign pc_plus_4_out = add_intermed;

always@(pc_mux or jt or immbj or trap_ret_in or trap_address_in)
begin

case(pc_mux)

	2'b00:	pc_intermed = 32'h0000_0000;

	2'b01:	pc_intermed = trap_ret_in;

	2'b10:	pc-intermed = trap_address_in;

	2'b11:	pc-intermed = addr_in;

endcase
end


endmodule
*/
module prog_counter(clk,jalr_type_in,immbj,stall_in,pc_mux_in,branch_taken_in,ready_in,wrong_predict_in,pc_plus4_in,pc_imm,pc_out);

input [31:0] jalr_type_in,immbj;
input stall_in,pc_mux_in,branch_taken_in,ready_in,wrong_predict_in,clk;
output [31:0] pc_plus4_in,pc_imm;
output reg [31:0] pc_out;
reg [31:0] pc_inter_out,next_pc,pc_mux_out,pc_enter,pc_stall_out,reg_pc;

parameter boot_addr = 32'h0000_0000;
//assign branch_mux_in = (branch_taken_in)
//branch_taken => predict unit
// branch => branch unit
assign pc_plus4_in 	=  pc_enter + 4;
assign pc_imm 		=  pc_enter + immbj;

always@(branch_taken_in or pc_imm or pc_plus4_in)
begin
case(branch_taken_in)
1'b1:next_pc = pc_imm;
1'b0:next_pc = pc_plus4_in;
default:next_pc = pc_plus4_in;
endcase
end/*
if(branch_taken_in)
   next_pc = pc_imm;
else
   next_pc = pc_plus4_in;
end
*/
always@(pc_mux_in or next_pc)
begin
case(pc_mux_in)
1'b1:pc_inter_out = boot_addr;
1'b0:pc_inter_out = next_pc;
default:pc_inter_out = next_pc;
endcase
end/*
if(pc_mux_in)
   pc_inter_out = boot_addr;
else
   pc_inter_out = next_pc;
end
*/

always@(ready_in or jalr_type_in or pc_inter_out)
begin
if(ready_in)
   pc_mux_out = jalr_type_in;
else
   pc_mux_out = pc_inter_out;
end


always@(stall_in or pc_out or pc_mux_out)
begin
if(stall_in)
   pc_stall_out = pc_out;
else
   pc_stall_out = pc_mux_out;
end

always@(posedge clk)
begin
if(stall_in)
begin
reg_pc <= reg_pc;
end
else
begin
reg_pc <= pc_out;
end
pc_out <= pc_stall_out;

end

always@(wrong_predict_in or reg_pc or pc_out)
begin
if(wrong_predict_in)
   pc_enter = reg_pc;
else
   pc_enter = pc_out;
end

endmodule





module jalr_type_adder(reg_1,imm,jalr_out);//to pc

input [31:0] reg_1,imm;
output [31:0] jalr_out;
wire [31:0] jalr_inter;

assign jalr_inter = reg_1 + imm;
assign jalr_out = {jalr_inter,1'b0};

endmodule







