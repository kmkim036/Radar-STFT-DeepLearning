`timescale 1ns/100ps

// SPI_SPI2MEM_DATA = > image data,        RPI(SPI) -> MEM0, 28 bits
// ILA_MEM_iDATA = > image data,        MEM0 -> BNN,      28 bits
// ILA_MEM_oDATA = > final class index, BNN -> MEM0,      28 bits
// SPI_MEM2SPI_DATA = > final class index, MEM0 -> RPI(SPI), 28 bits
// ILA_MEM_oADDR = > MEM0 ADDR used by BNN              , 6 bits
// SPI_ADDR = > MEM0 ADDR used by SPI              , 6 bits

module BNN_WRAPPER(CLOCK_50,
                   iRSTn,
                   iCLR,
                   SCLK,
                   MOSI,
                   MISO,
                   CS,
                   LEDR,
                   SW,
                   Debug_SPI_SPI2MEM_DATA,
                   Debug_ILA_MEM_iDATA,
                   Debug_ILA_MEM_oDATA,
                   Debug_SPI_MEM2SPI_DATA,
                   Debug_ILA_MEM_oADDR,
                   Debug_SPI_ADDR);
    
    // Debugging
    input   SW;
    output  LEDR;
    assign  LEDR = SW;
    
    input						CLOCK_50;
    input						iRSTn;
    input						iCLR;
    input						SCLK;
    input						MOSI;
    input						CS;
    output					MISO;
    
    wire						  SPI_Rd_EN;
    wire						  SPI_Wr_EN;
    wire			[5:0]		SPI_ADDR;
    wire			[27:0]	SPI_MEM2SPI_DATA;
    wire			[27:0]	SPI_SPI2MEM_DATA;
    wire						  Rd_DONE;
    wire						  Wr_DONE;
    wire						  SPI_FINISH;
    
    wire						START_TICK;
    
    // ILA_MEMORY
    wire		[5:0]			ILA_MEM_oADDR;
    wire						  ILA_MEM_Rd_EN;
    wire						  ILA_MEM_Wr_EN;
    wire		[27:0]		ILA_MEM_oDATA;
    wire		[27:0]		ILA_MEM_iDATA;
    
    // Debugging
    output  [27:0] Debug_SPI_SPI2MEM_DATA, Debug_ILA_MEM_iDATA, Debug_ILA_MEM_oDATA, Debug_SPI_MEM2SPI_DATA;
    output  [5:0]  Debug_ILA_MEM_oADDR, Debug_SPI_ADDR
    assign Debug_SPI_SPI2MEM_DATA = SPI_SPI2MEM_DATA;
    assign Debug_ILA_MEM_iDATA    = ILA_MEM_iDATA;
    assign Debug_ILA_MEM_oDATA    = ILA_MEM_oDATA;
    assign Debug_SPI_MEM2SPI_DATA = SPI_MEM2SPI_DATA;
    assign Debug_ILA_MEM_oADDR    = ILA_MEM_oADDR;
    assign Debug_SPI_ADDR         = SPI_ADDR;
    
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
    .iRSTn(iRSTn & (~SPI_FINISH)),
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
    );
    
    //iSTART tick signal generator
    Tick_signal_gen Start_Signal_Gen(
    .iCLK(CLOCK_50),
    .iRSTn(iRSTn),
    .iEN(Wr_DONE),
    .Pulse(START_TICK)
    );
    
    /*
     ////////////////////////////////////////
     // temporary Code
     MEM48x28 RAM0(
     .clock_a(SCLK),
     .address_a(SPI_ADDR),
     .data_a(SPI_SPI2MEM_DATA),
     .rden_a(SPI_Rd_EN),
     .wren_a(SPI_Wr_EN),
     .q_a(SPI_MEM2SPI_DATA),
     .clock_b(CLOCK_50),
     .address_b(ILA_MEM_oADDR),//fill the blank
     .data_b(28'd0),//fill the blank
     .rden_b(ILA_MEM_Rd_EN),//fill the blank
     .wren_b(1'b0),//fill the blank
     .q_b(ILA_MEM_oDATA)//fill the blank
     );
     
     BNN_IP_temp BNN_IP(
     .iCLK(CLOCK_50),
     .iRSTn(iRSTn),
     .iCLR(~iCLR),
     .iSTART(START_TICK),
     .oADDR(ILA_MEM_oADDR),
     .oRd_EN(ILA_MEM_Rd_EN),
     .oWr_EN(ILA_MEM_Wr_EN)
     );
     ////////////////////////////////////////
     */
    
    ////////////////////////////////////////
    // real codes
    MEM48x28 RAM0(
    .clock_a(SCLK),
    .address_a(SPI_ADDR),
    .data_a(SPI_SPI2MEM_DATA),
    .rden_a(SPI_Rd_EN),
    .wren_a(SPI_Wr_EN),
    .q_a(SPI_MEM2SPI_DATA),
    .clock_b(CLOCK_50),
    .address_b(ILA_MEM_oADDR),
    .data_b(ILA_MEM_oDATA),
    .rden_b(ILA_MEM_Rd_EN),
    .wren_b(ILA_MEM_Wr_EN),
    .q_b(ILA_MEM_iDATA)
    );
    
    //BNN IP Code
    BNN_TEST BNN_IP(
    .iCLK(CLOCK_50),
    .iRSTn(iRSTn),
    .iCLR(~iCLR),
    .iSTART(START_TICK),
    .iMEM0RdDATA(ILA_MEM_iDATA),
    .oMEM0ADDR(ILA_MEM_oADDR),
    .oMEM0WrDATA(ILA_MEM_oDATA),
    .oMEM0Rd_EN(ILA_MEM_Rd_EN),
    .oMEM0Wr_EN(ILA_MEM_Wr_EN),
    );
    
    
endmodule
