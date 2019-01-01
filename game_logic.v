module game_logic(
	input CLK_2_21,
    input CLK100MHZ,
    input RESET,
	input [512-1:0] key_down,
	input [9-1:0] last_change,
	input been_ready,
	output reg [11-1:0] P1_y,
	output reg [11-1:0] P2_y
	);


	reg [2-1:0] P1_life, next_P1_life;
	reg [2-1:0] P2_life, next_P2_life;
	reg [2-1:0] game_state, next_game_state;
	parameter INIT = 2'd0, RUN = 2'd1, END = 2'd2;
	parameter eight = 9'b0_0111_0101;	//9'h75
	parameter  five = 9'b0_0111_0011;	//9'h73
	parameter W = 9'b0_0001_1101;
	parameter S = 9'b0_0001_1011;
	wire eight_down, five_down;
	wire W_down, S_down;
	assign eight_down = (key_down[eight] == 1'd1);
	assign  five_down = (key_down[five] == 1'd1);
	assign W_down = (key_down[W] == 1'd1);
	assign S_down = (key_down[S] == 1'd1);
	
	always@(posedge CLK_2_21 or posedge RESET) begin
		if(RESET) begin
			game_state <= INIT;
		end else begin
			game_state <= next_game_state;
		end
	end
	always@(*)begin
		case(game_state)
		INIT:begin
			if( key_down[9'h29] && !been_ready )			next_game_state = RUN;
			else 										next_game_state = INIT;
		end
		RUN:begin
			if( P1_life == 2'd0 || P2_life == 2'd0 )	next_game_state = END;
			else										next_game_state = RUN;
		end
		END:begin	//hold the screend until press "space"
			if( key_down[9'h29] && !been_ready )			next_game_state = RUN; 
			else 										next_game_state = END;
		end
		default:begin
			next_game_state = INIT;
		end
		endcase
	end
	
	//P1
	reg signed [11-1:0] next_P1_y;
	always@(posedge CLK_2_21 or posedge RESET) begin
		if(RESET) begin
			P1_y <= 11'd75;
		end else begin
			P1_y <= next_P1_y;
		end
	end
	always@(*)begin
		case(game_state)
		INIT:begin
            if( key_down[9'h29] && !been_ready )	begin
            	next_P1_y = 11'd125;
            end
            else begin
                 next_P1_y = 11'd75;
            end
		end
		RUN:begin
			if(!been_ready && key_down[last_change]  )begin // press '8' go up
				if(eight_down)begin 
					if(P1_y == 11'd125)	next_P1_y = 11'd375; //go to the lowest table
					else				next_P1_y = P1_y - 11'd50;
				end else if(five_down)begin//press '5' go down
					if(P1_y == 11'd375)	next_P1_y = 11'd125; //go to the highest table
					else				next_P1_y = P1_y + 11'd50;
				end else
					next_P1_y = P1_y;
			end else begin
				next_P1_y = P1_y;
			end
		end
		END:begin	//hold the screend until press "space"
			next_P1_y = P1_y;
		end
		default:begin
			next_P1_y = 11'd75;
		end
		endcase
	end
	
	//P2
	reg signed [11-1:0] next_P2_y;
	always@(posedge CLK_2_21 or posedge RESET) begin
            if(RESET) begin
                P2_y <= 11'd75;
            end else begin
                P2_y <= next_P2_y;
            end
        end
        always@(*)begin
            case(game_state)
            INIT:begin
                if( key_down[9'h29] && !been_ready )    begin
                    next_P2_y = 11'd125;
                end
                else begin
                     next_P2_y = 11'd75;
                end
            end
            RUN:begin
                if(!been_ready && key_down[last_change]  )begin // press 'W' go up
                    if(W_down)begin 
                        if(P2_y == 11'd125)    next_P2_y = 11'd375; //go to the lowest table
                        else                next_P2_y = P2_y - 11'd50;
                    end else if(S_down)begin//press 'S' go down
                        if(P2_y == 11'd375)    next_P2_y = 11'd125; //go to the highest table
                        else                next_P2_y = P2_y + 11'd50;
                    end else
                        next_P2_y = P2_y;
                end else begin
                    next_P2_y = P2_y;
                end
            end
            END:begin    //hold the screend until press "space"
                next_P2_y = P2_y;
            end
            default:begin
                next_P2_y = 11'd75;
            end
            endcase
        end
	
				
	always@(posedge CLK_2_21 or posedge RESET) begin
		if(RESET) begin
			P1_life <= 2'd3;
			P2_life <= 2'd3;
		end else begin
			P1_life <= next_P1_life;
			P2_life <= next_P2_life;
		end
	end
	always@(*)begin
		case(game_state)
		INIT:begin
			next_P1_life = 2'd3;
			next_P2_life = 2'd3;
		end
		RUN:begin
			next_P1_life = P1_life;
			next_P2_life = P2_life;	//################################
		end
		END:begin	//hold the screend until press "space"
			next_P1_life = P1_life;
			next_P2_life = P2_life;
		end
		default:begin
			next_P1_life = 2'd3;
			next_P2_life = 2'd3;
		end
		endcase
	end
endmodule
