module FCL_Read_Controller(iCLK,
                       iRSTn,
                       iEN,
							  iSTATE,
                       oRd_ADDR,
                       oRd_DONE
);

input iCLK;
input iRSTn;
input iEN;
input [2:0] iSTATE;
output oRd_DONE;
output [8:0] oRd_ADDR;

wire [6:0] OUTER_CNTS;
wire [2:0] INNER_CNTS;

// counter 112 or 12
wire [6:0] OUTER_COUNTER_MV;
assign OUTER_COUNTER_MV = (iSTATE == 3'b101) ? 7'd112: 7'd12;
// counter 6 or 1
wire [2:0] INNER_COUNTER_MV;
assign INNER_COUNTER_MV = (iSTATE == 3'b101) ? 3'd6: 3'd1;

wire INNER_COUNTER_DONE;
wire DUMP;

COUNTER_LAB#(
.WL(7),
.MV(OUTER_COUNTER_MV)
)OUTER_COUNTER_FCL(
.iCLK(iCLK),
.iRSTn(iRSTn),
.iEN(INNER_COUNTER_DONE),
.oEN(DUMP),
.oCNT(OUTER_CNTS)
);

COUNTER_LAB#(
.WL(WL),
.MV(INNER_COUNTER_MV)
)INNER_COUNTER_FCL(
.iCLK(iCLK),
.iRSTn(iRSTn),
.iEN(iEN),
.oEN(INNER_COUNTER_DONE),
.oCNT(INNER_CNTS)
);

assign oRd_DONE = (OUTER_CNTS == 7'd111 && INNER_CNTS == 3'd5) ? 1'b1 : 1'b0;

assign oRd_ADDR = (iSTATE == 3'b101) ? INNER_CNTS : (INNER_CNTS + 8'd252);

endmodule			
