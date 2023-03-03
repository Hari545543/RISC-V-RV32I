module store_unit(op_for,funct3_in,rs2_in,rs2_out,wb_mask_out,wr_req_out);


input [31:0] rs2_in;
input [1:0] funct3_in;
input [2:0] op_for;//from control logic
output [31:0] rs2_out;
output reg [3:0] wb_mask_out;
//output [31:0] addr_out;
output wr_req_out;

wire mem_wr;
reg [31:0] rs2_inter;
wire [3:0] byte_mask,half_word_mask;
wire [31:0] byte_out,half_word_out;

assign mem_wr = ((~op_for[2]) & (op_for[1]) & (~op_for[0]));
//assign addr_out = {addr_in[31:2],2'b0};
assign wr_req_out = mem_wr;
//connect to OR gate as enable signal enable (load | vmem_wr) r/w =>(load & !mem_wr)
assign byte_mask = {3'b0,mem_wr};
/*
always@(addr_in or mem_wr)
begin
case(addr_in[1:0])

2'b00: byte_mask = {3'b0,mem_wr};
2'b01: byte_mask = {2'b0,mem_wr,1'b0};
2'b10: byte_mask = {1'b0,mem_wr,2'b0};
2'b11: byte_mask = {mem_wr,3'b0};
endcase
end*/
assign half_word_mask = {2'b0,{2{mem_wr}}};
/*
always@(addr_in or mem_wr)
begin
case(addr_in[1])

1'b0: half_word_mask = {2'b0,{2{mem_wr}}};
1'b1: half_word_mask = {{2{mem_wr}},2'b0};
endcase
end
*/

assign byte_out = {8'b0,8'b0,8'b0,rs2_in[7:0]};
assign half_word_out = {16'b0,rs2_in[15:0]};
/*
always@(addr_in or mem_wr)
begin
case(addr_in[1:0])

2'b00: byte_out = {8'b0,8'b0,8'b0,rs2_in[7:0]};
2'b01: byte_out = {16'b0,rs2_in[15:8],8'b0};
2'b10: byte_out = {8'b0,rs2_in[23:16],8'b0,8'b0};
2'b11: byte_out = {rs2_in[31:24],8'b0,8'b0,8'b0};
endcase
end
always@(addr_in or mem_wr)
begin
case(addr_in[1])

1'b0: half_word_out = {16'b0,rs2_in[15:0]};
1'b1: half_word_out = {rs2_in[31:16],16'b0};
endcase
end
*/
always@(funct3_in or byte_mask or half_word_mask or mem_wr)
begin
case(funct3_in)

2'b00: wb_mask_out = byte_mask;
2'b01: wb_mask_out = half_word_mask;
default: wb_mask_out = {4{mem_wr}};
endcase
end

always@(funct3_in or byte_out or rs2_in or half_word_out)
begin

case(funct3_in)

2'b00: rs2_inter = byte_out;
2'b01: rs2_inter = half_word_out;
default: rs2_inter = rs2_in;
endcase
end

assign rs2_out = (mem_wr)? rs2_inter : 32'hzzzz_zzzz;
endmodule
