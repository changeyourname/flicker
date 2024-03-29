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

module SRAM_10R5W_PIPE_NEXT(
	data0wr_i,
	data1wr_i,
	data2wr_i,
	data3wr_i,
	data4wr_i,
		clk,
		reset,
	decoded_addr0_i,
	decoded_addr1_i,
	decoded_addr2_i,
	decoded_addr3_i,
	decoded_addr4_i,
	decoded_addr5_i,
	decoded_addr6_i,
	decoded_addr7_i,
	decoded_addr8_i,
	decoded_addr9_i,
	decoded_addr0wr_i,
	decoded_addr1wr_i,
	decoded_addr2wr_i,
	decoded_addr3wr_i,
	decoded_addr4wr_i,
	we0_i,
	we1_i,
	we2_i,
	we3_i,
	we4_i,
	data0_o,
	data1_o,
	data2_o,
	data3_o,
	data4_o,
	data5_o,
	data6_o,
	data7_o,
	data8_o,
	data9_o,

	decoded_addr0_o,
	decoded_addr1_o,
	decoded_addr2_o,
	decoded_addr3_o,
	decoded_addr4_o,
	decoded_addr5_o,
	decoded_addr6_o,
	decoded_addr7_o,
	decoded_addr8_o,
	decoded_addr9_o,
	decoded_addr0wr_o,
	decoded_addr1wr_o,
	decoded_addr2wr_o,
	decoded_addr3wr_o,
	decoded_addr4wr_o,
	we0_o,
	we1_o,
	we2_o,
	we3_o,
	we4_o
);

/* Parameters */
parameter SRAM_DEPTH = 64;
parameter SRAM_INDEX = 6;
parameter SRAM_WIDTH = 8;

	input [SRAM_WIDTH-1:0] data0wr_i;
	input [SRAM_WIDTH-1:0] data1wr_i;
	input [SRAM_WIDTH-1:0] data2wr_i;
	input [SRAM_WIDTH-1:0] data3wr_i;
	input [SRAM_WIDTH-1:0] data4wr_i;

 input clk; 
 input reset;
	input [SRAM_DEPTH-1:0] decoded_addr0_i;
	input [SRAM_DEPTH-1:0] decoded_addr1_i;
	input [SRAM_DEPTH-1:0] decoded_addr2_i;
	input [SRAM_DEPTH-1:0] decoded_addr3_i;
	input [SRAM_DEPTH-1:0] decoded_addr4_i;
	input [SRAM_DEPTH-1:0] decoded_addr5_i;
	input [SRAM_DEPTH-1:0] decoded_addr6_i;
	input [SRAM_DEPTH-1:0] decoded_addr7_i;
	input [SRAM_DEPTH-1:0] decoded_addr8_i;
	input [SRAM_DEPTH-1:0] decoded_addr9_i;
	input [SRAM_DEPTH-1:0] decoded_addr0wr_i;
	input [SRAM_DEPTH-1:0] decoded_addr1wr_i;
	input [SRAM_DEPTH-1:0] decoded_addr2wr_i;
	input [SRAM_DEPTH-1:0] decoded_addr3wr_i;
	input [SRAM_DEPTH-1:0] decoded_addr4wr_i;
	input we0_i;
	input we1_i;
	input we2_i;
	input we3_i;
	input we4_i;
	output we0_o;
	output we1_o;
	output we2_o;
	output we3_o;
	output we4_o;
	output [SRAM_WIDTH-1:0] data0_o;
	output [SRAM_WIDTH-1:0] data1_o;
	output [SRAM_WIDTH-1:0] data2_o;
	output [SRAM_WIDTH-1:0] data3_o;
	output [SRAM_WIDTH-1:0] data4_o;
	output [SRAM_WIDTH-1:0] data5_o;
	output [SRAM_WIDTH-1:0] data6_o;
	output [SRAM_WIDTH-1:0] data7_o;
	output [SRAM_WIDTH-1:0] data8_o;
	output [SRAM_WIDTH-1:0] data9_o;
	output [SRAM_DEPTH-1:0] decoded_addr0_o;
	output [SRAM_DEPTH-1:0] decoded_addr1_o;
	output [SRAM_DEPTH-1:0] decoded_addr2_o;
	output [SRAM_DEPTH-1:0] decoded_addr3_o;
	output [SRAM_DEPTH-1:0] decoded_addr4_o;
	output [SRAM_DEPTH-1:0] decoded_addr5_o;
	output [SRAM_DEPTH-1:0] decoded_addr6_o;
	output [SRAM_DEPTH-1:0] decoded_addr7_o;
	output [SRAM_DEPTH-1:0] decoded_addr8_o;
	output [SRAM_DEPTH-1:0] decoded_addr9_o;
	output [SRAM_DEPTH-1:0] decoded_addr0wr_o;
	output [SRAM_DEPTH-1:0] decoded_addr1wr_o;
	output [SRAM_DEPTH-1:0] decoded_addr2wr_o;
	output [SRAM_DEPTH-1:0] decoded_addr3wr_o;
	output [SRAM_DEPTH-1:0] decoded_addr4wr_o;
	reg [SRAM_WIDTH-1:0] sram [SRAM_DEPTH-1:0];
	reg [SRAM_WIDTH-1:0] data0_o;
	reg [SRAM_WIDTH-1:0] data1_o;
	reg [SRAM_WIDTH-1:0] data2_o;
	reg [SRAM_WIDTH-1:0] data3_o;
	reg [SRAM_WIDTH-1:0] data4_o;
	reg [SRAM_WIDTH-1:0] data5_o;
	reg [SRAM_WIDTH-1:0] data6_o;
	reg [SRAM_WIDTH-1:0] data7_o;
	reg [SRAM_WIDTH-1:0] data8_o;
	reg [SRAM_WIDTH-1:0] data9_o;
integer i,j;

 assign decoded_addr0_o = decoded_addr0_i;
 assign decoded_addr1_o = decoded_addr1_i;
 assign decoded_addr2_o = decoded_addr2_i;
 assign decoded_addr3_o = decoded_addr3_i;
 assign decoded_addr4_o = decoded_addr4_i;
 assign decoded_addr5_o = decoded_addr5_i;
 assign decoded_addr6_o = decoded_addr6_i;
 assign decoded_addr7_o = decoded_addr7_i;
 assign decoded_addr8_o = decoded_addr8_i;
 assign decoded_addr9_o = decoded_addr9_i;
 assign decoded_addr0wr_o = decoded_addr0wr_i;
 assign we0_o = we0_i;
 assign decoded_addr1wr_o = decoded_addr1wr_i;
 assign we1_o = we1_i;
 assign decoded_addr2wr_o = decoded_addr2wr_i;
 assign we2_o = we2_i;
 assign decoded_addr3wr_o = decoded_addr3wr_i;
 assign we3_o = we3_i;
 assign decoded_addr4wr_o = decoded_addr4wr_i;
 assign we4_o = we4_i;
/* Read operation */
always @(*)
begin

	data0_o = 0;
	data1_o = 0;
	data2_o = 0;
	data3_o = 0;
	data4_o = 0;
	data5_o = 0;
	data6_o = 0;
	data7_o = 0;
	data8_o = 0;
	data9_o = 0;
	for(j=0; j<SRAM_DEPTH; j=j+1)
	begin
		if(decoded_addr0_i[j])	data0_o = sram[j];
		if(decoded_addr1_i[j])	data1_o = sram[j];
		if(decoded_addr2_i[j])	data2_o = sram[j];
		if(decoded_addr3_i[j])	data3_o = sram[j];
		if(decoded_addr4_i[j])	data4_o = sram[j];
		if(decoded_addr5_i[j])	data5_o = sram[j];
		if(decoded_addr6_i[j])	data6_o = sram[j];
		if(decoded_addr7_i[j])	data7_o = sram[j];
		if(decoded_addr8_i[j])	data8_o = sram[j];
		if(decoded_addr9_i[j])	data9_o = sram[j];
	end

end

/* Write operation */
always @(posedge clk)
begin

	if(reset)
	begin
		for(i=`SIZE_RMT; i<SRAM_DEPTH; i=i+1)
		begin
			sram[i] <= 0;
		end
	end
	else
	begin
        for(i=0;i<SRAM_DEPTH;i=i+1)
        begin

		if(we0_i)
			if(decoded_addr0wr_i[i]) sram[i] <= data0wr_i;

		if(we1_i)
			if(decoded_addr1wr_i[i]) sram[i] <= data1wr_i;

		if(we2_i)
			if(decoded_addr2wr_i[i]) sram[i] <= data2wr_i;

		if(we3_i)
			if(decoded_addr3wr_i[i]) sram[i] <= data3wr_i;

		if(we4_i)
			if(decoded_addr4wr_i[i]) sram[i] <= data4wr_i;

	end
end
end

endmodule





