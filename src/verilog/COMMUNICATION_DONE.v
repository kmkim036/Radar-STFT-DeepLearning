`timescale 1ns/100ps

module COMMUNICATION_DONE(iCLK,
                          iRSTn,
                          iCLR,
                          iEN,
                          iDATA,
                          oDATA);
    
    input   iCLK;
    input	iRSTn;
    input	iCLR;
    input	iEN;
    input	iDATA;
    
    output	oDATA;
    
    wire	D1, D2, D3, D4, D5, D6, D7, D8, D9;
    
    D_REG#(
    .WL(1)
    )Finish_1D(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(iDATA),
    .oDATA(D1)
    );
    
    D_REG#(
    .WL(1)
    )Finish_2D(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(D1),
    .oDATA(D2)
    );
    
    D_REG#(
    .WL(1)
    )Finish_3D(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(D2),
    .oDATA(D3)
    );
    
    D_REG#(
    .WL(1)
    )Finish_4D(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(D3),
    .oDATA(D4)
    );
    
    D_REG#(
    .WL(1)
    )Finish_5D(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(D4),
    .oDATA(D5)
    );
    
    D_REG#(
    .WL(1)
    )Finish_6D(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(D5),
    .oDATA(D6)
    );
    
    D_REG#(
    .WL(1)
    )Finish_7D(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(D6),
    .oDATA(D7)
    );
    
    D_REG#(
    .WL(1)
    )Finish_8D(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(D7),
    .oDATA(D8)
    );
    
    D_REG#(
    .WL(1)
    )Finish_9D(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(D8),
    .oDATA(D9)
    );
    
    D_REG#(
    .WL(1)
    )Finish_10D(
    .iCLK(iCLK),
    .iRSTn(iRSTn),
    .iCLR(iCLR),
    .iEN(iEN),
    .iDATA(D9),
    .oDATA(oDATA)
    );
    
endmodule
