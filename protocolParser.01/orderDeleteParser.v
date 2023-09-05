module orderDeleteParser (
    input clk, rst,
    input [63:0] dataIn,
    input [5:0] trackerIn,
    input startOrderDelete,
    output reg [31:0] timeStamp,
    output reg [63:0] orderID,
    output reg [31:0] orderBookID,
    output reg [7:0] side,
    output reg [5:0] trackerOut // take care of this later
);

reg counter, counterNext;
reg state, stateNext; 
reg [5:0] trackerNew, trackerNewNext;
reg [31:0] timeStampNext;
reg [63:0] orderIDNext;
reg [31:0] orderBookIDNext;
reg [7:0] sideNext;
reg timeStampValid, timeStampValidNext;
reg orderIDValid, orderIDValidNext;
reg orderBookIDValid, orderBookIDValidNext;
reg sideValid, sideValidNext;

always @(posedge clk) begin
    counter <= counterNext;
    state <= stateNext;
    timeStamp <= timeStampNext;
    orderID <= orderIDNext;
    orderBookID <= orderBookIDNext;
    side <= sideNext;
    trackerNew <= trackerNewNext;
    timeStampValid <= timeStampValidNext;
    orderBookIDValid <= orderBookIDValidNext;
    orderIDValid <= orderIDValidNext;
    sideValid <= sideValidNext;
end

always @* begin
    counterNext = counter;
    stateNext = state;
    timeStampNext = timeStamp;
    orderIDNext = orderID;
    orderBookIDNext = orderBookID;
    sideNext = side;
    trackerNewNext = trackerNew;
    timeStampValidNext = timeStampValid;
    orderBookIDValidNext = orderBookIDValid;
    orderIDValidNext = orderIDValid;
    sideValidNext = sideValid;
    if (rst) begin
        counterNext = 0;
        stateNext = 0;
        timeStampNext = 32'h0;
        orderIDNext = 64'h0;
        orderBookIDNext = 32'h0;
        sideNext = 8'h0;
        trackerNewNext = trackerIn;
        timeStampValidNext = 0;
        orderBookIDValidNext = 0;
        orderIDValidNext = 0;
        sideValidNext = 0;
    end 
    else begin
        
    end
end

endmodule
