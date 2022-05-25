`timescale 1ns/100ps

module BNN_Top(iCLK,
                   iRSTn,
                   iCLR,
                   iSTART,
                   oADDR,
                   oRd_EN,
                   oWr_EN);
    
    parameter	IDLE_ST	= 	3'b000;
    parameter	CONV1_ST	= 	3'b001;
    parameter	CONV2_ST	= 	3'b010; 
	 parameter	CONV3_ST = 	3'b011;
	 parameter	FCL1_ST	=	3'b100;
	 parameter	FCL2_ST	= 	3'b101;
	 
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
    
    //FSM			mem0Read	mem0Write	mem1Read	mem1Write
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
    assign	next_state = (current_state == IDLE_ST) ? ((iSTART == 1'b1) ? CONV1_ST : IDLE_ST) :
								 (current_state == CONV1_ST) ? ((CONV1_DONE == 1'b1) ? CONV2_ST : CONV1_ST) : 
								 (current_state == CONV2_ST) ? ((CONV2_DONE == 1'b1) ? CONV3_ST : CONV2_ST) : 
								 (current_state == CONV3_ST) ? ((CONV3_DONE == 1'b1) ? FCL1_ST : CONV3_ST) : 
								 (current_state == FCL1_ST) ? ((FCL1_DONE == 1'b1) ? FCL2_ST : FCL1_ST) : 
								 (current_state == FCL2_ST) ? ((FCL2_DONE == 1'b1) ? IDLE_ST : FCL2_ST) : 
                         IDLE_ST;
    
    assign	oRd_EN 	= (current_state == READ_ST) ? 1'b1 : 1'b0;
    assign	oWr_EN 	= 1'b0;
    assign	DONE  	= (oADDR == 5'd27) ? 1'b1 : 1'b0;	// 20 -> 19, 28 -> 27
    
    //MEM0 address counter
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
	
    //MEM1 address counter
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

	wire [111:0] iImage;
	wire [6:0] oPopcount;
	
	xnor_popcount#(
	.WL(112)
	)XNOR_POPCOUNT(
	.iCLK(iCLK), 
	.iRSTn(iRSTn), 
	.iEN(1'b1),
	.idata(iImage),
	.iweight(),
	.odata(oPopcount)
	);
	
//	COUNTER_NECV#(
//	.WL(4), 
//	.IV(0)
//	)Counter_Image(
//	.iCLK(iCLK), 
//	.iRSTn(iRSTn), 
//	.iCLR(iCLR|DONE), 
//	.iEN(oRd_EN), 
//	.oCNT(oADDR)
//	);

		wire [10:0] oAccumulator;
	Accumulator#(
	.IL(7),
	.END(9),
	.OL(11)
	)ACCUMLATOR(
	.iCLK(iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(after count 9 or 12),
   .iEN(after popcount calc),
   .iDATA(oPopcount),
   .oDATA(oAccumulator),
	.oEN()
	);
	
	wire oCompartor;
	
	Comparator#(
	.IL(11)
	)COMPARATOR(
	.iCLK(iCLK), 
	.iRSTn(iRSTn), 
	.iEN(),
	.iDATA(oAccumulator),
	.iTH(),
	.oDATA(oCompartor),
	.oEN()
	);
	
	//	MAXPOOLING
	// input 112 * 4 => output 1
	
	wire oMaxpooling;
	
	wire [111:0] REG_DATA;
	SHIFT_REG#(
	.WL(112),
   .TL(7)    
	)Shift_reg(
	.iCLK(iCLK), 
	.iRSTn(iRSTn), 
	.iEN(),
	.iCLR,
	.iDATA(oMaxpooling),
   .oDATA(REG_DATA)
	);
	
endmodule
