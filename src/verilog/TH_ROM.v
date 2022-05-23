`timescale 1 ns / 100 ps

module TH_ROM(TH_addr,
              oTH);
    
    parameter WN = 10;
    parameter WL = 10;
    
    input [WN-1:0] TH_addr;
    output [WL-1:0] oTH;
    
    reg [WL-1:0] oTH
    
    always@(TH_addr)
    begin
        case(TH_addr)
            'd00:
            begin
                oTH <= #1 10'b000000000;
            end
            default:
            begin
                oTH <= #1 10'b000000000;
            end
        endcase
    end
    
endmodule
