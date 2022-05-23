`timescale 1 ns / 100 ps

module MaxPooling(iRSTn,
                  iCLK,
                  iEN,
                  iCLR,
                  iDATA,
                  oDATA);
    
    input 	iRSTn;
    input 	iCLK;
    input 	iEN;
    input 	iCLR;
    input 	iDATA;
    
    output 	oDATA;
    reg 	oDATA;
    
    always@(posedge iCLK or negedge iRSTn)
    begin
        if (~iRSTn)
        begin
            oDATA <= #1 0;
        end
        else if (iCLR)
        begin
            oDATA <= #1 0;
        end
        else if (iEN)
        begin
            oDATA = oDATA | iDATA;
        end
    end
            
endmodule
            
            /*
             module Maxpooling(iRSTn,
             iCLK,
             iEN,
             iCLR,
             iDATA,
             oDATA);
             
             parameter TL  = 4;
             parameter TLB = 2;
             
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
             .WL(TLB),
             .IV(0)
             )CounterLines(
             .iCLK(iCLK),
             .iRSTn(iRSTn),
             .iCLR(iCLR),
             .iEN(iEN),
             .oCNT(CNT)
             );
             
             assign oDATA = (CNT > TL) ? (DATA_tmp[0] || DATA_tmp[1] || DATA_tmp[TL-1] || DATA_tmp[TL-2]) : 0;
             */
