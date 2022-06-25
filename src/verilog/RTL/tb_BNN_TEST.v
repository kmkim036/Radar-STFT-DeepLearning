`timescale 1 ns/100 ps

module tb_BNN_TEST();
    
    parameter CLOCK_PERIOD = 2;
    reg iCLK;
    reg iSTART;
    reg iRSTn;
    reg iCLR;
    wire [5:0]	oMEM0RdADDR, oMEM0WrADDR;
    wire [27:0]	oMEM0WrDATA;
    wire	oMEM0Rd_EN, oMEM0Wr_EN;
    
    BNN_TEST uut(
    .iCLK(iCLK),
    .iSTART(iSTART),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .oMEM0RdADDR(oMEM0RdADDR),
    .oMEM0WrADDR(oMEM0WrADDR),
    .oMEM0WrDATA(oMEM0WrDATA),
    .oMEM0Rd_EN(oMEM0Rd_EN),
    .oMEM0Wr_EN(oMEM0Wr_EN)
    );
    
    initial begin
        iCLK       <= 0;
        iRSTn      <= 0;
        iSTART     <= 0;
        iCLR       <= 0;
        #5 iRSTn   <= 1;
        #10 iSTART <= 1;
    end
    
    initial begin
        forever #(CLOCK_PERIOD/2) iCLK <= ~iCLK;
    end
    
    
endmodule
    
