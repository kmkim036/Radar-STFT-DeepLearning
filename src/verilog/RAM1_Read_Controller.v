module RAM1_Read_Controller(iCLK,
                       iRSTn,
                       iCLR,
                       iEN,
                       iDATA,
                       oRd_ADDR,
                       oRd_DONE
);

parameter WL = 3'd4;
parameter HL = 3'd5;
parameter WIDTH = 4'd14;
parameter HEIGHT = 5'd18;

wire [WL-1:0] i;
wire [HL-1:0] j;

output oRd_DONE;

assign oRd_DONE = (j == HEIGHT-3) ? 1'b1 : 1'b0;

wire COUNTER_i_oEN;

// counter j
COUNTER_LAB#(
.WL(HL),
.MV(HEIGHT)
)COUNTER_J(
.iCLK(iCLK),
.iRSTn(iRSTn),
.iEN(COUNTER_i_oEN),
.oEN(),
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
.iEN(),
.oEN(COUNTER_9_oEN),
.oCNT(CNTS_9)
);

