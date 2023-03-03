/*
module bypass_unit(clk,reset,in_u_type,sb_type_in,bypass_ir1_in,bypass_ir2_in,op_format_contrl_in,ir_mux_in,rs1,rd,rs2,load_in,irmux1,irmux2,stall_out,u_type_in_stall);

input load_in,clk,reset,bypass_ir1_in,bypass_ir2_in,sb_type_in,in_u_type;
input [1:0] ir_mux_in;
input [4:0] rs1,rs2,rd;
input [2:0] op_format_contrl_in;
reg [4:0] reg_rd [2:0];
reg [1:0] inter_irmux;
reg  inter1_ir1,inter1_ir2,inter2_ir1,inter2_ir2,inter_load;
reg reg_u_type,stall_output;
output [1:0] irmux1;
output [1:0] irmux2;
output reg stall_out;
reg [1:0] inter1;
output reg u_type_in_stall;
parameter START = 2'b00, STALL = 2'b01,U_TYPE_STALL = 2'b10;

reg [1:0] STATE,NEXT_STATE;

//assign rtype = ((~op_format_contrl_in[2]) & (op_format_contrl_in[1]) & (op_format_contrl_in[0]));

always@(posedge clk)
begin
if(reset)
begin
//reg_rd <= rd; 
STATE 		<= STALL;
reg_rd[0] 	= 0;
reg_rd[1] 	= 0;
reg_rd[2] 	= 0;
stall_out 	= 0;
reg_u_type 	= 0;
u_type_in_stall = 0;
stall_output 	= 0;
inter1_ir1 	= 0;
inter1_ir2 	= 0;
inter2_ir1 	= 0;
inter2_ir2 	= 0; 
end
else
begin
//reg_rd <= rd; 
STATE <= NEXT_STATE;
//inter_ir1 = (reg_rd == rs1);
//inter_ir2 = (reg_rd == rs2);
//reg_rd = rd;
//inter_ir1 <= (reg_rd == rs1);
//inter_ir2 <= (reg_rd == rs2);
inter_load = load_in;
end
if(sb_type_in | (NEXT_STATE != START))
begin
reg_rd[0] <= 5'b00000;
end
else
begin
reg_rd[0] <= rd;
end
reg_rd[1] <= reg_rd[0];
reg_rd[2] <= reg_rd[1];
reg_u_type <= in_u_type;
end
/*
always@(posedge clk)
begin
reg_rd[0] <= rd;
reg_rd[1] <= reg_rd[0];
end

always@(*)
begin
case(STATE)

START:	begin
	//reg_rd = rd; 
	inter1_ir1 = ((reg_rd[0] == rs1) & (|(reg_rd[0])));
	inter1_ir2 = ((reg_rd[0] == rs2) & (|(reg_rd[0])));
	inter2_ir1 = ((reg_rd[1] == rs1) & (|(reg_rd[1])));
	inter2_ir2 = ((reg_rd[1] == rs2) & (|(reg_rd[1])));
	u_type_in_stall = ((inter1_ir1 | inter1_ir2) & (reg_u_type));
	stall_output  = (((reg_rd[2] == rs2) | (reg_rd[2] == rs1)) & (|(reg_rd[2])));
	case({stall_output,u_type_in_stall})
	2'b00: NEXT_STATE = START;
	2'b01: NEXT_STATE = U_TYPE_STALL;
	2'b10: NEXT_STATE = STALL;
	2'b11: NEXT_STATE = START;
	endcase
	/*if(inter_load | stall_out)
	begin
	NEXT_STATE <= LOAD;
	end
	else
	begin
	NEXT_STATE <= START;
	end
	//reg_rd = rd; 
	end
//'stall' will happen here...
STALL:	begin
	stall_out = 1'b0;
	reg_rd[2] <= 5'b00000;
/*
	if(inter_load)
	begin
	NEXT_STATE <= LOAD;
	end
	else
	begin
	NEXT_STATE <= START;
	//end
	end

U_TYPE_STALL: 	begin
		u_type_in_stall = 1'b0;
		reg_rd[0] <= 0;
		NEXT_STATE <= START;
		end
endcase

end
always@(/*inter_load or inter2_ir2 or inter1_ir2 or ir_mux_in)
begin
inter_irmux = ir_mux_in;
	case({/*inter_loadinter2_ir2,inter1_ir2})
	2'b01:	inter_irmux = {/*inter_loadinter2_ir2,inter1_ir2};
	2'b00:	inter_irmux = ir_mux_in;
	2'b10:	inter_irmux = {inter2_ir2,inter1_ir2};//ir_mux_in;
	2'b11:	inter_irmux = {(~inter2_ir2),inter1_ir2};//{inter_load,(~inter_ir2)};
	default: inter_irmux = ir_mux_in;
	endcase
	
end

assign irmux2 = (bypass_ir2_in)? inter_irmux : ir_mux_in;

always@(/*inter_load inter2_ir1 or inter1_ir1)
begin
inter1 = 2'b00;
	case({/*inter_loadinter2_ir1,inter1_ir1})
	2'b01:	inter1 = {/*inter_loadinter2_ir1,inter1_ir1};
	2'b00:	inter1 = 2'b00;
	2'b10:	inter1 = {/*inter_loadinter2_ir1,inter1_ir1};//2'b00;
	2'b11:	inter1 = {(~inter2_ir1),inter1_ir1};//{inter_load,(~inter_ir1)};
	default: inter1 = 2'b00;
	endcase
end

assign irmux1 = (bypass_ir1_in)? inter1 : 2'b00;
/*
always@(*)
begin
	case({inter_load,inter_ir1})
	2'b01:	irmux1 = {1'b0,inter_ir1};
	2'b00:	irmux1 = 2'b00;
	2'b10:	irmux1 = 2'b00;
	2'b11:	irmux1 = {inter_load,(~inter_ir1)};
	
	endcase

end

endmodule
*/


module bypass_unit(clk,reset,sb_type_in,in_u_type,bypass_ir1_in,bypass_ir2_in,op_format_contrl_in,ir_mux_in,rs1,rd,rs2,load_in,irmux1,irmux2,stall_out,u_type_contrl_in);

input load_in,clk,reset,bypass_ir1_in,bypass_ir2_in,sb_type_in,in_u_type;
input [1:0] ir_mux_in;
input [4:0] rs1,rs2,rd;
input [2:0] op_format_contrl_in;
reg [4:0] reg_rd0,reg_rd1,reg_rd2;
reg [1:0] inter_irmux;
reg  inter1_ir1,inter1_ir2,inter2_ir1,inter2_ir2,inter_load;
reg reg_u_type;
output [1:0] irmux1;
output [1:0] irmux2;
output reg stall_out,u_type_contrl_in;
reg [1:0] inter1;
reg u_type_in_stall,reg_load_type_stall,load_type_contrl_in,no_stall;
parameter START = 1'b0, LOAD = 1'b1;

reg STATE,NEXT_STATE;

//assign rtype = ((~op_format_contrl_in[2]) & (op_format_contrl_in[1]) & (op_format_contrl_in[0]));

always@(posedge clk)
begin
if(reset)
begin
//reg_rd <= rd; 
STATE <= LOAD;
reg_rd0 	= 0;
reg_rd1 	= 0;
reg_rd2 	= 0;
stall_out 	= 0;
reg_u_type 	= 0; 
u_type_in_stall = 0;
inter1_ir1 	= 0;
inter1_ir2 	= 0;
inter2_ir1 	= 0;
inter2_ir2 	= 0; 
end
else
begin
//reg_rd <= rd; 
STATE <= NEXT_STATE;
//inter_ir1 = (reg_rd == rs1);
//inter_ir2 = (reg_rd == rs2);
//reg_rd = rd;
//inter_ir1 <= (reg_rd == rs1);
//inter_ir2 <= (reg_rd == rs2);
end

end


always@(posedge clk) //or sb_type_in)
begin
if(sb_type_in | (NEXT_STATE == LOAD))
begin
reg_rd0 <= 5'b00000;
end
else
begin
reg_rd0 <= rd;
end
reg_rd1 <= reg_rd0;
reg_rd2 <= reg_rd1;
reg_u_type <= in_u_type;
//reg_load_type_stall <= load_in;
end

always@(*)
begin
	inter1_ir1 = ((reg_rd0 == rs1) & (|(rs1)));
	inter1_ir2 = ((reg_rd0 == rs2) & (|(rs2)));
	inter2_ir1 = ((reg_rd1 == rs1) & (|(rs1)));
	inter2_ir2 = ((reg_rd1 == rs2) & (|(rs2)));
	no_stall   = ((reg_rd0 == reg_rd2)| (reg_rd1 == reg_rd2));
case(STATE)
START:	begin
	//reg_rd = rd; 
	/*
	inter1_ir1 = ((reg_rd[0] == rs1) & (|(reg_rd[0])));
	inter1_ir2 = ((reg_rd[0] == rs2) & (|(reg_rd[0])));
	inter2_ir1 = ((reg_rd[1] == rs1) & (|(reg_rd[1])));
	inter2_ir2 = ((reg_rd[1] == rs2) & (|(reg_rd[1])));*/
	load_type_contrl_in = ((inter1_ir1 | inter1_ir2) & (reg_load_type_stall));
	u_type_contrl_in = ((inter1_ir1 | inter1_ir2) & (reg_u_type));
	stall_out  = (((reg_rd2 == rs2) | (reg_rd2 == rs1)) & (|(reg_rd2)) & (~no_stall)); //& (~no_stall)); // | load_type_contrl_in); | (u_type_in_stall));
	if(stall_out)
	begin
	NEXT_STATE <= LOAD;
	end
	else
	begin
	NEXT_STATE <= START;
	end
	//reg_rd = rd; 
	end
//'stall' will happen here...
LOAD:	begin
	stall_out  = (((reg_rd2 == rs2) | (reg_rd2 == rs1)) & (|(reg_rd2))); // | load_type_contrl_in); | (u_type_in_stall));

	//stall_out = 1'b0;
	//reg_rd2 = 5'b00000;
/*
	if(inter_load)
	begin
	NEXT_STATE <= LOAD;
	end
	else
	begin*/
	if(stall_out)
	begin
	NEXT_STATE <= LOAD;
	end
	else
	begin
	NEXT_STATE <= START;
	end
	//end
	end
endcase

end
always@(inter2_ir2 or inter1_ir2 or ir_mux_in)
begin
inter_irmux = ir_mux_in;
	case({inter2_ir2,inter1_ir2})
	2'b01:	inter_irmux = {inter2_ir2,inter1_ir2};
	2'b00:	inter_irmux = ir_mux_in;
	2'b10:	inter_irmux = {inter2_ir2,inter1_ir2};//ir_mux_in;
	2'b11:	inter_irmux = {(~inter2_ir2),inter1_ir2};//{inter_load,(~inter_ir2)};
	default: inter_irmux = ir_mux_in;
	endcase
	
end

assign irmux2 = (bypass_ir2_in /*& (~load_type_contrl_in)*/)? inter_irmux : ir_mux_in;

always@(inter2_ir1 or inter1_ir1)
begin
inter1 = 2'b00;
	case({inter2_ir1,inter1_ir1})
	2'b01:	inter1 = {inter2_ir1,inter1_ir1};
	2'b00:	inter1 = 2'b00;
	2'b10:	inter1 = {inter2_ir1,inter1_ir1};//2'b00;
	2'b11:	inter1 = {(~inter2_ir1),inter1_ir1};//{inter_load,(~inter_ir1)};
	default: inter1 = 2'b00;
	endcase
end

assign irmux1 = (bypass_ir1_in /*& (~load_type_contrl_in)*/)? inter1 : 2'b00;//& ~load_type_contrl_in
/*
always@(*)
begin
	case({inter_load,inter_ir1})
	2'b01:	irmux1 = {1'b0,inter_ir1};
	2'b00:	irmux1 = 2'b00;
	2'b10:	irmux1 = 2'b00;
	2'b11:	irmux1 = {inter_load,(~inter_ir1)};
	
	endcase

end*/

endmodule



