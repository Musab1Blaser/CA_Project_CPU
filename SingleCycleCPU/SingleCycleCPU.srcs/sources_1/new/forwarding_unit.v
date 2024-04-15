`timescale 1ns / 1ps

module forwarding_unit(
    input clk,
    
    input [4:0] ex_mem_rd, 
    input ex_mem_RW,
    input [4:0] mem_wb_rd,
    input mem_wb_RW,
    input [4:0] id_ex_rs1, id_ex_rs2,
        
    output reg [1:0] forwardA, forwardB
    );
    
    always @(posedge clk)
    begin
        // default case
        forwardA = 00;
        forwardB = 00;
        
        // ex hazard
        if (ex_mem_RW & (ex_mem_rd != 0) & (ex_mem_rd == id_ex_rs1)) 
            forwardA = 2'b10;
            
        if (ex_mem_RW & (ex_mem_rd != 0) & (ex_mem_rd == id_ex_rs2)) 
            forwardB = 2'b10;
            
        // mem hazard
        if (mem_wb_RW & (mem_wb_rd != 0) & ~(ex_mem_RW & (ex_mem_rd != 0) & (ex_mem_rd == id_ex_rs1)) & (mem_wb_rd == id_ex_rs1))
            forwardA = 2'b01;
            
        if (mem_wb_RW & (mem_wb_rd != 0) & ~(ex_mem_RW & (ex_mem_rd != 0) & (ex_mem_rd == id_ex_rs2)) & (mem_wb_rd == id_ex_rs2))
            forwardB = 2'b01;
    end
    
endmodule
