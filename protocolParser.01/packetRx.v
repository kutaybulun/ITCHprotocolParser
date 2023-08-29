`timescale 1ns / 1ps
`define INITIAL_STATE 0
`define STEADY_STATE 1

module packetRx( //add a counter that will act as a global counter, also use dataOut globally.
	clk,
	rst,
	rx_data_net,
	rx_sof_net,
	rx_eof_net,
	rx_len_net,
	rx_vld_net,
	dataOut
);

input clk, rst;
input [63:0] rx_data_net; // 64bit ethernet frame data
input rx_sof_net; //end of the frame
input rx_eof_net; //start of the frame
input [2:0] rx_len_net; //valid bytes of dataOut
input rx_vld; //if 1 dataOut is valid

output reg [63:0] dataOut; 
reg [63:0] rx_data_net_Next;
reg state, stateNext;

always @(posedge clk) begin
	state <= #1 stateNext;
	rx_data_net <= #1 rx_data_net_Next; 
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