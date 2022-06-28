module CONV1_Read_Controller(iCLK,
                             iRSTn,
                             iEN,
                             oRd_ADDR,
                             oBit_ADDR,
                             oRd_DONE,
                             opad);
    
    input iCLK;
    input iRSTn;
    input iEN;
    output [5:0] oRd_ADDR;
    output [4:0] oBit_ADDR;
    output oRd_DONE;
    output [1:0] opad;
    wire oEN_col;
    wire oEN_4;
    wire oEN_9;
    wire oEN_112;
    wire oEN_row;
    wire oEN_11;
    wire [3:0] CNT_col;
    wire [4:0] CNT_row;
    wire [1:0] CNT_4;
    wire [3:0] CNT_9;
    wire [6:0] CNT_112;
    wire [3:0] CNT_11;
    assign oRd_DONE = (oEN_row == 1 && oEN_col == 1) ? 1 : 0;
    wire		[1:0]	 pad_d1, pad_d2, pad_d3, pad_d4, pad_d5, pad_d6, pad_d7, pad_d8, pad_d9, pad_d10, pad_d11;
    
    COUNTER_LAB#(
    .WL(4),
    .MV(14)
    )Counter_col(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(oEN_4),
    .oCNT(CNT_col),
    .oEN(oEN_col)
    );
    
    COUNTER_LAB#(
    .WL(5),
    .MV(18)
    )Counter_row(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(oEN_col),
    .oCNT(CNT_row),
    .oEN(oEN_row)
    );
    
    COUNTER_LAB#(
    .WL(2),
    .MV(4)
    )Counter_4(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(oEN_112),
    .oCNT(CNT_4),
    .oEN(oEN_4)
    );
    
    COUNTER_LAB#(
    .WL(4),
    .MV(9)
    )Counter_9(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(iEN),
    .oCNT(CNT_9),
    .oEN(oEN_9)
    );
    
    COUNTER_LAB#(
    .WL(7),
    .MV(112)
    )Counter_112(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iEN(oEN_9),
    .oCNT(CNT_112),
    .oEN(oEN_112)
    );
    
    COUNTER_LAB#(
    .WL(4),
    .MV(11)
    )Counter_padd_delay(
    .iCLK(iCLK),
    .iRSTn(~oEN_9),
    .iEN(1'b1),
    .oCNT(CNT_11),
    .oEN(oEN_11)
    );
    
    assign oRd_ADDR = 
    (CNT_col > = 1 && CNT_col < = 12 && CNT_row > = 1 && CNT_row < = 16) ?
    ((CNT_4 == 2'd0 || CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd2) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd3) ? (CNT_row << 1)     :
    (CNT_9 == 4'd4) ? (CNT_row << 1)     :
    (CNT_9 == 4'd5) ? (CNT_row << 1)     :
    (CNT_9 == 4'd6) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_row << 1) + 1 : 6'd36):
    (CNT_4 == 2'd2 || CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1)     :
    (CNT_9 == 4'd1) ? (CNT_row << 1)     :
    (CNT_9 == 4'd2) ? (CNT_row << 1)     :
    (CNT_9 == 4'd3) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd4) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_row << 1) + 2 :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 2 :
    (CNT_9 == 4'd8) ? (CNT_row << 1) + 2 : 6'd36): 6'd36):
    //////////////////////////////////
    (CNT_col == 0 && CNT_row == 0) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? 6'd36 :
    (CNT_9 == 4'd1) ? 6'd36 :
    (CNT_9 == 4'd2) ? 6'd36 :
    (CNT_9 == 4'd3) ? 6'd36 :
    (CNT_9 == 4'd4) ? 0   :
    (CNT_9 == 4'd5) ? 0   :
    (CNT_9 == 4'd6) ? 6'd36 :
    (CNT_9 == 4'd7) ? 1   :
    (CNT_9 == 4'd8) ? 1   : 6'd36):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? 6'd36 :
    (CNT_9 == 4'd1) ? 6'd36 :
    (CNT_9 == 4'd2) ? 6'd36 :
    (CNT_9 == 4'd3) ? 0   :
    (CNT_9 == 4'd4) ? 0   :
    (CNT_9 == 4'd5) ? 0   :
    (CNT_9 == 4'd6) ? 1   :
    (CNT_9 == 4'd7) ? 1   :
    (CNT_9 == 4'd8) ? 1   : 6'd36):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? 6'd36 :
    (CNT_9 == 4'd1) ? 0   :
    (CNT_9 == 4'd2) ? 0   :
    (CNT_9 == 4'd3) ? 6'd36 :
    (CNT_9 == 4'd4) ? 1   :
    (CNT_9 == 4'd5) ? 1   :
    (CNT_9 == 4'd6) ? 6'd36 :
    (CNT_9 == 4'd7) ? 2   :
    (CNT_9 == 4'd8) ? 2   : 6'd36):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? 0   :
    (CNT_9 == 4'd1) ? 0   :
    (CNT_9 == 4'd2) ? 0   :
    (CNT_9 == 4'd3) ? 1   :
    (CNT_9 == 4'd4) ? 1   :
    (CNT_9 == 4'd5) ? 1   :
    (CNT_9 == 4'd6) ? 2   :
    (CNT_9 == 4'd7) ? 2   :
    (CNT_9 == 4'd8) ? 2   : 6'd36): 6'd36):
    ///////////////////////////////
    (CNT_col > = 1 && CNT_col < = 12 && CNT_row == 0) ?
    ((CNT_4 == 2'd0 || CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? 6'd36 :
    (CNT_9 == 4'd1) ? 6'd36 :
    (CNT_9 == 4'd2) ? 6'd36 :
    (CNT_9 == 4'd3) ? 0   :
    (CNT_9 == 4'd4) ? 0   :
    (CNT_9 == 4'd5) ? 0   :
    (CNT_9 == 4'd6) ? 1   :
    (CNT_9 == 4'd7) ? 1   :
    (CNT_9 == 4'd8) ? 1   : 6'd36):
    (CNT_4 == 2'd2 || CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? 0   :
    (CNT_9 == 4'd1) ? 0   :
    (CNT_9 == 4'd2) ? 0   :
    (CNT_9 == 4'd3) ? 1   :
    (CNT_9 == 4'd4) ? 1   :
    (CNT_9 == 4'd5) ? 1   :
    (CNT_9 == 4'd6) ? 2   :
    (CNT_9 == 4'd7) ? 2   :
    (CNT_9 == 4'd8) ? 2   : 6'd36): 6'd36):
    ////////////////////////////////
    (CNT_col == 13 && CNT_row == 0) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? 6'd36 :
    (CNT_9 == 4'd1) ? 6'd36 :
    (CNT_9 == 4'd2) ? 6'd36 :
    (CNT_9 == 4'd3) ? 0   :
    (CNT_9 == 4'd4) ? 0   :
    (CNT_9 == 4'd5) ? 0   :
    (CNT_9 == 4'd6) ? 1   :
    (CNT_9 == 4'd7) ? 1   :
    (CNT_9 == 4'd8) ? 1   : 6'd36):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? 6'd36 :
    (CNT_9 == 4'd1) ? 6'd36 :
    (CNT_9 == 4'd2) ? 6'd36 :
    (CNT_9 == 4'd3) ? 0   :
    (CNT_9 == 4'd4) ? 0   :
    (CNT_9 == 4'd5) ? 6'd36 :
    (CNT_9 == 4'd6) ? 1   :
    (CNT_9 == 4'd7) ? 1   :
    (CNT_9 == 4'd8) ? 6'd36 : 6'd36):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? 0   :
    (CNT_9 == 4'd1) ? 0   :
    (CNT_9 == 4'd2) ? 0   :
    (CNT_9 == 4'd3) ? 1   :
    (CNT_9 == 4'd4) ? 1   :
    (CNT_9 == 4'd5) ? 1   :
    (CNT_9 == 4'd6) ? 2   :
    (CNT_9 == 4'd7) ? 2   :
    (CNT_9 == 4'd8) ? 2   : 6'd36):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? 0   :
    (CNT_9 == 4'd1) ? 0   :
    (CNT_9 == 4'd2) ? 6'd36 :
    (CNT_9 == 4'd3) ? 1   :
    (CNT_9 == 4'd4) ? 1   :
    (CNT_9 == 4'd5) ? 6'd36 :
    (CNT_9 == 4'd6) ? 2   :
    (CNT_9 == 4'd7) ? 2   :
    (CNT_9 == 4'd8) ? 6'd36 : 6'd36): 6'd36):
    //////////////////////////////
    (CNT_col == 0 && CNT_row > = 1 && CNT_row < = 16) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? 6'd36 :
    (CNT_9 == 4'd1) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd2) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd3) ? 6'd36   :
    (CNT_9 == 4'd4) ? (CNT_row << 1)     :
    (CNT_9 == 4'd5) ? (CNT_row << 1)     :
    (CNT_9 == 4'd6) ? 6'd36   :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_row << 1) + 1 : 6'd36):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd2) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd3) ? (CNT_row << 1)     :
    (CNT_9 == 4'd4) ? (CNT_row << 1)     :
    (CNT_9 == 4'd5) ? (CNT_row << 1)     :
    (CNT_9 == 4'd6) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_row << 1) + 1 : 6'd36):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? 6'd36 :
    (CNT_9 == 4'd1) ? (CNT_row << 1)     :
    (CNT_9 == 4'd2) ? (CNT_row << 1)     :
    (CNT_9 == 4'd3) ? 6'd36 :
    (CNT_9 == 4'd4) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd6) ? 6'd36 :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 2 :
    (CNT_9 == 4'd8) ? (CNT_row << 1) + 2 : 6'd36):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1)     :
    (CNT_9 == 4'd1) ? (CNT_row << 1)     :
    (CNT_9 == 4'd2) ? (CNT_row << 1)     :
    (CNT_9 == 4'd3) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd4) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_row << 1) + 2 :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 2 :
    (CNT_9 == 4'd8) ? (CNT_row << 1) + 2 : 6'd36): 6'd36):
    //////////////////////////////////////
    (CNT_col == 13 && CNT_row > = 1 && CNT_row < = 16) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd2) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd3) ? (CNT_row << 1)     :
    (CNT_9 == 4'd4) ? (CNT_row << 1)     :
    (CNT_9 == 4'd5) ? (CNT_row << 1)     :
    (CNT_9 == 4'd6) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_row << 1) + 1 : 6'd36):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd2) ? 6'd36 :
    (CNT_9 == 4'd3) ? (CNT_row << 1)     :
    (CNT_9 == 4'd4) ? (CNT_row << 1)     :
    (CNT_9 == 4'd5) ? 6'd36 :
    (CNT_9 == 4'd6) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd8) ? 6'd36 : 6'd36):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1)     :
    (CNT_9 == 4'd1) ? (CNT_row << 1)     :
    (CNT_9 == 4'd2) ? (CNT_row << 1)     :
    (CNT_9 == 4'd3) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd4) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_row << 1) + 2 :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 2 :
    (CNT_9 == 4'd8) ? (CNT_row << 1) + 2 : 6'd36):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1)     :
    (CNT_9 == 4'd1) ? (CNT_row << 1)     :
    (CNT_9 == 4'd2) ? 6'd36 :
    (CNT_9 == 4'd3) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd4) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd5) ? 6'd36 :
    (CNT_9 == 4'd6) ? (CNT_row << 1) + 2 :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 2 :
    (CNT_9 == 4'd8) ? 6'd36 : 6'd36): 6'd36):
    ////////////////////////////////////////////
    (CNT_col == 0 && CNT_row == 17) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? 6'd36 :
    (CNT_9 == 4'd1) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd2) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd3) ? 6'd36 :
    (CNT_9 == 4'd4) ? (CNT_row << 1)     :
    (CNT_9 == 4'd5) ? (CNT_row << 1)     :
    (CNT_9 == 4'd6) ? 6'd36 :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_row << 1) + 1 : 6'd36):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd2) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd3) ? (CNT_row << 1)     :
    (CNT_9 == 4'd4) ? (CNT_row << 1)     :
    (CNT_9 == 4'd5) ? (CNT_row << 1)     :
    (CNT_9 == 4'd6) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_row << 1) + 1 : 6'd36):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? 6'd36 :
    (CNT_9 == 4'd1) ? (CNT_row << 1)     :
    (CNT_9 == 4'd2) ? (CNT_row << 1)     :
    (CNT_9 == 4'd3) ? 6'd36 :
    (CNT_9 == 4'd4) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd6) ? 6'd36 :
    (CNT_9 == 4'd7) ? 6'd36 :
    (CNT_9 == 4'd8) ? 6'd36 : 6'd36):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1)     :
    (CNT_9 == 4'd1) ? (CNT_row << 1)     :
    (CNT_9 == 4'd2) ? (CNT_row << 1)     :
    (CNT_9 == 4'd3) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd4) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd6) ? 6'd36 :
    (CNT_9 == 4'd7) ? 6'd36 :
    (CNT_9 == 4'd8) ? 6'd36 : 6'd36): 6'd36):
    //////////////////////////////////////////////
    (CNT_col > = 1 && CNT_col < = 12 && CNT_row == 17) ?
    ((CNT_4 == 2'd0 || CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd2) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd3) ? (CNT_row << 1)     :
    (CNT_9 == 4'd4) ? (CNT_row << 1)     :
    (CNT_9 == 4'd5) ? (CNT_row << 1)     :
    (CNT_9 == 4'd6) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_row << 1) + 1 : 6'd36):
    (CNT_4 == 2'd2 || CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1)     :
    (CNT_9 == 4'd1) ? (CNT_row << 1)     :
    (CNT_9 == 4'd2) ? (CNT_row << 1)     :
    (CNT_9 == 4'd3) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd4) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd6) ? 6'd36 :
    (CNT_9 == 4'd7) ? 6'd36 :
    (CNT_9 == 4'd8) ? 6'd36 : 6'd36): 6'd36):
    /////////////////////////////////////////////
    (CNT_col == 13 && CNT_row == 17) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd2) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd3) ? (CNT_row << 1)     :
    (CNT_9 == 4'd4) ? (CNT_row << 1)     :
    (CNT_9 == 4'd5) ? (CNT_row << 1)     :
    (CNT_9 == 4'd6) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_row << 1) + 1 : 6'd36):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_row << 1) - 1 :
    (CNT_9 == 4'd2) ? 6'd36 :
    (CNT_9 == 4'd3) ? (CNT_row << 1)     :
    (CNT_9 == 4'd4) ? (CNT_row << 1)     :
    (CNT_9 == 4'd5) ? 6'd36 :
    (CNT_9 == 4'd6) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd7) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd8) ? 6'd36 : 6'd36):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1)     :
    (CNT_9 == 4'd1) ? (CNT_row << 1)     :
    (CNT_9 == 4'd2) ? (CNT_row << 1)     :
    (CNT_9 == 4'd3) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd4) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd6) ? 6'd36 :
    (CNT_9 == 4'd7) ? 6'd36 :
    (CNT_9 == 4'd8) ? 6'd36 : 6'd36):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_row << 1)     :
    (CNT_9 == 4'd1) ? (CNT_row << 1)     :
    (CNT_9 == 4'd2) ? 6'd36 :
    (CNT_9 == 4'd3) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd4) ? (CNT_row << 1) + 1 :
    (CNT_9 == 4'd5) ? 6'd36 :
    (CNT_9 == 4'd6) ? 6'd36 :
    (CNT_9 == 4'd7) ? 6'd36 :
    (CNT_9 == 4'd8) ? 6'd36 : 6'd36): 6'd36):6'd36;
    
    
    
    assign oBit_ADDR = 
    (CNT_col > = 1 && CNT_col < = 12 && CNT_row > = 1 && CNT_row < = 16) ?
    ((CNT_4 == 2'd0 || CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 28):
    (CNT_4 == 2'd1 || CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 2 : 28): 28):
    //////////////////////////////////
    (CNT_col == 0 && CNT_row == 0) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? 28 :
    (CNT_9 == 4'd1) ? 28 :
    (CNT_9 == 4'd2) ? 28 :
    (CNT_9 == 4'd3) ? 28 :
    (CNT_9 == 4'd4) ? 0 :
    (CNT_9 == 4'd5) ? 1 :
    (CNT_9 == 4'd6) ? 28 :
    (CNT_9 == 4'd7) ? 0 :
    (CNT_9 == 4'd8) ? 1 : 28):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? 28 :
    (CNT_9 == 4'd1) ? 28 :
    (CNT_9 == 4'd2) ? 28 :
    (CNT_9 == 4'd3) ? 0     :
    (CNT_9 == 4'd4) ? 1 :
    (CNT_9 == 4'd5) ? 2 :
    (CNT_9 == 4'd6) ? 0     :
    (CNT_9 == 4'd7) ? 1 :
    (CNT_9 == 4'd8) ? 2 : 28):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? 28 :
    (CNT_9 == 4'd1) ? 0 :
    (CNT_9 == 4'd2) ? 1 :
    (CNT_9 == 4'd3) ? 28 :
    (CNT_9 == 4'd4) ? 0 :
    (CNT_9 == 4'd5) ? 1 :
    (CNT_9 == 4'd6) ? 28 :
    (CNT_9 == 4'd7) ? 0 :
    (CNT_9 == 4'd8) ? 1 : 28):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? 0 :
    (CNT_9 == 4'd1) ? 1 :
    (CNT_9 == 4'd2) ? 2 :
    (CNT_9 == 4'd3) ? 0 :
    (CNT_9 == 4'd4) ? 1 :
    (CNT_9 == 4'd5) ? 2 :
    (CNT_9 == 4'd6) ? 0 :
    (CNT_9 == 4'd7) ? 1 :
    (CNT_9 == 4'd8) ? 2 : 28): 28):
    ///////////////////////////////
    (CNT_col > = 1 && CNT_col < = 12 && CNT_row == 0) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? 28 :
    (CNT_9 == 4'd1) ? 28 :
    (CNT_9 == 4'd2) ? 28 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 28):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? 28 :
    (CNT_9 == 4'd1) ? 28 :
    (CNT_9 == 4'd2) ? 28 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 2 : 28):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 28):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 2 : 28): 28):
    ////////////////////////////////
    (CNT_col == 13 && CNT_row == 0) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? 28 :
    (CNT_9 == 4'd1) ? 28 :
    (CNT_9 == 4'd2) ? 28 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 28):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? 28 :
    (CNT_9 == 4'd1) ? 28 :
    (CNT_9 == 4'd2) ? 28 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? 28 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? 28 : 28):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 28):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? 28 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? 28 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? 28 : 28): 28):
    //////////////////////////////
    (CNT_col == 0 && CNT_row > = 1 && CNT_row < = 16) ?
    ((CNT_4 == 2'd0 || CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? 28 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? 28 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? 28 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 28):
    (CNT_4 == 2'd1 || CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 2 : 28): 28):
    //////////////////////////////////////
    (CNT_col == 13 && CNT_row > = 1 && CNT_row < = 16) ?
    ((CNT_4 == 2'd0 || CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 28):
    (CNT_4 == 2'd1 || CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? 28 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? 28 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? 28 : 28):28):
    ////////////////////////////////////////////
    (CNT_col == 0 && CNT_row == 17) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? 28 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? 28 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? 28 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 28):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 2 : 28):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? 28 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? 28 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? 28 :
    (CNT_9 == 4'd7) ? 28     :
    (CNT_9 == 4'd8) ? 28 : 28):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? 28 :
    (CNT_9 == 4'd7) ? 28 :
    (CNT_9 == 4'd8) ? 28 : 28): 28):
    //////////////////////////////////////////////
    (CNT_col > = 1 && CNT_col < = 12 && CNT_row == 17) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 28):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 2 : 28):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? 28 :
    (CNT_9 == 4'd7) ? 28 :
    (CNT_9 == 4'd8) ? 28 : 28):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? 28 :
    (CNT_9 == 4'd7) ? 28 :
    (CNT_9 == 4'd8) ? 28 : 28): 28):
    /////////////////////////////////////////////
    (CNT_col == 13 && CNT_row == 17) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 28):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? 28 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? 28 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? 28 : 28):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? 28 :
    (CNT_9 == 4'd7) ? 28 :
    (CNT_9 == 4'd8) ? 28 : 28):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? 28 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? 28 :
    (CNT_9 == 4'd6) ? 28 :
    (CNT_9 == 4'd7) ? 28 :
    (CNT_9 == 4'd8) ? 28 : 28): 28):28;
    
    
    assign pad_d1 = 
    (CNT_col > = 1 && CNT_col < = 12 && CNT_row > = 1 && CNT_row < = 16) ? 2'd0:
    //////////////////////////////////
    (CNT_col == 0 && CNT_row == 0) ?
    ((CNT_4 == 2'd0) ? 2'd1:
    (CNT_4 == 2'd1) ?  2'd2:
    (CNT_4 == 2'd2) ?  2'd2:
    (CNT_4 == 2'd3) ?  2'd0: 2'd0):
    ///////////////////////////////
    (CNT_col > = 1 && CNT_col < = 12 && CNT_row == 0) ?
    ((CNT_4 == 2'd0 || CNT_4 == 2'd1) ? 2'd2:
    (CNT_4 == 2'd2 || CNT_4 == 2'd3) ? 2'd0 : 2'd0):
    ////////////////////////////////
    (CNT_col == 13 && CNT_row == 0) ?
    ((CNT_4 == 2'd0) ? 2'd2:
    (CNT_4 == 2'd1) ?  2'd1:
    (CNT_4 == 2'd2) ?  2'd0:
    (CNT_4 == 2'd3) ?  2'd2: 2'd0):
    //////////////////////////////
    (CNT_col == 0 && CNT_row > = 1 && CNT_row < = 16) ?
    ((CNT_4 == 2'd0 || CNT_4 == 2'd2) ? 2'd2:
    (CNT_4 == 2'd1 || CNT_4 == 2'd3) ?  2'd0: 2'd0):
    //////////////////////////////////////
    (CNT_col == 13 && CNT_row > = 1 && CNT_row < = 16) ?
    ((CNT_4 == 2'd0 || CNT_4 == 2'd2) ? 2'd0:
    (CNT_4 == 2'd1 || CNT_4 == 2'd3) ?  2'd2: 2'd0):
    ////////////////////////////////////////////
    (CNT_col == 0 && CNT_row == 17) ?
    ((CNT_4 == 2'd0) ? 2'd2:
    (CNT_4 == 2'd1) ?  2'd0:
    (CNT_4 == 2'd2) ?  2'd1:
    (CNT_4 == 2'd3) ?  2'd2: 2'd0):
    //////////////////////////////////////////////
    (CNT_col > = 1 && CNT_col < = 12 && CNT_row == 17) ?
    ((CNT_4 == 2'd0 || CNT_4 == 2'd1) ? 2'd0:
    (CNT_4 == 2'd2 || CNT_4 == 2'd3) ? 2'd2: 2'd0):
    /////////////////////////////////////////////
    (CNT_col == 13 && CNT_row == 17) ?
    ((CNT_4 == 2'd0) ? 2'd0:
    (CNT_4 == 2'd1) ?  2'd2:
    (CNT_4 == 2'd2) ?  2'd2:
    (CNT_4 == 2'd3) ?  2'd1: 2'd0): 2'd0;
    
    
    ////////////////////padding reg 12//////////////////////
    D_REG#(
    .WL(2)
    )U_pad_delay1(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(oEN_9),
    .iCLR(0),
    .iDATA(pad_d1),
    .oDATA(pad_d2)
    );
    
    D_REG#(
    .WL(2)
    )U_pad_delay2(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(pad_d2),
    .oDATA(pad_d3)
    );
    
    D_REG#(
    .WL(2)
    )U_pad_delay3(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(pad_d3),
    .oDATA(pad_d4)
    );
    
    D_REG#(
    .WL(2)
    )U_pad_delay4(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(pad_d4),
    .oDATA(pad_d5)
    );
    
    D_REG#(
    .WL(2)
    )U_pad_delay5(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(pad_d5),
    .oDATA(pad_d6)
    );
    
    D_REG#(
    .WL(2)
    )U_pad_delay6(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(pad_d6),
    .oDATA(pad_d7)
    );
    
    D_REG#(
    .WL(2)
    )U_pad_delay7(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(pad_d7),
    .oDATA(pad_d8)
    );
    
    D_REG#(
    .WL(2)
    )U_pad_delay8(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(pad_d8),
    .oDATA(pad_d9)
    );
    
    D_REG#(
    .WL(2)
    )U_pad_delay9(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(pad_d9),
    .oDATA(pad_d10)
    );
    
    D_REG#(
    .WL(2)
    )U_pad_delay10(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(pad_d10),
    .oDATA(pad_d11)
    );
    
    D_REG#(
    .WL(2)
    )U_pad_delay11(
    .iRSTn(WHOLE_RST),
    .iCLK(iCLK),
    .iEN(1),
    .iCLR(0),
    .iDATA(pad_d11),
    .oDATA(opad)
    );
    
endmodule
