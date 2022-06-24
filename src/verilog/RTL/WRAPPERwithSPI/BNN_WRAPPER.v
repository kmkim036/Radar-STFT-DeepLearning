`timescale 1ns/100ps

module BNN_WRAPPER(CLOCK_50,
                   iRSTn,
                   iCLR,
                   SCLK,
                   MOSI,
                   MISO,
                   CS,
                   LEDR,
                   SW,
                   ILA_MEM_oADDR,
                   ILA_MEM_Rd_EN,
                   ILA_MEM_Wr_EN,
                   ILA_MEM_oDATA);
    
    // Debugging
    input SW;
    output LEDR;
    assign LEDR = SW;
    
    //ILA_MEMORY
    output		[5:0]			ILA_MEM_oADDR;
    output						ILA_MEM_Rd_EN;
    output						ILA_MEM_Wr_EN;
    output		[27:0]			ILA_MEM_oDATA;
    
    input						CLOCK_50;
    input						iRSTn;
    input						iCLR;
    input						SCLK;
    input						MOSI;
    input						CS;
    
    output						MISO;
    
    wire						Rd_DONE;
    wire						Wr_DONE;
    wire						SPI_FINISH;
    wire			[27:0]		SPI_MEM2SPI_DATA;
    wire						SPI_Rd_EN;
    wire			[5:0]		SPI_ADDR;
    wire			[27:0]		SPI_SPI2MEM_DATA;
    wire						SPI_Wr_EN;
    
    wire			[27:0]		tmp;
    wire						START_TICK;
    wire						IP_DONE;
    wire						DONE_FLAG;
    
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
    
    //iSTART tick signal generator
    Tick_signal_gen Start_Signal_Gen(
    .iCLK(CLOCK_50),
    .iRSTn(iRSTn),
    .iEN(Wr_DONE),
    .Pulse(START_TICK)
    );
    
    /*
     //BNN IP Code
     BNN_IP BNN_IP(
     .iCLK(CLOCK_50),
     .iRSTn(iRSTn),
     .iCLR(~iCLR),
     .iSTART(START_TICK),
     .iMEM0RdDATA(), // 28bits
     .oMEM0WrADDR(), // 6bits
     .oMEM0RdADDR(), // 6bits
     .oMEM0WrDATA(), // 28bits
     .oMEM0Rd_EN(ILA_MEM_Rd_EN),
     .oMEM0Wr_EN(ILA_MEM_Wr_EN),
     );
     */
    //BNN IP temp Code
    BNN_IP_temp BNN_IP(
    .iCLK(CLOCK_50),
    .iRSTn(iRSTn),
    .iCLR(~iCLR),
    .iSTART(START_TICK),
    .oADDR(ILA_MEM_oADDR),
    .oRd_EN(ILA_MEM_Rd_EN),
    .oWr_EN(ILA_MEM_Wr_EN)
    );
    
endmodule
