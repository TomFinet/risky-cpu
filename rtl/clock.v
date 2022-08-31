/* Taken from https://www.chipverify.com/verilog/verilog-clock-generator */

`timescale 1ns/1ps

module clock(
	input enable,

	output reg clock
);

parameter FREQ=100000; // kHz
parameter PHASE=0;     // degrees
parameter DUTY=50;     // percentage

real clock_period=1.0/(FREQ*1e3)*1e9; // ns
real clock_on=DUTY/100.0*clock_period;
real clock_off=clock_period-clock_on;
real quarter=clock_period/4;
real start_delay=quarter*PHASE/90;

reg start_clock = 0;

always @(posedge enable or negedge enable) begin
	if(enable) begin
		#(start_delay) start_clock=1;
	end else begin
		#(start_delay) start_clock=0;
	end
end

always @(posedge start_clock) begin
	if(start_clock) begin
		clock=1;
	
		while(start_clock) begin
			#(clock_on) clock=0;
			#(clock_off) clock=1;
		end

		clock=0;
	end
end

endmodule