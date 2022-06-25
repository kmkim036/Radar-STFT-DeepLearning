module CONV1_Read_Controller(iCLK,
                             iRSTn,
                             iEN,
                             oRd_ADDR,
                             oBit_ADDR,
                             oRd_DONE);
    
    input iCLK;
    input iRSTn;
    input iEN;
    output [5:0] oRd_ADDR;
    output [4:0] oBit_ADDR;
    output oRd_DONE;
    
    wire oEN_col;
    wire oEN_4;
    wire oEN_9;
    wire oEN_112;
    wire oEN_row;
    
    wire [3:0] CNT_col;
    wire [4:0] CNT_row;
    wire [1:0] CNT_4;
    wire [3:0] CNT_9;
    wire [6:0] CNT_112;
    
    assign oRd_DONE = (oEN_row == 1 && oEN_col == 1) ? 1 : 0;
    
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
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 5'd0):
    (CNT_4 == 2'd1 || CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 2 : 5'd0): 5'd0):
    //////////////////////////////////
    (CNT_col == 0 && CNT_row == 0) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? 5'd0 :
    (CNT_9 == 4'd1) ? 5'd0 :
    (CNT_9 == 4'd2) ? 5'd0 :
    (CNT_9 == 4'd3) ? 5'd0 :
    (CNT_9 == 4'd4) ? 0 :
    (CNT_9 == 4'd5) ? 1 :
    (CNT_9 == 4'd6) ? 5'd0 :
    (CNT_9 == 4'd7) ? 0 :
    (CNT_9 == 4'd8) ? 1 : 5'd0):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? 5'd0 :
    (CNT_9 == 4'd1) ? 5'd0 :
    (CNT_9 == 4'd2) ? 5'd0 :
    (CNT_9 == 4'd3) ? 0     :
    (CNT_9 == 4'd4) ? 1 :
    (CNT_9 == 4'd5) ? 2 :
    (CNT_9 == 4'd6) ? 0     :
    (CNT_9 == 4'd7) ? 1 :
    (CNT_9 == 4'd8) ? 2 : 5'd0):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? 5'd0 :
    (CNT_9 == 4'd1) ? 0 :
    (CNT_9 == 4'd2) ? 1 :
    (CNT_9 == 4'd3) ? 5'd0 :
    (CNT_9 == 4'd4) ? 0 :
    (CNT_9 == 4'd5) ? 1 :
    (CNT_9 == 4'd6) ? 5'd0 :
    (CNT_9 == 4'd7) ? 0 :
    (CNT_9 == 4'd8) ? 1 : 5'd0):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? 0 :
    (CNT_9 == 4'd1) ? 1 :
    (CNT_9 == 4'd2) ? 2 :
    (CNT_9 == 4'd3) ? 0     :
    (CNT_9 == 4'd4) ? 1 :
    (CNT_9 == 4'd5) ? 2 :
    (CNT_9 == 4'd6) ? 0     :
    (CNT_9 == 4'd7) ? 1 :
    (CNT_9 == 4'd8) ? 2 : 5'd0): 5'd0):
    ///////////////////////////////
    (CNT_col > = 1 && CNT_col < = 12 && CNT_row == 0) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? 5'd0 :
    (CNT_9 == 4'd1) ? 5'd0 :
    (CNT_9 == 4'd2) ? 5'd0 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 5'd0):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? 5'd0 :
    (CNT_9 == 4'd1) ? 5'd0 :
    (CNT_9 == 4'd2) ? 5'd0 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 2 : 5'd0):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 5'd0):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 2 : 5'd0): 5'd0):
    ////////////////////////////////
    (CNT_col == 13 && CNT_row == 0) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? 5'd0 :
    (CNT_9 == 4'd1) ? 5'd0 :
    (CNT_9 == 4'd2) ? 5'd0 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 5'd0):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? 5'd0 :
    (CNT_9 == 4'd1) ? 5'd0 :
    (CNT_9 == 4'd2) ? 5'd0 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? 5'd0 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? 5'd0 : 5'd0):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 5'd0):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? 5'd0 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? 5'd0 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? 5'd0 : 5'd0): 5'd0):
    //////////////////////////////
    (CNT_col == 0 && CNT_row > = 1 && CNT_row < = 16) ?
    ((CNT_4 == 2'd0 || CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? 5'd0 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? 5'd0 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? 5'd0 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 5'd0):
    (CNT_4 == 2'd1 || CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 2 : 5'd0): 5'd0):
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
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 5'd0):
    (CNT_4 == 2'd1 || CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? 5'd0 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? 5'd0 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? 5'd0 : 5'd0):5'd0):
    ////////////////////////////////////////////
    (CNT_col == 0 && CNT_row == 17) ?
    ((CNT_4 == 2'd0) ?(
    (CNT_9 == 4'd0) ? 5'd0 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? 5'd0 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? 5'd0 :
    (CNT_9 == 4'd7) ? (CNT_col << 1)     :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 5'd0):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 2 : 5'd0):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? 5'd0 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? 5'd0 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? 5'd0 :
    (CNT_9 == 4'd7) ? 5'd0     :
    (CNT_9 == 4'd8) ? 5'd0 : 5'd0):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? 5'd0 :
    (CNT_9 == 4'd7) ? 5'd0 :
    (CNT_9 == 4'd8) ? 5'd0 : 5'd0): 5'd0):
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
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 5'd0):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 2 : 5'd0):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? 5'd0 :
    (CNT_9 == 4'd7) ? 5'd0 :
    (CNT_9 == 4'd8) ? 5'd0 : 5'd0):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 2 :
    (CNT_9 == 4'd6) ? 5'd0 :
    (CNT_9 == 4'd7) ? 5'd0 :
    (CNT_9 == 4'd8) ? 5'd0 : 5'd0): 5'd0):
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
    (CNT_9 == 4'd8) ? (CNT_col << 1) + 1 : 5'd0):
    (CNT_4 == 2'd1) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? 5'd0 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? 5'd0 :
    (CNT_9 == 4'd6) ? (CNT_col << 1)     :
    (CNT_9 == 4'd7) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd8) ? 5'd0 : 5'd0):
    (CNT_4 == 2'd2) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd1) ? (CNT_col << 1)     :
    (CNT_9 == 4'd2) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd3) ? (CNT_col << 1) - 1 :
    (CNT_9 == 4'd4) ? (CNT_col << 1)     :
    (CNT_9 == 4'd5) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd6) ? 5'd0 :
    (CNT_9 == 4'd7) ? 5'd0 :
    (CNT_9 == 4'd8) ? 5'd0 : 5'd0):
    (CNT_4 == 2'd3) ?(
    (CNT_9 == 4'd0) ? (CNT_col << 1)     :
    (CNT_9 == 4'd1) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd2) ? 5'd0 :
    (CNT_9 == 4'd3) ? (CNT_col << 1)     :
    (CNT_9 == 4'd4) ? (CNT_col << 1) + 1 :
    (CNT_9 == 4'd5) ? 5'd0 :
    (CNT_9 == 4'd6) ? 5'd0 :
    (CNT_9 == 4'd7) ? 5'd0 :
    (CNT_9 == 4'd8) ? 5'd0 : 5'd0): 5'd0):5'd0;
      
endmodule
