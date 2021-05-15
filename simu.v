`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//  
// Oguzhan Alpaslan- 24096
//Elif Rahmiye Kulunk-20830
//////////////////////////////////////////////////////////////////////////////////
module atm (input clk,
                     input rst,
                     input BTN3, BTN2, BTN1,
                     input [3:0] SW,
                     output reg [7:0] LED,                                     // LED[7] is the left most-LED
                     output reg [6:0] digit4, digit3, digit2, digit1  // digit4 is the left-most SSD
                    );
  
	 reg [3:0] password;
	 reg [15:0] balance; 
	 reg [7:0] current_state;
	 reg [7:0] next_state;	
	 reg [7:0] cntr;
	 parameter [3:0] S0 = 4'b0000;
	 parameter [3:0] S1 = 4'b0001;
	 parameter [3:0] S2 = 4'b0010;
	 parameter [3:0] S3 = 4'b0011;
	 parameter [3:0] S4 = 4'b0100;
	 parameter [3:0] S5 = 4'b0101;
	 parameter [3:0] S6 = 4'b0110;
	 parameter [3:0] S7 = 4'b0111;
	 parameter [3:0] S8 = 4'b1000;
	 parameter [3:0] S9 = 4'b1001;
	 parameter [3:0] S10 = 4'b1010;
	 parameter [3:0] S11 = 4'b1011;
	 
	 // parameter S0 = 0, S1 = 0, S2=0;
	 
	 
	

	// sequential part - state transitions
	always @ (posedge clk or posedge rst)
	begin
		      if(rst)
            begin
					current_state <= S0;
					/*password <= 0;
					balance <= 0;
					cntr <= 8'b0;*/
				end
        else
            current_state <= next_state;

	end

	// combinational part - next state definitions
	always @ (*)
	begin
		if(rst)
		begin
			next_state = S0;
		end
		
		else
		begin
		case(current_state)
			S0:
				if(BTN3) 
					next_state = S1;
				else 
					next_state = S0;
				
			S1:
				if(BTN1) 
					next_state = S0;
				else if(SW == password && BTN3)
					next_state = S5;
				else if(SW != password && BTN3)
					next_state= S2;
				else
					next_state =S1;
					
			S2:
				if(BTN1 && !BTN3) 
					next_state = S0;
				else if(SW == password && BTN3)
					next_state = S5;
				else if(SW != password && BTN3)
					next_state= S3;
				else
					next_state =S2;
				
					
			S3:
				if(BTN1 && !BTN3) 
					next_state = S0;
				else if(SW == password && BTN3)
					next_state = S5;
				else if(SW != password && BTN3)
					next_state= S4;
				else
					next_state =S3;
			
			
			S4:
				if(cntr >= 100) next_state = S0;
				else next_state = S4;
				
			
			S5:
			   if(BTN1 && !BTN2 && !BTN3)
					next_state= S0;
				else if(!BTN1 && BTN2 && !BTN3)
					next_state = S8;
				else if(!BTN1 && !BTN2 && BTN3)
					next_state = S6;
				else next_state = S5;
			
			
			S6:
				if(BTN1 && !BTN2 && !BTN3)
					next_state = S5;
				else if(!BTN1 && !BTN2 && BTN3)
					next_state = S6;
				else if(!BTN1 && BTN2 && !BTN3)
					begin
					 if(balance < SW) 
						next_state = S7;
					 else if(balance >= SW)
						next_state = S6;
					end
				else next_state= S6;
			
			
			S7:
				if(cntr >= 50) next_state = S6;
				else next_state = S7;
			
			
			S8:
				if(BTN1 && !BTN3)
					next_state = S5;
				else if(!BTN1 && BTN3 && password == SW)
					next_state = S11;
				else if(!BTN1 && BTN3 && password != SW)
					next_state = S9;
				else 
					next_state = S8;
					
			
			
			S9:
				if(BTN1 && !BTN3)
					next_state = S5;
				else if(!BTN1 && BTN3 && password == SW)
					next_state = S11;
				else if(!BTN1 && BTN3 && password != SW)
					next_state = S10;
				else 
					next_state = S9;
				
			
			S10:
				if(BTN1 && !BTN3)
					next_state = S5;
				else if(!BTN1 && BTN3 && password == SW)
					next_state = S11;
				else if(!BTN1 && BTN3 && password != SW)
					next_state = S4;
				else 
					next_state= S10;
			
			S11:
				if(BTN3)
					next_state = S5;
				else
					next_state = S11;
			endcase
			end
			
   end
	
	// sequential part - control registers
	always @ (posedge clk or posedge rst)
	begin
	
		if(rst)
		begin
			password <= 4'd0;
			balance <= 16'd0;
			cntr <= 8'd0;
		end
	
		else
		begin
				case(current_state)
					S4:
						if(cntr >= 8'd100) 
							cntr <= 8'b0;
						else
							cntr <= cntr + 8'd1;
					S6:
						if(BTN3)
							balance <= balance + SW;
						else if(BTN2)
							begin
								if(balance > SW)
								balance <= balance - SW;
								else;
							end
						else;
					
					S7:
						if(cntr >= 8'd50) 
							cntr <= 8'b0;
						else
							cntr <= cntr + 8'd1;
					S11:
						if(BTN3)
							password <= SW;
						else;
					endcase
		end
	end

// sequential part - outputs
always @ (posedge clk or posedge rst)
begin
	
	if(rst)
	begin
		LED <= 8'b11111111;
		digit4 <= 7'b1111111; 
		digit3 <= 7'b1111111;
		digit2 <= 7'b1111111; 
		digit1 <= 7'b1111111; 
	end
	
	else
	begin
	
		case(current_state)
		
		S0: // CArd
		begin
			LED <= 8'b00000001;
			digit4 <= 7'b0110001;
			digit3 <= 7'b0001000;
			digit2 <= 7'b1111010;
			digit1 <= 7'b1000010;
		end
		
			
		S1: //PE-3
		begin
		
			LED <= 8'b10000000;
			digit4 <= 7'b0011000;
			digit3 <= 7'b0110000;
			digit2 <= 7'b1111110;
			digit1 <= 7'b0000110;
		end
	
			
		S2:	//PE-2
		begin
			LED <= 8'b11000000;
			digit4 <= 7'b0011000;
			digit3 <= 7'b0110000;
			digit2 <= 7'b1111110;
			digit1 <= 7'b0010010;
		end
		
		S3: // PE-1
		begin
			LED <= 8'b11100000;
			digit4 <= 7'b0011000;
			digit3 <= 7'b0110000;
			digit2 <= 7'b1111110;
			digit1 <= 7'b1001111;
		end
			
		S4: //FAIL
		begin
			LED <= 8'b11111111;
			digit4 <= 7'b0111000;
			digit3 <= 7'b0001000;
			digit2 <= 7'b1001111;
			digit1 <= 7'b1110001;
		end
				
		S5: //OPEN
		begin
			LED <= 8'b00010000;
			digit4 <= 7'b0000001;
			digit3 <= 7'b0011000;
			digit2 <= 7'b0110000;
			digit1 <= 7'b1101010;
		end
		
		S6: // balance
		begin
			LED <= 8'b11111111;
				if(balance[3:0]==4'b0000)
					digit1<=7'b0000001;
				else if(balance[3:0]==4'b0001)
					digit1<=7'b1001111;
				else if(balance[3:0]==4'b0010)
					digit1<=7'b0010010;
				else if(balance[3:0]==4'b0011)
					digit1<=7'b0000110;
				else if(balance[3:0]==4'b0100)
					digit1<=7'b1001100;
				else if(balance[3:0]==4'b0101)
					digit1<=7'b0100100;
				else if(balance[3:0]==4'b0110)
					digit1<=7'b0100000;
				else if(balance[3:0]==4'b0111)
					digit1<=7'b0001111;
				else if(balance[3:0]==4'b1000)
					digit1<=7'b0000000;
				else if(balance[3:0]==4'b1001)
					digit1<=7'b0000100;
				else if(balance[3:0]==4'b1010)
					digit1<=7'b0001000;
				else if(balance[3:0]==4'b1011)
					digit1<=7'b1100000;
				else if(balance[3:0]==4'b1100)
					digit1<=7'b0110001;
				else if(balance[3:0]==4'b1101)
					digit1<=7'b0000010;
				else if(balance[3:0]==4'b1110)
					digit1<=7'b0110000;
				else if(balance[3:0]==4'b1111)
					digit1<=7'b0111000;
				else;
				
				if(balance[7:4]==4'b0000)
					digit2<=7'b0000001;
				else if(balance[7:4]==4'b0001)
					digit2<=7'b1001111;
				else if(balance[7:4]==4'b0010)
				digit2<=7'b0010010;
				else if(balance[7:4]==4'b0011)
				digit2<=7'b0000110;
				else if(balance[7:4]==4'b0100)
				digit2<=7'b1001100;
				else if(balance[7:4]==4'b0101)
				digit2<=7'b0100100;
				else if(balance[7:4]==4'b0110)
				digit2<=7'b0100000;
				else if(balance[7:4]==4'b0111)
				digit2<=7'b0001111;
				else if(balance[7:4]==4'b1000)
				digit2<=7'b0000000;
				else if(balance[7:4]==4'b1001)
				digit2<=7'b0000100;
				else if(balance[7:4]==4'b1010)
				digit2<=7'b0001000;
				else if(balance[7:4]==4'b1011)
				digit2<=7'b1100000;
				else if(balance[7:4]==4'b1100)
				digit2<=7'b0110001;
				else if(balance[7:4]==4'b1101)
				digit2<=7'b0000010;
				else if(balance[7:4]==4'b1110)
				digit2<=7'b0110000;
				else if(balance[7:4]==4'b1111)
				digit2<=7'b0111000;
				else;
				
				if(balance[11:8]==4'b0000)
				digit3<=7'b0000001;
				else if(balance[11:8]==4'b0001)
				digit3<=7'b1001111;
				else if(balance[11:8]==4'b0010)
				digit3<=7'b0010010;
				else if(balance[11:8]==4'b0011)
				digit3<=7'b0000110;
				else if(balance[11:8]==4'b0100)
				digit3<=7'b1001100;
				else if(balance[11:8]==4'b0101)
				digit3<=7'b0100100;
				else if(balance[11:8]==4'b0110)
				digit3<=7'b0100000;
				else if(balance[11:8]==4'b0111)
				digit3<=7'b0001111;
				else if(balance[11:8]==4'b1000)
				digit3<=7'b0000000;
				else if(balance[11:8]==4'b1001)
				digit3<=7'b0000100;
				else if(balance[11:8]==4'b1010)
				digit3<=7'b0001000;
				else if(balance[11:8]==4'b1011)
				digit3<=7'b1100000;
				else if(balance[11:8]==4'b1100)
				digit3<=7'b0110001;
				else if(balance[11:8]==4'b1101)
				digit3<=7'b0000010;
				else if(balance[11:8]==4'b1110)
				digit3<=7'b0110000;
				else if(balance[11:8]==4'b1111)
				digit3<=7'b0111000;
				else;
				
				if(balance[15:12]==4'b0000)
				digit4<=7'b0000001;
				else if(balance[15:12]==4'b0001)
				digit4<=7'b1001111;
				else if(balance[15:12]==4'b0010)
				digit4<=7'b0010010;
				else if(balance[15:12]==4'b0011)
				digit4<=7'b0000110;
				else if(balance[15:12]==4'b0100)
				digit4<=7'b1001100;
				else if(balance[15:12]==4'b0101)
				digit4<=7'b0100100;
				else if(balance[15:12]==4'b0110)
				digit4<=7'b0100000;
				else if(balance[15:12]==4'b0111)
				digit4<=7'b0001111;
				else if(balance[15:12]==4'b1000)
				digit4<=7'b0000000;
				else if(balance[15:12]==4'b1001)
				digit4<=7'b0000100;
				else if(balance[15:12]==4'b1010)
				digit4<=7'b0001000;
				else if(balance[15:12]==4'b1011)
				digit4<=7'b1100000;
				else if(balance[15:12]==4'b1100)
				digit4<=7'b0110001;
				else if(balance[15:12]==4'b1101)
				digit4<=7'b0000010;
				else if(balance[15:12]==4'b1110)
				digit4<=7'b0110000;
				else if(balance[15:12]==4'b1111)
				digit4<=7'b0111000;
				else;
		
		end
				
		S7: //WARNING
		begin
			LED <= 8'b00001000;
			digit4 <= 7'b1111110;
			digit3 <= 7'b1101010;
			digit2 <= 7'b0001000;
			digit1 <= 7'b1111110;
		end

		S8: //PASS_CHG_3
		begin
			LED <= 8'b00000100;
			digit4 <= 7'b0011000;
			digit3 <= 7'b0110001;
			digit2 <= 7'b1111110;
			digit1 <= 7'b0000110;
		end

		S9: //PASS_CHG_2
		begin
			LED <= 8'b00000110;
			digit4 <= 7'b0011000;
			digit3 <= 7'b0110001;
			digit2 <= 7'b1111110;
			digit1 <= 7'b0010010;
		end

		S10: //PASS_CHG_1
		begin
			LED <= 8'b00000111;
			digit4 <= 7'b0011000;
			digit3 <= 7'b0110001;
			digit2 <= 7'b1111110;
			digit1 <= 7'b1001111;
		end

		S11: //PASS_NEW
		begin
			LED <= 8'b00000010;
			digit4 <= 7'b0011000;
			digit3 <= 7'b0001000;
			digit2 <= 7'b0100100;
			digit1 <= 7'b0100100;
		end
		
			
		endcase
		
		end
end	


	// additional always statements
	
endmodule

