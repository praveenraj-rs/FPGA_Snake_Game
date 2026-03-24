// =======================================================  
// Navigation_state_machine  
// =======================================================  
module Navigation_state_machine(  
    input CLK,  
    input BTNR,  
    input BTNL,  
    input BTND,  
    input BTNU,  
    input RESET,  
    output [1:0] NAV_STATE  
);  
    parameter UP    = 2'd0;  
    parameter LEFT  = 2'd1;  
    parameter RIGHT = 2'd2;  
    parameter DOWN  = 2'd3;  
  
    reg [1:0] Curr_state;  
    reg [1:0] Next_state;  
  
    assign NAV_STATE = Curr_state;  
  
    always@(posedge CLK or posedge RESET) begin  
        if (RESET)  
            Curr_state <= UP;  
        else  
            Curr_state <= Next_state;  
    end  
  
    always@(*) begin  
        case (Curr_state)  
            UP:    if (BTNL) Next_state = LEFT;  
                   else if(BTNR) Next_state = RIGHT;  
                   else Next_state = UP;  
  
            LEFT:  if (BTNU) Next_state = UP;  
                   else if(BTND) Next_state = DOWN;  
                   else Next_state = LEFT;  
  
            RIGHT: if (BTNU) Next_state = UP;  
                   else if(BTND) Next_state = DOWN;  
                   else Next_state = RIGHT;  
  
            DOWN:  if (BTNL) Next_state = LEFT;  
                   else if(BTNR) Next_state = RIGHT;  
                   else Next_state = DOWN;  
        endcase  
    end  
endmodule