module Comparator(iCLK,
                  iRSTn,
                  iEN,
                  iDATA,
                  iTH,
                  oDATA,
                  oEN);
    
    
    //	Parameter
    parameter IL = 10;
    
    //	Input Signals
    input iRSTn;
    input iCLK;
    input iEN;
    input [IL-1 : 0] iTH;
    input [IL-1 : 0] iDATA;
    
    //	Output Signals
    output oDATA;
    output oEN;
    
    //	Internal Signals
    wire BoDATA;
    
    assign BoDATA = (iDATA > = iTH) ? 1'b1 : 1'b0;
    
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
