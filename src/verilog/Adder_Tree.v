`timescale 1 ns / 100 ps

module Adder_Tree(a1,
                  a2,
                  a3,
                  a4,
                  a5,
                  a6,
                  a7,
                  a8,
                  a9,
                  a10,
                  a11,
                  a12,
                  a13,
                  a14,
                  a15,
                  a16,
                  a17,
                  a18,
                  a19,
                  a20,
                  a21,
                  a22,
                  a23,
                  a24,
                  a25,
                  a26,
                  a27,
                  a28,
                  a29,
                  a30,
                  a31,
                  a32,
                  a33,
                  a34,
                  a35,
                  a36,
                  a37,
                  a38,
                  a39,
                  a40,
                  a41,
                  a42,
                  a43,
                  a44,
                  a45,
                  a46,
                  a47,
                  a48,
                  a49,
                  a50,
                  a51,
                  a52,
                  a53,
                  a54,
                  a55,
                  a56,
                  a57,
                  a58,
                  a59,
                  a60,
                  a61,
                  a62,
                  a63,
                  a64,
                  a65,
                  a66,
                  a67,
                  a68,
                  a69,
                  a70,
                  a71,
                  a72,
                  a73,
                  a74,
                  a75,
                  a76,
                  a77,
                  a78,
                  a79,
                  a80,
                  a81,
                  a82,
                  a83,
                  a84,
                  a85,
                  a86,
                  a87,
                  a88,
                  a89,
                  a90,
                  a91,
                  a92,
                  a93,
                  a94,
                  a95,
                  a96,
                  a97,
                  a98,
                  a99,
                  a100,
                  a101,
                  a102,
                  a103,
                  a104,
                  a105,
                  a106,
                  a107,
                  a108,
                  a109,
                  a110,
                  a111,
                  a112,
                  iCLK,
                  iRSTn,
                  iEN,
                  odata);
    
    parameter WL = 1;
    
    input		iCLK;
    input		iRSTn;
    input		iEN;
    input 		a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14,
    a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28,
    a29, a30, a31, a32, a33, a34, a35, a36, a37, a38, a39, a40, a41, a42,
    a43, a44, a45, a46, a47, a48, a49, a50, a51, a52, a53, a54, a55, a56,
    a57, a58, a59, a60, a61, a62, a63, a64, a65, a66, a67, a68, a69, a70,
    a71, a72, a73, a74, a75, a76, a77, a78, a79, a80, a81, a82, a83, a84,
    a85, a86, a87, a88, a89, a90, a91, a92, a93, a94, a95, a96, a97, a98,
    a99, a100, a101, a102, a103, a104, a105, a106, a107, a108, a109, a110, a111, a112;
    
    wire	[WL:0]		b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14,
    b15, b16, b17, b18, b19, b20, b21, b22, b23, b24, b25, b26, b27, b28,
    b29, b30, b31, b32, b33, b34, b35, b36, b37, b38, b39, b40, b41, b42,
    b43, b44, b45, b46, b47, b48, b49, b50, b51, b52, b53, b54, b55, b56;
    
    wire	[WL+1:0]	c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14,
    c15, c16, c17, c18, c19, c20, c21, c22, c23, c24, c25, c26, c27, c28;
    
    wire	[WL+2:0]	d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14;
    
    wire	[WL+3:0]	e1, e2, e3, e4, e5, e6, e7;
    
    wire	[WL+4:0]	f1, f2, f3, f4;
    
    wire	[WL+5:0]	g1, g2;
    
    output	[WL+6:0]	odata;
    
    // STAGE 1
    Adder_Clock Stage1_1(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a1),
    .idata2(a2),
    .odata(b1)
    );
    
    Adder_Clock Stage1_2(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a3),
    .idata2(a4),
    .odata(b2)
    );
    
    Adder_Clock Stage1_3(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a5),
    .idata2(a6),
    .odata(b3)
    );
    
    Adder_Clock Stage1_4(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a7),
    .idata2(a8),
    .odata(b4)
    );
    
    Adder_Clock Stage1_5(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a9),
    .idata2(a10),
    .odata(b5)
    );
    
    Adder_Clock Stage1_6(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a11),
    .idata2(a12),
    .odata(b6)
    );
    
    Adder_Clock Stage1_7(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a13),
    .idata2(a14),
    .odata(b7)
    );
    
    Adder_Clock Stage1_8(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a15),
    .idata2(a16),
    .odata(b8)
    );
    
    Adder_Clock Stage1_9(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a17),
    .idata2(a18),
    .odata(b9)
    );
    
    Adder_Clock Stage1_10(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a19),
    .idata2(a20),
    .odata(b10)
    );
    
    Adder_Clock Stage1_11(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a21),
    .idata2(a22),
    .odata(b11)
    );
    
    Adder_Clock Stage1_12(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a23),
    .idata2(a24),
    .odata(b12)
    );
    
    Adder_Clock Stage1_13(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a25),
    .idata2(a26),
    .odata(b13)
    );
    
    Adder_Clock Stage1_14(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a27),
    .idata2(a28),
    .odata(b14)
    );
    
    Adder_Clock Stage1_15(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a29),
    .idata2(a30),
    .odata(b15)
    );
    
    Adder_Clock Stage1_16(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a31),
    .idata2(a32),
    .odata(b16)
    );
    
    Adder_Clock Stage1_17(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a33),
    .idata2(a34),
    .odata(b17)
    );
    
    Adder_Clock Stage1_18(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a35),
    .idata2(a36),
    .odata(b18)
    );
    
    Adder_Clock Stage1_19(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a37),
    .idata2(a38),
    .odata(b19)
    );
    
    Adder_Clock Stage1_20(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a39),
    .idata2(a40),
    .odata(b20)
    );
    
    Adder_Clock Stage1_21(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a41),
    .idata2(a42),
    .odata(b21)
    );
    
    Adder_Clock Stage1_22(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a43),
    .idata2(a44),
    .odata(b22)
    );
    
    Adder_Clock Stage1_23(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a45),
    .idata2(a46),
    .odata(b23)
    );
    
    Adder_Clock Stage1_24(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a47),
    .idata2(a48),
    .odata(b24)
    );
    
    Adder_Clock Stage1_25(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a49),
    .idata2(a50),
    .odata(b25)
    );
    
    Adder_Clock Stage1_26(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a51),
    .idata2(a52),
    .odata(b26)
    );
    
    Adder_Clock Stage1_27(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a53),
    .idata2(a54),
    .odata(b27)
    );
    
    Adder_Clock Stage1_28(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a55),
    .idata2(a56),
    .odata(b28)
    );
    
    Adder_Clock Stage1_29(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a57),
    .idata2(a58),
    .odata(b29)
    );
    
    Adder_Clock Stage1_30(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a59),
    .idata2(a60),
    .odata(b30)
    );
    
    Adder_Clock Stage1_31(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a61),
    .idata2(a62),
    .odata(b31)
    );
    
    Adder_Clock Stage1_32(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a63),
    .idata2(a64),
    .odata(b32)
    );
    
    Adder_Clock Stage1_33(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a65),
    .idata2(a66),
    .odata(b33)
    );
    
    Adder_Clock Stage1_34(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a67),
    .idata2(a68),
    .odata(b34)
    );
    
    Adder_Clock Stage1_35(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a69),
    .idata2(a70),
    .odata(b35)
    );
    
    Adder_Clock Stage1_36(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a71),
    .idata2(a72),
    .odata(b36)
    );
    
    Adder_Clock Stage1_37(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a73),
    .idata2(a74),
    .odata(b37)
    );
    
    Adder_Clock Stage1_38(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a75),
    .idata2(a76),
    .odata(b38)
    );
    
    Adder_Clock Stage1_39(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a77),
    .idata2(a78),
    .odata(b39)
    );
    
    Adder_Clock Stage1_40(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a79),
    .idata2(a80),
    .odata(b40)
    );
    
    Adder_Clock Stage1_41(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a81),
    .idata2(a82),
    .odata(b41)
    );
    
    Adder_Clock Stage1_42(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a83),
    .idata2(a84),
    .odata(b42)
    );
    
    Adder_Clock Stage1_43(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a85),
    .idata2(a86),
    .odata(b43)
    );
    
    Adder_Clock Stage1_44(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a87),
    .idata2(a88),
    .odata(b44)
    );
    
    Adder_Clock Stage1_45(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a89),
    .idata2(a90),
    .odata(b45)
    );
    
    Adder_Clock Stage1_46(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a91),
    .idata2(a92),
    .odata(b46)
    );
    
    Adder_Clock Stage1_47(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a93),
    .idata2(a94),
    .odata(b47)
    );
    
    Adder_Clock Stage1_48(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a95),
    .idata2(a96),
    .odata(b48)
    );
    
    Adder_Clock Stage1_49(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a97),
    .idata2(a98),
    .odata(b49)
    );
    
    Adder_Clock Stage1_50(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a99),
    .idata2(a100),
    .odata(b50)
    );
    
    Adder_Clock Stage1_51(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a101),
    .idata2(a102),
    .odata(b51)
    );
    
    Adder_Clock Stage1_52(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a103),
    .idata2(a104),
    .odata(b52)
    );
    
    Adder_Clock Stage1_53(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a105),
    .idata2(a106),
    .odata(b53)
    );
    
    Adder_Clock Stage1_54(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a107),
    .idata2(a108),
    .odata(b54)
    );
    
    Adder_Clock Stage1_55(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a109),
    .idata2(a110),
    .odata(b55)
    );
    
    Adder_Clock Stage1_56(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(a111),
    .idata2(a112),
    .odata(b56)
    );
    
    // STAGE 2
    Adder_Clock Stage2_1(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b1),
    .idata2(b2),
    .odata(c1)
    );
    
    Adder_Clock Stage2_2(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b3),
    .idata2(b4),
    .odata(c2)
    );
    
    Adder_Clock Stage2_3(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b5),
    .idata2(b6),
    .odata(c3)
    );
    
    Adder_Clock Stage2_4(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b7),
    .idata2(b8),
    .odata(c4)
    );
    
    Adder_Clock Stage2_5(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b9),
    .idata2(b10),
    .odata(c5)
    );
    
    Adder_Clock Stage2_6(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b11),
    .idata2(b12),
    .odata(c6)
    );
    
    Adder_Clock Stage2_7(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b13),
    .idata2(b14),
    .odata(c7)
    );
    
    Adder_Clock Stage2_8(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b15),
    .idata2(b16),
    .odata(c8)
    );
    
    Adder_Clock Stage2_9(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b17),
    .idata2(b18),
    .odata(c9)
    );
    
    Adder_Clock Stage2_10(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b19),
    .idata2(b20),
    .odata(c10)
    );
    
    Adder_Clock Stage2_11(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b21),
    .idata2(b22),
    .odata(c11)
    );
    
    Adder_Clock Stage2_12(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b23),
    .idata2(b24),
    .odata(c12)
    );
    
    Adder_Clock Stage2_13(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b25),
    .idata2(b26),
    .odata(c13)
    );
    
    Adder_Clock Stage2_14(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b27),
    .idata2(b28),
    .odata(c14)
    );
    
    Adder_Clock Stage2_15(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b29),
    .idata2(b30),
    .odata(c15)
    );
    
    Adder_Clock Stage2_16(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b31),
    .idata2(b32),
    .odata(c16)
    );
    
    Adder_Clock Stage2_17(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b33),
    .idata2(b34),
    .odata(c17)
    );
    
    Adder_Clock Stage2_18(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b35),
    .idata2(b36),
    .odata(c18)
    );
    
    Adder_Clock Stage2_19(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b37),
    .idata2(b38),
    .odata(c19)
    );
    
    Adder_Clock Stage2_20(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b39),
    .idata2(b40),
    .odata(c20)
    );
    
    Adder_Clock Stage2_21(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b41),
    .idata2(b42),
    .odata(c21)
    );
    
    Adder_Clock Stage2_22(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b43),
    .idata2(b44),
    .odata(c22)
    );
    
    Adder_Clock Stage2_23(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b45),
    .idata2(b46),
    .odata(c23)
    );
    
    Adder_Clock Stage2_24(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b47),
    .idata2(b48),
    .odata(c24)
    );
    
    Adder_Clock Stage2_25(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b49),
    .idata2(b50),
    .odata(c25)
    );
    
    Adder_Clock Stage2_26(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b51),
    .idata2(b52),
    .odata(c26)
    );
    
    
    Adder_Clock Stage2_27(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b53),
    .idata2(b54),
    .odata(c27)
    );
    
    Adder_Clock Stage2_28(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(b55),
    .idata2(b56),
    .odata(c28)
    );
    
    //STAGE 3
    Adder_Clock Stage3_1(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(c1),
    .idata2(c2),
    .odata(d1)
    );
    
    Adder_Clock Stage3_2(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(c3),
    .idata2(c4),
    .odata(d2)
    );
    
    Adder_Clock Stage3_3(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(c5),
    .idata2(c6),
    .odata(d3)
    );
    
    Adder_Clock Stage3_4(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(c7),
    .idata2(c8),
    .odata(d4)
    );
    
    Adder_Clock Stage3_5(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(c9),
    .idata2(c10),
    .odata(d5)
    );
    
    Adder_Clock Stage3_6(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(c11),
    .idata2(c12),
    .odata(d6)
    );
    
    Adder_Clock Stage3_7(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(c13),
    .idata2(c14),
    .odata(d7)
    );
    
    Adder_Clock Stage3_8(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(c15),
    .idata2(c16),
    .odata(d8)
    );
    
    Adder_Clock Stage3_9(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(c17),
    .idata2(c18),
    .odata(d9)
    );
    
    Adder_Clock Stage3_10(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(c19),
    .idata2(c20),
    .odata(d10)
    );
    
    Adder_Clock Stage3_11(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(c21),
    .idata2(c22),
    .odata(d11)
    );
    
    Adder_Clock Stage3_12(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(c23),
    .idata2(c24),
    .odata(d12)
    );
    
    Adder_Clock Stage3_13(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(c25),
    .idata2(c26),
    .odata(d13)
    );
    
    Adder_Clock Stage3_14(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(c27),
    .idata2(c28),
    .odata(d14)
    );
    
    // STAGE 4
    Adder_Clock Stage4_1(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(d1),
    .idata2(d2),
    .odata(e1)
    );
    
    Adder_Clock Stage4_2(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(d3),
    .idata2(d4),
    .odata(e2)
    );
    
    Adder_Clock Stage4_3(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(d5),
    .idata2(d6),
    .odata(e3)
    );
    
    Adder_Clock Stage4_4(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(d7),
    .idata2(d8),
    .odata(e4)
    );
    
    Adder_Clock Stage4_5(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(d9),
    .idata2(d10),
    .odata(e5)
    );
    
    Adder_Clock Stage4_6(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(d11),
    .idata2(d12),
    .odata(e6)
    );
    
    Adder_Clock Stage4_7(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(d13),
    .idata2(d14),
    .odata(e7)
    );
    
    // STAGE 5
    Adder_Clock Stage5_1(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(e1),
    .idata2(e2),
    .odata(f1)
    );
    
    Adder_Clock Stage5_2(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(e3),
    .idata2(e4),
    .odata(f2)
    );
    
    Adder_Clock Stage5_3(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(e5),
    .idata2(e6),
    .odata(f3)
    );
    
    Adder_Clock Stage5_4(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(e7),
    .idata2(0),
    .odata(f4)
    );
    
    // STAGE 6
    Adder_Clock Stage6_1(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(f1),
    .idata2(f2),
    .odata(g1)
    );
    
    Adder_Clock Stage6_2(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(f3),
    .idata2(f4),
    .odata(g2)
    );
    
    // STAGE 7
    Adder_Clock Stage7_1(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(iEN),
    .idata1(g1),
    .idata2(g2),
    .odata(odata)
    );
    
endmodule
