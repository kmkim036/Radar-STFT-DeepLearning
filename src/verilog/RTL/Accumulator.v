module Accumulator(iCLK,
                   iRSTn,
                   iCLR,
                   iEN,
                   iDATA,
                   iCNT,
                   iMV,
                   oEN,
                   oDATA);
    
    //	Parameter
    parameter IL = 10;
    parameter OL = 10;
    
    //	Input Signals
    input iRSTn;
    input iCLK;
    input iCLR;
    input iEN;
    input [IL-1 : 0] iDATA;
    input [3:0] iCNT;
    input [3:0] iMV;
    
    //	Output Signals
    output oEN;
    output [OL-1:0] oDATA;
    
    //	Internal Signals
    wire oEN;
    wire [3:0] iCNT;
    reg [OL-1:0]oDATA;
    assign oEN = (iCNT == iMV) ? 1'b1 : 1'b0;	// && iEN == 1'b1?
    
    always@(posedge iCLK or negedge iRSTn)
    begin
        if (~iRSTn)
        begin
            oDATA <= 1'b0;
        end
        else if (iCLR)
        begin
            oDATA <= iDATA;
        end
        else if (iEN)
        begin
            oDATA <= oDATA + iDATA;
        end
        else
        begin
            oDATA <= oDATA;
        end
    end
    
endmodule
