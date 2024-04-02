`timescale 1ns / 1ps
module instruction_Memory(
input [63:0] Instr_Addr,
output reg [31:0] Instruction
);

reg [7:0] IM [15:0];
initial 
begin
    IM[0] <= 8'h83 ;
    IM[1] <= 8'h34 ;
    IM[2] <= 8'h85 ;
    IM[3] <= 8'h02 ;
    IM[4] <= 8'hB3 ;
    IM[5] <= 8'h84 ;
    IM[6] <= 8'h9A ;
    IM[7] <= 8'h00 ;
    IM[8] <= 8'h93 ; 
    IM[9] <= 8'h94 ;
    IM[10] <= 8'h14 ;
    IM[11] <= 8'h00 ;
    IM[12] <= 8'h23 ;
    IM[13] <= 8'h34 ;
    IM[14] <= 8'h95 ;
    IM[15] <= 8'h02 ; 
end
always @(*)
begin 
    Instruction <= {IM[Instr_Addr+3],IM[Instr_Addr+2],IM[Instr_Addr+1],IM[Instr_Addr]};
end 

endmodule