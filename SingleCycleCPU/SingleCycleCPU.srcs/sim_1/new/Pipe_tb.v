`timescale 1ns / 1ps

module Pipe_tb();
    reg [31:0] inst;
    reg [63:0] pc;
    reg clk;
    wire [31:0] inst_out;
    wire [63:0] pc_out;
    IF_ID if_id(clk, pc, inst, pc_out, inst_out);
    initial
    begin
        clk = 0;
        pc = 3;
        inst = 0;    
    end
    always @(posedge clk)
    begin
        pc <= pc + 1;
        inst <= inst + 1; 
    end
    
    always
        #5 clk = ~clk; 
endmodule
