
module BNN_TEST(iCLK,
                iSTART,
                iRSTn,
                iCLR,
                oMEM0RdADDR,
                oMEM0WrADDR,
                oMEM0WrDATA,
                oMEM0Rd_EN,
                oMEM0Wr_EN,
                done,
                oPopcount);
    
    parameter	IDLE_ST		  = 	3'b000;
    parameter 	READ_ST		 = 3'b001;
    parameter	CONV1_ST	  = 	3'b010;
    parameter	CONV2_ST	  = 	3'b011;
    parameter	CONV3_ST	  = 	3'b100;
    parameter	FCL1_ST		  = 	3'b101;
    parameter	FCL2_ST		  = 	3'b110;
    
    parameter	MEM1_OFFSET             = 8'd252;
    parameter	THRESHOLD_CONV2_OFFSET	 = 	9'd112;
    parameter	THRESHOLD_CONV3_OFFSET	 = 	9'd224;
    parameter	THRESHOLD_FCL1_OFFSET	  = 	9'd336;
    
    input			iCLK;
    input			iCLR;
    input			iRSTn;
    input 		   iSTART;
    //	 input	[27:0]	iMEM0RdDATA;
    
    output	[5:0]	oMEM0WrADDR, oMEM0RdADDR;
    output	[27:0]	oMEM0WrDATA;
    output	oMEM0Rd_EN, oMEM0Wr_EN;
    
    // temporary for compile
    assign oMEM0Rd_EN = 1'b1;
    assign oMEM0Wr_EN = 1'b1;
    
    reg [2:0] current_state;
    
    wire	 		CONV1_Wr_DONE, CONV2_Wr_DONE, CONV3_Wr_DONE, FCL1_Wr_DONE;
    wire	[8:0]	CONV1_Wr_ADDR, CONV2_Wr_ADDR, CONV3_Wr_ADDR, FCL1_Wr_ADDR;
    
    wire            STATE_DONE;
    assign STATE_DONE = (current_state == CONV1_ST) ? CONV1_Wr_DONE :
    (current_state == CONV2_ST) ? CONV2_Wr_DONE :
    (current_state == CONV3_ST) ? CONV3_Wr_DONE :
    (current_state == FCL1_ST) ? FCL1_Wr_DONE : 1'b0;
    
    wire        WHOLE_RST, STATE_DONE_DELAY;
    D_FF_enable#(
    .WL(1)
    )U_D_FF_0(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(1'b1),
    .iDATA(STATE_DONE),
    .oDATA(STATE_DONE_DELAY)
    );
    assign WHOLE_RST = iRSTn & ~STATE_DONE_DELAY;
    
    wire	[2:0] next_state;
    assign next_state = (current_state == IDLE_ST) ? (iSTART == 1'b1) ? CONV1_ST : IDLE_ST :
    (current_state == CONV1_ST) ? (STATE_DONE == 1'b1) ? CONV2_ST : CONV1_ST :
    (current_state == CONV2_ST) ? (STATE_DONE == 1'b1) ? CONV3_ST : CONV2_ST :
    (current_state == CONV3_ST) ? (STATE_DONE == 1'b1) ? FCL1_ST : CONV3_ST :
    (current_state == FCL1_ST) ? (STATE_DONE == 1'b1) ? FCL2_ST : FCL1_ST :
    (current_state == FCL2_ST) ? (STATE_DONE == 1'b1) ? IDLE_ST : FCL2_ST : IDLE_ST;
    
    
    wire    [111:0]   IMAGE;
    wire    [111:0]   WEIGHT;
    wire    [11:0]   weight_ADDR;
    output    [6:0]   oPopcount;
    wire            ACCUMULATOR_EN;
    
    wire    [8:0]  MEM1_wr_ADDR;
    wire    [8:0]   MEM1_Rd_ADDR;
    wire            MEM1_Rd_DONE;
    wire				  MEM0_Rd_DONE;
    wire            READ_DONE;
    wire Rd_Enable0;
    assign READ_DONE = (current_state > CONV1_ST) ? MEM1_Rd_DONE : MEM0_Rd_DONE;
    wire Rd_Enable;
    assign Rd_Enable0 = (current_state == IDLE_ST) ? (iSTART == 1'b1) ? 1'b1 : 1'b0 :
    (STATE_DONE == 1'b0 && READ_DONE == 1'b0) ? 1'b1 : 1'b0; //CONV1, CONV2, CONV3, FCL1, FCL2
    wire	[111:0]	BNN_WR_DATA;
    D_REG
    #(.WL(1))
    U_D_rd_en_delay(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(Rd_Enable0),
    .oDATA(Rd_Enable)
    );
    wire [111:0] IMAGE_TEMP_MEM0, IMAGE_TEMP_MEM1;
    wire	[27:0]	MEM0RdDATA_TMP;
    //	assign IMAGE_TEMP_MEM0 = {84'd0 ,iMEM0RdDATA};
    assign IMAGE_TEMP_MEM0    = {84'd0 ,MEM0RdDATA_TMP};
    
    wire [4:0] CONV1_Bit_ADDR;
    assign IMAGE = (current_state == CONV1_ST) ? IMAGE_TEMP_MEM0 : IMAGE_TEMP_MEM1;
    
    wire            ACCUMULATOR_CLEAR;
    wire            COMPARATOR_EN;
    wire    [10:0]  oAccumulator;
    wire    [3:0]   COMPARATOR_iCNT;
    
    
    wire    [6:0]   total_CNT;
    
    
    wire [3:0] ACC_Max_Val;
    assign ACC_Max_Val = (current_state > CONV3_ST) ? 4'd6 : 4'd9;
    wire            oCompartor;
    wire            MAXPOOLING_EN;
    wire    [9:0]   THRESHOLD_VALUE;
    wire    [8:0]   THRESHOLD_ADDR_CNTS, THRESHOLD_ADDR;
    
    wire MAXPOOLING_READ_EN, CONV_READ_EN, FCL_READ_EN;
    wire    [2:0]   DUMP1;
    wire            DUMP2, DUMP3;
    
    //////////////////////////////////
    output done;
    
    wire POPCOUNT_EN;
    wire RD_EN_delay1, RD_EN_delay2;
    
    always@(posedge iCLK or negedge iRSTn)
    begin
        if (~iRSTn)
        begin
            current_state <= IDLE_ST;
        end
        else if (iCLR)
        begin
            current_state <= IDLE_ST;
        end
        else
        begin
            current_state <= next_state;
        end
    end
    assign THRESHOLD_ADDR = 	(current_state == CONV1_ST) ? THRESHOLD_ADDR_CNTS :
    (current_state == CONV2_ST) ? THRESHOLD_ADDR_CNTS + THRESHOLD_CONV2_OFFSET :
    (current_state == CONV3_ST) ? THRESHOLD_ADDR_CNTS + THRESHOLD_CONV3_OFFSET :
    (current_state == FCL1_ST) ? THRESHOLD_ADDR_CNTS + THRESHOLD_FCL1_OFFSET : 9'd0;
    // (current_state == FCL1_ST) ? THRESHOLD_FCL1_OFFSET : 9'd0;	// use this same threshold
    
    MEM48X28 MEM0(
    .clock(iCLK),
    .data(oMEM0WrDATA),
    .rdaddress(oMEM0RdADDR),
    .rden(Rd_Enable),
    .wraddress(oMEM0WrADDR),
    .wren(oMEM0Wr_EN),
    //	.q(iMEM0RdDATA)
    .q(MEM0RdDATA_TMP)
    );
    
    MEM112X300 MEM1(
    .clock(iCLK),
    .data(BNN_WR_DATA),
    .rdaddress(MEM1_Rd_ADDR),
    .rden(Rd_Enable),
    .wraddress(MEM1_wr_ADDR),
    .wren(MAXPOOLING_READ_EN),
    .q(IMAGE_TEMP_MEM1)
    );
    
    MEM1_READ_CONTROLLER MEM1_READ_ADDR_CONTROLLER(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(Rd_Enable),
    .iSTATE(current_state),
    .oADDR(MEM1_Rd_ADDR),
    .oDONE(MEM1_Rd_DONE)
    );
    
    
    CONV1_Read_Controller MEM0_READ_ADDR_CONTROLLER(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(Rd_Enable),
    .oRd_ADDR(oMEM0RdADDR),
    .oBit_ADDR(CONV1_Bit_ADDR),
    .oRd_DONE(MEM0_Rd_DONE)
    );
    
    
    WEIGHT_ROM_CONTROLLER WEIGHT_ROM_CONTROLLER(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(Rd_Enable),
    .iSTATE(current_state),
    .oADDR(weight_ADDR)
    );
    
    WEIGHT_ROM WEIGHT_ROM(
    .address(weight_ADDR),
    .clock(iCLK),
    .rden(Rd_Enable),
    .q(WEIGHT)
    );
    
    //    D_FF_enable#(
    //    .WL(1)
    //    )U_D_FF_1(
    //    .iCLK(iCLK),
    //    .iRSTn(iRSTn),
    //    .iEN(1'b1),
    //    .iDATA(Rd_Enable),
    //    .oDATA(Rd_Enable_DELAY)
    //    );
    
    D_REG
    #(.WL(1))
    U_D_delay1(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(Rd_Enable),
    .oDATA(RD_EN_delay1)
    );
    
    // D_REG
    //	 #(.WL(1))
    //	 U_D_delay2(
    //	.iRSTn(iRSTn),
    //	.iCLK(iCLK),
    //	.iEN(1),
    //	.iCLR(0),
    //	.iDATA(RD_EN_delay1),
    //	.oDATA(RD_EN_delay2)
    //);
    
    //    D_FF_enable#(
    //    .WL(1)
    //    )U_D_FF_2(
    //    .iCLK(iCLK),
    //    .iRSTn(iRSTn),
    //    .iEN(1'b1),
    //    .iDATA(Rd_Enable_DELAY),
    //    .oDATA(POPCOUNT_EN)
    //    );
    
    D_REG#(
    .WL(1)
    )U_D_POP_EN(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(RD_EN_delay1),
    .oDATA(POPCOUNT_EN)
    );
    
    xnor_popcount#(
    .WL(112)
    )XNOR_POPCOUNT(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(POPCOUNT_EN), // after first memory read by stages: read enable + 2 clk
    .idata(IMAGE),
    .iSTATE(current_state),
    .iweight(WEIGHT),
    .iaddr(CONV1_Bit_ADDR),
    .odata(oPopcount),
    .oEN(ACCUMULATOR_EN)
    );
    
    COUNTER_LAB#(
    .WL(7),
    .MV(100)
    )Counter_total(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(1'b1),
    .oCNT(total_CNT)
    );
    
    // counter for iCNT
    COUNTER_LAB_ACC#(
    .WL(4)
    )Counter_iCNT_ACCMULATOR(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(ACCUMULATOR_EN),
    .iMV(ACC_Max_Val),
    .oEN(ACCUMULATOR_CLEAR),
    .oCNT(COMPARATOR_iCNT)
    );
    
    Accumulator#(
    .IL(7),
    .OL(11)
    )ACCUMLATOR(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iCLR(ACCUMULATOR_CLEAR),
    .iEN(ACCUMULATOR_EN),
    .iDATA(oPopcount),
    .iCNT(COMPARATOR_iCNT),
    .iMV(ACC_Max_Val),
    .oDATA(oAccumulator),
    .oEN(COMPARATOR_EN)
    );
    
    COUNTER_LAB#(
    .WL(9),
    .MV(112)
    )THRESHOLD_ADDR_COUNTER(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(COMPARATOR_EN),
    .oEN(DUMP3),
    .oCNT(THRESHOLD_ADDR_CNTS)
    );
    
    THRESHOLD_ROM THRESHOLD_ROM(
    .address(THRESHOLD_ADDR),
    .clock(iCLK),
    .rden(COMPARATOR_EN),
    .q(THRESHOLD_VALUE)
    );
    
    wire cmr_EN_d1, cmr_EN;
    
    D_REG#(
    .WL(1)
    )U_D_cmr_EN_d1(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(COMPARATOR_EN),
    .oDATA(cmr_EN_d1)
    );
    
    D_REG#(
    .WL(1)
    )
    U_D_cmr_EN_d2(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(cmr_EN_d1),
    .oDATA(cmr_EN)
    );
    
    wire [10:0] cmr_data_d1, cmr_data;
    D_REG#(
    .WL(11)
    )U_D_cmr_data_d1(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(oAccumulator),
    .oDATA(cmr_data_d1)
    );
    
    D_REG#(
    .WL(11)
    )U_D_cmr_data_d2(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(cmr_data_d1),
    .oDATA(cmr_data)
    );
    
    Comparator#(
    .IL(11)
    )COMPARATOR(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(cmr_EN),
    .iDATA(cmr_data),
    .iTH({1'b0,THRESHOLD_VALUE}),
    .oDATA(oCompartor),
    .oEN(MAXPOOLING_EN)
    );
    
    // counter for 112
    // register address
    // make iADDR in Maxpooling(FINAL_REGISTER)
    wire            iADDR_clear;
    wire    [6:0]  REG_ADDR;
    COUNTER_LAB#(
    .WL(7),
    .MV(112)
    )MAXPOOLING_iADDR_COUNTER(
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
    wire max_EN_4;
    COUNTER_LAB#(
    .WL(3),
    .MV(4)
    )MAXPOOLING_iRdEn_COUNTER_CONV(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(iADDR_clear),
    .oEN(max_EN_4),
    .oCNT(DUMP1)
    );
    
    COUNTER_LAB#(
    .WL(1),
    .MV(1)
    )MAXPOOLING_iRdEn_COUNTER_FCL(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(iADDR_clear),
    .oEN(FCL_READ_EN),
    .oCNT(DUMP2)
    );
    
    wire CONV_READ_EN1;
    assign CONV_READ_EN = (max_EN_4 == 1) && (iADDR_clear == 1) ? 1'b1 : 1'b0;
    
    D_REG#(
    .WL(1)
    )U_D_READ_EN(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(CONV_READ_EN),
    .oDATA(CONV_READ_EN1)
    );
    
    wire FCL_READ_EN1;
    D_REG#(
    .WL(1)
    )U_D_FCL_READ_EN(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(FCL_READ_EN),
    .oDATA(FCL_READ_EN1)
    );
    
    assign MAXPOOLING_READ_EN = (current_state > CONV3_ST) ? FCL_READ_EN1 : CONV_READ_EN1;
    
    Maxpooling#(
    .WL(112)
    )FINAL_REGISTER(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iReadEN(MAXPOOLING_READ_EN),
    .iWriteEN(MAXPOOLING_EN),
    .iDATA(oCompartor),
    .iADDR(REG_ADDR),
    .oDATA(BNN_WR_DATA)
    );
    
    COUNTER_LAB#(
    .WL(9),
    .MV(252)
    )WR_DONE_COUNTER_CONV1(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(MAXPOOLING_READ_EN),
    .oEN(CONV1_Wr_DONE),
    .oCNT(CONV1_Wr_ADDR)
    );
    
    COUNTER_LAB#(
    .WL(9),
    .MV(48)
    )WR_DONE_COUNTER_CONV2(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(MAXPOOLING_READ_EN),
    .oEN(CONV2_Wr_DONE),
    .oCNT(CONV2_Wr_ADDR)
    );
    
    COUNTER_LAB#(
    .WL(9),
    .MV(6)
    )WR_DONE_COUNTER_CONV3(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(MAXPOOLING_READ_EN),
    .oEN(CONV3_Wr_DONE),
    .oCNT(CONV3_Wr_ADDR)
    );
    
    COUNTER_LAB#(
    .WL(9),
    .MV(1)
    )WR_DONE_COUNTER_FCL1(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(MAXPOOLING_READ_EN),
    .oEN(FCL1_Wr_DONE),
    .oCNT(FCL1_Wr_ADDR)
    );
    
    /////////////////////final result save///////////////////////////
    wire [3:0] class_index;
    wire	FinalOutEnable;
    wire	Final_Compare;
    assign Final_Compare_En = (current_state == FCL2_ST) ? 1'b1 : 1'b0;
    COUNTER_LAB#(
    .WL(4),
    .MV(13)
    )Final_Compare_CNT(
    .iCLK(iCLK),
    .iRSTn(WHOLE_RST),
    .iEN(ACCUMULATOR_EN & Final_Compare_En),
    .oEN(FinalOutEnable),
    .oCNT(class_index)
    );
    
    reg [3:0] Final_Index;
    reg [6:0] Maximum_Value;
    
    always@(posedge iCLK or negedge WHOLE_RST)
    begin
        if (~WHOLE_RST)
        begin
            Final_Index   <= 4'd0;
            Maximum_Value <= 7'd0;
        end
        else
        begin
            if (ACCUMULATOR_EN && Final_Compare_En)
            begin
                if (Maximum_Value < oPopcount)
                begin
                    Final_Index   <= class_index;
                    Maximum_Value <= oPopcount;
                end
            end
        end
    end
    // MEM0 Wr Enable: Final_Compare_En && FinalOutEnable
    
    assign MEM1_wr_ADDR = (current_state == CONV1_ST) ? CONV1_Wr_ADDR :
    (current_state == CONV2_ST) ? (CONV2_Wr_ADDR + MEM1_OFFSET) :
    (current_state == CONV3_ST) ? CONV3_Wr_ADDR :
    (current_state == FCL1_ST) ? (FCL1_Wr_ADDR + MEM1_OFFSET) : 9'd0;
    
    assign done = (current_state == FCL2_ST) ? 1 : 0;
    
endmodule
