module CONV1_Read_Controller(iCLK,
                       iRSTn,
                       iEN,
							  oRd_ADDR,
                       oRd_DONE
);


// zero padding
parameter WL = 3'd4;
parameter HL = 3'd5;
parameter WIDTH = 4'd14;
parameter HEIGHT = 5'd18;

input iCLK;
input iRSTn;
input iEN;
output oRd_DONE;
output [8:0] oRd_ADDR;

wire [8:0] oRd_ADDR_TEMP;

wire [WL-1:0] i;
wire [HL-1:0] j;

wire COUNTER_i_oEN;
wire DUMP;
// counter j
COUNTER_LAB#(
.WL(HL),
.MV(HEIGHT)
)COUNTER_J(
.iCLK(iCLK),
.iRSTn(iRSTn),
.iEN(COUNTER_i_oEN),
.oEN(DUMP), //
.oCNT(j)
);

wire COUNTER_112_oEN;

// counter i
COUNTER_LAB#(
.WL(WL),
.MV(WIDTH-3)
)COUNTER_I(
.iCLK(iCLK),
.iRSTn(iRSTn),
.iEN(COUNTER_112_oEN),
.oEN(COUNTER_i_oEN),
.oCNT(i)
);

wire [6:0] CNTS_112;
wire COUNTER_4_oEN;
// counter 112							  
COUNTER_LAB#(
.WL(7),
.MV(112)
)COUNTER_112(
.iCLK(iCLK),
.iRSTn(iRSTn),
.iEN(COUNTER_4_oEN),
.oEN(COUNTER_112_oEN),
.oCNT(CNTS_112)
);


// counter 4
wire [1:0] CNTS_4;
wire COUNTER_9_oEN;

COUNTER_LAB#(
.WL(2),
.MV(4)
)COUNTER_4(
.iCLK(iCLK),
.iRSTn(iRSTn),
.iEN(COUNTER_9_oEN),
.oEN(COUNTER_4_oEN),
.oCNT(CNTS_4)
);
		
// counter 9
wire [3:0] CNTS_9;

COUNTER_LAB#(
.WL(4),
.MV(9)
)COUNTER_9(
.iCLK(iCLK),
.iRSTn(iRSTn),
.iEN(iEN),  //iEN_COUNTER
.oEN(COUNTER_9_oEN),
.oCNT(CNTS_9)
);

assign oRd_DONE = (j == HEIGHT-3) ? 1'b1 : 1'b0;

assign oRd_ADDR_TEMP = (CNTS_4 == 2'd0) ? (
							(CNTS_9 == 4'd0) ? ((i << 1) + 0 + ((j << 1) + 0) * WIDTH)  : 
							(CNTS_9 == 4'd1) ? ((i << 1) + 1 + ((j << 1) + 0) * WIDTH)  :
							(CNTS_9 == 4'd2) ? ((i << 1) + 2 + ((j << 1) + 0) * WIDTH)  :
							(CNTS_9 == 4'd3) ? ((i << 1) + 0 + ((j << 1) + 1) * WIDTH)  : 
							(CNTS_9 == 4'd4) ? ((i << 1) + 1 + ((j << 1) + 1) * WIDTH)  :
							(CNTS_9 == 4'd5) ? ((i << 1) + 2 + ((j << 1) + 1) * WIDTH)  :
							(CNTS_9 == 4'd6) ? ((i << 1) + 0 + ((j << 1) + 2) * WIDTH)  : 
							(CNTS_9 == 4'd7) ? ((i << 1) + 1 + ((j << 1) + 2) * WIDTH)  :
							(CNTS_9 == 4'd8) ? ((i << 1) + 2 + ((j << 1) + 2) * WIDTH) ):
					   (CNTS_4 == 2'd1) ? (
							(CNTS_9 == 4'd0) ? ((i << 1) + 1 + ((j << 1) + 0) * WIDTH)  : 
							(CNTS_9 == 4'd1) ? ((i << 1) + 2 + ((j << 1) + 0) * WIDTH)  :
							(CNTS_9 == 4'd2) ? ((i << 1) + 3 + ((j << 1) + 0) * WIDTH)  :
							(CNTS_9 == 4'd3) ? ((i << 1) + 1 + ((j << 1) + 1) * WIDTH)  : 
							(CNTS_9 == 4'd4) ? ((i << 1) + 2 + ((j << 1) + 1) * WIDTH)  :
							(CNTS_9 == 4'd5) ? ((i << 1) + 3 + ((j << 1) + 1) * WIDTH)  :
							(CNTS_9 == 4'd6) ? ((i << 1) + 1 + ((j << 1) + 2) * WIDTH)  : 
							(CNTS_9 == 4'd7) ? ((i << 1) + 2 + ((j << 1) + 2) * WIDTH)  :
							(CNTS_9 == 4'd8) ? ((i << 1) + 3 + ((j << 1) + 2) * WIDTH) ):
					   (CNTS_4 == 2'd2) ? (
							(CNTS_9 == 4'd0) ? ((i << 1) + 0 + ((j << 1) + 1) * WIDTH)  : 
							(CNTS_9 == 4'd1) ? ((i << 1) + 1 + ((j << 1) + 1) * WIDTH)  :
							(CNTS_9 == 4'd2) ? ((i << 1) + 2 + ((j << 1) + 1) * WIDTH)  :
							(CNTS_9 == 4'd3) ? ((i << 1) + 0 + ((j << 1) + 2) * WIDTH)  : 
							(CNTS_9 == 4'd4) ? ((i << 1) + 1 + ((j << 1) + 2) * WIDTH)  :
							(CNTS_9 == 4'd5) ? ((i << 1) + 2 + ((j << 1) + 2) * WIDTH)  :
							(CNTS_9 == 4'd6) ? ((i << 1) + 0 + ((j << 1) + 3) * WIDTH)  : 
							(CNTS_9 == 4'd7) ? ((i << 1) + 1 + ((j << 1) + 3) * WIDTH)  :
							(CNTS_9 == 4'd8) ? ((i << 1) + 2 + ((j << 1) + 3) * WIDTH) ):
					   (CNTS_4 == 2'd3) ? (
							(CNTS_9 == 4'd0) ? ((i << 1) + 1 + ((j << 1) + 1) * WIDTH)  : 
							(CNTS_9 == 4'd1) ? ((i << 1) + 2 + ((j << 1) + 1) * WIDTH)  :
							(CNTS_9 == 4'd2) ? ((i << 1) + 3 + ((j << 1) + 1) * WIDTH)  :
							(CNTS_9 == 4'd3) ? ((i << 1) + 1 + ((j << 1) + 2) * WIDTH)  : 
							(CNTS_9 == 4'd4) ? ((i << 1) + 2 + ((j << 1) + 2) * WIDTH)  :
							(CNTS_9 == 4'd5) ? ((i << 1) + 3 + ((j << 1) + 2) * WIDTH)  :
							(CNTS_9 == 4'd6) ? ((i << 1) + 1 + ((j << 1) + 3) * WIDTH)  : 
							(CNTS_9 == 4'd7) ? ((i << 1) + 2 + ((j << 1) + 3) * WIDTH)  :
							(CNTS_9 == 4'd8) ? ((i << 1) + 3 + ((j << 1) + 3) * WIDTH) ): 9'd0;

assign oRd_ADDR = (iSTATE == 3'b011) ? (oRd_ADDR_TEMP + 8'd252) : oRd_ADDR_TEMP;
							
endmodule			
