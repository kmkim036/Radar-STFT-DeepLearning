// Read ADDR Test
module MEM1_READ_CONTROLLER(iCLK,
                            iRSTn,
                            iEN,
                            iSTATE,
                            oADDR,
                            oDONE);
    
    parameter	IDLE_ST		  = 	3'b000;
    parameter 	READ_ST		  =     3'b001;
    parameter	CONV1_ST	  = 	3'b010;
    parameter	CONV2_ST	  = 	3'b011;
    parameter	CONV3_ST	  = 	3'b100;
    parameter	FCL1_ST		  = 	3'b101;
    parameter	FCL2_ST		  = 	3'b110;
    
    parameter	MEM1_OFFSET	 = 	9'd252;
    
    input			iCLK;
    input			iRSTn;
    input	[2:0]	iSTATE;
    input 			iEN;
    output	[8:0]	oADDR;
    output			oDONE;
    
    wire			CONV2_Rd_DONE, CONV3_Rd_DONE, FCL1_Rd_DONE, FCL2_Rd_DONE;
    wire 	[8:0] 	CONV2_Rd_ADDR, CONV3_Rd_ADDR, FCL1_Rd_ADDR, FCL2_Rd_ADDR;
    
    CONV23_Read_Controller#(
    .WIDTH(14),
    .HEIGHT(18)
    )CONV2_READ_CONTROLLER(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(iEN),	// Enable for Reading
    .oRd_ADDR(CONV2_Rd_ADDR),
    .oRd_DONE(CONV2_Rd_DONE)
    );
    
    CONV23_Read_Controller#(
    .WIDTH(6),
    .HEIGHT(8)
    )CONV3_READ_CONTROLLER(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(iEN),	// Enable for Reading
    .oRd_ADDR(CONV3_Rd_ADDR),
    .oRd_DONE(CONV3_Rd_DONE)
    );
    
    FCL_Read_Controller#(
    .OUTER_COUNTER_MV(112),
    .INNER_COUNTER_MV(6)
    )FCL1_READ_CONTROLLER(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(iEN),	// Enable for Reading
    .oRd_ADDR(FCL1_Rd_ADDR),
    .oRd_DONE(FCL1_Rd_DONE)
    );
    
    FCL_Read_Controller#(
    .OUTER_COUNTER_MV(12),
    .INNER_COUNTER_MV(1)
    )FCL2_READ_CONTROLLER(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(iEN),	// Enable for Reading
    .oRd_ADDR(FCL2_Rd_ADDR),
    .oRd_DONE(FCL2_Rd_DONE)
    );
    
    assign oDONE = (iSTATE == CONV2_ST) ? CONV2_Rd_DONE :
    (iSTATE == CONV3_ST) ? CONV3_Rd_DONE :
    (iSTATE == FCL1_ST) ? FCL1_Rd_DONE :
    (iSTATE == FCL2_ST) ? FCL2_Rd_DONE : 1'b0;
    
    assign oADDR = (iSTATE == CONV2_ST) ? CONV2_Rd_ADDR :
    (iSTATE == CONV3_ST) ? (CONV3_Rd_ADDR + MEM1_OFFSET) :
    (iSTATE == FCL1_ST) ? FCL1_Rd_ADDR :
    (iSTATE == FCL2_ST) ? (FCL2_Rd_ADDR + MEM1_OFFSET) : 9'd0;
    
endmodule
