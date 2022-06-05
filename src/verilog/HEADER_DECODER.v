`timescale 1ns/100ps

module HEADER_DECODER(iCLK,
                      iRSTn,
                      iCLR,
                      iEN,
                      MOSI,
                      oHEADER,
                      oHEADER_EN);
    
    input			iCLK;
    input			iRSTn;
    input			iCLR;
    input			iEN;
    input			MOSI;
    
    output  [5:0]	oHEADER;
    output			oHEADER_EN;
    
    wire	[2:0]	CNT;
    wire			header0, header1, header2, header3, header4, header5, header6, header7;
    
    //shift reg
    D_REG#(
    .WL(1)
    )Shift_Reg0(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(MOSI),
    .oDATA(header0)
    );
    
    D_REG#(
    .WL(1)
    )Shift_Reg1(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(header0),
    .oDATA(header1)
    );
    
    D_REG#(
    .WL(1)
    )Shift_Reg2(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(header1),
    .oDATA(header2)
    );
    
    D_REG#(
    .WL(1)
    )Shift_Reg3(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(header2),
    .oDATA(header3)
    );
    
    D_REG#(
    .WL(1)
    )Shift_Reg4(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(header3),
    .oDATA(header4)
    );
    
    D_REG#(
    .WL(1)
    )Shift_Reg5(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(header4),
    .oDATA(header5)
    );
    
    // D_REG#(
    // .WL(1)
    // )shift_reg6(
    // .iCLK(iCLK), 
    // .iRSTn(iRSTn), 
    // .iCLR(iCLR), 
    // .iEN(iEN), 
    // .iDATA(header5), 
    // .oDATA(header6)
    // );

    // D_REG#(
    // .WL(1)
    // )shift_reg7(
    // .iCLK(iCLK), 
    // .iRSTn(iRSTn), 
    // .iCLR(iCLR), 
    // .iEN(iEN), 
    // .iDATA(header6), 
    // .oDATA(header7)
    // );
    
    //counter
    COUNTER_NECV#(
    .WL(3),
    .IV(0)
    )Counter(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .oCNT(CNT)
    );
    
    assign	oHEADER	   = {header5, header4, header3, header2, header1, header0};
    assign	oHEADER_EN = ((CNT == 3'd5) && (iEN == 1'b1)) ? 1'b1 : 1'b0;
    
endmodule
