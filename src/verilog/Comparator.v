`timescale 1 ns / 100 ps

module Comparator(iCLK,
                  iRSTn,
                  iEN,
                  iDATA,
						iTH,
                  oDATA);
    
    
    //	Parameter
    parameter IL = 10;
    
    //	Input Signals
    input iRSTn;
    input iCLK;
	 input iEN;
    input [IL-1 : 0] iDATA;
    input [2:0] STAGE;
    
    //	Output Signals
    output oDATA;
    
    //	Internal Signals
    wire [IL-1:0] oTH;
    wire [16:0] CNT;
    wire BoDATA;
    
    TH_ROM
    U_TH_ROM(
    .TH_addr(CNT),
    .oTH(oTH)
    );
    
    assign BoDATA = (iDATA >= oTH) ? 1'b1 : 1'b0;
    
    D_FF_enable#(
    .WL(IL)
    )U_D_FF(
    .iCLK(iCKK),
    .iRSTn(iRSTn),
    .iEN(iEN),
    .iDATA(BoDATA),
    .oDATA(oDATA)
    );
    
endmodule
