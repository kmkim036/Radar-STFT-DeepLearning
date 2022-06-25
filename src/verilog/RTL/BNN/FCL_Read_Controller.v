module FCL_Read_Controller(iCLK,
                           iRSTn,
                           iEN,
                           oRd_ADDR,
                           oRd_DONE);
    
    // FCL 1
    parameter OUTER_COUNTER_MV = 7'd112;
    parameter INNER_COUNTER_MV = 3'd6;
    
    // FCL 2
    //parameter OUTER_COUNTER_MV = 7'd12;
    //parameter INNER_COUNTER_MV = 3'd1;
    
    
    input           iCLK;
    input           iRSTn;
    input           iEN;
    output          oRd_DONE;
    output  [8:0]   oRd_ADDR;
    
    wire    [6:0]   OUTER_CNTS;
    wire    [2:0]   INNER_CNTS;
    
    wire            INNER_COUNTER_DONE;
    
    COUNTER_LAB#(
    .WL(7),
    .MV(OUTER_COUNTER_MV)
    )OUTER_COUNTER_FCL(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(INNER_COUNTER_DONE),
    .oEN(oRd_DONE),
    .oCNT(OUTER_CNTS)
    );
    
    COUNTER_LAB#(
    .WL(3),
    .MV(INNER_COUNTER_MV)
    )INNER_COUNTER_FCL(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(iEN),
    .oEN(INNER_COUNTER_DONE),
    .oCNT(INNER_CNTS)
    );
    
    assign oRd_ADDR = INNER_CNTS;
    
endmodule
