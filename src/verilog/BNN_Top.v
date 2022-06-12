`timescale 1ns/100ps

module BNN_Top(iCLK,
               iRSTn,
               iCLR,
               iSTART,
               oADDR,
               oRd_EN,
               oWr_EN);
    
    parameter	IDLE_ST		 = 	3'b000;
    parameter 	READ_ST		= 3'b001;
	 parameter	CONV1_ST	 = 	3'b010;
    parameter	CONV2_ST	 = 	3'b011;
    parameter	CONV3_ST	 = 	3'b100;
    parameter	FCL1_ST		 = 	3'b101;
    parameter	FCL2_ST		 = 	3'b110;
	 
	 parameter	MEM_ADDR_OFFSET = 7'd252;
    
    input			iCLK;
    input			iRSTn;
    input			iCLR;
    input			iSTART;
    
    output	[4:0]	oADDR;
    output			oRd_EN;
    output			oWr_EN;
    
    wire			CNT_EN;
    wire			DONE;
    wire			next_state;
    
	 wire 		READ_DONE;
	 wire			READ_STATE;
	 assign 		READ_STATE = (current_state == READ_ST) ? 1'b1 : 1'b0;
	 
	 wire 	[111:0]	MEM1_WR_DATA;
	 wire		[8:0]		MEM1_WR_ADDR;
	 
	 wire		[111:0]	READ_COPY_WR_DATA;
	 wire		[8:0]		READ_COPY_WR_ADDR;
	 
	 wire		[111:0]	BNN_WR_DATA;
	 wire		[8:0]		BRR_WR_ADDR;
	 
	 assign 		MEM1_WR_DATA = BNN_WR_DATA;
	 assign 		MEM1_WR_ADDR = (current_state == CONV1_ST || current_state == CONV3_ST || current_state == FCL2_ST) 
	 ? MEM1_WR_ADDR_TMP : MEM1_WR_ADDR_TMP + 8'd252;
	 
	 wire		[111:0]	MEM1_RD_DATA;
	 wire		[8:0]		MEM1_RD_ADDR;
	 
    reg				current_state;
    
    // FSM			mem0Read	mem0Write	mem1Read	mem1Write
	 // READ			1			0				0			1
    // conv 1		1			0				0			1
    // conv 2		0			0				1			1
    // conv 3		0			0				1			1
    // FCL 1		0			0				1			1
    // FCL 2		0			1				1			x
    
    always@(posedge iCLK or negedge iRSTn)
    begin
        if (~iRSTn)
        begin
            current_state <= #1 IDLE_ST;
        end
        else if (iCLR)
        begin
            current_state <= #1 IDLE_ST;
        end
        else
        begin
            current_state <= #1 next_state;
        end
    end
	 
	 wire READ_DONE, CONV1_DONE, CONV2_DONE, CONV3_DONE, FCL1_DONE, FCL2_DONE;
    
    //next state logic
    assign next_state = (current_state == IDLE_ST) ? ((iSTART == 1'b1) ? CONV1_ST : IDLE_ST):
    (current_state == CONV1_ST) ? ((STATE_DONE == 1'b1) ? CONV2_ST : CONV1_ST) :
    (current_state == CONV2_ST) ? ((STATE_DONE == 1'b1) ? CONV3_ST : CONV2_ST) :
    (current_state == CONV3_ST) ? ((STATE_DONE == 1'b1) ? FCL1_ST : CONV3_ST) :
    (current_state == FCL1_ST) ? ((STATE_DONE == 1'b1) ? FCL2_ST : FCL1_ST) :
    (current_state == FCL2_ST) ? ((STATE_DONE == 1'b1) ? IDLE_ST : FCL2_ST) :
    IDLE_ST;
    
	 wire state_start;
	 assign state_start = (current_state == IDLE_ST) ? ((iSTART == 1'b1) ? 1'b1 : 1'b0):
    (current_state == CONV1_ST) ? ((STATE_DONE == 1'b1) ? 1'b1 : 1'b0) :
    (current_state == CONV2_ST) ? ((STATE_DONE == 1'b1) ? 1'b1 : 1'b0) :
    (current_state == CONV3_ST) ? ((STATE_DONE == 1'b1) ? 1'b1 : 1'b0) :
    (current_state == FCL1_ST) ? ((STATE_DONE == 1'b1) ? 1'b1 : 1'b0) :
    (current_state == FCL2_ST) ? ((STATE_DONE == 1'b1) ? 1'b1 : 1'b0) :
    1'b0;
		
	 wire WHOLE_RST = iRSTn | ~state_start;
	 
	 MEM112x315 MEM1(
	 .clock(iCLK),
	 .data(MEM1_WR_DATA),
	 .rdaddress(MEM1_RD_ADDR),
	 .rden(),
	 .wraddress(MEM1_WR_ADDR),
	 .wren(),
	 .q(MEM1_RD_DATA)
	 );
//	 
//	 READ_COPY readNcopy(
//	 .mem0readDATA(),
//	 .mem0readADDR(),
//	 .mem1writeADDR(READ_COPY_WR_ADDR),
//	 .mem1writeDATA(READ_COPY_WR_DATA),
//	 .READ_STATE(READ_STATE),
//	 .iCLR(iCLR),
//	 .iRSTn(WHOLE_RST),
//	 .iCLK(iCLK),
//	 .DONE(READ_DONE)
//	 );
//
//		
	 // counter for weight address
	 
	 //====================================================//
	 //XNOR + POPCOUNT//
    wire [111:0] iImage;
    wire [6:0] oPopcount;
    wire [111:0] WEIGHT;
	 wire ACCUMULATOR_EN;
	 
	 WEIGHT_ROM weight_rom(
	 .iADDR(weight_ADDR),
	 .oDATA(WEIGHT)
	 );
	 
    xnor_popcount#(
    .WL(112)
    )XNOR_POPCOUNT(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(1'b1),
    .idata(iImage),
    .iweight(WEIGHT),
    .odata(oPopcount),
	 .oEN(ACCUMULATOR_EN)
    );
    
	 // shift_reg 84bits (7bit>>)
	 // use it only in FCL2
	 // FCL2 done signal -> whole BNN DONE
	 
	 //====================================================//
	 //Accumulator//	 
	 wire [3:0] END_SIGNAL;
	 assign END_SIGNAL = (current_state > CONV3_ST) ? 4'd12 : 4'd9;	 

	 wire ACCUMULATOR_CLEAR;

	 wire COMPARATOR_EN;
    wire [10:0] oAccumulator;

	 wire COMPARATOR_iCNT;
	 
	 
	 // counter for iCNT
	 COUNTER_LAB#(
    .WL(4),
    .MV(END_SIGNAL)
    )Counter_iCNT_ACCMULATOR(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(ACCUMULATOR_EN),
    .oEN(ACCUMULATOR_CLEAR),
	 .oCNT(COMPARATOR_iCNT)
    );	
	 
    Accumulator#(
    .IL(7),
    .END(END_SIGNAL),
    .OL(11)
    )ACCUMLATOR(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iCLR(ACCUMULATOR_CLEAR),
    .iEN(ACCUMULATOR_EN),
    .iDATA(oPopcount),
	 .iCNT(COMPARATOR_iCNT)
    .oDATA(oAccumulator),
    .oEN(COMPARATOR_EN)
    );
    
	 //====================================================//
	 //COMPARATOR//
    wire oCompartor;
    wire [10:0] THRESHOLD;
	 wire MAXPOOLING_EN;

	 // need to counter for threshold address	 	 
	 THRESHOLD_ROM THRESHOLD_rom(
	 .iADDR(THRESHOLD_ADDR),
	 .oDATA(THRESHOLD)
	 );
    
    Comparator#(
    .IL(11)
    )COMPARATOR(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(COMPARATOR_EN),
    .iDATA(oAccumulator),
    .iTH(THRESHOLD),
    .oDATA(oCompartor),
    .oEN(MAXPOOLING_EN)
    );
    
	 //====================================================//
	 //FINAL REGISTER (Maxpooling)//

    // counter for 112
    // register address
    // make iADDR in Maxpooling(FINAL_REGISTER)
	 wire iADDR_clear;
	 wire [6:0] REG_ADDR;
    COUNTER_LAB#(
    .WL(7),
    .MV(112)
    )Counter_iADDR_MAXPOOLING(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(MAXPOOLING_EN),
	 .oEN(iADDR_clear),
    .oCNT(REG_ADDR)
    );	
	 
    // counter for 4 or 1
    // 4: CONV = > maxpooling
    // 1: FCL
    // make iWriteEN in Maxpooling(FINAL_REGISTER)
	 wire [2:0] WRITE_EN;
	 assign WRITE_EN = (current_state > CONV3_ST) ? 3'b001 : 3'b100;
	 wire MAXPOOLING_READ_EN;
	 wire [2:0] DUMP1;
	 
	 COUNTER_LAB#(
    .WL(3),
    .MV(WRITE_EN)
    )Counter_iADDR_MAXPOOLING(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(iADDR_clear),
	 .oEN(MAXPOOLING_READ_EN),
    .oCNT(DUMP1)
    );
	 
    Maxpooling#(
    .WL(112)
    )FINAL_REGISTER(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iReadEN(MAXPOOLING_READ_EN), // 
    .iWriteEN(MAXPOOLING_EN),
    .iDATA(oCompartor),
    .iADDR(REG_ADDR) // 
    .oDATA(BNN_WR_DATA)
    );
    
	 wire [7:0] STATE_DONE_CNT;
	 assign STATE_DONE_CNT = (current_state == CONV1_ST) ? 7'd252 :
	 (current_state == CONV2_ST) ? 7'd48 :
	 (current_state == CONV3_ST) ? 7'd6 :
	 (current_state == FCL1_ST) ? 7'd1 :
	 (current_state == FCL2_ST) ? 7'd1 : 7'd1;
		
	wire STATE_DONE;
	wire [7:0] MEM1_WR_ADDR_TMP;
	 COUNTER_LAB#(
	 .WL(8),
	 .MV(STATE_DONE_CNT)
	 )STATE_DONE_COUNTER(
	 .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(MAXPOOLING_READ_EN),
	 .oEN(STATE_DONE),
    .oCNT(MEM1_WR_ADDR_TMP)
	 );
	 
endmodule
