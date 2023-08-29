module orderDeleteParser (
    input clk, rst,
    input [63:0] dataIn,
    input [1:0] counter,
    input startOrderDelete,
    output reg [31:0] timeStamp,
    output reg [63:0] orderID,
    output reg [31:0] orderBookID,
    output reg [7:0] side
);

reg state, stateNext;
reg [31:0] timeStampNext;
reg [63:0] orderIDNext;
reg [31:0] orderBookIDNext;
reg [7:0] sideNext;

always @(posedge clk) begin
    state <= stateNext;
    timeStamp <= timeStampNext;
    orderID <= orderIDNext;
    orderBookID <= orderBookIDNext;
    side <= sideNext;
end

always @* begin
    stateNext = state;
    timeStampNext = timeStamp;
    orderIDNext = orderID;
    orderBookIDNext = orderBookID;
    sideNext = side;

    if (rst) begin
        stateNext = 0;
        timeStampNext = 32'h0;
        orderIDNext = 64'h0;
        orderBookIDNext = 32'h0;
        sideNext = 8'h0;
    end else begin
        case (state)
            0: begin
                if (startOrderDelete && counter == 8) begin
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
                    end
                    default:
                endcase
                stateNext = state;
            end
        endcase
    end
end

endmodule
