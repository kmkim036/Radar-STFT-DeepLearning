`timescale 1ns/100ps

module tb_BNN_WRAPPER();
    
    reg		CLOCK_50;
    reg		iRSTn;
    reg		iCLR;
    reg		SCLK;
    reg		MOSI;
    reg		CS;
    
    wire	MISO;
    
    BNN_WRAPPER U1(
    .CLOCK_50(CLOCK_50),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .SCLK(SCLK),
    .MOSI(MOSI),
    .MISO(MISO),
    .CS(CS)
    );
    
    integer			i, j;
    reg		[7:0]	byte_read	[0:9];	//8bit 10depth
    reg		[7:0]	byte_write	[0:60];	//8bit 61depth
    
    initial
    begin
        $readmemh("C:/Users/SoC/Desktop/test/BNN_WRAPPER_ILA/byte_read.txt", byte_read);
        $readmemh("C:/Users/SoC/Desktop/test/BNN_WRAPPER_ILA/byte_write.txt", byte_write);
    end
    
    initial
    begin
        #0
        iRSTn = 1'b1;
        iCLR  = 1'b1;
        CS    = 1'b1;
        SCLK  = 1'b0;
        MOSI  = 1'b0;
        
        #50
        iRSTn = 	1'b0;
        
        #100
        iRSTn = 	1'b1;
        
        //write byte data
        #500
        CS = 1'b0;
        
        #100;
        for(i = 0; i < 61; i = i + 1)
        begin
            for(j = 0; j < 8; j = j + 1)
            begin
                #20
                SCLK = 1'b1;
                #0
                MOSI = byte_write[i][7-j];//byte data
                #20
                SCLK = 1'b0;
            end
            #20
            MOSI = 1'b0;
            #100;
        end
        #100
        CS = 1'b1;
        #5000
        
        //read byte data
        #1000
        CS = 1'b0;
        #100;
        for(i = 0; i < 10; i = i + 1)
        begin
            for(j = 0; j < 8; j = j +  1)
            begin
                #20
                SCLK = 1'b1;
                #0
                MOSI = byte_read[i][7-j];//byte data
                #20
                SCLK = 1'b0;
            end
            #20
            MOSI = 1'b0;
            #100;
        end
        #100
        CS = 1'b1;
        #5000
        
        //write byte data
        #1000
        CS = 1'b0;
        #100;
        for(i = 0; i < 61; i = i + 1)
        begin
            for(j = 0; j < 8; j = j + 1)
            begin
                #20
                SCLK = 1'b1;
                #0
                MOSI = byte_write[i][7-j];//byte data
                #20
                SCLK = 1'b0;
            end
            #20
            MOSI = 1'b0;
            #100;
        end
        #100
        CS = 1'b1;
        #5000
        
        //read byte data
        #1000
        CS = 1'b0;
        #100;
        for(i = 0; i < 10; i = i + 1)
        begin
            for(j = 0; j < 8; j = j + 1)
            begin
                #20
                SCLK = 	1'b1;
                #0
                MOSI = byte_read[i][7-j];//byte data
                #20
                SCLK = 1'b0;
            end
            #20
            MOSI = 1'b0;
            #100;
        end
        #100
        CS = 1'b1;
        
        //	#100		MOSI		 = 	1'b0;//byte data[7]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[6]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[5]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[4]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[3]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[2]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[1]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[0]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //
        //	#100		MOSI		 = 	1'b0;//byte data[7]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[6]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[5]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[4]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[3]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[2]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[1]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[0]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //
        //	#100		MOSI		 = 	1'b0;//byte data[7]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[6]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[5]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[4]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[3]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[2]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[1]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[0]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //
        //	#100		MOSI		 = 	1'b0;//byte data[7]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[6]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[5]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[4]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[3]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[2]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[1]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[0]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //
        //	#100		MOSI		 = 	1'b0;//byte data[7]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[6]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[5]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[4]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[3]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[2]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[1]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[0]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //
        //	#100		MOSI		 = 	1'b0;//byte data[7]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[6]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[5]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[4]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[3]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[2]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[1]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[0]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //
        //	#100		MOSI		 = 	1'b0;//byte data[7]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[6]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[5]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[4]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[3]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[2]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[1]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[0]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //
        //	#100		MOSI		 = 	1'b0;//byte data[7]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[6]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[5]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[4]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[3]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[2]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[1]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[0]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //
        //	#100		MOSI		 = 	1'b0;//byte data[7]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[6]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[5]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[4]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[3]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[2]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[1]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[0]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        
        //	#100		MOSI		 = 	1'b0;//byte data[7]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[6]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[5]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[4]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[3]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[2]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[1]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        //	#0			MOSI		  = 	1'b0;//byte data[0]
        //	#20		SCLK		  = 	1'b1;
        //	#20		SCLK		  = 	1'b0;
        
        #100		CS			 = 	1'b1;
    end
    
    
    initial
    begin
        CLOCK_50 = 0;
        forever
            #10
            CLOCK_50 = ~CLOCK_50;
    end
    
endmodule
