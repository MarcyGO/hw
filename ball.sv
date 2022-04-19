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
					input [7:0] keycode [6], input logic [0:29][0:39] tile,
					output logic move_left, move_right,
               output logic [9:0]  BallX, BallY, BallH, BallW, BallCH, BallCW);
    
    logic [9:0] Ball_X_Pos, Ball_Y_Pos, Ball_X_Motion, Ball_Y_Motion, Ball_down_Motion, Ball_up_Motion;
	 logic [9:0] Ball_Height, Ball_Width, Collision_h, Collision_w;
	 logic up, left, right, down; // collision
	 logic move_up; //move_left, move_right, 
	 int jump_time;
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
	 
	 // size of the box collider
	 assign Collision_h = 16;
	 assign Collision_w = 8;
	 // size of the player
    assign Ball_Height = 16;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign Ball_Width = 8;
   
									
	logic [5:0] col_left, col_right, row_up, row_up_after, row_down, row_down_after;
	always_comb
		begin: collision_check
			col_left = (BallX-Collision_w-2)>>4;			// left
			col_right = (BallX+Collision_w+2)>>4;		// right
			row_up = (BallY-Collision_h-1)>>4;			// up
			row_up_after = (BallY-Collision_h-Ball_Y_Motion-1)>>4;			// up after the movement
			row_down = (BallY+Collision_h+1)>>4;			// down
			row_down_after = (BallY+Collision_h+Ball_Y_Motion-1+1)>>4;			// down
			left = tile[(BallY-16)>>4][col_left] || tile[(BallY+16)>>4][col_left] || tile[BallY>>4][col_left];
			right = tile[(BallY-16)>>4][col_right] || tile[(BallY+16)>>4][col_right] || tile[BallY>>4][col_right];
			up = tile[row_up][(BallX-8)>>4] || tile[row_up][(BallX+8)>>4];
			down = tile[row_down][(BallX-8)>>4] || tile[row_down][(BallX+8)>>4];
		end
	
	
	always_comb
	begin
		// read keyboard input
		move_left = (keycode[0]==8'h04) || (keycode[1]==8'h04) || (keycode[2]==8'h04) || (keycode[3]==8'h04) || (keycode[4]==8'h04) || (keycode[5]==8'h04);
		move_right = (keycode[0]==8'h07) || (keycode[1]==8'h07) || (keycode[2]==8'h07) || (keycode[3]==8'h07) || (keycode[4]==8'h07) || (keycode[5]==8'h07);
		move_up = (keycode[0]==8'h1A) || (keycode[1]==8'h1A) || (keycode[2]==8'h1A) || (keycode[3]==8'h1A) || (keycode[4]==8'h1A) || (keycode[5]==8'h1A);
		//determine horizontal movement
		Ball_X_Motion = 10'h0;
		case ({move_left, move_right})
			2'b01 : if (!right) Ball_X_Motion = Ball_X_Step; 					// move right
			2'b10 : if (!left) Ball_X_Motion = (~ (Ball_X_Step) + 1'b1);  	// 2's complement; move left
		endcase
		//determine vertical movement
		Ball_Y_Motion = 10'h0;
		if (jump_time > 0) Ball_Y_Motion = (~ (Ball_Y_Step) + 1'b1);  		// 2's complement; move up
		else if (!down) Ball_Y_Motion = Ball_Y_Step;								// move down, not jumping and not on ground		
	end
	
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
		  if (Reset)  // Asynchronous Reset
        begin 
            Ball_up_Motion <= 10'd0; //Ball_Y_Step;
				Ball_down_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= 479-48;
				Ball_X_Pos <= 48;
				jump_time <= 0;
        end
        else 
        begin
				// up date jump_time
				if (up)						jump_time <= 0; 				// reach ceiling
				else if (jump_time>0)	jump_time <= jump_time-1;	// in the air, rising
				else if (move_up && down)			jump_time <= 48;				// begin jumpping
				else jump_time <=0;
				// up date ball position
				Ball_X_Pos <= Ball_X_Pos + Ball_X_Motion;
				Ball_Y_Pos <= Ball_Y_Pos + Ball_Y_Motion;			
		end  
    end
       
    assign BallX = Ball_X_Pos;
    assign BallY = Ball_Y_Pos;
	 // size of the character
    assign BallH = Ball_Height;
	 assign BallW = Ball_Width;
    // size of the collider
	 assign BallCH = Collision_h;
	 assign BallCW = Collision_w;

endmodule


//					if(move_up)
//						begin
//							if (down) Ball_up_Motion = 10; //W
//						end
//				 
//				 if (!up && Ball_up_Motion>0) // !up need modify, it only check step=1
//					begin
//						Ball_Y_Pos <= Ball_Y_Pos-Ball_up_Motion;
//						Ball_up_Motion <= Ball_up_Motion - 1;
//					end
//				 else if (!down)  Ball_Y_Pos <= Ball_Y_Pos + 1;
//					begin
//						Ball_down_Motion <= Ball_down_Motion+1;
//						Ball_Y_Pos <= Ball_Y_Pos+Ball_down_Motion;
//					end
//				 else Ball_down_Motion <= 0;
