//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_h, Ball_w,
								input 		[0:29][0:39] tile,
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on, tile_on;
	 logic [9:0] row, col;
	
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
	  
    always_comb
    begin:Ball_on_proc
        if ((DrawX >= BallX - Ball_w) &&
				(DrawX <= BallX + Ball_w) &&
				(DrawY >= BallY - Ball_h) &&
				(DrawY <= BallY + Ball_h))
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 
	  
	 always_comb
    begin:Tile_on_proc
      col = DrawX >> 4;
		row = DrawY >> 4;
		tile_on = tile[row][col];
     end 
	
       
    always_comb
    begin:RGB_Display
        if (ball_on) 
        begin 
            Red = 8'hff;
            Green = 8'h55;
            Blue = 8'h00;
        end  
		  else if (tile_on)
		  begin
				Red = 8'h55;
            Green = 8'h55;
            Blue = 8'h00;
		  end
        else 
        begin 
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h7f - DrawX[9:3];
        end      
    end 
    
endmodule
