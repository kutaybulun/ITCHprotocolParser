module itchMessageTypeDecoder (
    input clk, rst,
    input [63:0] dataIn,
    input [1:0] counter,
    output reg startAddOrderNoMPID,
    output reg startAddOrderWithMPID,
    output reg startOrderExecuted,
    output reg startOrderExecutedWithPrice,
    output reg startOrderDelete,
    output reg [15:0] messageLength;
);
reg [15:0] messageLenghtNext;
reg [7:0] messageType, messageTypeNext;
reg startAddOrderNoMPIDNext;
reg startAddOrderWithMPIDNext;
reg startOrderExecutedNext;
reg startOrderExecutedWithPriceNext;
reg startOrderDeleteNext;

always @(posedge clk) begin
    startAddOrderNoMPID <= startAddOrderNoMPIDNext;
    startAddOrderWithMPID <= startAddOrderWithMPIDNext;
    startOrderExecuted <= startOrderExecutedNext;
    startOrderExecutedWithPrice <= startOrderExecutedWithPriceNext;
    startOrderDelete <= startOrderDeleteNext;
    messageType <= messageTypeNext;
    messageLength <= messageCountNext;
end

always @* begin
    startAddOrderNoMPIDNext = 0;
    startAddOrderWithMPIDNext = 0;
    startOrderExecutedNext = 0;
    startOrderExecutedWithPriceNext = 0;
    startOrderDeleteNext = 0;
    messageTypeNext = 8'h0;
    messageLenghtNext = messageLength;
    if (rst) begin
        messageTypeNext = 8'h0;
    end else begin
        if (counter == 8) begin
            // Extract the first 16 bits as message length
            reg [15:0] messageLength = dataIn[15:0];

            // Extract the message type (1 byte) following message length
            messageTypeNext = dataIn[23:16];

            // Determine the appropriate submodule to start based on the message type
            case (messageTypeNext)
                8'h10: startAddOrderNoMPIDNext = 1; // A: addOrderNoMPID
                8'h15: startAddOrderWithMPIDNext = 1; // F: addOrderWithMPID
                8'h14: startOrderExecutedNext = 1; // E: orderExecuted
                8'h12: startOrderExecutedWithPriceNext = 1; // C: orderExecutedWithPrice
                8'h13: startOrderDeleteNext = 1; // D: orderDelete
                default: 
            endcase
        end
    end
end
    
endmodule