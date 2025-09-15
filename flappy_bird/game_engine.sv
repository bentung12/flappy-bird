module game_engine
  #(
    parameter int pA = 10 ,
    parameter int fA = 32 ,
    parameter int cA = 4 
    )
    (
     input  logic [pA-1:0] pix_x ,
     input  logic [pA-1:0] pix_y ,
     input  logic          pix_v ,
     input  logic [fA-1:0] frame_id,
     output logic [cA-1:0] color[2:0],
     input  logic clk,
     input  logic rst,
	  input  logic jmp,
	  output logic [3:0] score_ones,
	  output logic [3:0] score_tens
     );

   //assign color = ( pix_x[6] ^ pix_y[6] ^ frame_id[7] ) && pix_v ? '{4'hf,4'hf,4'hf} : '{4'h0,4'h0,4'h0} ;
	
	logic wallx_pos, wally_pos;
	logic birdx_pos, birdy_pos;
	logic [pA-1:0] wall_pos;
	logic [20:0] wall_clk;
	logic [8:0] wall_gap;
	logic [pA-1:0] bird_pos;
	logic [17:0] bird_clk;
	logic [cA-1:0] screen[2:0];
	logic death;
	logic [27:0] timer;
	logic death_en;
	logic [7:0] wall_randomizer;
	
	
	assign color[2] = pix_v?screen[2]:4'h0;   
   assign color[1] = pix_v?screen[1]:4'h0; 
   assign color[0] = pix_v?screen[0]:4'h0;
	
	assign wallx_pos = (pix_x < wall_pos) && (pix_x > (wall_pos - 6'd50));
	assign wally_pos = (pix_y < wall_gap) || (pix_y > wall_gap + 8'd100);
	
	assign birdx_pos = (pix_x > 5'd25) && (pix_x < 6'd55);
	assign birdy_pos = (pix_y > bird_pos) && (pix_y < bird_pos + 5'd30);
	
	my_dff #(1) death_dff(.q(death), .din(1'b1), .en(((wallx_pos && wally_pos && birdx_pos && birdy_pos) || bird_pos == 10'd479) && death_en), .clk, .rst);
	
	
	//blue
	always_comb begin
		priority case (1'b1)
			death                  : screen[2] = 4'h0;
			wallx_pos && wally_pos : screen[2] = 4'h0;
			birdx_pos && birdy_pos : screen[2] = 4'h0;
			default                : screen[2] = 4'h0;
		endcase
	end
	
	//green
	always_comb begin
		priority case (1'b1)
			death                  : screen[1] = 4'h0;
			wallx_pos && wally_pos : screen[1] = 4'hf;
			birdx_pos && birdy_pos : screen[1] = 4'hf;
			default                : screen[1] = 4'h0;
		endcase
	end
	
	//red
	always_comb begin
		priority case (1'b1)
			death                  : screen[0] = 4'hf;
			wallx_pos && wally_pos : screen[0] = 4'h0;
			birdx_pos && birdy_pos : screen[0] = 4'hf;
			default                : screen[0] = 4'h0;
		endcase
	end
	
	//wall + bird position
	counter #(pA, 640) wall_pos_cnt(.inc('0), .dec(1'b1), .clk(wall_clk == '0), .rst, .cnt(wall_pos));
	birdcounter #(pA, 480) bird_pos_cnt(.inc(!jmp), .dec(jmp), .clk(bird_clk == '0), .rst, .cnt(bird_pos));
	
	counter #(21, 166_667) wall_clk_cnt(.inc(1'b1), .dec('0), .clk, .rst, .cnt(wall_clk));
	counter #(18, 150_000) bird_clk_cnt(.inc(1'b1), .dec('0), .clk, .rst, .cnt(bird_clk));
	
	//death enable
	counter #(28, 250_000_000) timer_cnt(.inc(1'b1), .dec('0), .clk, .rst, .cnt(timer));
	my_dff #(1) timer_dff(.q(death_en), .din(1'b1), .en(timer == 28'd100_000_000), .clk, .rst);
	
	//score counter
	counter #(4, 10) score0Counter(.inc(wall_pos == 5'd25 && !death && death_en), .dec('0), .clk(wall_clk == '0), .rst, .cnt(score_ones));
	counter #(4, 10) score1Counter(.inc(wall_pos == 5'd25 && score_ones == 4'd9 && !death && death_en), .dec('0), .clk(wall_clk == '0), .rst, .cnt(score_tens));
	
	//wall position counter
	counter #(8, 250) wallRandomization(.inc(1'b1), .dec('0), .clk, .rst, .cnt(wall_randomizer));
	
	my_dff #(9) wall_gap_dff (.q(wall_gap), .din(wall_randomizer + 9'd50), .en(wall_pos == 10'd639), .clk(wall_clk == '0), .rst);
   
endmodule //game_engine