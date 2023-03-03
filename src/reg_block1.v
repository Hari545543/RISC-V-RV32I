module reg_block1(clk,stall,decode_instr,reg_1,reg_2,dest,opcode,funct_3,funct_7,instr,)


always@(posedge clk)
begin
case(stall)

	1'b1:	decode_instr	= 	32'h0000_0013;// addi x0,x0,x0

	1'b0:	decode_instr 	= 	instr_in;  

	default:decode_instr 	= 	instr_in;

endcase


end

endmodule
