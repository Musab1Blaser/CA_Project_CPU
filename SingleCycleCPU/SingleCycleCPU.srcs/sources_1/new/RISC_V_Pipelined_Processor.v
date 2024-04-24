`timescale 1ns / 1ps

module RISC_V_Pipelined_Processor(input clk, input reset);
    wire [63:0] PC_In;
    wire [63:0] PC_next;
    
    wire PC_Write, IF_ID_Write;
    Program_Counter PC (clk, reset, PC_Write, PC_In, PC_next); //instantiating Program Counter
    
    wire [63:0] PC_adder_out;
    Adder PC_ADD (PC_next, 64'd4, PC_adder_out); //calling adder for the PC to point to the next instruction
    
    wire [31:0] Instruction_next;
    instruction_Memory IM (PC_next, Instruction_next); //instantiating Instruction Memory

    wire [63:0] PC_Out;
    wire [31:0] Instruction;
    wire takeBranch; //to be used later to determine branches

    IF_ID if_id (clk, reset, IF_ID_Write, takeBranch, PC_next, Instruction_next, PC_Out, Instruction); //calling IF_ID pipe to store in between values for pipelining

    wire MuxSignal;    
    wire Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite;
    wire [4:0] rd, rs1, rs2;
    
    hazard_unit hu (clk, rs1_next, rs2_next, rd,
    MemRead, PC_Write, IF_ID_Write, MuxSignal); //instantiating Hazard Unit to appropriately handle hazards such as load use hazard
    
    wire MuxSignal2;
    assign MuxSignal2 = MuxSignal & ~takeBranch;   

    wire [6:0] opcode;
    wire [4:0] rd_next, rs1_next, rs2_next;
    wire [2:0] funct3;
    wire [6:0] funct7;
    instruction_parser IP (Instruction, opcode, rd_next, funct3, rs1_next, rs2_next, funct7); //instantiating Instruction Parser
    
    wire Branch_next, MemRead_next, MemToReg_next, MemWrite_next, ALUSrc_next, RegWrite_next;
    wire [1:0] ALUOp_next;
    Control_Unit CU (opcode, Branch_next, MemRead_next, MemToReg_next, MemWrite_next, ALUSrc_next, RegWrite_next, ALUOp_next); //instantiating Control Unit to generate appropriate control signals and handle branching
    
    wire [63:0] control_signals;

    mux_2 ctrl_mux (64'b0, {56'b0,  MemToReg_next, RegWrite_next, Branch_next, MemWrite_next, MemRead_next, ALUOp_next, ALUSrc_next}, MuxSignal2, control_signals); //mux decides whether to flush control signals or forward them 
    
    wire MemToReg_final, RegWrite_final;
    wire [4:0] rd_final;
    wire [63:0] WriteData;
    wire [63:0] ReadData1_next, ReadData2_next; 
    registerFile RF (WriteData, rs1_next, rs2_next, rd_final, RegWrite_final, clk, reset, ReadData1_next, ReadData2_next); //instantiating register file

    wire [63:0] imm_data_next;
    ide Imm_Gen (reset, Instruction, imm_data_next); //instantiating immediate generator
    
    
    wire [1:0] ALUOp;
    wire [63:0] imm_data;    
    wire [63:0] ReadData1, ReadData2;
    wire [63:0] PC_Out2;
    wire [3:0] funct_next;

    ID_EX id_ex (clk, 
    control_signals[7], control_signals[6], control_signals[5], control_signals[4], control_signals[3], control_signals[2:1], control_signals[0], 
    PC_Out, imm_data_next, ReadData1_next, ReadData2_next, rs1_next, rs2_next, rd_next, {Instruction[30], Instruction[14:12]}, 
    
    MemToReg, RegWrite, Branch, MemWrite, MemRead, ALUOp, ALUSrc, 
    PC_Out2, imm_data, ReadData1, ReadData2, rs1, rs2, rd, funct_next); //calling ID_EX pipe to store in between values for pipelining
    
    wire [63:0] op2;
    wire [63:0] ReadData2_next2;

    mux_2 r2_imm_mux (ReadData2_next2, imm_data, ALUSrc, op2);
    
    wire [3:0] operation;
    ALU_Control ALU_CU (ALUOp, funct_next, operation); //instantiating ALU Control
    
    wire [63:0] branch_address_next;
    Adder Branch_Adder (PC_Out2, imm_data[63:0], branch_address_next); //adder to determine which instruction to branch to
    
    wire [63:0] op1;
    wire [1:0] forwardA, forwardB;
    wire [63:0] result;
    wire [63:0] result_final;
    
    mux_3 op1_mux (ReadData1, WriteData, result, forwardA, op1); //forwarding mux which takes in forward A to determine if data from register file, previous ALU result, or DM is to be forwarded
    
    mux_3 op2_mux (ReadData2, WriteData, result, forwardB, ReadData2_next2); //forwarding mux which takes in forward B to determine if data from register file, previous ALU result, or DM is to be forwarded
    
    wire [63:0] result_next;
    wire zero_next, lt_next;
    ALU_64_bit ALU (op1, op2, operation, result_next, zero_next, lt_next); //instantiating ALU
    
    wire Branch2, MemRead2, MemToReg2, MemWrite2, RegWrite2;
    
    wire [4:0] rd2;
    
    forwarding_unit fw_unit (clk, rd2, RegWrite2,
    rd_final, RegWrite_final,
    rs1, rs2,
    
    forwardA, forwardB
    ); //instantiating forwarding unit to check conditions for forwarding
    
    
    wire [63:0] branch_address;
    wire zero, lt;
    
    wire [63:0] MemWriteData;
    wire [3:0] funct;

    
    EX_MEM ex_mem (clk, takeBranch, MemToReg, RegWrite, MemRead, MemWrite, Branch,
    branch_address_next, zero_next, lt_next,
    result_next, ReadData2_next2, rd, funct_next,
    
    MemToReg2, RegWrite2, MemRead2, MemWrite2, Branch2, 
    branch_address, zero, lt, 
    result, MemWriteData, rd2, funct); //calling EX_MEM pipe to store in between values for pipelining

    assign takeBranch = Branch2 & ((funct[2] == 0 & zero) | (funct[2] == 1 & lt)); 
    mux_2 pc_mux (PC_adder_out, branch_address, takeBranch, PC_In); //mux to determine whether next instruction or branch instruction to take
    
    
    wire [63:0] Read_Data_next;
    data_Memory DM (result, MemWriteData, clk, MemWrite2, MemRead2, Read_Data_next); //instantiating Data Memory
    
    
    wire [63:0] Read_Data;

    MEM_WB mem_wb (clk,
    MemToReg2, RegWrite2, Read_Data_next, result, rd2,
    MemToReg_final, RegWrite_final, Read_Data, result_final, rd_final); //calling MEM_WB pipe to store in between values for pipelining
    
    mux_2 final_mux (result_final, Read_Data, MemToReg_final, WriteData); //final mux to determine whether to write back to register file
    
endmodule
