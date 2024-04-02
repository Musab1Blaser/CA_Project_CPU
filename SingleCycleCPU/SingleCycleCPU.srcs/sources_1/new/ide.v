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


module ide(input [31:0] instruction, output reg [63:0] imm_data);

always @(*)
begin
case (instruction[6:5])
    2'b00: // Load
    begin
        imm_data[11:0] = instruction[31:20];
    end
    2'b01: // Store
    begin
        imm_data[11:0] = {instruction[31:25], instruction[11:7]};
    end
    
    default: // Conditional Branch
    begin
        imm_data[11:0] = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
    end
endcase 
imm_data[63:12] = (imm_data[11] == 1 ? 52'hf_ffff_ffff_ffff : 52'h0); 
end
endmodule
