`timescale 1ns / 1ps

module Program_Counter(
    input clk, reset,
    input [63:0] PC_In,
    output reg [63:0] PC_Out);
    
    always @(posedge clk)
    begin
        if (~reset)
            begin
            PC_Out <= PC_In;
            end
        else 
            begin
            PC_Out <= 0;
            end
    end
endmodule
