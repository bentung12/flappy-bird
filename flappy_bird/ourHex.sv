module ourHex 		( 
					input logic [3:0]s,
					output logic [6:0]z);
					
	always_comb begin
		unique case (s)
			4'h0 : z = 7'b1000000;
			4'h1 : z = 7'b1111001;
			4'h2 : z = 7'b0100100;
			4'h3 : z = 7'b0110000;
			4'h4 : z = 7'b0011001;
			4'h5 : z = 7'b0010010;
			4'h6 : z = 7'b0000010;
			4'h7 : z = 7'b1111000;
			4'h8 : z = 7'b0000000;
			4'h9 : z = 7'b0010000;
			default : z = 7'b0110110;
		endcase
	end
	
endmodule