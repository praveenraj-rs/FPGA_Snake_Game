// =======================================================  
// Master_state_machine: adds NEW_GAME pulse on restart  
// =======================================================  
module Master_state_machine(  
    input BTNL,  
    input BTNR,  
    input BTNU,  
    input BTND,  
    input CLK,  
    input RESET,  
    input SCORE_WIN,  
    input LOST,  
    input WIN,  
    output [1:0] MSM_STATE,  
    output reg NEW_GAME  
    );  
  
    parameter START  = 2'd0;  
    parameter PLAY   = 2'd1;  
    parameter WINNER = 2'd2;  
    parameter LOSER  = 2'd3;  
  
    reg [1:0] Curr_state;  
    reg [1:0] Next_state;  
  
    initial begin  
        Curr_state = START;  
        NEW_GAME   = 1'b0;  
    end  
  
    assign MSM_STATE = Curr_state;  
  
    always@(posedge CLK or posedge RESET) begin  
      if (RESET) begin  
           Curr_state <= START;  
           NEW_GAME   <= 1'b0;  
      end else begin  
           Curr_state <= Next_state;  
           if ((Curr_state == WINNER || Curr_state == LOSER) && (Next_state == START))  
               NEW_GAME <= 1'b1;  
           else  
               NEW_GAME <= 1'b0;  
      end  
    end  
  
    always@(*) begin  
        case (Curr_state)  
            START:   if (BTNL || BTNU || BTNR || BTND) Next_state = PLAY;  
                     else Next_state = START;  
  
            PLAY:    if (SCORE_WIN || WIN) Next_state = WINNER;  
                     else if (LOST) Next_state = LOSER;  
                     else Next_state = PLAY;  
  
            WINNER:  if (RESET || BTNL || BTNU || BTNR || BTND)  
                         Next_state = START;  
                     else Next_state = WINNER;  
  
            LOSER:   if (RESET || BTNL || BTNU || BTNR || BTND)  
                         Next_state = START;  
                     else Next_state = LOSER;  
        endcase  
    end  
endmodule  