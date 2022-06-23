//********************************************************************************************************
//
//   Title             : Shift_Register
//   File Name         : shift_reg.v
//   Author            : Yousun Hwang	(Email: hys1022@kau.ac.kr)
//   Related document  : TM-2008-XX-XX.hwp/doc/ppt/vsd
//   Organization      : SoC Design Lab.
//                      School of Electrics, Telecommunications and Computer Engineering (ETCE)
//                      Korea Aerospace University (KAU)
//
//   Simulator         : ModelSim SE 6.1f
//   Synthesizer       : Synopsys
//   related document  : Shift_reg.vsd
//   function		   : This  Shift_Register Block prints output data after TL clock
//
//   Created date      : 2009-02-17
//   Last updated date : 2009-02-17
//   Update notice     : {date} - {comments}
//
//   Version           : Ver0.0
//   SHIFT_REG #(.WL(),.TL())
//   shift_reg (.iCLK(), .iRSTn(), .iCLR(), .iEN(), .iDATA(), .oDATA());
//
//********************************************************************************************************/

`timescale 1 ns / 100 ps

module SHIFT_REG(iRSTn,
                 iCLK,
                 iEN,
                 iCLR,
                 iDATA,
                 oDATA);
    
    parameter WL = 8;
    parameter TL = 3;
    
    input 				iRSTn;
    input 				iCLK;
    input 				iEN;
    input 				iCLR ;
    input	[WL-1:0] 	iDATA;
    output  [WL-1:0] 	oDATA;
    
    reg  	[WL*TL-1:0] DATA_tmp ;
    
    always@(negedge iRSTn or posedge iCLK)
    begin
        if (~iRSTn)
            DATA_tmp <= #1 0 ;
        else if (iCLR)
            DATA_tmp <= #1 0 ;
        else if (iEN)
            DATA_tmp <= #1 {DATA_tmp [WL*(TL-1)-1:0],iDATA};	// Input data input to Shift register & shift operation
    end
        
    assign oDATA = DATA_tmp[WL*TL-1:WL*(TL-1)];			// print output data
        
endmodule
        
