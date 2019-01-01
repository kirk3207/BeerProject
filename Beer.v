module Beer(
    input CLK100MHZ,
    input RESET,
	inout PS2_DATA,
    inout PS2_CLK,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync
);

//clock dividor
wire CLK_2_21;
wire CLK_2_2;
CLK_divisor CLK_divisor_inst(
    .clk(CLK100MHZ),
    .clk_2_2(CLK_2_2),
    .clk_2_21(CLK_2_21)
    );
//vga
wire valid;
wire [9:0] h_cnt; //640
wire [9:0] v_cnt;  //480
vga_controller vga_controller_inst(
    .pclk(CLK_2_2),
    .reset(RESET),
    .hsync(hsync),
    .vsync(vsync),
    .valid(valid),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt)
    );
// keyboard
wire [512-1:0] key_down;
wire [9-1:0] last_change;
wire been_ready;
KeyboardDecoder key_de (
	.key_down(key_down),
	.last_change(last_change),
	.key_valid(been_ready),
	.PS2_DATA(PS2_DATA),
	.PS2_CLK(PS2_CLK),
	.rst(0),
	.clk(CLK100MHZ)
	);
	
	
	
wire  [11-1:0] P1_y;
wire  [11-1:0] P2_y;
wire  [11-1:0] beer1_y;		
		
game_logic game_logic_inst(
    .CLK_2_21(CLK_2_21),
    .CLK100MHZ(CLK100MHZ),
    .RESET(RESET),
	.key_down(key_down),
    .last_change(last_change),
    .been_ready(been_ready),
    .P1_y(P1_y)
	//.P2_y(P2_y),
	//.beer1_y(beer1_y)
    );		
		
//background
wire [16:0] pixel_addr_background;
mem_addr_gen_background mem_addr_gen_background_inst(
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .pixel_addr(pixel_addr_background)
    );  
// //P1 left
wire [11-1:0] pixel_addr_P1; //30*50
mem_addr_gen_P1 mem_addr_gen_P1_inst(
    .h_cnt(h_cnt),
    .v_cnt(v_cnt), 
    .P1_y(P1_y),
    .pixel_addr(pixel_addr_P1)
    ); 
//P2 right 

wire [12-1:0] pixel_addr_P2; //30*50
mem_addr_gen_P2 mem_addr_gen_P2_inst(
    .h_cnt(h_cnt),
    .v_cnt(v_cnt), 
    .P2_y(P2_y),
    .pixel_addr(pixel_addr_P2)
    ); 	

// get the pixel color from memory 
wire [12-1:0] pixel_background;
blk_mem_gen_background blk_mem_gen_background_inst(
    .clka(CLK_2_2),
    .wea(0),
    .addra(pixel_addr_background),
    .dina(0),
    .douta(pixel_background)
    ); 
	
	
wire [12-1:0] pixel_P1;
blk_mem_gen_P1 blk_mem_gen_P1_inst(
    .clka(CLK_2_2),
    .wea(0),
    .addra(pixel_addr_P1),
    .dina(0),
    .douta(pixel_P1)
    ); 

	
 wire [12-1:0] pixel_P2;
 blk_mem_gen_P2 blk_mem_gen_P2_inst(
     .clka(CLK_2_2),
     .wea(0),
     .addra(pixel_addr_P2),
     .dina(0),
     .douta(pixel_P2)
     ); 	
	


wire [4-1:0] layers;
layers_gen layers_gen_inst(
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .P1_y(P1_y),
    .P2_y(P2_y),
    .layers(layers)
    );

//select which pixel to show
wire [12-1:0] pixel;
pixel_selector pixel_selector_inst(
	.layers(layers),
	.pixel_P1(pixel_P1),
	.pixel_P2(pixel_P2),
	.pixel_background(pixel_background),
	.pixel(pixel)
	);	
	
	
//assign {vgaRed, vgaGreen, vgaBlue} = valid ? pixel_P1 : 12'h000;
assign {vgaRed, vgaGreen, vgaBlue} = valid ? pixel : 12'h000;
	
endmodule