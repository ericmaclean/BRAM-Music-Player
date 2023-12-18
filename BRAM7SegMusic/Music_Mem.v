module Music_Mem
(input i_Clk,
input i_Music_En,
input i_Read_Data,
output o_ROM_Addr,
output io_PMOD_4);
//localparam Clkdivider = 25000000/440/2;

// first create a 16bit binary counter
reg [14:0] counter = 0; 
reg speaker = 0;
reg [3:0] r_ROM_Addr = 0;
reg [21:0] tempo_count = 0;


always @(posedge i_Clk)
begin 

		tempo_count <= tempo_count +1;
		if (tempo_count == 3125000-1)
		begin 
			tempo_count <= 0;
			if (r_ROM_Addr == 15)
				r_ROM_Addr <= 0;
			else 
				r_ROM_Addr <= r_ROM_Addr + 1;
		end 
	
end 

reg [14:0] clkdivider = 0;
reg [7:0] Read_Data;

always @(posedge i_Clk)
Read_Data <= i_Read_Data;
begin
	case(Read_Data)
	  8'h61: clkdivider = 28409; // A 25,000,000/440/2
	  8'h41: clkdivider = 26824; // A#/Bb
	  8'h62: clkdivider = 25354; // B
	  8'h63: clkdivider = 23496; // C
	  8'h43: clkdivider = 22563; // C#/Db
	  8'h64: clkdivider = 21294; // D
	  8'h44: clkdivider = 20096; // D#/Eb
	  8'h65: clkdivider = 18968; // E
	  8'h66: clkdivider = 17908; // F
	  8'h46: clkdivider = 16914; // F#/Gb
	  8'h67: clkdivider = 15964; // G
	  8'h47: clkdivider = 15060; // G#/Ab
	  8'h00: clkdivider = 312; // rest note 25,000,000/40,000/2
	  default: clkdivider = 28409; // A 25,000,000/440/2

	endcase
end


always @(posedge i_Clk) 
begin 
	if (counter == clkdivider)
	begin 
	counter <= 0;
	speaker <= ~speaker;
	end 
	else 
	counter <= counter+1;
end 

// and use the most significant bit (MSB) of the counter to drive the speaker

assign io_PMOD_4 = (i_Music_En) ? speaker : 1'b0;
assign o_ROM_Addr = (i_Music_En) ? r_ROM_Addr : 1'b0;

endmodule