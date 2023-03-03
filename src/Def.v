`define R_type 3'b011
`define I_type 3'b001
`define I_type_load 3'b000
`define S_type 3'b010
`define B_type 3'b110
`define J_type 3'b101
`define U_type_LUI 3'b100
`define U_type_AUIPC 3'b111
//`define INVALID 3'b111 


`define ADD 4'd0
`define SUB 4'd1
`define XOR 4'd2
`define OR 4'd3
`define AND 4'd4
`define SLL 4'd5
`define SRL 4'd6
`define SRA 4'd7
`define SLT 4'd8
`define SLTU 4'd9
`define BEQ 4'd10
`define BNE 4'd11
`define BLT 4'd12
`define BGE 4'd13
`define BLTU 4'd14
`define BGEU 4'd15
`define JALR 4'd16
`define ERR 4'd17




`define J_type_JAL 4'b1011
`define I_type_JALR 4'b1111
`define R_type_out 4'b0001
`define I_type_out 4'b0010
`define S_type_out 4'b0100
`define B_type_out 4'b1100
`define U_type_LUI_out 4'b0110
`define U_type_AUIPC_out 4'b1000
`define I_type_load_out 4'b0000