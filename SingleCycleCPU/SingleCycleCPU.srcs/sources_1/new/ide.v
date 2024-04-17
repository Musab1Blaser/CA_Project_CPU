`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2024 04:37:48 PM
// Design Name: 
// Module Name: ide
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ide(input reset, input [31:0] instruction, output reg [63:0] imm_data);

always @(*)
begin
if (reset)
    imm_data = 0;
else
case (instruction[6:5])
    2'b00: // I-Type
    begin
        imm_data[11:0] = instruction[31:20];
        imm_data[63:12] = (imm_data[11] == 1 ? 52'hf_ffff_ffff_ffff : 52'h0); 
    end
    2'b01: // S-Type
    begin
        imm_data[11:0] = {instruction[31:25], instruction[11:7]};
        imm_data[63:12] = (imm_data[11] == 1 ? 52'hf_ffff_ffff_ffff : 52'h0); 
    end
    
    default: // Conditional Branch
    begin
        imm_data[12:1] = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
        imm_data[63:13] = (imm_data[12] == 1 ? 51'hf_ffff_ffff_ffff : 51'h0); 
        imm_data[0] = 1'b0;
    end
endcase 
end
endmodule
