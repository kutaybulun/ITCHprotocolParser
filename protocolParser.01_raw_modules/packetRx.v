`timescale 1ns / 1ps
`define INITIAL_STATE 0
`define STEADY_STATE 1

module packetRx(
	input clk,
	input rst,
	input [63:0] rx_data_net,
	input rx_sof_net,
	input rx_eof_net,
	input [2:0] rx_len_net,
	input rx_vld_net,
	output reg [63:0] dataOut,
	output reg [6:0] counterOut
);

reg [63:0] rx_data_net_Next;
reg state, stateNext;

always @(posedge clk) begin
	if (rst) begin
        counterOut <= 0;
    end else begin
		counterOut <= counterOut + 1;
		state <=  stateNext;
		rx_data_net <=  rx_data_net_Next;
    end 
end

always @* begin
	rx_data_net_Next = rx_data_net;
	stateNext = state;
	if (rst) begin
		stateNext = 0;
	end
	else begin
		case (state)
			`INITIAL_STATE: begin
				if (rx_vld_net && rx_sof_net) begin
					wEn = 1;
					dataOut = rx_data_net;
					stateNext = `STEADY_STATE;
				end
			end
			`STEADY_STATE: begin
				if (rx_vld_net) begin
					if (rx_eof_net) begin
						if (rx_len_net == 0) begin
							wEn = 0;
						end
						else begin
							wEn = 1;
							dataOut = rx_data_net[rx_len_net*8-1 : 0];
						end
						stateNext = `INITIAL_STATE;
						eof_out = 1;
					end
					else begin
						wEn  = 1;
						dataOut = rx_data_net;
					end
				end
			end
		endcase
	end
end
endmodule