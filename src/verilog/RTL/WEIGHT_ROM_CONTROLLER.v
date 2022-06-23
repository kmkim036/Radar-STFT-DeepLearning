module WEIGHT_ROM_CONTROLLER(iCLK,
                             iRSTn,
                             iEN,
                             iSTATE,
                             oADDR);
    
    // iEN == ReadEnable which is same with MEM0 or MEM1 ReadEnable
    
    parameter	IDLE_ST		  = 	3'b000;
    parameter 	READ_ST		  =     3'b001;
    parameter	CONV1_ST	  = 	3'b010;
    parameter	CONV2_ST	  = 	3'b011;
    parameter	CONV3_ST	  = 	3'b100;
    parameter	FCL1_ST		  = 	3'b101;
    parameter	FCL2_ST		  = 	3'b110;
    
    parameter	CONV2_OFFSET	 = 	12'd9;
    parameter	CONV3_OFFSET	 = 	12'd1017;
    parameter	FCL1_OFFSET		 = 	12'd2025;
    parameter	FCL2_OFFSET		 = 	12'd2697;
    
    input	iCLK, iRSTn, iEN;
    input	[2:0] iSTATE;
    
    output	[11:0] oADDR;
    
    wire	[6:0]	CNT_112;
    wire	[3:0] CNT_9;
    wire  oEN_4, oEN_9;
    wire	[9:0] CNTS_CONV23, CNTS_FCL1;
    wire	[3:0]	CNTS_FCL2;
    wire	DUMP1, DUMP2, DUMP3;
    
    COUNTER_LAB#(
    .WL(4),
    .MV(9)
    )CONV1_Counter9(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(iEN),
    .oCNT(CNT_9),
    .oEN(oEN_4)
    );
    
    COUNTER_LAB#(
    .WL(7),
    .MV(112)
    )CONV1_Counter112(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(oEN_4),
    .oCNT(CNT_112),
    .oEN(oEN_9)
    );
    
    COUNTER_LAB#(
    .WL(10),
    .MV(10'd1008)
    )CONV23(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(iEN),
    .oEN(DUMP1),
    .oCNT(CNTS_CONV23)
    );
    
    COUNTER_LAB#(
    .WL(10),
    .MV(10'd672)
    )FCL1(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(iEN),
    .oEN(DUMP2),
    .oCNT(CNTS_FCL1)
    );
    
    COUNTER_LAB#(
    .WL(4),
    .MV(4'd12)
    )FCL2(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(iEN),
    .oEN(DUMP3),
    .oCNT(CNTS_FCL2)
    );
    
    assign oADDR = 	(iSTATE == CONV1_ST) ? {8'b0, CNT_9} :
    (iSTATE == CONV2_ST) ? CNTS_CONV23 + CONV2_OFFSET :
    (iSTATE == CONV3_ST) ? CNTS_CONV23 + CONV3_OFFSET :
    (iSTATE == FCL1_ST) ? CNTS_FCL1 + FCL1_OFFSET :
    (iSTATE == FCL2_ST) ? CNTS_FCL2 + FCL2_OFFSET : 12'd0;
    
endmodule
