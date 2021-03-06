module xnor_popcount(iCLK,
                     iRSTn,
                     iEN,
                     idata,
                     iSTATE,
                     iweight,
                     iaddr,
                     odata,
                     oEN,
                     weight_addr);
    
    parameter WL = 112;
    
    input   iCLK;
    input   iRSTn;
    input   iEN;
    input   [2:0]   iSTATE;
    input   [4:0]   iaddr;
    input	[WL-1:0]	idata;
    input	[WL-1:0]	iweight;
    input   [6:0]   weight_addr;
    
    output  oEN;
    output  [6:0]   odata;
    
    wire    [WL-1:0]    xnor_result, temp_xnor;
    wire    [6:0]   pop_result;
    wire    bit_result;
    
    assign temp_xnor    = idata ~^ iweight;
    assign bit_result   = idata[iaddr] ~^ iweight[weight_addr];
    assign xnor_result	 = 	(iSTATE > 3'b010) ? temp_xnor : bit_result;
    
    adder_tree popcount(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .a1(xnor_result[0]),
    .a2(xnor_result[1]),
    .a3(xnor_result[2]),
    .a4(xnor_result[3]),
    .a5(xnor_result[4]),
    .a6(xnor_result[5]),
    .a7(xnor_result[6]),
    .a8(xnor_result[7]),
    .a9(xnor_result[8]),
    .a10(xnor_result[9]),
    .a11(xnor_result[10]),
    .a12(xnor_result[11]),
    .a13(xnor_result[12]),
    .a14(xnor_result[13]),
    .a15(xnor_result[14]),
    .a16(xnor_result[15]),
    .a17(xnor_result[16]),
    .a18(xnor_result[17]),
    .a19(xnor_result[18]),
    .a20(xnor_result[19]),
    .a21(xnor_result[20]),
    .a22(xnor_result[21]),
    .a23(xnor_result[22]),
    .a24(xnor_result[23]),
    .a25(xnor_result[24]),
    .a26(xnor_result[25]),
    .a27(xnor_result[26]),
    .a28(xnor_result[27]),
    .a29(xnor_result[28]),
    .a30(xnor_result[29]),
    .a31(xnor_result[30]),
    .a32(xnor_result[31]),
    .a33(xnor_result[32]),
    .a34(xnor_result[33]),
    .a35(xnor_result[34]),
    .a36(xnor_result[35]),
    .a37(xnor_result[36]),
    .a38(xnor_result[37]),
    .a39(xnor_result[38]),
    .a40(xnor_result[39]),
    .a41(xnor_result[40]),
    .a42(xnor_result[41]),
    .a43(xnor_result[42]),
    .a44(xnor_result[43]),
    .a45(xnor_result[44]),
    .a46(xnor_result[45]),
    .a47(xnor_result[46]),
    .a48(xnor_result[47]),
    .a49(xnor_result[48]),
    .a50(xnor_result[49]),
    .a51(xnor_result[50]),
    .a52(xnor_result[51]),
    .a53(xnor_result[52]),
    .a54(xnor_result[53]),
    .a55(xnor_result[54]),
    .a56(xnor_result[55]),
    .a57(xnor_result[56]),
    .a58(xnor_result[57]),
    .a59(xnor_result[58]),
    .a60(xnor_result[59]),
    .a61(xnor_result[60]),
    .a62(xnor_result[61]),
    .a63(xnor_result[62]),
    .a64(xnor_result[63]),
    .a65(xnor_result[64]),
    .a66(xnor_result[65]),
    .a67(xnor_result[66]),
    .a68(xnor_result[67]),
    .a69(xnor_result[68]),
    .a70(xnor_result[69]),
    .a71(xnor_result[70]),
    .a72(xnor_result[71]),
    .a73(xnor_result[72]),
    .a74(xnor_result[73]),
    .a75(xnor_result[74]),
    .a76(xnor_result[75]),
    .a77(xnor_result[76]),
    .a78(xnor_result[77]),
    .a79(xnor_result[78]),
    .a80(xnor_result[79]),
    .a81(xnor_result[80]),
    .a82(xnor_result[81]),
    .a83(xnor_result[82]),
    .a84(xnor_result[83]),
    .a85(xnor_result[84]),
    .a86(xnor_result[85]),
    .a87(xnor_result[86]),
    .a88(xnor_result[87]),
    .a89(xnor_result[88]),
    .a90(xnor_result[89]),
    .a91(xnor_result[90]),
    .a92(xnor_result[91]),
    .a93(xnor_result[92]),
    .a94(xnor_result[93]),
    .a95(xnor_result[94]),
    .a96(xnor_result[95]),
    .a97(xnor_result[96]),
    .a98(xnor_result[97]),
    .a99(xnor_result[98]),
    .a100(xnor_result[99]),
    .a101(xnor_result[100]),
    .a102(xnor_result[101]),
    .a103(xnor_result[102]),
    .a104(xnor_result[103]),
    .a105(xnor_result[104]),
    .a106(xnor_result[105]),
    .a107(xnor_result[106]),
    .a108(xnor_result[107]),
    .a109(xnor_result[108]),
    .a110(xnor_result[109]),
    .a111(xnor_result[110]),
    .a112(xnor_result[111]),
    .odata(pop_result),
    .oEN(oEN)
    );
    
    assign odata = pop_result;
    
endmodule
