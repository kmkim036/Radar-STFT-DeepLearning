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
    
    //next state logic
    assign next_state = (current_state == IDLE_ST) ? ((iSTART == 1'b1) ? READ_ST : IDLE_ST):
	 (current_state == READ_ST) ? ((READ_DONE == 1'b1) ? CONV1_ST : IDLE_ST) :
    (current_state == CONV1_ST) ? ((CONV1_DONE == 1'b1) ? CONV2_ST : CONV1_ST) :
    (current_state == CONV2_ST) ? ((CONV2_DONE == 1'b1) ? CONV3_ST : CONV2_ST) :
    (current_state == CONV3_ST) ? ((CONV3_DONE == 1'b1) ? FCL1_ST : CONV3_ST) :
    (current_state == FCL1_ST) ? ((FCL1_DONE == 1'b1) ? FCL2_ST : FCL1_ST) :
    (current_state == FCL2_ST) ? ((FCL2_DONE == 1'b1) ? IDLE_ST : FCL2_ST) :
    IDLE_ST;
    
    assign	oRd_EN 	 = (current_state == READ_ST) ? 1'b1 : 1'b0;
    assign	oWr_EN 	 = 1'b0;
    assign	DONE  	 = (oADDR == 5'd27) ? 1'b1 : 1'b0;	// 20 -> 19, 28 -> 27
    
    //MEM0 READ address counter
    COUNTER_NECV#(
    .WL(5),
    .IV(0)
    )Counter_Image(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR|DONE),
    .iEN(oRd_EN),
    .oCNT(oADDR)
    );
    
    //MEM1 READ address counter
    COUNTER_NECV#(
    .WL(5),
    .IV(0)
    )Counter_Image(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR|DONE),
    .iEN(oRd_EN),
    .oCNT(oADDR)
    );
    
	 // counter for weight address
	 
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
    .iRSTn(iRSTn),
    .iEN(1'b1),
    .idata(iImage),
    .iweight(WEIGHT),
    .odata(oPopcount),
	 .oEN(ACCUMULATOR_EN)
    );
    
	 wire [3:0] END_SIGNAL;
	 assign END_SIGNAL = (current_state > CONV3_ST) ? 4'd12 : 4'd9;
	 
	 // counter for 
	 wire ACCUMULATOR_CLEAR;
	 assign ACCUMULATOR_CLEAR = (counts == 0) ? 1'b1 : 1'b0;
	 wire COMPARATOR_EN;
    wire [10:0] oAccumulator;
    Accumulator#(
    .IL(7),
    .END(END_SIGNAL),
    .OL(11)
    )ACCUMLATOR(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(ACCUMULATOR_CLEAR),
    .iEN(ACCUMULATOR_EN),
    .iDATA(oPopcount),
	 .iCNT(counts for 9 or 12)
    .oDATA(oAccumulator),
    .oEN(COMPARATOR_EN)
    );
    
    wire oCompartor;

	 // counter for threshold address	 
    wire [10:0] THRESHOLD;
	 wire MAXPOOLING_EN;
	 
	 THRESHOLD_ROM THRESHOLD_rom(
	 .iADDR(THRESHOLD_ADDR),
	 .oDATA(THRESHOLD)
	 );
    
    Comparator#(
    .IL(11)
    )COMPARATOR(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(COMPARATOR_EN),
    .iDATA(oAccumulator),
    .iTH(THRESHOLD),
    .oDATA(oCompartor),
    .oEN(MAXPOOLING_EN)
    );
    
    // counter for 112
    // register address
    // make iADDR in Maxpooling(FINAL_REGISTER)
    
    // counter for 4 or 1
    // 4: CONV = > maxpooling
    // 1: FCL
    // make iWriteEN in Maxpooling(FINAL_REGISTER)
    
    wire [111:0] REG_DATA;
    
    Maxpooling#(
    .WL(112)
    )FINAL_REGISTER(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iCLR(afrer Read Register),
    .iReadEN(when need to write into MEM1), // 
    .iWriteEN(MAXPOOLING_EN),
    .iDATA(oCompartor),
    .iADDR(Register Address) // 
    .oDATA(REG_DATA)
    );
    
endmodule
