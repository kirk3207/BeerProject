module mem_addr_gen_background(
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   output [16:0] pixel_addr
   );  

	assign pixel_addr = (h_cnt>>1)+320*(v_cnt>>1);  //640*480 --> 320*240 
	
endmodule
