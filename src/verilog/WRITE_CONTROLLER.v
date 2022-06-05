`timescale 1ns/100ps

module WRITE_CONTROLLER(iCLK,
                        iRSTn,
                        iCLR,
                        iEN,
                        MOSI,
                        oDATA,
                        oWr_EN,
                        oWr_ADDR,
                        oWr_DONE,
                        ILA_WR_CNT_line,
                        ILA_WR_ECV_VALUE,
                        ILA_WR_LAST_CNT,
                        ILA_WR_Wr_EN_LAST,
                        ILA_WR_LAST_3count_EN,
                        ILA_WR_next_state,
                        ILA_WR_current_state);
    
    parameter	IDLE_ST	=	1'b0;
    parameter	LAST_ST	=	1'b1;
    
    input		iCLK;
    input		iRSTn;
    input		iCLR;
    input		iEN;
    input		MOSI;
    
    output		[19:0]	oDATA;
    output				oWr_EN;
    output		[4:0]	oWr_ADDR;
    output				oWr_DONE;
    
    //ILA
    output		[4:0]	ILA_WR_CNT_line;
    output				ILA_WR_ECV_VALUE;
    output		[2:0]	ILA_WR_LAST_CNT;
    output				ILA_WR_Wr_EN_LAST;
    output				ILA_WR_LAST_3count_EN;
    output				ILA_WR_next_state;
    output				ILA_WR_current_state;
    
    wire				d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, d16, d17, d18, d19, d20;
    wire		[4:0]	CNT_line;
    wire				ECV_VALUE;
    wire		[2:0]	LAST_CNT;
    wire				Wr_EN_LAST;
    wire				LAST_3count_EN;
    wire				next_state;
    
    reg					current_state;
    
    //shift reg
    D_REG#(
	.WL(1)
	)Shift_Reg0(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(MOSI)
	,.oDATA(d0)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg1(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d0), 
	.oDATA(d1)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg2(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d1), 
	.oDATA(d2)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg3(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d2), 
	.oDATA(d3)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg4(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d3), 
	.oDATA(d4)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg5(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d4), 
	.oDATA(d5)
	);
 
    D_REG#(
	.WL(1)
	)Shift_Reg6(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d5), 
	.oDATA(d6)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg7(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d6), 
	.oDATA(d7)
	);
 
    D_REG#(
	.WL(1)
	)Shift_Reg8(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d7), 
	.oDATA(d8)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg9(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d8), 
	.oDATA(d9)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg10(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d9), 
	.oDATA(d10)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg11(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d10),
	.oDATA(d11)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg12(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d11),
	.oDATA(d12)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg13(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d12),
	.oDATA(d13)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg14(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d13),
	.oDATA(d14)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg15(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d14),
	.oDATA(d15)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg16(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d15),
	.oDATA(d16)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg17(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d16),
	.oDATA(d17)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg18(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d17),
	.oDATA(d18)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg19(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d18),
	.oDATA(d19)
	);

    D_REG#(
	.WL(1)
	)Shift_Reg20(
	.iCLK(~iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(iEN), 
	.iDATA(d19),
	.oDATA(d20)
	);

    //counter 1 line(20bit), SPI = 24clock
    COUNTER_NECV#(
	.WL(5), 
	.IV(0)
	)Counter_Line(
	.iCLK(iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR|ECV_VALUE), 
	.iEN(iEN), 
	.oCNT(CNT_line)
	);
    
    assign	oDATA		= 	{d20, d19, d18, d17, d16, d15, d14, d13, d12, d11, d10, d9, d8, d7, d6, d5, d4, d3, d2, d1};
    assign	oWr_EN		= 	((CNT_line == 5'd20) && (iEN == 1'b1)) ? 1'b1 : 1'b0;
    assign	ECV_VALUE	= 	((CNT_line == 5'd23) && (iEN == 1'b1)) ? 1'b1 : 1'b0;
    
    //counter 1 image(20line)
    COUNTER_NECV#(
	.WL(5), 
	.IV(0)
	)Counter_Image(
	.iCLK(iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(oWr_EN), 
	.oCNT(oWr_ADDR)
	);
    
    assign	Wr_EN_LAST	=	((oWr_ADDR == 5'd19) && (oWr_EN == 1'b1)) ? 1'b1 : 1'b0;
    
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
    assign	next_state	=	(current_state == IDLE_ST) ? ((Wr_EN_LAST == 1'b1) ? LAST_ST : IDLE_ST) :
    						(current_state == LAST_ST) ? ((oWr_DONE == 1'b1) ? IDLE_ST : LAST_ST) : 
							IDLE_ST;
    
    assign	LAST_3count_EN 	=	(current_state == LAST_ST) ? 1'b1 : 1'b0;
    
    //last data 3clock counter
    COUNTER_NECV#(
	.WL(3), 
	.IV(3'd0)
	)Last_Data_Counter_8(
	.iCLK(iCLK), 
	.iRSTn(iRSTn), 
	.iCLR(iCLR), 
	.iEN(LAST_3count_EN), 
	.oCNT(LAST_CNT)
	);
    
    assign	oWr_DONE	=	(LAST_CNT == 3'd2) ? 1'b1 : 1'b0;
    
endmodule
