module COUNTER_LAB_ACC(iCLK,
                       iRSTn,
                       iEN,
                       iMV,
                       oEN,
                       oCNT);
    
    parameter WL = 4;
    
    input iCLK,iRSTn,iEN;
    input [WL-1:0] iMV;
    output [WL-1:0] oCNT;
    output oEN;
    
    reg [WL-1:0] oCNT;
    
    assign oEN = ((oCNT == iMV) && (iEN == 1'b1)) ? 1'b1 : 1'b0;
    
    always @(posedge iCLK or negedge iRSTn)
    begin
        if (~iRSTn)
        begin
            oCNT <= 0;
        end
        else if (iEN)
        begin
            if (oCNT == iMV)
            begin
                oCNT <= 1;
            end
			else
			begin
				oCNT <= oCNT +1;
			end
        end
        else
        begin
            oCNT <= oCNT;
        end
    end
endmodule
