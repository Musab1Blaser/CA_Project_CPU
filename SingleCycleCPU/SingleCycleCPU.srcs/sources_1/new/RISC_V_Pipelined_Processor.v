`timescale 1ns / 1ps

module RISC_V_Pipelined_Processor(input clk, input reset);
    wire [63:0] PC_In;
    wire [63:0] PC_next;
    Program_Counter PC (clk, reset, PC_In, PC_next);
    
    wire [63:0] PC_adder_out;
    Adder PC_ADD (PC_next, 64'd4, PC_adder_out);
    
    wire [31:0] Instruction_next;
    instruction_Memory IM (PC_next, Instruction_next);

    wire [63:0] PC_Out;
    wire [31:0] Instruction;
    IF_ID if_id (clk, PC_next, Instruction_next, PC_Out, Instruction);

    wire [6:0] opcode;
    wire [4:0] rd_next, rs1_next, rs2_next;
    wire [2:0] funct3;
    wire [6:0] funct7;
    instruction_parser IP (Instruction, opcode, rd_next, funct3, rs1_next, rs2_next, funct7);
    
    wire Branch_next, MemRead_next, MemToReg_next, MemWrite_next, ALUSrc_next, RegWrite_next;
    wire [1:0] ALUOp_next;
    Control_Unit CU (opcode, Branch_next, MemRead_next, MemToReg_next, MemWrite_next, ALUSrc_next, RegWrite_next, ALUOp_next);
    
    
    wire MemToReg_final, RegWrite_final;
    wire [4:0] rd_final;
    wire [63:0] WriteData;
    wire [63:0] ReadData1_next, ReadData2_next; // need final wires for rd, regwrite, writedata
    registerFile RF (WriteData, rs1_next, rs2_next, rd_final, RegWrite_final, clk, reset, ReadData1_next, ReadData2_next);

    wire [63:0] imm_data_next;
    ide Imm_Gen (Instruction, imm_data_next);
    
    
    wire Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite;
    wire [1:0] ALUOp;
    wire [63:0] imm_data;    
    wire [4:0] rd, rs1, rs2;
    wire [63:0] ReadData1, ReadData2;
    wire [63:0] PC_Out2;
    wire [3:0] funct_next;

    ID_EX id_ex (clk, 
    MemToReg_next, RegWrite_next, Branch_next, MemWrite_next, MemRead_next, ALUOp_next, ALUSrc_next, 
    PC_Out, imm_data_next, ReadData1_next, ReadData2_next, rs1_next, rs2_next, rd_next, {Instruction[30], Instruction[14:12]},
    
    MemToReg, RegWrite, Branch, MemWrite, MemRead, ALUOp, ALUSrc, 
    PC_Out2, imm_data, ReadData1, ReadData2, rs1, rs2, rd, funct_next);
    
    wire [63:0] op2;
    wire [63:0] ReadData2_next2;

    mux_2 r2_imm_mux (ReadData2_next2, imm_data, ALUSrc, op2);
    
    wire [3:0] operation;
    ALU_Control ALU_CU (ALUOp, funct_next, operation);
    
    wire [63:0] branch_address_next;
    Adder Branch_Adder (PC_Out2, imm_data[63:0], branch_address_next);
    
    wire [63:0] op1;
    wire [1:0] forwardA, forwardB;
    wire [63:0] result;
    wire [63:0] result_final;
    
    mux_3 op1_mux (ReadData1, result_final, result, forwardA, op1);
    
    mux_3 op2_mux (ReadData2, result_final, result, forwardB, ReadData2_next2);
    
    wire [63:0] result_next;
    wire zero_next, lt_next;
    ALU_64_bit ALU (op1, op2, operation, result_next, zero_next, lt_next);
    
    wire Branch2, MemRead2, MemToReg2, MemWrite2, RegWrite2;
    
    wire [4:0] rd2;
    
    forwarding_unit fw_unit (clk, rd2, RegWrite2,
    rd_final, RegWrite_final,
    rs1, rs2,
    
    forwardA, forwardB
    );
    
    
    wire [63:0] branch_address;
    wire zero, lt;
    
    wire [63:0] MemWriteData;
    wire [3:0] funct;

    
    EX_MEM ex_mem (clk, MemToReg, RegWrite, MemRead, MemWrite, Branch,
    branch_address_next, zero_next, lt_next,
    result_next, ReadData2_next2, rd, funct_next,
    
    MemToReg2, RegWrite2, MemRead2, MemWrite2, Branch2, 
    branch_address, zero, lt, 
    result, MemWriteData, rd2, funct);
    
    wire takeBranch = Branch2 & ((funct[2] == 0 & zero) | (funct[2] == 1 & lt)); // funct3 broken - needs to be taken from pipeline - needs to be passed along pipeline
    mux_2 pc_mux (PC_adder_out, branch_address, takeBranch, PC_In);
    
    
    wire [63:0] Read_Data_next;
    data_Memory DM (result, MemWriteData, clk, MemWrite2, MemRead2, Read_Data_next);
    
    
    wire [63:0] Read_Data;

    MEM_WB mem_wb (clk,
    MemToReg2, RegWrite2, Read_Data_next, result, rd2,
    MemToReg_final, RegWrite_final, Read_Data, result_final, rd_final);
    
    mux_2 final_mux (result_final, Read_Data, MemToReg_final, WriteData);
    
endmodule
