`timescale 1ns/100ps

module WRITE_CONTROLLER(iCLK,
                        iRSTn,
                        iCLR,
                        iEN,
                        MOSI,
                        oDATA,
                        oWr_EN,
                        oWr_ADDR,
                        oWr_DONE);
    
    parameter	IDLE_ST		 = 	1'b0;
    parameter	LAST_ST		 = 	1'b1;
    
    input						iCLK;
    input						iRSTn;
    input						iCLR;
    input						iEN;
    input						MOSI;
    
    output		[27:0]	oDATA;
    output					oWr_EN;
    output		[5:0]		oWr_ADDR;
    output					oWr_DONE;
    
    wire						d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, d16, d17, d18, d19, d20, d21, d22, d23, d24, d25, d26, d27, d28;
    wire			[4:0]		CNT_line;
    wire						ECV_VALUE;
    wire			[2:0]		LAST_CNT;
    wire						Wr_EN_LAST;
    wire						LAST_3count_EN;
    wire						next_state;
    
    reg						current_state;
    
    //shift reg
    D_REG#(
    .WL(1)
    )Shift_Reg0(
    .iCLK(~iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(MOSI),
    .oDATA(d0)
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
    
    D_REG#(
    .WL(1)
    )Shift_Reg21(
    .iCLK(~iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(d20),
    .oDATA(d21)
    );
    
    D_REG#(
    .WL(1)
    )Shift_Reg22(
    .iCLK(~iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(d21),
    .oDATA(d22)
    );
    
    D_REG#(
    .WL(1)
    )Shift_Reg23(
    .iCLK(~iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(d22),
    .oDATA(d23)
    );
    
    D_REG#(
    .WL(1)
    )Shift_Reg24(
    .iCLK(~iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(d23),
    .oDATA(d24)
    );
    
    D_REG#(
    .WL(1)
    )Shift_Reg25(
    .iCLK(~iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(d24),
    .oDATA(d25)
    );
    
    D_REG#(
    .WL(1)
    )Shift_Reg26(
    .iCLK(~iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(d25),
    .oDATA(d26)
    );
    
    D_REG#(
    .WL(1)
    )Shift_Reg27(
    .iCLK(~iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(d26),
    .oDATA(d27)
    );
    
    D_REG#(
    .WL(1)
    )Shift_Reg28(
    .iCLK(~iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(d27),
    .oDATA(d28)
    );
    
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
    
    assign	oDATA	     = 	{d28, d27, d26, d25, d24, d23, d22, d21, d20, d19, d18, d17, d16, d15, d14, d13, d12, d11, d10, d9, d8, d7, d6, d5, d4, d3, d2, d1};
    assign	oWr_EN	    = 	((CNT_line == 5'd28) && (iEN == 1'b1)) ? 1'b1 : 1'b0;
    assign	ECV_VALUE	 = 	((CNT_line == 5'd31) && (iEN == 1'b1)) ? 1'b1 : 1'b0;
    
    COUNTER_NECV#(
    .WL(6),
    .IV(0)
    )Counter_Image(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(oWr_EN),
    .oCNT(oWr_ADDR)
    );
    
    assign	Wr_EN_LAST	 = 	((oWr_ADDR == 6'd35) && (oWr_EN == 1'b1)) ? 1'b1 : 1'b0;
    
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
    assign	next_state = 	(current_state == IDLE_ST) ? ((Wr_EN_LAST == 1'b1) ? LAST_ST : IDLE_ST):
    (current_state == LAST_ST) ? ((oWr_DONE == 1'b1) ? IDLE_ST : LAST_ST): IDLE_ST;
    
    assign	LAST_3count_EN	 = 	(current_state == LAST_ST) ? 1'b1 : 1'b0;
    
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
    
    assign	oWr_DONE = (LAST_CNT == 3'd2) ? 1'b1 : 1'b0;
    
endmodule
