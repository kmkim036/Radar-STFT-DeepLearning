module COUNTER_LAB(iCLK,iRSTn,iEN,oEN,oCNT);

parameter WL =4;
parameter MV = 10;

input iCLK,iRSTn,iEN;
output [WL-1:0] oCNT;
output oEN;

reg [WL-1:0] oCNT;

assign oEN = ((oCNT == MV-1) && (iEN == 1'b1)) ? 1'b1 : 1'b0;

always @(posedge iCLK or negedge iRSTn)
begin
	if(~iRSTn)
	begin
		oCNT <=0;
	end
	else if(iEN)
	begin
		if(oCNT == MV-1)
		begin
			oCNT <= 0;
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
