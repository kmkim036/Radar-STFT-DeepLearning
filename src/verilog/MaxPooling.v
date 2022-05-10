`timescale 1 ns / 100 ps

module SHIFT_REG(iRSTn,
                 iCLK,
                 iEN,
                 iCLR,
                 iDATA,
                 oDATA);
    
    parameter TL  = 30;
    parameter TLB = 5;
    
    input 				iRSTn;
    input 				iCLK;
    input 				iEN;
    input 				iCLR ;
    input	            iDATA;
    output              oDATA;
    
    reg  	[TL-1:0]    DATA_tmp ;
    wire                ResetCounter;
    wire                Count2bit;
    wire    [TLB-1:0]   CNT;
    
    
    always@(negedge iRSTn or posedge iCLK)
    begin
        if (~iRSTn)
        begin
            DATA_tmp <= #1 0 ;
        end
        else if (iCLR)
        begin
            DATA_tmp <= #1 0 ;
        end
        else if (iEN)
        begin
            DATA_tmp <= #1 {DATA_tmp[(TL-1)-1:0], iDATA};	// Input data input to Shift register & shift operation
        end
    end        
       
    COUNTER_NECV#(
    .WL(1),
    .IV(0)
    )Counter2bits(
    .iCLK(iCLK),
    .iRSTn(iRSTn|ResetCounter),
    .iCLR(iCLR),
    .iEN(iEN),
    .oCNT(Count2bit)
    );
    
    COUNTER_NECV#(
    .WL(TLB),
    .IV(0)
    )CounterLines(
    .iCLK(iCLK),
    .iRSTn(iRSTn|ResetCounter),
    .iCLR(iCLR),
    .iEN(iEN),
    .oCNT(CNT)
    );
    
    assign ResetCounter = ~Count2bit;
    
    assign oDATA = (Count2bit && CNT == 5'd29) ? (DATA_tmp[0] || DATA_tmp[1] || DATA_tmp[TL-1] || DATA_tmp[TL-2]) : 0;
        
endmodule
        
