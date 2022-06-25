`timescale 1ns/100ps

module SPI_PROTOCOL(iRSTn,
                    iCLR,
                    SCLK,
                    MOSI,
                    CS,
                    iDATA,
                    MISO,
                    oRd_DONE,
                    oWr_DONE,
                    oADDR,
                    oRd_EN,
                    oDATA,
                    oWr_EN);
    
    //parameter
    parameter	[1:0]		IDLE_ST		 	  = 	2'b00;
    parameter	[1:0]		HEADER_ST	 	 = 	2'b01;
    parameter	[1:0]		READ_ST		 	  = 	2'b10;
    parameter	[1:0]		WRITE_ST		   = 	2'b11;
    
    //input from SPI
    input						iRSTn;
    input						iCLR;
    input						SCLK;
    input						MOSI;
    input						CS;
    
    //input from MEMORY
    input			[27:0]	iDATA;
    
    //output to SPI
    output					MISO;
    output					oRd_DONE;
    output					oWr_DONE;
    
    //output to MEMORY
    output		[5:0]		oADDR;
    output					oRd_EN;
    output		[27:0]	oDATA;
    output					oWr_EN;
    
    //wire
    wire			[5:0]		HEADER;
    wire						HEADER_EN;
    wire			[5:0]		Rd_ADDR;
    wire			[5:0]		Wr_ADDR;
    wire						EN1, EN2, EN3;
    wire						EN3_tmp1, EN3_tmp2;
    wire			[1:0]		next_state;
    
    //register
    reg			[1:0]		current_state;
    
    HEADER_DECODER Header_Decoder(
    .iCLK(SCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(EN1),
    .MOSI(MOSI),
    .oHEADER(HEADER),
    .oHEADER_EN(HEADER_EN)
    );
    
    READ_CONTROLLER Read_Controller(
    .iCLK(SCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(EN2),
    .iDATA(iDATA[7:0]),
    .MISO(MISO),
    .oRd_EN(oRd_EN),
    .oRd_ADDR(Rd_ADDR),
    .oRd_DONE(oRd_DONE)
    );
    
    WRITE_CONTROLLER Write_Controller(
    .iCLK(SCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(EN3),
    .MOSI(MOSI),
    .oDATA(oDATA),
    .oWr_EN(oWr_EN),
    .oWr_ADDR(Wr_ADDR),
    .oWr_DONE(oWr_DONE)
    );
    
    always@(posedge SCLK or negedge iRSTn)
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
    assign	next_state = (current_state == IDLE_ST)	? ((CS == 1'b0) ? HEADER_ST : IDLE_ST) :
    (current_state == HEADER_ST)	? (((HEADER == 6'b0) && (HEADER_EN == 1'b1)) ? READ_ST : ((HEADER == 6'b1) && (HEADER_EN == 1'b1) ? WRITE_ST : HEADER_ST)):
    (current_state == READ_ST)		? ((oRd_DONE == 1'b1) ? IDLE_ST : READ_ST) :
    (current_state == WRITE_ST)		? ((oWr_DONE == 1'b1) ? IDLE_ST : WRITE_ST) : IDLE_ST;
    
    assign	EN1				     = 	(current_state == HEADER_ST) ? 1'b1 : 1'b0;
    assign	EN2				     = 	(current_state == READ_ST) ? 1'b1 : 1'b0;
    assign	EN3_tmp1			 = 	(current_state == WRITE_ST) ? 1'b1 : 1'b0;
    
    D_REG#(
    .WL(1)
    )EN3_1D(
    .iCLK(SCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(1'b1),
    .iDATA(EN3_tmp1),
    .oDATA(EN3_tmp2)
    );
    
    D_REG#(
    .WL(1)
    )EN3_2D(
    .iCLK(SCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(1'b1),
    .iDATA(EN3_tmp2),
    .oDATA(EN3)
    );
    
    assign	oADDR = (EN2 == 1'b1) ? Rd_ADDR : (EN3 == 1'b1) ? Wr_ADDR : 6'd0;
    
endmodule
