module reg_block4(clk,reset,addr_wb_in,wb_mux_in,werf_enable_in,out_mux,werf_ou,write_addr_out);
input [31:0] wb_mux_in;
input [4:0] addr_wb_in;
input clk,werf_enable_in,reset;
output reg [31:0] out_mux;
output reg werf_ou;
output reg [4:0] write_addr_out;

always@(posedge clk)
begin
case(reset)
1'b0: begin
out_mux <= wb_mux_in;
werf_ou <= werf_enable_in;
write_addr_out <= addr_wb_in;
end

1'b1: begin
out_mux <= 0;
werf_ou <= 0;
write_addr_out <= 0;
end
endcase
end
endmodule


