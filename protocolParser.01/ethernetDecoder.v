`timescale 1ns / 1ps
module ethernetDecoder (
    input clk, rst,
    input counter,
    input [63:0] dataIn,
    output reg ethValid,
    output reg [47:0] dMac,
    output reg [47:0] sMac,
    output reg [15:0] oTag,
    output reg [15:0] eType
);

reg [47:0] dMacNext;
reg [47:0] sMacNext;
reg [15:0] oTagNext;
reg [15:0] eTypeNext;

always @(posedge clk) begin
    dMac <= dMacNext;
    sMac <= sMacNext;
    oTag <= oTagNext;
    eType <= eTypeNext;
end

always @* begin
    dMacNext = dMac;
    sMacNext = sMac;
    oTagNext = oTag;
    eTypeNext = eType;
    if (rst) begin
        dMacNext = 0;
        sMacNext = 0;
        oTagNext = 0;
        eTypeNext = 0;
        ethValid = 0;
    end else begin
        case (counter)
            0: begin
                dMacNext = dataIn[47:0];
                sMacNext[15:0] = dataIn[63:48];
            end
            1: begin
                sMacNext[47:16] = dataIn[15:0];
                oTagNext = dataIn[31:15];
                eTypeNext = dataIn[63:32];
                if(dataIn[63:32] == 2048) ethValid = 1;
            end
            default: 
        endcase
    end
end
    
endmodule