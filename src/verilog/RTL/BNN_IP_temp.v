`timescale 1ns/100ps

module BNN_IP_temp(iCLK,
                   iRSTn,
                   iCLR,
                   iSTART,
                   oADDR,
                   oRd_EN,
                   oWr_EN);
    
    parameter	IDLE_ST		 = 	1'b0;
    parameter	READ_ST		 = 	1'b1;
    
    input						iCLK;
    input						iRSTn;
    input						iCLR;
    input						iSTART;
    
    output		[5:0]		oADDR;
    output					oRd_EN;
    output					oWr_EN;
    
    wire						CNT_EN;
    wire						DONE;
    wire						next_state;
    
    reg						current_state;
    
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
    assign	next_state		 = 	(current_state == IDLE_ST) ? ((iSTART == 1'b1) ? READ_ST : IDLE_ST):
    (current_state == READ_ST) ? ((DONE == 1'b1) ? IDLE_ST : READ_ST): IDLE_ST;
    
    assign	oRd_EN			 = (current_state == READ_ST) ? 1'b1 : 1'b0;
    assign	oWr_EN			 = 1'b0;
    assign	DONE				  = (oADDR == 6'd35) ? 1'b1 : 1'b0;
    
    //address counter
    COUNTER_NECV #(.WL(6), .IV(0))
    Counter_Image (.iCLK(iCLK), .iRSTn(iRSTn), .iCLR(iCLR|DONE), .iEN(oRd_EN), .oCNT(oADDR));
    
endmodule
