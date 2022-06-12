`timescale 1 ns / 100 ps

module Maxpooling(iRSTn,
                  iCLK,
                  iReadEN,
                  iWriteEN,
                  iDATA,
                  iADDR,
                  oDATA);
    
    parameter WL = 112;
    
    input                   iRSTn;
    input                   iCLK;
    input                   iReadEN;
    input                   iWriteEN;
    input	                iDATA;
    input                   iADDR;
    output      [TL-1:0]    oDATA;
    
    reg         [TL-1:0]    DATA_ARRAY_tmp;
    wire                    DATA_tmp;
    
    assign DATA_tmp = (iReadEN != 0) ? DATA_ARRAY_tmp[iADDR] | iDATA;
    
    always@(negedge iRSTn or posedge iCLK)
    begin
        if (~iRSTn)
        begin
            DATA_ARRAY_tmp <= #1 0 ;
        end
        else if (iReadEN)
        begin
            DATA_ARRAY_tmp <= #1 {111b'0, DATA_tmp} ;
        end
        else if (iWriteEN)
        begin
            DATA_ARRAY_tmp[iADDR] <= #1 DATA_tmp;
        end
    end
            
    assign oDATA = (iReadEN) ? DATA_ARRAY_tmp : 0;

endmodule