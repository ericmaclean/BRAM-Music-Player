module Debounce_Switch 

(input i_Clk,
input i_Switch, 
output o_Switch);

parameter c_Debounce_Limit = 250000; //25MHz divided by 100 to get amount of cycles in 10ms 

reg r_State = 1'b0; //intermediary for i_Switch and o_Switch
reg [17:0] r_Count = 0; // 2^18 equals around 260,000 

always @ (posedge i_Clk)
	begin 
	
	if (i_Switch !== r_State && r_Count < c_Debounce_Limit)
		r_Count <= r_Count + 1;
		else if (r_Count == c_Debounce_Limit)
		begin
			r_Count <= 0;
			r_State <= i_Switch;
		end	
	else 
		r_Count <= 0;
	end 
	
assign o_Switch = r_State;

endmodule //Debounce Switch  


