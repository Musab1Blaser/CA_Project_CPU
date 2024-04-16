`timescale 1ns / 1ps

module IF_ID(input clk, input IF_ID_Write, input wire [63:0] PC_Address_In, input wire [31:0] Inst_In,
output reg [63:0] PC_Address_Out, output reg [31:0] Inst_Out);

always @(posedge clk)
begin
    if (IF_ID_Write)
    begin
        PC_Address_Out = PC_Address_In;
        Inst_Out = Inst_In;
    end
end

endmodule
