module layers_gen(
	input [9:0] h_cnt,
    input [9:0] v_cnt,
	input [11-1:1] P1_y,
	input [11-1:1] P2_y,
	output reg [4-1:0] layers
	);


	
	wire P1_v, P2_v;
	wire P1_h, P2_h;
	
	always@(*)begin
		if(P1_v && P1_h)begin
			layers = 4'b0100;   // Player and background
	    end else if(P2_v && P2_h)begin
	        layers = 4'b0010;
		end else begin
			layers = 4'b0001;	//only background
		end
	end
	
	
	assign P1_v = v_cnt >= P1_y    && v_cnt < (P1_y + 11'd50);
	assign P1_h = h_cnt >= 11'd500 && h_cnt <  11'd530;
    assign P2_v = v_cnt >= P2_y    && v_cnt < (P2_y + 11'd50);
    assign P2_h = h_cnt >= 11'd110 && h_cnt <  11'd140;	
endmodule