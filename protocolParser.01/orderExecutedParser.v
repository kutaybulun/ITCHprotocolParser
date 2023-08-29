module orderExecutedParser (
    input clk, rst,
    input [63:0] dataIn,
    input [1:0] counter,
    input startOrderExecuted,
    output reg [31:0] timeStamp,
    output reg [63:0] orderID,
    output reg [31:0] orderBookID,
    output reg [7:0] side,
    output reg [63:0] executedQuantity,
    output reg [63:0] matchID,
    output reg [31:0] comboGroupID,
    output reg [31:0] reservedOne,
    output reg [31:0] reservedTwo
);

reg state, stateNext;
reg [31:0] timeStampNext;
reg [63:0] orderIDNext;
reg [31:0] orderBookIDNext;
reg [7:0] sideNext;
reg [63:0] executedQuantityNext;
reg [63:0] matchIDNext;
reg [31:0] comboGroupIDNext;
reg [31:0] reservedOneNext;
reg [31:0] reservedTwoNext;

always @(posedge clk) begin
    state <= stateNext;
    timeStamp <= timeStampNext;
    orderID <= orderIDNext;
    orderBookID <= orderBookIDNext;
    side <= sideNext;
    executedQuantity <= executedQuantityNext;
    matchID <= matchIDNext;
    comboGroupID <= comboGroupIDNext;
    reservedOne <= reservedOneNext;
    reservedTwo <= reservedTwoNext;
end

always @* begin
    stateNext = state;
    timeStampNext = timeStamp;
    orderIDNext = orderID;
    orderBookIDNext = orderBookID;
    sideNext = side;
    executedQuantityNext = executedQuantity;
    matchIDNext = matchID;
    comboGroupIDNext = comboGroupID;
    reservedOneNext = reservedOne;
    reservedTwoNext = reservedTwo;

    if (rst) begin
        stateNext = 0;
        timeStampNext = 32'h0;
        orderIDNext = 64'h0;
        orderBookIDNext = 32'h0;
        sideNext = 8'h0;
        executedQuantityNext = 64'h0;
        matchIDNext = 64'h0;
        comboGroupIDNext = 32'h0;
        reservedOneNext = 32'h0;
        reservedTwoNext = 32'h0;
    end else begin
        case (state)
            0: begin
                if (startOrderExecuted && counter == 8) begin
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
                        executedQuantityNext[31:0] = dataIn[63:32];
                    end
                    11: begin
                        executedQuantityNext[63:32] = dataIn[31:0];
                        matchIDNext[31:0] = dataIn[62:32];
                    end
                    12: begin
                        matchIDNext[63:32] = dataIn[31:0];
                        comboGroupIDNext = dataIn[63:32];
                    end
                    13: begin
                        reservedOneNext = dataIn[55:0];
                        reservedTwoNext[7:0] = dataIn[63:56];
                    end
                    14: begin
                        reservedTwoNext[63:8] = dataIn[55:0];
                    end
                    default:
                endcase
                stateNext = state;
            end
        endcase
    end
end

endmodule

