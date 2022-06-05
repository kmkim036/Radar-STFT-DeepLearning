`timescale 1ns/100ps

module READ_CONTROLLER(iCLK,
                       iRSTn,
                       iCLR,
                       iEN,
                       iDATA,
                       MISO,
                       oRd_EN,
                       oRd_ADDR,
                       oRd_DONE);
    
    parameter	IDLE_ST	 = 	1'b0;
    parameter	LAST_ST	 = 	1'b1;
    
    input			iCLK;
    input			iRSTn;
    input			iCLR;
    input			iEN;
    input	[7:0]	iDATA;
    
    output			MISO;
    output			oRd_EN;
    output	[4:0]	oRd_ADDR;
    output			oRd_DONE;
    
    wire	[7:0]	data;
    wire	[2:0]	CNT;
    wire			Rd_EN_LAST_tmp, Rd_EN_LAST;
    wire			LAST_8count_EN;
    wire	[2:0]	LAST_CNT;
    wire			next_state;
    
    reg				current_state;
    
    //data buffer
    D_REG#(
    .WL(8)
    )shift_reg0(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(iDATA),
    .oDATA(data)
    );
    
    //bit counter
    COUNTER_NECV_DOWN#(
    .WL(3),
    .IV(3'd1)
    )Down_Counter_8(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .oCNT(CNT)
    );
    
    assign	MISO	   = (iEN == 1'b1) ? data[CNT] : 1'bz;
    assign	oRd_EN	 = ((CNT == 3'd1) && (iEN == 1'b1)) ? 1'b1 : 1'b0;
    
    //address counter
    COUNTER_NECV#(
    .WL(5),
    .IV(5'd20)
    )Address_Counter(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR|Rd_EN_LAST_tmp),
    .iEN(oRd_EN),
    .oCNT(oRd_ADDR)
    );
    
    assign	Rd_EN_LAST_tmp = ((oRd_ADDR == 5'd28) && (oRd_EN == 1'b1)) ? 1'b1 : 1'b0;
    
    //1D for Rd_EN_LAST
    D_REG#(
    .WL(1)
    )D_Reg(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(Rd_EN_LAST_tmp),
    .oDATA(Rd_EN_LAST)
    );
    
    //fsm
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
    assign	next_state 	 = 	(current_state == IDLE_ST) ? ((Rd_EN_LAST == 1'b1) ? LAST_ST : IDLE_ST) :
    						(current_state == LAST_ST) ? ((oRd_DONE == 1'b1) ? IDLE_ST : LAST_ST) : 
                            IDLE_ST;
    
    assign	LAST_8count_EN	 =	(current_state == LAST_ST) ? 1'b1 : 1'b0;
    
    //last data 8clock counter
    COUNTER_NECV#(
    .WL(3),
    .IV(3'd0)
    )Last_Data_Counter_8(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(LAST_8count_EN),
    .oCNT(LAST_CNT)
    );
    
    assign	oRd_DONE	=	(LAST_CNT == 3'd7) ? 1'b1 : 1'b0;
    
endmodule
