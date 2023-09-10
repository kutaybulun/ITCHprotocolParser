`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:10:13 09/07/2023 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(
    input clk,
    input rst,
    input [63:0] rx_data_net,
    output [6:0] counterOut,
	 
	output [47:0] dMac_out,
    output [47:0] sMac_out,
    output [15:0] oTag_out,
    output [15:0] eType_out,
    output [3:0] version_out,
    output [3:0] headerLength_out,
    output [7:0] typeOfService_out,
    output [15:0] totalLength_out,
    output [15:0] identification_out,
    output [2:0] flags_out,
    output [12:0] fragmentOffset_out,
    output [7:0] timeToLive_out,
    output [7:0] protocol_out,
    output [15:0] headerChecksum_out,
    output [31:0] srcIPAddress_out,
    output [31:0] destIPAddress_out,
    output [15:0] srcPort_out,
    output [15:0] destPort_out,
    output [15:0] length_out,
    output [15:0] checksum_out,
    output [79:0] sessionID_out,
    output [63:0] sequenceNumber_out,
    output [15:0] messageCount_out
);

reg [6:0] counter;
wire [47:0] dMac, sMac;
wire [15:0] oTag, eType;
wire [3:0] version, headerLength;
wire [7:0] typeOfService;
wire [15:0] totalLength, identification;
wire [2:0] flags;
wire [12:0] fragmentOffset;
wire [7:0] timeToLive, protocol;
wire [15:0] headerChecksum;
wire [31:0] srcIPAddress, destIPAddress;
wire [15:0] srcPort, destPort, length, checksum;
wire [79:0] sessionID;
wire [63:0] sequenceNumber;
wire [15:0] messageCount;

ethernetDecoder u_ethernetDecoder (
    .clk(clk),
    .rst(rst),
    .counter(counter),
    .dataIn(rx_data_net), // Connect dataIn to rx_data_net of packetRx
    .dMac(dMac),
    .sMac(sMac),
    .oTag(oTag),
    .eType(eType)
);

ipDecoder u_ipDecoder (
    .clk(clk),
    .rst(rst),
    .counter(counter),
    .dataIn(rx_data_net), // Connect dataIn to rx_data_net of packetRx
    .version(version),
    .headerLength(headerLength),
    .typeOfService(typeOfService),
    .totalLength(totalLength),
    .identification(identification),
    .flags(flags),
    .fragmentOffset(fragmentOffset),
    .timeToLive(timeToLive),
    .protocol(protocol),
    .headerChecksum(headerChecksum),
    .srcIPAddress(srcIPAddress),
    .destIPAddress(destIPAddress)
);

udpDecoder u_udpDecoder (
    .clk(clk),
    .rst(rst),
    .dataIn(rx_data_net), // Connect dataIn to rx_data_net of packetRx
    .counter(counter),
    .srcPort(srcPort),
    .destPort(destPort),
    .length(length),
    .checksum(checksum)
);

moldUDP64Decoder u_moldUDP64Decoder (
    .clk(clk),
    .rst(rst),
    .dataIn(rx_data_net), // Connect dataIn to rx_data_net of packetRx
    .counter(counter),
    .sessionID(sessionID),
    .sequenceNumber(sequenceNumber),
    .messageCount(messageCount)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 7'b0;
    end else begin
        counter <= counter + 1;
    end
end

assign counterOut = counter;

assign dMac_out = dMac;
assign sMac_out = sMac;
assign oTag_out = oTag;
assign eType_out = eType;
assign version_out = version;
assign headerLength_out = headerLength;
assign typeOfService_out = typeOfService;
assign totalLength_out = totalLength;
assign identification_out = identification;
assign flags_out = flags;
assign fragmentOffset_out = fragmentOffset;
assign timeToLive_out = timeToLive;
assign protocol_out = protocol;
assign headerChecksum_out = headerChecksum;
assign srcIPAddress_out = srcIPAddress;
assign destIPAddress_out = destIPAddress;
assign srcPort_out = srcPort;
assign destPort_out = destPort;
assign length_out = length;
assign checksum_out = checksum;
assign sessionID_out = sessionID;
assign sequenceNumber_out = sequenceNumber;
assign messageCount_out = messageCount;

endmodule
