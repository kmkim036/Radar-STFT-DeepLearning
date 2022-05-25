`timescale 1 ns / 100 ps

module Adder_Clock(iCLK,
                   iRSTn,
                   iEN,
                   idata1,
                   idata2,
                   odata);
    
    parameter WL = 1;
    
    input		iCLK;
    input		iRSTn;
    input		iEN;
    input	[WL-1:0]	idata1;
    input	[WL-1:0]	idata2;
    output	[WL:0]		odata;
    
    reg		[WL:0]		odata;
    
    always @(negedge iRSTn or posedge iCLK)
    begin
        if (~iRSTn)
        begin
            odata <= 0 ;
        end
        else if (iEN)
        begin
            odata <= idata1 + idata2;
        end
        else
        begin
            odata <= odata;
        end
    end
    
endmodule
