module mem_pip_reg(clk,reset,load_type_pip_in,funct3_pip_in,alu_out,addr_in_pip,imm_in_mem,mask_bits_in_to,mem_enable_in,mem_rw_in,pc_4_pip,pc_imm_pip,werf_in,wb_mux_in,store_in,alu_res,data_mem_store,werf_contrl_out,wb_mux_output,pc_4_wb,pc_imm_wb,data_mem_enable_out,data_mem_rw_out,mask_bits_out,wb_imm,addr_out_pip,funct3_out_pip,load_type_unit_in);

input [31:0] alu_out,store_in,pc_4_pip,pc_imm_pip,imm_in_mem;
input clk,mem_enable_in,mem_rw_in,reset,load_type_pip_in;
input werf_in;
input [2:0] funct3_pip_in;
input [4:0] addr_in_pip; 
input [3:0] mask_bits_in_to;
input [1:0] wb_mux_in;
output reg werf_contrl_out;
output reg [1:0] wb_mux_output;
output reg [31:0] alu_res,data_mem_store,pc_4_wb,pc_imm_wb,wb_imm;
output reg data_mem_enable_out,data_mem_rw_out,load_type_unit_in;
output reg [3:0] mask_bits_out;
output reg [4:0] addr_out_pip;
output reg [2:0] funct3_out_pip;



always@(posedge clk)
begin
case(reset)
1'b0: begin
pc_4_wb			<= 	pc_4_pip;
pc_imm_wb 		<= 	pc_imm_pip;
alu_res 		<= 	alu_out;
data_mem_store 		<=  	store_in;
wb_mux_output		<=	wb_mux_in;
werf_contrl_out		<=	werf_in;
data_mem_enable_out 	<= 	mem_enable_in;
data_mem_rw_out		<= 	mem_rw_in;
mask_bits_out 		<= 	mask_bits_in_to;
wb_imm			<=	imm_in_mem;
addr_out_pip		<=	addr_in_pip;
funct3_out_pip		<=	funct3_pip_in;
load_type_unit_in	<=	load_type_pip_in;
end

1'b1: begin
pc_4_wb			<= 	0;
pc_imm_wb 		<= 	0;
alu_res 		<= 	0;
data_mem_store 		<=  	0;
wb_mux_output		<=	0;
werf_contrl_out		<=	0;
data_mem_enable_out 	<= 	0;
data_mem_rw_out		<= 	1;
mask_bits_out 		<= 	0;
wb_imm			<=	0;
addr_out_pip		<=	0;
load_type_unit_in	<=	0;
end
endcase
end
endmodule
