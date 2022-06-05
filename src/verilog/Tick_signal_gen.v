//********************************************************************************************************
//
//  Title             : tick signal generator
//  File Name         : Tick_signal_gen.v
//  Author            : Soohyun Jang	(Email: shjang@kau.ac.kr)
//  Related document  : TM-2008-XX-XX.hwp/doc/ppt/vsd
//  Organization      : SoC Design Lab.
//                      School of Electrics, Telecommunications and Computer Engineering (ETCE)
//                      Korea Aerospace University (KAU)
//
//  Simulator         : ModelSim SE 6.1b
//  Synthesizer       : Synopsys 2004 SP2
//
//  Created date      : 2009-02-21
//  Last updated date : 2009-xx-xx
//  Update notice     : {date} - {comments}
//
//  Version           : Ver0.0
//
//********************************************************************************************************/

`timescale 1 ns / 100 ps

module Tick_signal_gen(iRSTn,
                       iCLK,
                       iEN,
                       Pulse);

    input			iRSTn,iCLK,iEN;
    output			Pulse;
    
    wire			a1out,a2out,a3out,oout,A;
    
    and a1(
    a1out,
    iEN,
    A
    );
    
    and a2(
    a2out,
    iEN,
    Pulse
    );
    
    and	a3(
    a3out,
    ~A,
    iEN,
    ~Pulse
    );
    
    or or1(
    oout,
    a1out,
    a2out
    );
    
    D_REG#(
    .WL(1)
    )Dreg1(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(1'b1),
    .iCLR(1'b0),
    .iDATA(oout),
    .oDATA(A)
    );
    
    D_REG#(
    .WL(1)
    )Dreg2(
    .iRSTn(iRSTn),
    .iCLK(iCLK),
    .iEN(1'b1),
    .iCLR(1'b0),
    .iDATA(a3out),
    .oDATA(Pulse)
    );
    
endmodule
    
    
