module pixel_selector(
    input [4-1:0] layers,
	input [12-1:0] pixel_P1,
	input [12-1:0] pixel_P2,
    input [12-1:0] pixel_background,
    output reg [12-1:0] pixel
    );
	
	
always@(*)begin
	if( layers[2] )begin		//player & background
		if( pixel_P1 != 12'hF0F)	pixel = pixel_P1; 
		else 						pixel = pixel_background;
	end else if( layers[1] ) begin
	   if( pixel_P2 != 12'hF0F) pixel = pixel_P2;
	   else pixel = pixel_background;
	end else if( layers[0] ) begin
		pixel = pixel_background;
	end else begin
		pixel = pixel_background;
	end
	
end
endmodule