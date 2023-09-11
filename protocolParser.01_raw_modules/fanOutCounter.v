module fanOutCounter (
    clk,
    rst,
    counterOut
);

input clk;
input rst;
output reg [6:0] counterOut;

always @(posedge clk) begin
    if (rst) begin
        counterOut <= 0;
    end else begin
        counterOut <= counterOut + 1;
    end
end
endmodule