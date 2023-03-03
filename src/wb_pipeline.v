module pip_reg4(clk,addr_wb_in,werf_enable_in,pc_plus_4_in,immu_in,pc_plus_immu_in,read_mem_in,load_in,alu_result_in,wb_select_in,pc_plus_4_out,immu_out,pc_plus_immu_out,read_mem_out,load_out,alu_result_out,wb_select_out,addr_wb_out,werf_enable_out);

input [4:0] addr_wb_in;
input [31:0] pc_plus_4_in,immu_in,pc_plus_immu_in,read_mem_in,alu_result_in;
input load_in,clk,werf_enable_in;
input [1:0] wb_select_in;
output reg [31:0] pc_plus_4_out,immu_out,pc_plus_immu_out,read_mem_out,alu_result_out;
output reg load_out;
output reg [1:0] wb_select_out;
output reg [4:0] addr_wb_out;
output reg werf_enable_out;


always@(posedge clk)
begin

pc_plus_4_out		<=	pc_plus_4_in;
immu_out		<=	immu_in;
pc_plus_immu_out	<=	pc_plus_immu_in;
read_mem_out		<=	read_mem_in;
alu_result_out		<=	alu_result_in;
load_out		<=	load_in;
wb_select_out		<=	wb_select_in;
addr_wb_out		<=	addr_wb_in;
werf_enable_out		<=	werf_enable_in;
end


endmodule

