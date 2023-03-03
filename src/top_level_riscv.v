module top_level_riscv(clk,reset);//data_mem_read_output,store_mem_out,data_mem_enable_out,data_mem_rw_out);
input clk,reset;
wire [31:0] data_mem_read_output;//output
wire [31:0] store_mem_out;//output
//output [3:0] wb_mask_out;
//output wr_req_out;
//wire data_mem_enable_out,data_mem_rw_out;//output
`include "Def.v"
/*
initial
begin
clk = 0;
forever #10 clk =~clk;
end

initial begin
reset = 1;
#20 reset = 0;
#1000 $finish;
end
*/
//jalr
wire mem_enable_out,mem_rw_out;
wire [31:0] jalr_out,imm;
//prog_counter
wire stall_in,branch_taken_in,t,ready_in;
wire [31:0] pc_plus4_out,pc_imm,pc_out;
//instr mem(testbench purpose)
wire [31:0] data_out;
//decoder
wire [4:0] source_reg_1,source_reg_2,dest_reg;
wire [6:0] opcode_out;
wire [2:0] funct_3_out;
wire [6:0] funct_7_out;
wire load_itype;
wire [24:0] instr_out;
wire [31:0] pc_imm_out,pc_4_out;
//imm gen
wire [2:0] op_format;
//control unit
wire werf_contrl;
wire [1:0] wbmux_control;
wire [3:0] aluop;
wire [1:0] ir_mux;
wire load_type_out;
//branch unit
wire [31:0] rd1,rd2;
wire [31:0] operand1_select,alu_operand;
//bypass unit
wire [1:0] ir_mux1_out,ir_mux2_out;
//reg file
wire werf_enable; //from wb mux
wire [31:0] out_mux;
wire [4:0] writing_addr;
//store unit
wire data_mem_enable,data_mem_rw,wr_req_out;
wire [31:0] rs2_out;
wire [3:0] wb_mask_out;
//reg block 3
wire [31:0] oper1,oper2,out;
wire [3:0] aluop_out,mask_bit_in_pip;
wire werf_out,load_type_instr,data_mem_enable_out,data_mem_rw_out;
//wire mem_rw_out,mem_enable_out;
wire [1:0] wb_mux_ou;
wire [31:0] pc_imm_to,pc_4_to,store_rs2,imm_out_to_mem;
//alu

//mem pip reg
wire [31:0] alu_res;
wire werf_contrl_out;
wire [1:0] wb_mux_output;
wire [31:0] pc_4_wb,pc_imm_wb,wb_imm_in;
//wire data_mem_enable_out,data_mem_rw_out;
wire [3:0] mask_bits_out;
//load unit
wire load_mux_out;
wire [31:0] read_mem_output;
//wb_mux
wire [31:0] wb_mux_out;
reg [4:0] reg_write_addr;
reg [4:0] writing_adder;
wire [4:0] addr_out,addr_out_pip,write_addr_out;
wire bypass_ir2,bypass_ir1,bypass_stall_out,sb_type,stall_to;
wire out_u_type,contrl_utype,bypass_exe_utyp,load_type_unit_in;
wire [31:0] pc_bypass_in;
wire [2:0] funct3_out_pip,funct3_to_load;
//reg [31:0] data_mem [65535:0];


jalr_type_adder add1(.reg_1(operand1_select),.imm(imm),.jalr_out(jalr_out));

prog_counter p2(.clk(clk),.jalr_type_in(jalr_out),.immbj(imm),.stall_in(stall_to),.pc_mux_in(reset),.branch_taken_in(branch_taken_in),.ready_in(ready_in),.wrong_predict_in(branch_taken_in),.pc_plus4_in(pc_plus4_out),.pc_imm(pc_imm),.pc_out(pc_out));

assign stall_to = (stall_in | bypass_stall_out);

instr_mem i2(.address(pc_out),.data_out(data_out));

decoder d2(.instr_in(data_out),.bypass_stall(bypass_stall_out),.clk(clk),.reset(reset),.stall(stall_in),.pc_imm_in(pc_imm),.pc_4_in(pc_plus4_out),.wrong_predict_in(branch_taken_in)/*,.branching()*/,.source_reg_1(source_reg_1),.source_reg_2(source_reg_2),.dest_reg(dest_reg),.opcode_out(opcode_out),.funct_3_out(funct_3_out),.funct_7_out(funct_7_out),.load_itype(load_itype),.instr_out(instr_out),.pc_imm_out(pc_imm_out),.pc_4_out(pc_4_out));

imm_gen imm2(.instr(instr_out),.imm_mux(op_format),.imm(imm));

control_unit conrl2(.clk(clk),.reset(reset),.load_type_in(load_itype),.opcode_in(opcode_out),.funct3_in(funct_3_out),.funct7_in(funct_7_out[5]),.werf_contrl(werf_contrl),.wbmux_contol(wbmux_control),.stall(stall_in),.aluop(aluop),.ir_mux(ir_mux),.ready_in(ready_in),.op_format_out(op_format),.bypass_ir1(bypass_ir1),.bypass_ir2(bypass_ir2),.sb_type(sb_type),.out_u_type(out_u_type),.reg_u_type_lui(contrl_utype),.i_type_load(load_type_out));

branch_unit branch2(.funct3_in(funct_3_out),.opcode_in(opcode_out[6:2]),.source_1(operand1_select),.source_2(alu_operand),.branch_out(branch_taken_in));

bypass_unit by2(.clk(clk),.reset(reset),.sb_type_in(sb_type),.in_u_type(out_u_type),.bypass_ir1_in(bypass_ir1),.bypass_ir2_in(bypass_ir2),.op_format_contrl_in(op_format),.ir_mux_in(ir_mux),.rs1(source_reg_1),.rd(dest_reg),.rs2(source_reg_2),.load_in(load_type_out),.irmux1(ir_mux1_out),.irmux2(ir_mux2_out),.stall_out(bypass_stall_out),.u_type_contrl_in(bypass_exe_utype));
//assign bypass_stall_out = (u_type_in_stall | bypass_stall_output);
/*
always@(posedge clk)
begin
reg_write_addr <=  dest_reg;
//reg_write_addr[1] <= reg_write_addr[0];
//reg_write_addr[0] <= reg_write_addr[1];
writing_adder <= reg_write_addr;
end
*/

reg_file regfile2(.clk(clk),.read_address1(source_reg_1),.read_address2(source_reg_2),.write_enable(werf_enable),.write_address(write_addr_out),.write_data(out_mux),.read_data1(rd1),.read_data2(rd2)/*test*/);



store_unit store2(.op_for(op_format),.funct3_in(funct_3_out),.rs2_in(alu_operand),.rs2_out(rs2_out),.wb_mask_out(wb_mask_out),.wr_req_out(wr_req_out));

assign data_mem_enable = wr_req_out | load_type_out;//data mem enable
assign data_mem_rw = (load_type_out & (~wr_req_out));//active low write

reg_block3 reg_3(.clk(clk),.reset(reset),.funct3_in(funct_3_out),.pc_imm_plus4(pc_bypass_in),.bypass_exe_utype(bypass_exe_utype),.stall_bypass_in(bypass_stall_out),.werf(werf_contrl),.write_adr(dest_reg),.rs2_store(rs2_out),.store_mask_bits(wb_mask_out),.load_type_out(load_type_out),.mem_enable(data_mem_enable),.mem_rw(data_mem_rw),.wb_mux(wbmux_control),.pc_imm_reg(pc_imm),.pc_4_reg(pc_plus4_out),.operand_1(rd1),.operand_2(rd2),.aluop(aluop),.imm(imm),.execute_bypass_in(out),.wb_bypass_in(wb_mux_out),.irmux1_in(ir_mux1_out),.irmux2_in(ir_mux2_out),.oper1(oper1),.oper2(oper2),.alu_op(aluop_out),.werf_out(werf_out),.wb_mux_ou(wb_mux_ou),.pc_imm_reg_out(pc_imm_to),.pc_4_reg_out(pc_4_to),.load_type_instr(load_type_instr),.mem_enable_out(mem_enable_out),.mem_rw_out(mem_rw_out),.store_rs2(store_rs2),.store_mask_out_pip(mask_bit_in_pip),.imm_out_to_mem(imm_out_to_mem),.addr_out(addr_out),.operand1_select(operand1_select),.alu_operand(alu_operand),.funct3_to_load(funct3_to_load));
//(clk,werf,rs2_store,store_mask_bits,load_type_out,mem_enable,mem_rw,wb_mux,pc_imm_reg,pc_4_reg,operand_1,operand_2,,aluop,imm,execute_bypass_in,wb_bypass_in,irmux1_in,irmux2_in,oper1,oper2,alu_op,werf_out,wb_mux_ou,pc_imm_reg_out,pc_4_reg_out,load_type_instr,mem_enable_out,mem_rw_out,store_rs2,store_mask_out_pip,imm_out_to_mem);

assign pc_bypass_in = (contrl_utype)? imm_out_to_mem : pc_imm_to;

alu_riscv alu2(.operand_1(oper1),.operand_2(oper2),.aluop(aluop_out),.out(out));
//change done here
mem_pip_reg mempip2(.clk(clk),.reset(reset),.load_type_pip_in(load_type_instr),.funct3_pip_in(funct3_to_load),.alu_out(out),.addr_in_pip(addr_out),.imm_in_mem(imm_out_to_mem),.mask_bits_in_to(mask_bit_in_pip),.mem_enable_in(mem_enable_out),.mem_rw_in(mem_rw_out),.pc_4_pip(pc_4_to),.pc_imm_pip(pc_imm_to),.werf_in(werf_out),.wb_mux_in(wb_mux_ou),.store_in(store_rs2),.alu_res(alu_res),.data_mem_store(store_mem_out),.werf_contrl_out(werf_contrl_out),.wb_mux_output(wb_mux_output),.pc_4_wb(pc_4_wb),.pc_imm_wb(pc_imm_wb),.data_mem_enable_out(data_mem_enable_out),.data_mem_rw_out(data_mem_rw_out),.mask_bits_out(mask_bits_out),.wb_imm(wb_imm_in),.addr_out_pip(addr_out_pip),.funct3_out_pip(funct3_out_pip),.load_type_unit_in(load_type_unit_in));

//testbench purpose
data_mem da1(.read_write(data_mem_rw_out),.enable(data_mem_enable_out),.data_write_in(store_mem_out),.data_addr_in(alu_res),.inter_data(data_mem_read_output));

load_unit load2(.load_funct3_in(funct3_out_pip),.load_in(load_type_unit_in),.data_in(data_mem_read_output),.load_output(read_mem_output),.load_mux(load_mux_out));

wb_mux w2(.pc_plus4(pc_4_wb),.immu(wb_imm_in),.pc_plus_immu(pc_imm_wb),.read_mem(read_mem_output),.is_load(load_mux_out),.alu_out(alu_res),.wb_select(wb_mux_output),.wb_mux_out(wb_mux_out));

//change done here
reg_block4 reg_4(.clk(clk),.reset(reset),.addr_wb_in(addr_out_pip),.wb_mux_in(wb_mux_out),.werf_enable_in(werf_contrl_out),.out_mux(out_mux),.werf_ou(werf_enable),.write_addr_out(write_addr_out));

endmodule
