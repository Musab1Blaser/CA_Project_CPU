`timescale 1ns / 1ps
module instruction_Memory(
input [63:0] Instr_Addr,
output reg [31:0] Instruction
);

reg [7:0] IM [255:0];
initial 
begin
IM[0] <= 8'h13;
IM[1] <= 8'h05;
IM[2] <= 8'h00;
IM[3] <= 8'h10;
IM[4] <= 8'h93;
IM[5] <= 8'h05;
IM[6] <= 8'h40;
IM[7] <= 8'h00;
IM[8] <= 8'h63;
IM[9] <= 8'h02;
IM[10] <= 8'h05;
IM[11] <= 8'h04;
IM[12] <= 8'h63;
IM[13] <= 8'h80;
IM[14] <= 8'h05;
IM[15] <= 8'h04;
IM[16] <= 8'h13;
IM[17] <= 8'h84;
IM[18] <= 8'h15;
IM[19] <= 8'h00;
IM[20] <= 8'h13;
IM[21] <= 8'h04;
IM[22] <= 8'hf4;
IM[23] <= 8'hff;
IM[24] <= 8'h63;
IM[25] <= 8'h0a;
IM[26] <= 8'h04;
IM[27] <= 8'h02;
IM[28] <= 8'h13;
IM[29] <= 8'h04;
IM[30] <= 8'hf4;
IM[31] <= 8'hff;
IM[32] <= 8'hb3;
IM[33] <= 8'h04;
IM[34] <= 8'h00;
IM[35] <= 8'h00;
IM[36] <= 8'h13;
IM[37] <= 8'h9e;
IM[38] <= 8'h34;
IM[39] <= 8'h00;
IM[40] <= 8'h33;
IM[41] <= 8'h0e;
IM[42] <= 8'hae;
IM[43] <= 8'h00;
IM[44] <= 8'h03;
IM[45] <= 8'h3a;
IM[46] <= 8'h0e;
IM[47] <= 8'h00;
IM[48] <= 8'h83;
IM[49] <= 8'h3a;
IM[50] <= 8'h8e;
IM[51] <= 8'h00;
IM[52] <= 8'h63;
IM[53] <= 8'h46;
IM[54] <= 8'h5a;
IM[55] <= 8'h01;
IM[56] <= 8'h23;
IM[57] <= 8'h30;
IM[58] <= 8'h5e;
IM[59] <= 8'h01;
IM[60] <= 8'h23;
IM[61] <= 8'h34;
IM[62] <= 8'h4e;
IM[63] <= 8'h01;
IM[64] <= 8'h93;
IM[65] <= 8'h84;
IM[66] <= 8'h14;
IM[67] <= 8'h00;
IM[68] <= 8'he3;
IM[69] <= 8'hc0;
IM[70] <= 8'h84;
IM[71] <= 8'hfe;
IM[72] <= 8'he3;
IM[73] <= 8'h08;
IM[74] <= 8'h00;
IM[75] <= 8'hfc;
IM[76] <= 8'h63;
IM[77] <= 8'h02;
IM[78] <= 8'h00;
IM[79] <= 8'h00;
end
always @(*)
begin 
    Instruction <= {IM[Instr_Addr+3],IM[Instr_Addr+2],IM[Instr_Addr+1],IM[Instr_Addr]};
end 

endmodule