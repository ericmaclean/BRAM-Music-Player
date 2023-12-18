//`include "Mem_Init.txt";
//comment out include and initial line for synth
module BRAM
#(parameter Data_Width = 8, 
parameter Addr_Width = 4,
parameter INIT_FILE = "Mem_Init.txt")
(input i_Clk, 
input Wr_En,  
input Rd_En,
input [Addr_Width-1:0] W_Addr,
input [Addr_Width-1:0] R_Addr,
input [Data_Width-1:0] Wr_Data,
output reg [Data_Width-1:0] Rd_Data);
 
 
  reg [Data_Width-1:0] Mem [0:(2**Addr_Width)-1];

	always @(posedge i_Clk)
	begin 
		if (Wr_En == 1'b1)
		begin 
		Mem[W_Addr] <= Wr_Data;
		end 
		if (Rd_En == 1'b1)
		begin
		Rd_Data <= Mem[R_Addr];
		end 
	end 
	
	//initial if (INIT_FILE)
	//begin 
      //$readmemh(INIT_FILE, Mem);
	//end 
	
	endmodule 