`timescale 1ns / 1ps
module EX_MEM(
    input clk,
   
    input wire MemToReg, input wire RegWrite, 
    input wire MemRead, input wire MemWrite, input wire Branch,
   
    input wire [63:0] BranchAddress, input Zero, input Lt,
    input wire [63:0] ALUResult, input wire [63:0] MemWriteData, input wire [4:0] RD,
    input [3:0] Funct,
   
    output reg memtoreg, regwrite, memread, memwrite, branch,
   
    output reg [63:0] branchaddress,
    output reg zero, lt,
    output reg [63:0] aluresult, memwritedata,
   
    output reg [4:0] rd,
    output reg [3:0] funct
    );
    
initial
begin
    memtoreg <= 0;
    regwrite <= 0;
    branch <= 0;
    memwrite <= 0;
    memread <= 0;
end
   
    always @ (posedge clk)
    begin
   
        memtoreg <= MemToReg;
        regwrite <= RegWrite;
        memread <= MemRead;
        memwrite <= MemWrite;
        branch <= Branch;
        branchaddress <= BranchAddress;
        zero = Zero;
        lt = Lt;
        aluresult <= ALUResult;
        memwritedata <= MemWriteData;
        rd <= RD;
        funct <= Funct;
    end
   
endmodule