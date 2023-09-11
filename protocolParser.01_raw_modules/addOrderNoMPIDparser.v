module AddOrderNoMPIDParser (
    input clk, rst,
    input [63:0] dataIn,
    input [1:0] counter,
    input startAddOrderNoMPID,
    output reg [31:0] timeStamp,
    output reg [63:0] orderID,
    output reg [31:0] orderBookID,
    output reg [7:0] side,
    output reg [31:0] orderBookPosition,
    output reg [63:0] quantity,
    output reg [31:0] price,
    output reg [15:0] orderAttributes,
    output reg [7:0] lotType
);

reg state, stateNext;
reg [31:0] timeStampNext;
reg [63:0] orderIDNext;
reg [31:0] orderBookIDNext;
reg [7:0] sideNext;
reg [31:0] orderBookPositionNext;
reg [63:0] quantityNext;
reg [31:0] priceNext;
reg [15:0] orderAttributesNext;
reg [7:0] lotTypeNext;

always @(posedge clk) begin
    state <= stateNext;
    timeStamp <= timeStampNext;
    orderID <= orderIDNext;
    orderBookID <= orderBookIDNext;
    side <= sideNext;
    orderBookPosition <= orderBookPositionNext;
    quantity <= quantityNext;
    price <= priceNext;
    orderAttributes <= orderAttributesNext;
    lotType <= lotTypeNext;
end

always @* begin
    stateNext = state;
    timeStampNext = timeStamp;
    orderIDNext = orderID;
    orderBookIDNext = orderBookID;
    sideNext = side;
    orderBookPositionNext = orderBookPosition;
    quantityNext = quantity;
    priceNext = price;
    orderAttributesNext = orderAttributes;
    lotTypeNext = lotType;

    if (rst) begin
        stateNext = 0;
        timeStampNext = 32'h0;
        orderIDNext = 64'h0;
        orderBookIDNext = 32'h0;
        sideNext = 0;
        orderBookPositionNext = 32'h0;
        quantityNext = 64'h0;
        priceNext = 32'h0;
        orderAttributesNext = 16'h0;
        lotTypeNext = 0;
    end else begin
        case (state)
            0: begin
                if (startAddOrderNoMPID && counter == 8) begin
                    timeStampNext = dataIn[55:24];
                    orderIDNext[7:0] = dataIn[63:56];
                    stateNext = 1;
                end
            end
            1: begin
                case (counter)
                    9: begin
                        orderIDNext[63:8] = dataIn[55:0];
                        orderBookIDNext[7:0] = dataIn[63:56];
                    end
                    10: begin
                        orderBookIDNext[31:8] = dataIn[23:0];
                        sideNext = dataIn[31:24];
                        orderBookPositionNext = dataIn[63:32];
                    end
                    11: begin
                        quantityNext = dataIn;
                    end
                    12: begin
                        orderAttributesNext = dataIn[15:0];
                        lotTypeNext = dataIn[23:16];
                    end
                    default:
                endcase
                stateNext = state;
            end
        endcase
    end
end

endmodule
