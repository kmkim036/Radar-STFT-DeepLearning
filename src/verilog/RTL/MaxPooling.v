
module Maxpooling(iRSTn,
                  iCLK,
                  iReadEN,
                  iWriteEN,
                  iDATA,
                  iADDR,
                  oDATA);
    
    parameter WL = 5;
    
    input                   iRSTn;
    input                   iCLK;
    input                   iReadEN;
    input                   iWriteEN;
    input	                iDATA;
    input       [6:0]       iADDR;
    output      [WL-1:0]    oDATA;
    
    reg         [WL-1:0]    DATA_ARRAY_tmp;
    wire                    DATA_tmp;
    
    assign DATA_tmp = (iReadEN == 0) ? DATA_ARRAY_tmp[iADDR] | iDATA : iDATA ;
    
    always@(negedge iRSTn or posedge iCLK)
    begin
        if (~iRSTn)
        begin
            DATA_ARRAY_tmp <= 0 ;
        end
        else if (iReadEN)
        begin
            DATA_ARRAY_tmp <= {111'b0, DATA_tmp} ;
        end
        else if (iWriteEN)
        begin
            DATA_ARRAY_tmp[iADDR] <= DATA_tmp;
        end
    end
            
    assign oDATA = (iReadEN) ? DATA_ARRAY_tmp : 0;
            
endmodule
