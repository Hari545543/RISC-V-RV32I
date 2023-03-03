module branch_prediction_unit(clock,opcode_in,reset,branch_in,branch_taken_out,wrong_predict_out,is_branch);

input clock, branch_in,reset;
input [4:0] opcode_in;//after fetch
output branch_taken_out;
output wrong_predict_out;
output is_branch;
reg wrong_predict,wrong_next;
wire branch_out,enable,branch_inter_out,enable_in,wrong_predict_in;

parameter SLT = 2'b00,LT = 2'b01,NLT = 2'b10, SNLT = 2'b11;

reg [1:0] present_state,next_state;

//STATE = SLT;
assign enable_in = ((opcode_in[4]) & (opcode_in[3]) & (~opcode_in[2]) & (~opcode_in[1]) & (~opcode_in[0]));
//assign jal_enable = ((opcode_in[4]) & (opcode_in[3]) & (~opcode_in[2]) & (opcode_in[1]) & (opcode_in[0]));
assign enable = (enable_in | branch_in);

function [1:0] taken_branch(input branching,input [1:0] NS_logic_1,input [1:0] NS_logic_2);
begin
if(branching)
	taken_branch = NS_logic_1;
else
	taken_branch = NS_logic_2;

/*
case(branching)

1'b0: NS = NS_logic_2;
1'b1: NS= NS_logic_1;
default: NS= NS_logic_1;

endcase*/
end
endfunction

//assign enable = ((opcode_in[4]) & (opcode_in[3]) & (~opcode_in[2]) & (~opcode_in[1]) & (~opcode_in[0]));
//assign jal_enable = ((opcode_in[4]) & (opcode_in[3]) & (~opcode_in[2]) & (opcode_in[1]) & (opcode_in[0]));

always@(posedge clock)
begin
if(reset)
begin
	present_state <= SNLT;
	//wrong_next <= branch_inter_out;
end
else
begin
	present_state <= next_state;
	//wrong_next <= branch_inter_out;

end
end

always@(present_state or branch_in or wrong_predict_in or enable)
//begin
//if(wrong_predict_in & enable)
begin
case(present_state)

SLT: 	next_state = taken_branch(branch_in,SLT,LT);

LT: 	next_state = taken_branch(branch_in,SLT,NLT);

NLT: 	next_state = taken_branch(branch_in,LT,SNLT);

SNLT: 	next_state = taken_branch(branch_in,NLT,SNLT);

default: next_state = SLT;
endcase
end/*
else
begin
next_state = present_state;
end
end
*/

assign branch_out = ((present_state == SLT) | (present_state == LT));
assign branch_inter_out = (enable_in)? branch_out : 1'b0;
assign wrong_predict_in = (next_state != present_state) ;//((branch_inter_out) ^ (branch_in));




assign wrong_predict_out = (enable_in)? wrong_predict_in : 1'b0;//send to pc and stall
assign is_branch = branch_inter_out;
assign branch_taken_out = ((wrong_predict_out)? (~is_branch): (is_branch));

//send to pc 
endmodule
