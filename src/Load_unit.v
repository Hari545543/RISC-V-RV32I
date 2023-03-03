module load_unit(load_funct3_in,load_in,data_in,load_output,load_mux);

input [31:0] data_in;//from data memory
input [2:0] load_funct3_in;
input load_in;//from control logic (load_itype_in)

output [31:0] load_output;
wire [7:0] byte_pos;
wire [15:0] half_word_pos;
reg byte_sign,half_word_sign;
reg [31:0] load_inter;
output load_mux;


assign load_mux =load_in;
assign byte_pos = data_in[7:0];
assign half_word_pos = data_in[15:0];

/*
always@(data_in or iaddr_in)
begin
case(iaddr_in)

2'b00:	byte_pos = data_in[7:0];
2'b01: 	byte_pos = data_in[15:8];
2'b10: 	byte_pos = data_in[23:16];
2'b11: 	byte_pos = data_in[31:24];

endcase
end

always@(data_in or iaddr_in)
begin
case(iaddr_in[1])

1'b0:	half_word_pos = data_in[15:0];
1'b1: 	half_word_pos = data_in[31:16];

endcase
end

*/
always@(load_funct3_in or data_in)
begin
case(load_funct3_in[2])

1'b1:	begin
	byte_sign = byte_pos[7];
	half_word_sign = half_word_pos[15];
	end

1'b0: 	begin
	byte_sign = 1'b0;
	half_word_sign = 1'b0;
	end

endcase
end

always@(*)
begin
case(load_funct3_in[1:0])

2'b00:	load_inter = {{24{byte_sign}},byte_pos};
2'b01:	load_inter = {{16{half_word_sign}},half_word_pos};
2'b10:	load_inter = data_in;
default:load_inter = data_in;
endcase
end

assign load_output = (load_in)? load_inter : 32'hzzzz_zzzz;
//use OR gate to enable data mem 'enable (load | vmem_wr) r/w => (load & !mem_wr)
endmodule


