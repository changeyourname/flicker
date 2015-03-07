/*******************************************************************************
#                        NORTH CAROLINA STATE UNIVERSITY
#
#                               FabScalar Project
#
# FabScalar Copyright (c) 2007-2011 by Niket K. Choudhary, Salil Wadhavkar,
# and Eric Rotenberg.  All Rights Reserved.
#
# This is a beta-release version.  It must not be redistributed at this time.
#
# Purpose: 
# Author:  FabGen
*******************************************************************************/

`timescale 1ns/100ps

module FU2(
	input clk,
	input reset,
             
	input [`SIZE_PC+`SIZE_IMMEDIATE+`SIZE_OPCODE_I+2*(`SIZE_DATA+`SIZE_PHYSICAL_LOG)+`SIZE_PHYSICAL_LOG+
		`SIZE_ACTIVELIST_LOG+`SIZE_ISSUEQ_LOG+`CHECKPOINTS+`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC:0] inPacket_i,
	input [`SIZE_DATA-1:0] fuFinalData1_i,
	input [`SIZE_DATA-1:0] fuFinalData2_i,
	input inValid_i,
				 
	input ctrlVerified_i,
	input ctrlMispredict_i,
	input [`CHECKPOINTS_LOG-1:0] ctrlSMTid_i, 

	/* Output packet from the functional unit.
	*/	
	output [`CHECKPOINTS+`EXECUTION_FLAGS+`SIZE_PHYSICAL_LOG+`SIZE_ACTIVELIST_LOG+`SIZE_DATA+`SIZE_ISSUEQ_LOG+
		`SIZE_LSQ_LOG+`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC:0] outPacket_o,
	output outValid_o
); 

reg                            	outValid;
reg                            	flush;
reg                            	instBrDir;
reg [`SIZE_CTI_LOG-1:0]        	instCtiqTag;
reg [`SIZE_PC-1:0]             	instTarAddr;
reg [`SIZE_PC-1:0]             	instPC;
reg [`SIZE_OPCODE_I-1:0]       	instOpcode;
reg [`SIZE_IMMEDIATE-1:0]      	instImmd;
reg [`SIZE_PHYSICAL_LOG-1:0]   	instDestReg;
reg [`CHECKPOINTS_LOG-1:0]     	instSMTid;
reg [`CHECKPOINTS-1:0]         	instBranchMask;
reg [`SIZE_ISSUEQ_LOG-1:0]     	instIQentry;
reg [`SIZE_ACTIVELIST_LOG-1:0] 	instALid;
reg [`SIZE_LSQ_LOG-1:0]        	instLSQid;

wire [`SIZE_PC-1:0]            	nextPC;
wire [`SIZE_DATA-1:0]          	result;
wire [`EXECUTION_FLAGS-1:0]            flags;
wire 					computedDir;

 assign outPacket_o = {instBranchMask,flags,instDestReg,instALid,result,instIQentry,
	instLSQid,instSMTid,instCtiqTag,nextPC,computedDir};
 assign outValid_o  = outValid;	    	 


/* Following filters the instructions which is newer than the mis-predicted 
   branch (branch inst computed in the last cycle).
*/
always @(*)
begin
	instBranchMask = inPacket_i[`CHECKPOINTS+`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC:
		`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC+1]; 
	outValid   = inValid_i; 

	flush = instBranchMask[ctrlSMTid_i];
	if(ctrlVerified_i && ctrlMispredict_i)
	begin
		if(flush)
			outValid = 1'b0;
		else
			outValid = inValid_i;	
	end
end    

/* Following extracts information from the incoming FU packet.
 */
always @(*)
begin:EXTRACTS_INFO
	instBrDir   = inPacket_i[0];
	instTarAddr = inPacket_i[`SIZE_PC:1];
	instCtiqTag = inPacket_i[`SIZE_CTI_LOG+`SIZE_PC:`SIZE_PC+1];
	instSMTid   = inPacket_i[`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC:`SIZE_CTI_LOG+`SIZE_PC+1];
	instIQentry = inPacket_i[`SIZE_ISSUEQ_LOG+`CHECKPOINTS+`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC:
		`CHECKPOINTS+`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC+1];
	instALid    = inPacket_i[`SIZE_ACTIVELIST_LOG+`SIZE_ISSUEQ_LOG+`CHECKPOINTS+`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC:
		`SIZE_ISSUEQ_LOG+`CHECKPOINTS+`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC+1];
	instDestReg = inPacket_i[`SIZE_PHYSICAL_LOG+`SIZE_ACTIVELIST_LOG+`SIZE_ISSUEQ_LOG+`CHECKPOINTS+`CHECKPOINTS_LOG+
		`SIZE_CTI_LOG+`SIZE_PC:`SIZE_ACTIVELIST_LOG+`SIZE_ISSUEQ_LOG+`CHECKPOINTS+`CHECKPOINTS_LOG+
		`SIZE_CTI_LOG+`SIZE_PC+1];
	instOpcode  = inPacket_i[`SIZE_OPCODE_I+2*(`SIZE_DATA+`SIZE_PHYSICAL_LOG)+`SIZE_PHYSICAL_LOG+`SIZE_ACTIVELIST_LOG+
		`SIZE_ISSUEQ_LOG+`CHECKPOINTS+`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC:2*(`SIZE_DATA+`SIZE_PHYSICAL_LOG)+
		`SIZE_PHYSICAL_LOG+`SIZE_ACTIVELIST_LOG+`SIZE_ISSUEQ_LOG+`CHECKPOINTS+`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC+1];
	instImmd    = inPacket_i[`SIZE_IMMEDIATE+`SIZE_OPCODE_I+2*(`SIZE_DATA+`SIZE_PHYSICAL_LOG)+`SIZE_PHYSICAL_LOG+`SIZE_ACTIVELIST_LOG+
		`SIZE_ISSUEQ_LOG+`CHECKPOINTS+`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC:`SIZE_OPCODE_I+
		2*(`SIZE_DATA+`SIZE_PHYSICAL_LOG)+`SIZE_PHYSICAL_LOG+`SIZE_ACTIVELIST_LOG+`SIZE_ISSUEQ_LOG+`CHECKPOINTS+
		`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC+1];
	instPC      = inPacket_i[`SIZE_PC+`SIZE_IMMEDIATE+`SIZE_OPCODE_I+2*(`SIZE_DATA+`SIZE_PHYSICAL_LOG)+`SIZE_PHYSICAL_LOG+
		`SIZE_ACTIVELIST_LOG+`SIZE_ISSUEQ_LOG+`CHECKPOINTS+`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC:
		`SIZE_IMMEDIATE+`SIZE_OPCODE_I+2*(`SIZE_DATA+`SIZE_PHYSICAL_LOG)+`SIZE_PHYSICAL_LOG+
		`SIZE_ACTIVELIST_LOG+`SIZE_ISSUEQ_LOG+`CHECKPOINTS+`CHECKPOINTS_LOG+`SIZE_CTI_LOG+`SIZE_PC+1];

	instLSQid   = 0;
end

/* Functionality for the FU2:
*/
Ctrl_ALU ctrlAlu(
.data1_i(fuFinalData1_i),
	.data2_i(fuFinalData2_i),
	.immd_i(instImmd),
	.opcode_i(instOpcode),
	.predictedTarget_i(instTarAddr),
	.predictedDir_i(instBrDir),
	.pc_i(instPC),
	.result_o(result),
	.nextPC_o(nextPC),
	.direction_o(computedDir),
	.flags_o(flags)
);

endmodule
