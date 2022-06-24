//********************************************************************************************************
//
//  Title             : D_Reg
//  File Name         : D_Reg.v
//  Author            : kijung Yang	(Email: ykj1985@kau.ac.kr)
//  Related document  : TM-2008-XX-XX.hwp/doc/ppt/vsd
//  Organization      : SoC Design Lab.
//                      School of Electrics, Telecommunications and Computer Engineering (ETCE)
//                      Korea Aerospace University (KAU)
//
//  Simulator         : ModelSim SE 6.1b
//  Synthesizer       : Synopsys 2004 SP2
//
//  Created date      : 2009-01-08
//  Last updated date : 2009-02-23
//  Update notice     : {date} - {comments}
//
//  Version           : Ver0.0
//
//********************************************************************************************************/

`timescale 1 ns / 100 ps

module D_REG(iRSTn,
             iCLK,
             iEN,
             iCLR,
             iDATA,
             oDATA);
    
    parameter WL = 8;
    
    input	iRSTn;
    input	iCLK;
    input	iEN;
    input	iCLR;
    input	[WL-1:0] iDATA;
    output	[WL-1:0] oDATA;
    reg 	[WL-1:0] oDATA;
    
    always @(posedge iCLK or negedge iRSTn)
    begin
        if (~iRSTn)
        begin
            oDATA <= # 1	0;
        end
        else if (iCLR)
        begin
            oDATA <= # 1 0;
        end
        else if (iEN)
        begin
            oDATA	 <= # 1	 iDATA;
        end
        else
        begin
            oDATA	 <= # 1	 oDATA;
        end
    end
    
endmodule
