`timescale 1ns / 1ps

module data_Memory(
input [63:0] Mem_Addr,
input[63:0] Write_Data,
input clk,
input MemWrite,
input MemRead,
output reg [63:0] Read_Data
);
reg [7:0] DM [511:0];

integer i;

initial
begin
    Read_Data <= 0;
    for (i = 0; i < 512; i = i + 1)
        DM[i] = 0;
       
    // [4,8,3,1] or [4.-1.-2.1]
     
    DM[256] = 8'd4; // 4

    DM[264] = 8'd8; // 8
    // -1
//    DM[264] = 8'hff; 
//    DM[265] = 8'hff; 
//    DM[266] = 8'hff; 
//    DM[267] = 8'hff; 
//    DM[268] = 8'hff;
//    DM[269] = 8'hff; 
//    DM[270] = 8'hff; 
//    DM[271] = 8'hff; 

    DM[272] = 8'd3; // 3
    // -2
//    DM[272] = 8'hfe; 
//    DM[273] = 8'hff; 
//    DM[274] = 8'hff; 
//    DM[275] = 8'hff;
//    DM[276] = 8'hff; 
//    DM[277] = 8'hff; 
//    DM[278] = 8'hff; 
//    DM[279] = 8'hff; 

    DM[280] = 8'd1; // 1
    
end

always @(posedge clk)
begin
    if (MemWrite)
        {DM[Mem_Addr+7], DM[Mem_Addr+6], DM[Mem_Addr+5], DM[Mem_Addr+4], DM[Mem_Addr+3], DM[Mem_Addr+2], DM[Mem_Addr+1], DM[Mem_Addr]} <= Write_Data;
end

always @(*)
begin
    if (MemRead)
        Read_Data <= {DM[Mem_Addr+7], DM[Mem_Addr+6], DM[Mem_Addr+5], DM[Mem_Addr+4], DM[Mem_Addr+3], DM[Mem_Addr+2], DM[Mem_Addr+1], DM[Mem_Addr]};
end

endmodule