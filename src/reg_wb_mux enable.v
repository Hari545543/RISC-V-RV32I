/*
module dflip_flop(clk,reset,d,q);

input d,clk,reset;
output reg q;

always@(posedge clk)
begin
if(reset)
begin
q <= 0;
end
else
begin
q <= d;
end
end
endmodule

module reg_wb_mux_enable_gen(d,reset,clk,werf_contrl,wb_contrl);
input [1:0] d;
input clk,reset;
output werf_contrl,wb_contrl;
reg [1:0] inter_q;
dflip_flop D1(clk,reset,d[0],inter_q[0]);
dflip_flop D2(clk,reset,d[1],inter_q[1]);
dflip_flop D3(clk,reset,inter_q[0],wb_contrl);
dflip_flop D4(clk,reset,inter_q[0],werf_contrl);
endmodule

*/
module reg_wb_mux_enable_gen(d,,wer,reset,clk,werf_contrl,wb_contrl);
input [1:0] d;
input clk,reset,wer;
output reg werf_contrl;
output reg [1:0] wb_contrl;
reg [3:0] inter_wb;
reg [1:0] inter_werf;

always@(posedge clk)
begin
inter_werf[0] 	<= wer;

inter_werf[1]	<= inter_werf[0];
werf_contrl  	<= inter_werf[1];
inter_wb[1:0] 	<= d;
inter_wb[3:2]	<= inter_wb[1:0];
wb_contrl	<= inter_wb[3:2];
end


endmodule

