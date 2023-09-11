module orderExecutedWithPriceParser ( // add control signals within and for the next module after. counter, trackerOut etc. 
    input clk, rst,
    input [63:0] dataIn,
    input startOrderExecutedWithPrice,
    input [5:0] trackerIn,
    output reg [5:0] trackerOut,
    output reg [31:0] timeStamp,
    output reg [63:0] orderID,
    output reg [31:0] orderBookID,
    output reg [7:0] side,
    output reg [63:0] executedQuantity,
    output reg [63:0] matchID,
    output reg [31:0] comboGroupID,
    output reg [31:0] reservedOne,
    output reg [31:0] reservedTwo,
    output reg [31:0] tradePrice,
    output reg [7:0] occuredAtCross,
    output reg [7:0] printable
);

reg counter, counterNext;
reg [5:0] tracker, trackerNext;

reg [31:0] timeStampNext;
reg [63:0] orderIDNext;
reg [31:0] orderBookIDNext;
reg [7:0] sideNext;
reg [63:0] executedQuantityNext;
reg [63:0] matchIDNext;
reg [31:0] comboGroupIDNext;
reg [31:0] reservedOneNext;
reg [31:0] reservedTwoNext;
reg [31:0] tradePriceNext;
reg [7:0] occuredAtCrossNext;
reg [7:0] printableNext;

reg timeStampValid, timeStampValidNext;
reg orderIDValid, orderIDValidNext;
reg orderBookIDValid, orderBookIDValidNext;
reg sideValid, sideValidNext;
reg executedQuantityValid, executedQuantityValidNext;
reg matchIDValid, matchIDValidNext;
reg comboGroupIDValid, comboGroupIDValidNext;
reg reservedOneValid, reservedOneValidNext;
reg reservedTwoValid, reservedTwoValidNext;
reg tradePriceValid, tradePriceValidNext;
reg occuredAtCrossValid, occuredAtCrossValidNext;
reg printableValid, printableValidNext;

always @(posedge clk) begin
    state <= stateNext;
    tracker <= trackerNext;
    counter <= counterNext;
    timeStamp <= timeStampNext;
    orderID <= orderIDNext;
    orderBookID <= orderBookIDNext;
    side <= sideNext;
    executedQuantity <= executedQuantityNext;
    matchID <= matchIDNext;
    comboGroupID <= comboGroupIDNext;
    reservedOne <= reservedOneNext;
    reservedTwo <= reservedTwoNext;
    tradePrice <= tradePriceNext;
    occuredAtCross <= occuredAtCrossNext;
    printable <= printableNext;

    timeStampValid <= timeStampValidNext;
    orderIDValid <= orderIDValidNext;
    orderBookIDValid <= orderBookIDValidNext;
    sideValid <= sideValidNext;
    executedQuantityValid <= executedQuantityValidNext;
    matchIDValid <= matchIDValidNext;
    comboGroupIDValid <= comboGroupIDValidNext;
    reservedOneValid <= reservedOneValidNext;
    reservedTwoValid <= reservedTwoValidNext;
    tradePriceValid <= tradePriceValidNext;
    occuredAtCrossValid <= occuredAtCrossValidNext;
    printableValid <= printableValidNext
end

always @* begin
    trackerNext = tracker;
    counterNext = counter;
    timeStampNext = timeStamp;
    orderIDNext = orderID;
    orderBookIDNext = orderBookID;
    sideNext = side;
    executedQuantityNext = executedQuantity;
    matchIDNext = matchID;
    comboGroupIDNext = comboGroupID;
    reservedOneNext = reservedOne;
    reservedTwoNext = reservedTwo;
    tradePriceNext = tradePrice;
    occuredAtCrossNext = occuredAtCross;
    printableNext = printable;
    trackerOutValidNext = trackerOutValid;
    timeStampValidNext = timeStampValid;
    orderIDValidNext = orderIDValid;
    orderBookIDValidNext = orderBookIDValid;
    sideValidNext = sideValid;
    executedQuantityValidNext = executedQuantityValid;
    matchIDValidNext = matchIDValid;
    comboGroupIDValidNext = comboGroupIDValid;
    reservedOneValidNext = reservedOneValid;
    reservedTwoValidNext = reservedTwoValid;
    tradePriceValidNext = tradePriceValid;
    occuredAtCrossValidNext = occuredAtCrossValid;
    printableValidNext = printableValid;

    if (rst) begin
        counterNext = 0;
        trackerNext = trackerIn;
        timeStampNext = 32'h0;
        orderIDNext = 64'h0;
        orderBookIDNext = 32'h0;
        sideNext = 8'h0;
        executedQuantityNext = 64'h0;
        matchIDNext = 64'h0;
        comboGroupIDNext = 32'h0;
        reservedOneNext = 32'h0;
        reservedTwoNext = 32'h0;
        tradePriceNext = 32'h0;
        occuredAtCrossNext = 8'h0;
        printableNext = 8'h0;

        timeStampValidNext = 0;
        orderIDValidNext = 0;
        orderBookIDValidNext = 0;
        sideValidNext = 0;
        executedQuantityValidNext = 0;
        matchIDValidNext = 0;
        comboGroupIDValidNext = 0;
        reservedOneValidNext = 0;
        reservedTwoValidNext = 0;
        tradePriceValidNext = 0;
        occuredAtCrossValidNext = 0;
        printableValidNext = 0;
    end else begin
        case (counter)
            0: begin
                if(startOrderExecutedWithPrice) begin
                    if(64 - trackerIn >= 32) begin
                        timeStampNext = dataIn >> trackerIn;
                        timeStampValidNext = 1; //A valid
                        orderIDNext = dataIn >> (trackerIn + 32);
                        trackerNext = trackerIn + 32 + 64;
                    end
                    else begin
                        timeStampNext = dataIn >> trackerIn;
                        trackerNext = trackerIn + 32;
                    end
                    counterNext = counter + 1;
                end
            end
            1: begin
                if (timeStampValid) begin
                    orderIDNext = orderID + (dataIn << (64-1-tracker));
                    orderIDValidNext = 1; //B valid
                    if(64 - tracker >= 32) begin
                        orderBookIDNext = dataIn >> tracker;
                        orderBookIDValidNext = 1; //C valid
                        trackerNext = tracker + 32;
                    end
                    else begin
                        orderBookIDNext = dataIn >> tracker;
                        trackerNext = tracker + 32;
                    end
                end
                else begin
                    timeStampNext = timeStamp + (dataIn << (32-1-tracker));
                    timeStampValidNext = 1; //A valid
                    orderIDNext = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
            end
            2: begin
                if(orderIDValid) begin
                    if(orderBookIDValid) begin
                        sideNext = dataIn >> tracker;
                        sideValidNext = 1; //D valid
                        executedQuantityNext = dataIn >> (tracker + 8);
                        trackerNext = tracker + 8 + 64;
                    end
                    else begin
                        orderBookIDNext = (dataIn << (32-1-tracker));
                        orderBookIDValidNext = 1; //C valid
                        sideNext = dataIn >> tracker;
                        sideValidNext = 1; // D valid
                        executedQuantityNext = dataIn >> (tracker + 8);
                        trackerNext = tracker + 8 + 64;
                    end
                end
                else begin
                    orderIDNext = orderID + (dataIn << (64-1-tracker));
                    orderIDValidNext = 1; //B valid
                    orderBookIDNext = dataIn >> tracker;
                    orderBookIDValidNext = 1; //C valid
                    if(64 - tracker - 32 >= 8) begin
                        sideNext = dataIn >> (tracker + 32);
                        sideValidNext = 1; //D valid
                        executedQuantityNext = dataIn >> (tracker + 8 + 32);
                        trackerNext = tracker + 32 + 8 + 64;
                    end
                    else begin
                        sideNext = dataIn >> (tracker + 32);
                        trackerNext = tracker + 32 + 8;
                    end
                end
                counterNext = counter + 1;
            end
            3: begin
                if(sideValid) begin
                    executedQuantityNext = executedQuantity + (dataIn << (64-1-tracker));
                    executedQuantityValidNext = 1; //E valid
                    matchIDNext = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                else begin
                    sideNext = side + (dataIn << (8-1-tracker));
                    sideValidNext = 1; // D valid
                    executedQuantityNext = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end 
            4: begin
                if (executedQuantityValid) begin
                    matchIDNext = matchID + (dataIn << (64-1-tracker));
                    matchIDValidNext = 1; //F valid
                    {reservedOneNext, comboGroupIDNext} = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                else begin
                    executedQuantityNext = executedQuantity + (dataIn << (64-1-tracker));
                    executedQuantityValidNext = 1; //E valid
                    matchIDNext = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            5: begin
                if(matchIDValid) begin
                    {reservedOneNext, comboGroupIDNext} = {reservedOne, comboGroupID} + (dataIn << (64-1-tracker));
                    reservedOneValidNext = 1; //H valid
                    comboGroupIDValidNext = 1; //G valid
                    {tradePriceNext, reservedTwoNext} = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                else begin
                    matchIDNext = matchID + (dataIn << (64-1-tracker));
                    matchIDValidNext = 1; //F valid
                    {reservedOneNext, comboGroupIDNext} = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            6: begin
                if(reservedOneValid) begin
                    {tradePriceNext, reservedTwoNext} = {tradePrice, reservedTwo} + (dataIn << (64-1-tracker));
                    reservedTwoValidNext = 1; //I valid
                    tradePriceValidNext = 1; //J valid
                    if(64 - t >= 16) begin
                        {printableNext, occuredAtCrossNext} = dataIn >> tracker;
                        occuredAtCrossValidNext = 1; // K valid
                        printableValidNext = 1; //L valid
                        trackerNext = tracker + 16; //END.
                    end
                    else begin
                        {printableNext, occuredAtCrossNext} = dataIn >> tracker;
                        trackerNext = tracker + 16;
                    end
                end
                else begin
                    {reservedOneNext, comboGroupIDNext} = {reservedOne, comboGroupID} + (dataIn << (64-1-tracker));
                    reservedOneValidNext = 1; //H valid
                    comboGroupIDValidNext = 1; //G valid
                    {tradePriceNext, reservedTwoNext} = dataIn >> tracker;
                    trackerNext = tracker + 64;
                end
                counterNext = counter + 1;
            end
            7: begin
                if(tradePriceValid) begin
                    {printableNext, occuredAtCrossNext} = {printable, occuredAtCross} + (dataIn << (16-1-tracker));
                    occuredAtCrossValidNext = 1; // K valid
                    printableValidNext = 1; //L valid
                    trackerNext = tracker + 16; //END.
                end
                else begin
                    {tradePriceNext, reservedTwoNext} = {tradePrice, reservedTwo} + (dataIn << (64-1-tracker));
                    reservedTwoValidNext = 1; //I valid
                    tradePriceValidNext = 1; //J valid
                    {printableNext, occuredAtCrossNext} = dataIn >> tracker;
                    occuredAtCrossValidNext = 1; // K valid
                    printableValidNext = 1; //L valid
                    trackerNext = tracker + 16; //END.
                end
                counterNext = counter + 1;
            end
        endcase
    end
end

endmodule