`include "Def.v"
module imm_gen(instr,imm_mux,imm);
//`include "Def.v"
input [31:7]instr;
input [2:0] imm_mux;
output reg [31:0]imm;
wire [31:0] i_type,s_type,b_type,j_type,u_type;

assign i_type = {{20{instr[31]}},instr[31:20]};
assign s_type = {{20{instr[31]}},instr[31:25],instr[11:7]};
assign b_type = {{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
assign j_type = {{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};
assign u_type = {instr[31:12],12'h000};

always @(instr or imm_mux)
  begin
    case(imm_mux)

	`I_type:
	imm = i_type;

	`I_type_load:
	imm = i_type;

	`S_type:
	imm=  /*{{20{instr[31]}},instr[31:25],instr[11:7]};*/s_type;

	`B_type:
	imm = /*{{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};*/b_type;

	`J_type:
	imm = /*{{12{instr[31]}},instr[19:12],instr[20],instr[11:8],1'b0};*/j_type;

	`U_type_LUI:
	imm =/* {instr[31:12],12'h000};*/u_type;

	`U_type_AUIPC:
	imm =/* {instr[31:12],12'h000};*/u_type;

	default:
	imm = /*{{20{instr[31]}},instr[31:20]};*/i_type;

    endcase
  end
endmodule