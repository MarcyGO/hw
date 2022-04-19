//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk,
					input [7:0] keycode [6],
					input up, left, right, down, // collision
               output [9:0]  BallX, BallY, BallS );
    
    logic [9:0] Ball_X_Pos, Ball_down_Motion, Ball_Y_Pos, Ball_up_Motion, Ball_Size;
	 logic jump;
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
	 
    assign Ball_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_up_Motion <= 10'd0; //Ball_Y_Step;
				Ball_down_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end
           
        else 
        begin
					// response to keyboard press 
					case (keycode[0])
					8'h04 : if (!left) Ball_X_Pos <= Ball_X_Pos-Ball_X_Step; //A					        
					8'h07 : if (!right) Ball_X_Pos <= Ball_X_Pos+Ball_X_Step; //D							  
					8'h1A : if (down) Ball_up_Motion = 10; //W  
					default: ;
			   endcase
					
//					if(keycode[0]==8'h04 || keycode[1]==8'h04 || keycode[2]==8'h04 || keycode[3]==8'h04 || keycode[4]==8'h04 || keycode[5]==8'h04 )
//						begin
//							if (!left) Ball_X_Pos <= Ball_X_Pos-Ball_X_Step; //A
//						end
//					if(keycode[0]==8'h07 || keycode[1]==8'h07 || keycode[2]==8'h07 || keycode[3]==8'h07 || keycode[4]==8'h07 || keycode[5]==8'h07 )
//						begin
//							if (!right) Ball_X_Pos <= Ball_X_Pos+Ball_X_Step; //D
//						end
//					if(keycode[0]==8'h1A || keycode[1]==8'h1A || keycode[2]==8'h1A || keycode[3]==8'h1A || keycode[4]==8'h1A || keycode[5]==8'h1A )
//						begin
//							if (down) Ball_up_Motion = 10; //W
//						end
				 
				 if (!up && Ball_up_Motion>0) // !up need modify, it only check step=1
					begin
						Ball_Y_Pos <= Ball_Y_Pos-Ball_up_Motion;
						Ball_up_Motion <= Ball_up_Motion - 1;
					end
				 else if (!down)  Ball_Y_Pos <= Ball_Y_Pos + 1;
//					begin
//						Ball_down_Motion <= Ball_down_Motion+1;
//						Ball_Y_Pos <= Ball_Y_Pos+Ball_down_Motion;
//					end
//				 else Ball_down_Motion <= 0;
			
		end  
    end
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    

endmodule
