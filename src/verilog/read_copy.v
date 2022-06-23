module READ_COPY(
	input mem0readDATA,
	output mem0readADDR,
	output mem1writeADDR,
	output mem1writeDATA,
	input READ_STATE,
	input iCLR,
	input iRSTn,
	input iCLK,
	output DONE
)

	input iCLR;
	input iRSTn;
	input iCLK;
	input  [27:0] mem0readDATA;
	output [5:0] mem0readADDR;
	output [8:0] mem1writeADDR;
	output [111:0] mem1writeDATA;
	output DONE;
	input READ_STATE;
	
	wire [1:0] cntsfor4;
	reg [111:0] DATA_TMP;
	
	wire reset_counts;
	assign reset_counts = (cntsfor4 == 2'b11) ? 1'b1 : 1'b0;
	
	wire dd1, dd2;
	D_REG#(
	.WL(1)
	)D1(
	.iRSTn(iRSTn), 
	.iCLK(iCLK), 
	iEN(1'b1), 
	iCLR(iCLR), 
	iDATA(reset_counts), 
	oDATA(dd1)
	);

	D_REG#(
	.WL(1)
	)D2(
	.iRSTn(iRSTn), 
	.iCLK(iCLK), 
	iEN(1'b1), 
	iCLR(iCLR), 
	iDATA(dd1), 
	oDATA(dd2)
	);	
	 
	// count for 4
	COUNTER_NECV#(
    .WL(2),
    .IV(0)
    )Counter_Image(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(reset_counts),
    .iEN(READ_STATE),
    .oCNT(cntsfor4)
    );	
		
    //MEM0 READ address counter -> 0 ~ 35
    COUNTER_NECV#(
    .WL(6),
    .IV(0)
    )Counter_Image(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(READ_STATE),
    .oCNT(mem0readADDR)
    );
    
	 always@(posedge iCLK | negedge iRSTn)
	 begin
		if(reset_counts)
		begin
			DATA_TMP <= 0;
		end
		else
		begin
			DATA_TMP <= {DATA_tmp [83:0],mem0readDATA};	
		end
	 end
	 
    //MEM1 WRITE address counter -> 0 ~ 8
    COUNTER_NECV#(
    .WL(4),
    .IV(0)
    )Counter_Image(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR|DONE),
    .iEN(dd2),
    .oCNT(mem1writeADDR)
    );

	assign mem1writeDATA = DATA_TMP;
	assign DONE = (mem1writeADDR == 4'd9) ? 1'b1 : 1'b0;
	
endmodule