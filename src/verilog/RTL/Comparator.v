module Comparator(iCLK,
                  iRSTn,
                  iEN,
                  iDATA,
						iTH,
                  oDATA,
						oEN,
						current_state,
						ipad);
    
    
    //	Parameter
    parameter IL = 10;
    
    //	Input Signals
    input iRSTn;
    input iCLK;
	 input iEN;
	 input signed [IL-2 : 0] iTH;
    input [IL-1 : 0] iDATA;
    input [2:0] current_state;
	 input [1:0] ipad;
    //	Output Signals
	 wire judge;
    output oDATA;
	 output oEN;
    wire signed [IL-1 : 0] temp1, temp2, temp3, temp4, temp5;
	 
	 assign  temp1 = (iDATA << 1) - 9;
	 assign  temp2 = (iDATA << 1) - 4;
	 assign  temp3 = (iDATA << 1) - 6;
	 assign  temp4 = (iDATA << 1) - 1008;
	 assign  temp5 = (iDATA << 1) - 672;
	 assign judge = (current_state == 3'b010) ? (ipad == 2'd0) ? (temp1 >= iTH) ? 1'b1 : 1'b0 :
																(ipad == 2'd1) ? (temp2 >= iTH) ? 1'b1 : 1'b0 :
																(ipad == 2'd2) ? (temp3 >= iTH) ? 1'b1 : 1'b0 : 1'b0 : 1'b0;
    //	Internal Signals 
    wire BoDATA;
    assign BoDATA = (current_state == 3'b010) ? (ipad == 2'd0) ? (temp1 >= iTH) ? 1'b1 : 1'b0 :
																(ipad == 2'd1) ? (temp2 >= iTH)  ? 1'b1 : 1'b0 :
																(ipad == 2'd2) ? (temp3 >= iTH)  ? 1'b1 : 1'b0 : 1'b0 :
						  (current_state == 3'b011 || current_state == 3'b100) ? (temp4 >= iTH) ? 1'b1: 1'b0 :
						  (current_state == 3'b101) ? (temp5 > iTH) ? 1'b1: 1'b0 : 1'b0;
    //assign BoDATA = (iDATA >= iTH) ? 1'b1 : 1'b0;
    
    D_FF_enable#(
    .WL(1)
    )U_D_FF(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(iEN),
    .iDATA(BoDATA),
    .oDATA(oDATA)
    );
	 
	 D_FF_enable#(
    .WL(1)
    )U_D_FF_1(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(1'b1),
    .iDATA(iEN),
    .oDATA(oEN)
    );
    
endmodule
