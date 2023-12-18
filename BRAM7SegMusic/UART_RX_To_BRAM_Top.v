module UART_RX_To_7_Seg_Top
	(input i_Clk, //Main clock
	input i_UART_RX, // UART RX Data 
	// Segment1 is upper digit, segment2 is lower digit
	input i_Switch_1,
	input i_Switch_2,
	input i_Switch_3,
	input i_Switch_4,
	output o_LED_1,
	output o_LED_2,
	output o_LED_3,
	output o_LED_4,
	output io_PMOD_4,
	
	output o_Segment1_A,
	output o_Segment1_B,
	output o_Segment1_C,
	output o_Segment1_D,
	output o_Segment1_E,
	output o_Segment1_F,
	output o_Segment1_G,
	
	output o_Segment2_A,
	output o_Segment2_B,
	output o_Segment2_C,
	output o_Segment2_D,
	output o_Segment2_E,
	output o_Segment2_F,
	output o_Segment2_G);
	
	reg r_LED_1    = 1'b0;
	reg r_Switch_1 = 1'b0;
	reg r_LED_2    = 1'b0;
	reg r_Switch_2 = 1'b0;
	reg r_LED_3    = 1'b0;
	reg r_Switch_3 = 1'b0;
	reg r_LED_4    = 1'b0;
	reg r_Switch_4 = 1'b0;
	
	wire w_Switch_1;
	wire w_Switch_2;
	wire w_Switch_3;
	wire w_Switch_4;
	
	wire w_RX_DV;
	wire [7:0] w_RX_Byte; 
	wire [7:0] Read_Data;
	
	wire w_Segment1_A;
	wire w_Segment1_B;
	wire w_Segment1_C;
	wire w_Segment1_D;
	wire w_Segment1_E;
	wire w_Segment1_F;
	wire w_Segment1_G;
	wire w_Segment2_A;
	wire w_Segment2_B;
	wire w_Segment2_C;
	wire w_Segment2_D;
	wire w_Segment2_E;
	wire w_Segment2_F;
	wire w_Segment2_G;
	
	wire[3:0] M_ROM_Addr;
	wire [3:0] READ_Addr;
	reg [3:0] UART_Addr = 4'b0000;
	reg [3:0] ROM_Addr = 4'b0000;
	reg Rd_En = 0;
	reg Music_En = 0;
		
	Debounce_Switch Switch_1
	(.i_Clk(i_Clk),
	.i_Switch(i_Switch_1),
	.o_Switch(w_Switch_1));
	
	Debounce_Switch Switch_2
	(.i_Clk(i_Clk),
	.i_Switch(i_Switch_2),
	.o_Switch(w_Switch_2));
	
	Debounce_Switch Switch_3
	(.i_Clk(i_Clk),
	.i_Switch(i_Switch_3),
	.o_Switch(w_Switch_3));
	
	Debounce_Switch Switch_4
	(.i_Clk(i_Clk),
	.i_Switch(i_Switch_4),
	.o_Switch(w_Switch_4));
	
	//25,000,000 / 115,200 = 217 
	UART_RX
	#(.CLKS_PER_BIT(217))
	UART_RX_Inst
	(.i_Clock(i_Clk),
	.i_RX_Serial(i_UART_RX),
	.o_RX_DV(w_RX_DV),
	.o_RX_Byte(w_RX_Byte));
	
	BRAM 
	(.i_Clk(i_Clk),
	.Wr_En(w_RX_DV),
	.Rd_En(Rd_En),
	.W_Addr(UART_Addr),
	.R_Addr(READ_Addr),
	.Wr_Data(w_RX_Byte),
	.Rd_Data(Read_Data));
	
	//Binary to 7-Segment converter for upper digit 
	Binary_To_7Segment 
	SevenSeg1_Inst
	(.i_Clk(i_Clk),
	.i_Binary_Num(Read_Data[7:4]),
	.o_Segment_A(w_Segment1_A),
	.o_Segment_B(w_Segment1_B),
	.o_Segment_C(w_Segment1_C),
	.o_Segment_D(w_Segment1_D),
	.o_Segment_E(w_Segment1_E),
	.o_Segment_F(w_Segment1_F),
	.o_Segment_G(w_Segment1_G));
	
	assign o_Segment1_A = ~w_Segment1_A;
	assign o_Segment1_B = ~w_Segment1_B;
	assign o_Segment1_C = ~w_Segment1_C;
	assign o_Segment1_D = ~w_Segment1_D;
	assign o_Segment1_E = ~w_Segment1_E;
	assign o_Segment1_F = ~w_Segment1_F;
	assign o_Segment1_G = ~w_Segment1_G;
	
	//Binary to 7-Segment converter for lower digits 
	
	Binary_To_7Segment
	SevenSeg2_Inst 
	(.i_Clk(i_Clk),
	.i_Binary_Num(Read_Data[3:0]),
	.o_Segment_A(w_Segment2_A),
	.o_Segment_B(w_Segment2_B),
	.o_Segment_C(w_Segment2_C),
	.o_Segment_D(w_Segment2_D),
	.o_Segment_E(w_Segment2_E),
	.o_Segment_F(w_Segment2_F),
	.o_Segment_G(w_Segment2_G));
	
	assign o_Segment2_A = ~w_Segment2_A;
	assign o_Segment2_B = ~w_Segment2_B;
	assign o_Segment2_C = ~w_Segment2_C;
	assign o_Segment2_D = ~w_Segment2_D;
	assign o_Segment2_E = ~w_Segment2_E;
	assign o_Segment2_F = ~w_Segment2_F;
	assign o_Segment2_G = ~w_Segment2_G;
	
	Music_Mem 
	(.i_Clk(i_Clk),
	.i_Music_En(Music_En),
	.i_Read_Data(Read_Data),
	.o_ROM_Addr(M_ROM_Addr),
	.io_PMOD_4(io_PMOD_4));
	
	
	always @(posedge i_Clk)
	begin 
		if(w_RX_DV == 1'b1)
		begin 
			if (UART_Addr == 15)
				UART_Addr <= 1'b0;
			else 
				UART_Addr <= UART_Addr + 1;
		end 
		
	end 
	
	always @(posedge i_Clk)
	begin 
		
		r_Switch_1 <= w_Switch_1;
		r_Switch_2 <= w_Switch_2;
		r_Switch_3 <= w_Switch_3;
		r_Switch_4 <= w_Switch_4;
		
		if(w_Switch_1 == 1'b1 && r_Switch_1 == 1'b0)
		begin 
			if (ROM_Addr == 15)
				ROM_Addr <= 1'b0;
			else 
				ROM_Addr <= ROM_Addr + 1;
		end 
		if(w_Switch_3 == 1'b1 && r_Switch_3 == 1'b0)
		begin 
			Rd_En <= ~Rd_En;
		end 
		if(w_Switch_2 == 1'b1 && r_Switch_2 == 1'b0)
		begin 
			Music_En <= ~Music_En;
		end 
	end 
	
	assign READ_Addr = (Music_En) ? M_ROM_Addr : ROM_Addr;
	
	assign o_LED_1 = (Music_En) ? M_ROM_Addr[0] : ROM_Addr[0];
	assign o_LED_2 = (Music_En) ? M_ROM_Addr[1]: ROM_Addr[1];
	assign o_LED_3 = (Music_En) ? M_ROM_Addr[2]: ROM_Addr[2];
	assign o_LED_4 = (Music_En) ? M_ROM_Addr[3]: ROM_Addr[3];
	
endmodule 
	
	