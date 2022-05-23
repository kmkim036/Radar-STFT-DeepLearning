module D_FF_enable(iCLK,
                   iRSTn,
                   iEN,
                   iDATA,
                   oDATA);
    
    parameter WL = 10;

    input iCLK;
    input iEN;
    input iDATA;
    input iRSTn;
    
	output [WL-1:0] oDATA;
    
    reg [WL-1:0] oDATA;
    
    always@(posedge iCLK or negedge iRSTn)
    begin
        if (~iRSTn)
        begin
            oDATA <= 0;
        end
        else if (iEN)
        begin
        	oDATA <= iDATA;
    	end
		else
		begin
			oDATA <= oDATA;
		end
    end
    
endmodule
