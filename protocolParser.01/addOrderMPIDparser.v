module addOrderWithMPIDparser (
    input clk, rst,
    input [63:0] dataIn,
    input startAddOrderWithMPID,
    input [5:0] trackerIn,
    output reg [5:0] trackerOut,
    output reg [31:0] timeStamp,
    output reg [63:0] orderID,
    output reg [31:0] orderBookID,
    output reg [7:0] side,
    output reg [31:0] orderBookPosition,
    output reg [63:0] quantity,
    output reg [31:0] price,
    output reg [15:0] orderAttributes,
    output reg [7:0] lotType,
    output reg [55:0] participantID
);

reg counter, counterNext;
reg [5:0] tracker, trackerNext;

reg [31:0] timeStampNext;
reg [63:0] orderIDNext;
reg [31:0] orderBookIDNext;
reg [7:0] sideNext;
reg [31:0] orderBookPositionNext;
reg [63:0] quantityNext;
reg [31:0] priceNext;
reg [15:0] orderAttributesNext;
reg [7:0] lotTypeNext;
reg [55:0] participantIDNext;

reg timeStampValid, timeStampValidNext;
reg orderIDValid, orderIDValidNext;
reg orderBookIDValid, orderBookIDValidNext;
reg sideValid, sideValidNext;
reg orderBookPositionValid, orderBookPositionValidNext;
reg quantityValid, quantityValidNext;
reg priceValid, priceValidNext;
reg orderAttributesValid, orderAttributesValidNext;
reg lotTypeValid, lotTypeValidNext;
reg participantIDValid, participantIDValidNext;

always @(posedge clk) begin
    tracker <= trackerNext;
    counter <= counterNext;
    timeStamp <= timeStampNext;
    orderID <= orderIDNext;
    orderBookID <= orderBookIDNext;
    side <= sideNext;
    orderBookPosition <= orderBookPositionNext;
    quantity <= quantityNext;
    price <= priceNext;
    orderAttributes <= orderAttributesNext;
    lotType <= lotTypeNext;
    participantID <= participantIDNext;
    
    timeStampValid <= timeStampValidNext;
    orderIDValid <= orderIDValidNext;
    orderBookIDValid <= orderBookIDValidNext;
    sideValid <= sideValidNext;
    orderBookPositionValid <= orderBookPositionValidNext;
    quantityValid <= quantityValidNext;
    priceValid <= priceValidNext;
    orderAttributesValid <= orderAttributesValidNext;
    lotTypeValid <= lotTypeValidNext;
    participantIDValid <= participantIDValidNext;
end

always @* begin
    trackerNext = tracker;
    counterNext = counter;
    timeStampNext = timeStamp;
    orderIDNext = orderID;
    orderBookIDNext = orderBookID;
    sideNext = side;
    orderBookPositionNext = orderBookPosition;
    quantityNext = quantity;
    priceNext = price;
    orderAttributesNext = orderAttributes;
    lotTypeNext = lotType;
    participantIDNext = participantID;

    timeStampValidNext = timeStampValid;
    orderIDValidNext = orderIDValid;
    orderBookIDValidNext = orderBookIDValid;
    sideValidNext = sideValid;
    orderBookPositionValidNext = orderBookPositionValid;
    quantityValidNext = quantityValid;
    priceValidNext = priceValid;
    orderAttributesValidNext = orderAttributesValid;
    lotTypeValidNext = lotTypeValid;
    participantIDValidNext = participantIDValid;

    if (rst) begin
        counterNext = 0;
        trackerNext = trackerIn;
        timeStampNext = 32'h0;
        orderIDNext = 64'h0;
        orderBookIDNext = 32'h0;
        sideNext = 0;
        orderBookPositionNext = 32'h0;
        quantityNext = 64'h0;
        priceNext = 32'h0;
        orderAttributesNext = 16'h0;
        lotTypeNext = 0;
        participantIDNext = 0;

        timeStampValidNext = 0;
        orderIDValidNext = 0;
        orderBookIDValidNext = 0;
        sideValidNext = 0;
        orderBookPositionValidNext = 0;
        quantityValidNext = 0;
        priceValidNext = 0;
        orderAttributesValidNext = 0;
        lotTypeValidNext = 0;
        participantIDValidNext = 0;

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
                        orderBookPositionNext = dataIn >> (tracker + 8);
                        orderBookPositionValidNext = 1; //E valid
                        quantityNext = dataIn >> (tracker + 8 + 32);
                        trackerNext = tracker + 8 + 32 + 64;
                    end
                    else begin
                        orderBookIDNext = (dataIn << (32-1-tracker));
                        orderBookIDValidNext = 1; //C valid
                        sideNext = dataIn >> tracker;
                        sideValidNext = 1; // D valid
                        if(64 - tracker - 8 >= 32) begin
                            orderBookPositionNext = dataIn >> (tracker + 8);
                            orderBookPositionValidNext = 1; //E valid
                            quantityNext = dataIn >> (tracker + 8 + 32);
                            trackerNext = tracker + 8 + 32 + 64;
                        end
                        else begin
                            orderBookPositionNext = dataIn >> (tracker + 8);
                            trackerNext = tracker + 8 + 32;
                        end
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
                        orderBookPositionNext = dataIn >> (tracker + 32 + 8);
                        trackerNext = tracker + 32 + 8 + 32;
                    end
                    else begin
                        sideNext = dataIn >> (tracker + 32);
                        trackerNext = tracker + 32 + 8;
                    end
                end
                counterNext = counter + 1;
            end
            3: begin
                if(orderBookPositionValid) begin
                    quantityNext = quantity + (dataIn << (64-1-tracker));
                    quantityValidNext = 1; //F valid
                    priceNext = dataIn >> tracker;
                    trackerNext = tracker + 32;
                end
                else begin
                    if (sideValid) begin
                        orderBookPositionNext = orderBookPosition + (dataIn << (32-1-tracker));
                        orderBookPositionValidNext = 1; //E valid
                        quantityNext = dataIn >> tracker;
                        trackerNext = tracker + 64;
                    end
                    else begin
                        sideNext = side + (dataIn << (8-1-tracker));
                        orderBookPositionNext = dataIn >> tracker;
                        orderBookPositionValidNext = 1; //E valid
                        quantityNext = dataIn >> (tracker + 32);
                        trackerNext = tracker + 32 + 64;
                    end
                end
                counterNext = counter + 1;
            end
            4: begin
                if(quantityValid) begin
                    priceNext = price + (dataIn << (32-1-tracker));
                    {participantIDNext, lotTypeNext, orderAttributesValidNext} = dataIn >> tracker;
                    orderAttributesValidNext = 1; //H valid
                    lotTypeValidNext = 1; //I valid
                    trackerNext = tracker + 16 + 8 + 56;
                end
                else begin
                    quantityNext = quantity + (dataIn << (64-1-tracker));
                    if(64 - tracker > 56) begin
                        {lotTypeNext, orderAttributesNext, priceNext} = dataIn >> tracker;
                        priceValidNext = 1; //G valid
                        orderAttributesValidNext = 1; //H valid
                        lotTypeValidNext = 1; //I valid
                        participantIDNext = dataIn >> (tracker + 32 + 16 + 8);
                        trackerNext = tracker + 32 + 16 + 8 + 56;
                    end
                    else begin
                        {lotTypeNext, orderAttributesNext, priceNext} = dataIn >> tracker;
                        trackerNext = tracker + 32 + 16 + 8;
                    end
                end
                counterNext = counter + 1;
            end 
            5: begin
                if(lotTypeValid) begin
                    participantIDNext = participantID + (dataIn << (56-1-tracker));
                    participantIDValidNext = 1;
                    trackerNext = tracker; //END.
                end
                else begin
                    {lotTypeNext, orderAttributesNext, priceNext} = {lotType, orderAttributes, price} + (dataIn << (56-1-tracker));
                    priceValidNext = 1; //G valid
                    orderAttributesValidNext = 1; //H valid
                    lotTypeValidNext = 1; //I valid
                    if(64 - tracker >= 56) begin
                        participantIDNext = dataIn >> tracker;
                        participantIDValidNext = 1;
                        trackerNext = tracker + 56; //END.
                    end
                    else begin
                        participantIDNext = dataIn >> tracker;
                        trackerNext = tracker + 56;
                    end
                end
                counterNext = counter + 1;
            end
            6: begin
                participantIDNext = participantID + (dataIn << (56-1-tracker));
                participantIDValidNext = 1;
                trackerNext = tracker; //END. 
                counterNext = 0;
            end
        endcase
    end
end
    
endmodule