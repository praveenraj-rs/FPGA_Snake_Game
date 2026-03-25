// =======================================================  
// decode_world: 7-seg encoder (active-low segments)  
// =======================================================  
module decode_world(  
    input [1:0] SEG_SELECT_IN,  
    input [3:0] BIN_IN,  
    input DOT_IN,  
    output reg [3:0] SEG_SELECT_OUT,  
    output reg [7:0] HEX_OUT  
);  
    always @(*) begin  
        case (SEG_SELECT_IN)  
            2'b00: SEG_SELECT_OUT = 4'b1110;  
            2'b01: SEG_SELECT_OUT = 4'b1101;  
            2'b10: SEG_SELECT_OUT = 4'b1011;  
            2'b11: SEG_SELECT_OUT = 4'b0111;  
            default: SEG_SELECT_OUT = 4'b1111;  
        endcase  
    end  
  
    always @(*) begin  
        case (BIN_IN)  
            4'b0000: HEX_OUT[6:0] = 7'b1000000; // 0  
            4'b0001: HEX_OUT[6:0] = 7'b1111001; // 1  
            4'b0010: HEX_OUT[6:0] = 7'b0100100; // 2  
            4'b0011: HEX_OUT[6:0] = 7'b0110000; // 3  
            4'b0100: HEX_OUT[6:0] = 7'b0011001; // 4  
            4'b0101: HEX_OUT[6:0] = 7'b0010010; // 5  
            4'b0110: HEX_OUT[6:0] = 7'b0000010; // 6  
            4'b0111: HEX_OUT[6:0] = 7'b1111000; // 7  
            4'b1000: HEX_OUT[6:0] = 7'b0000000; // 8  
            4'b1001: HEX_OUT[6:0] = 7'b0010000; // 9  
            default: HEX_OUT[6:0] = 7'b1111111; // blank  
        endcase  
        HEX_OUT[7] = ~DOT_IN; // DOT is active-low  
    end  
endmodule  