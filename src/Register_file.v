module reg_file(clk,read_address1,read_address2,write_enable,write_address,write_data,read_data1,read_data2);

parameter ad_width = 5,data_width = 32,reg_depth=32;

input	[ad_width-1:0]	read_address1,read_address2,write_address;

input write_enable,clk;

input	[data_width-1:0]	write_data;

output [data_width-1:0]	read_data1,read_data2;

reg	[ad_width-1:0]	reg_write_addr	[2:0];

reg	[data_width-1:0]	reg_filex	[reg_depth-1:0];
reg [4:0] writing_addr;
reg [31:0] reg_write_data;
wire [ad_width-1:0] inter_addr;
//testbench purpose
integer i = 0;

initial
begin
reg_filex[0] <= 32'h0000_0000;
for(i=1;i<32;i=i+1)
begin
reg_filex[i] <= 16*i;
end
end
/*
always@(*)
begin
reg_write_addr[0] <=  write_address;
//reg_write_addr[1] <= reg_write_addr[0];
//reg_write_addr[0] <= reg_write_addr[1];
writing_addr <= reg_write_addr[0];
reg_write_data <= write_data;
end*/
/*
integer i = 0;

always@(reset)
begin
  if(reset)
  begin
  for(i = 1;i<data_width;i = i+1)
     begin
       reg_filex[i] = 32'h0000_0000;
     end
  end
end
*/

//assign inter_addr = (write_enable)? write_address : 5'bzzzzz;

always@(posedge clk)
begin
   if(write_enable)
	begin
	//writing_addr <= reg_write_addr[0];
	reg_filex[write_address] = write_data;
	reg_filex[0] = 32'h0000_0000;
	end
   /*else
    begin
	reg_filex[0] <= 32'h0000_0000;
end*/
end

//always@(reg_filex or read_address1 or read_address2 or writing_addr)
//begin
assign read_data1	=	reg_filex[read_address1];
assign read_data2	=	reg_filex[read_address2];
//end


endmodule

