`timescale 1ns/100ps

module BNN_WRAPPER(CLOCK_50,
                   iRSTn,
                   iCLR,
                   SCLK,
                   MOSI,
                   MISO,
                   CS,
                   ILA_BNN_Rd_DONE,
                   ILA_BNN_Wr_DONE,
                   ILA_BNN_SPI_FINISH,
                   ILA_BNN_SPI_MEM2SPI_DATA,
                   ILA_BNN_SPI_Rd_EN,
                   ILA_BNN_SPI_ADDR,
                   ILA_BNN_SPI_SPI2MEM_DATA,
                   ILA_BNN_SPI_Wr_EN,
                   ILA_BNN_tmp,
                   ILA_BNN_START_TICK,
                   ILA_BNN_IP_DONE,
                   ILA_BNN_DONE_FLAG,
                   ILA_HEADER,
                   ILA_HEADER_EN,
                   ILA_Rd_ADDR,
                   ILA_Wr_ADDR,
                   ILA_EN1,
                   ILA_EN2,
                   ILA_EN3,
                   ILA_EN3_tmp1,
                   ILA_EN3_tmp2,
                   ILA_next_state,
                   ILA_current_state,
                   ILA_WR_CNT_line,
                   ILA_WR_ECV_VALUE,
                   ILA_WR_LAST_CNT,
                   ILA_WR_Wr_EN_LAST,
                   ILA_WR_LAST_3count_EN,
                   ILA_WR_next_state,
                   ILA_WR_current_state,
                   ILA_MEM_oADDR,
                   ILA_MEM_Rd_EN,
                   ILA_MEM_Wr_EN,
                   ILA_MEM_oDATA);
    
    //ILA
    output			ILA_BNN_Rd_DONE;
    output			ILA_BNN_Wr_DONE;

    output			ILA_BNN_SPI_FINISH;
    output			ILA_BNN_SPI_Rd_EN;
    output			ILA_BNN_SPI_Wr_EN;
    output	[4:0]	ILA_BNN_SPI_ADDR;
    output	[19:0]	ILA_BNN_SPI_SPI2MEM_DATA;
    output	[19:0]	ILA_BNN_SPI_MEM2SPI_DATA;
    
    output	[19:0]	ILA_BNN_tmp;
    output			ILA_BNN_START_TICK;
    output			ILA_BNN_IP_DONE;
    output			ILA_BNN_DONE_FLAG;
    
    output	[5:0]	ILA_HEADER;
    output			ILA_HEADER_EN;

    output	[4:0]	ILA_Rd_ADDR;
    output	[4:0]	ILA_Wr_ADDR;

    output			ILA_EN1, ILA_EN2, ILA_EN3;
    output			ILA_EN3_tmp1, ILA_EN3_tmp2;

    output	[1:0]	ILA_next_state;
    output	[1:0]	ILA_current_state;
    
    output	[4:0]	ILA_WR_CNT_line;
    output			ILA_WR_ECV_VALUE;
    output	[2:0]	ILA_WR_LAST_CNT;
    output			ILA_WR_Wr_EN_LAST;
    output			ILA_WR_LAST_3count_EN;
    output			ILA_WR_next_state;
    output			ILA_WR_current_state;
    
    output	[4:0]	ILA_MEM_oADDR;
    output			ILA_MEM_Rd_EN;
    output			ILA_MEM_Wr_EN;
    output	[19:0]	ILA_MEM_oDATA;
    
    input			CLOCK_50;
    input			iRSTn;
    input			iCLR;
    input			SCLK;
    input			MOSI;
    input			CS;
    
    output			MISO;
    
    wire			Rd_DONE;
    wire			Wr_DONE;

    wire			SPI_FINISH;
    wire			SPI_Rd_EN;
    wire			SPI_Wr_EN;
    wire	[4:0]	SPI_ADDR;
    wire	[19:0]	SPI_SPI2MEM_DATA;
    wire	[19:0]	SPI_MEM2SPI_DATA;
    
    wire	[19:0]	tmp;
    wire			START_TICK;
    wire			IP_DONE;
    wire			DONE_FLAG;
    
    //clear all(shift_reg)
    COMMUNICATION_DONE clear_all(
    .iCLK(CLOCK_50),
    .iRSTn(iRSTn),
    .iCLR(~iCLR),
    .iEN(1'b1),
    .iDATA(Rd_DONE|Wr_DONE),
    .oDATA(SPI_FINISH)
    );
    
    //spi_protocol
    SPI_PROTOCOL spi_protocol(
    .iRSTn(iRSTn&(~SPI_FINISH)),
    .iCLR(~iCLR),
    .SCLK(SCLK),
    .MOSI(MOSI),
    .MISO(MISO),
    .CS(CS),
    .oRd_DONE(Rd_DONE),
    .oWr_DONE(Wr_DONE),
    .iDATA(SPI_MEM2SPI_DATA),
    .oADDR(SPI_ADDR),
    .oRd_EN(SPI_Rd_EN),
    .oDATA(SPI_SPI2MEM_DATA),
    .oWr_EN(SPI_Wr_EN),
    .ILA_HEADER(ILA_HEADER),
    .ILA_HEADER_EN(ILA_HEADER_EN),
    .ILA_Rd_ADDR(ILA_Rd_ADDR),
    .ILA_Wr_ADDR(ILA_Wr_ADDR),
    .ILA_EN1(ILA_EN1),
    .ILA_EN2(ILA_EN2),
    .ILA_EN3(ILA_EN3),
    .ILA_EN3_tmp1(ILA_EN3_tmp1),
    .ILA_EN3_tmp2(ILA_EN3_tmp2),
    .ILA_next_state(ILA_next_state),
    .ILA_current_state(ILA_current_state),
    .ILA_WR_CNT_line(ILA_WR_CNT_line),
    .ILA_WR_ECV_VALUE(ILA_WR_ECV_VALUE),
    .ILA_WR_LAST_CNT(ILA_WR_LAST_CNT),
    .ILA_WR_Wr_EN_LAST(ILA_WR_Wr_EN_LAST),
    .ILA_WR_LAST_3count_EN(ILA_WR_LAST_3count_EN),
    .ILA_WR_next_state(ILA_WR_next_state),
    .ILA_WR_current_state(ILA_WR_current_state)
    );
    
    //memory
    MEM20x29 U_memory(
    .clock_a(SCLK),
    .address_a(SPI_ADDR),
    .data_a(SPI_SPI2MEM_DATA),
    .rden_a(SPI_Rd_EN),
    .wren_a(SPI_Wr_EN),
    .q_a(SPI_MEM2SPI_DATA),    
	 .clock_b(CLOCK_50),
    .address_b(ILA_MEM_oADDR),  //fill the blank
    .data_b(20'd0),             //fill the blank
    .rden_b(ILA_MEM_Rd_EN),     //fill the blank
    .wren_b(1'b0),              //fill the blank
    .q_b(ILA_MEM_oDATA)         //fill the blank
    );
    
    //iSTART tick signal generator
    Tick_signal_gen Start_Signal_Gen(
    .iCLK(CLOCK_50),
    .iRSTn(iRSTn),
    .iEN(Wr_DONE),
    .Pulse(START_TICK)
    );
    
    //ILA assign
    assign		ILA_BNN_Rd_DONE          = Rd_DONE;
    assign		ILA_BNN_Wr_DONE          = Wr_DONE;
    assign		ILA_BNN_SPI_FINISH       = SPI_FINISH;
    assign		ILA_BNN_SPI_MEM2SPI_DATA = SPI_MEM2SPI_DATA;
    assign		ILA_BNN_SPI_Rd_EN        = SPI_Rd_EN;
    assign		ILA_BNN_SPI_ADDR         = SPI_ADDR;
    assign		ILA_BNN_SPI_SPI2MEM_DATA = SPI_SPI2MEM_DATA;
    assign		ILA_BNN_SPI_Wr_EN        = SPI_Wr_EN;
    assign		ILA_BNN_tmp              = tmp;
    assign		ILA_BNN_START_TICK       = START_TICK;
    assign		ILA_BNN_IP_DONE          = IP_DONE;
    assign		ILA_BNN_DONE_FLAG        = DONE_FLAG;
    
    //done flag register
    // D_REG#(
    // .WL(1)
    // )Done_Flag_Reg(
    // .iCLK(CLOCK_50), 
    // .iRSTn(iRSTn), 
    // .iCLR(iCLR), 
    // .iEN(1'b1), 
    // .iDATA(1'b1), 
    // .oDATA(DONE_FLAG)
    // );

    
    /////////////////////////////////////////////////
    //				Write Your BNN IP Code
    /////////////////////////////////////////////////
    
    //BNN IP Code
    BNN_Top BNN_Top(
    .iCLK(CLOCK_50),
    .iRSTn(iRSTn),
    .iCLR(~iCLR),
    .iSTART(START_TICK),
    .oADDR(ILA_MEM_oADDR),
    .oRd_EN(ILA_MEM_Rd_EN),
    .oWr_EN(ILA_MEM_Wr_EN)
    );
    
    /////////////////////////////////////////////////
    //				Write Your BNN IP Code
    /////////////////////////////////////////////////
    
endmodule
