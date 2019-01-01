module mem_addr_gen_P1(
	input [9:0] h_cnt,
	input [9:0] v_cnt,
	input [11-1:0] P1_y,
	output reg [11-1:0] pixel_addr
	);  
	
	wire [11-1:0] h;
	wire [11-1:0] v;
	always @ (*)begin
		if( h >= 11'd500  && v >= P1_y )begin
			pixel_addr = ((h - 11'd500 ) + 11'd30 * (v - P1_y)) % 1500;
		end else begin
			pixel_addr = 11'd14; //FOR DEBUG
		end
	end
	
	assign h = h_cnt; //320
	assign v = v_cnt; //240
endmodule