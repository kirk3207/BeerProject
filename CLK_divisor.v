module CLK_divisor(clk_2_2, clk, clk_2_21);
input clk;
output clk_2_2;
output clk_2_21;

reg [21:0] num;
wire [21:0] next_num;

/*num change*/
always @(posedge clk)
begin
    num <= next_num;
end

assign next_num = num + 1'b1;
/*output divided clk*/
assign clk_2_2 = num[1];
assign clk_2_21 = num[21];
   
    
endmodule
