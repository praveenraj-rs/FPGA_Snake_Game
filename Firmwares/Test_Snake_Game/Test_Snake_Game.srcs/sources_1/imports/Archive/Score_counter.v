// =======================================================  
// Score_counter: win@20, lose@60s (<10), self-hit loss  
// =======================================================  
module Score_counter(  
    input CLK,  
    input RESET,  
    input TARGET_REACHED,  
    input Timed_Mode,              // kept for compat (not gating timer)  
    input [1:0] MSM_STATE,  
    input SELF_HIT,                // NEW  
    output [3:0] SEG_SELECT_OUT,  
    output [7:0] DEC_OUT,  
    output reg LOST,  
    output reg SCORE_WIN,  
    output reg WIN  
    );  
  
    parameter timer = 6;  // 60 seconds  
  
    wire [4:0] DecCountAndDOT0;  
    wire [4:0] DecCountAndDOT1;  
    wire [4:0] DecCountAndDOT2;  
    wire [4:0] DecCountAndDOT3;  
  
    wire [3:0] DecCount0;  // tens of points (0..2)  
    wire [3:0] DecCount1;  // units of points (0..9)  
    wire [3:0] DecCount2;  // tens of seconds (0..9)  
    wire [3:0] DecCount3;  // seconds (0..9)  
  
    wire Bit17TriggOut;  
    wire [1:0] StrobeCount;  
  
    wire TRIG1;  
    wire TRIG_2;  
    wire OneSec;  
  
    wire [4:0] MuxOut;  
    wire HalfCount;  
  
    reg STOP;  
    initial STOP = 0;  
  
    assign DecCountAndDOT2 = {1'b1, DecCount2};  
    assign DecCountAndDOT3 = {1'b1, DecCount3};  
    assign DecCountAndDOT0 = {1'b1, DecCount0};  
    assign DecCountAndDOT1 = {1'b1, DecCount1};  
  
    Multiplexer_4way Mux4(  
        .CONTROL(StrobeCount),  
        .IN0(DecCountAndDOT0),  
        .IN1(DecCountAndDOT1),  
        .IN2(DecCountAndDOT2),  
        .IN3(DecCountAndDOT3),  
        .OUT(MuxOut)  
    );  
  
    // display refresh + strobe  
    wire [16:0] dummy_disprefresh;  
    Generic_counter # (.COUNTER_WIDTH(17), .COUNTER_MAX(99999))  
    DispRefresh(  
        .CLK(CLK), .RESET(1'b0), .ENABLE_IN(1'b1),  
        .TRIG_OUT(Bit17TriggOut), .COUNT(dummy_disprefresh)  
    );  
  
    Generic_counter # (.COUNTER_WIDTH(2), .COUNTER_MAX(3))  
    StrobeCounter(  
        .CLK(CLK), .RESET(1'b0), .ENABLE_IN(Bit17TriggOut),  
        .COUNT(StrobeCount)  
    );  
  
    Generic_counter # (.COUNTER_WIDTH(2), .COUNTER_MAX(1))  
    HalfCounter(  
        .CLK(CLK), .RESET(1'b0), .ENABLE_IN(1'b1),  
        .TRIG_OUT(HalfCount)  
    );  
  
    // points units  
    Generic_counter # (.COUNTER_WIDTH(4), .COUNTER_MAX(9))  
    SecDecimal(  
        .CLK(CLK), .RESET(RESET),  
        .ENABLE_IN(TARGET_REACHED && HalfCount),  
        .TRIG_OUT(TRIG1), .COUNT(DecCount1)  
    );  
  
    // points tens (0..2) => up to 20  
    Generic_counter # (.COUNTER_WIDTH(4), .COUNTER_MAX(2))  
    FirstDecimal(  
        .CLK(CLK), .RESET(RESET),  
        .ENABLE_IN(TRIG1),  
        .COUNT(DecCount0)  
    );  
  
    decode_world Seg7(  
        .SEG_SELECT_IN(StrobeCount),  
        .BIN_IN(MuxOut[3:0]),  
        .DOT_IN(MuxOut[4]),  
        .SEG_SELECT_OUT(SEG_SELECT_OUT),  
        .HEX_OUT(DEC_OUT)  
    );  
  
    // Win flag for FSM when score == 20  
    always@(posedge CLK) begin  
        if (DecCount0 == 4'd2 && DecCount1 == 4'd0)  
            SCORE_WIN <= 1;  
        else  
            SCORE_WIN <= 0;  
    end  
  
    // Timer: runs whenever in PLAY and not stopped  
    Generic_counter # (.COUNTER_WIDTH(28), .COUNTER_MAX(99999999))  
    OneSecond(  
        .CLK(CLK), .RESET(RESET),  
        .ENABLE_IN(MSM_STATE == 2'd1 && ~STOP),  
        .TRIG_OUT(OneSec)  
    );  
  
    Generic_counter # (.COUNTER_WIDTH(4), .COUNTER_MAX(9))  
    Seconds(  
        .CLK(CLK), .RESET(RESET),  
        .ENABLE_IN(OneSec),  
        .TRIG_OUT(TRIG_2), .COUNT(DecCount3)  
    );  
  
    Generic_counter # (.COUNTER_WIDTH(4), .COUNTER_MAX(9))  
    DecSeconds(  
        .CLK(CLK), .RESET(RESET),  
        .ENABLE_IN(TRIG_2),  
        .COUNT(DecCount2)  
    );  
  
    // Decisions  
    always@(posedge CLK) begin  
        // default: run timer in PLAY, stop otherwise  
        if (MSM_STATE == 2'd1) STOP <= 0;  
        else                   STOP <= 1;  
  
        // Self-hit ? immediate loss  
        if (SELF_HIT) begin  
            LOST <= 1;  
            WIN  <= 0;  
            STOP <= 1;  
        end  
        // Lose if time >=60s and score < 10  
        else if (DecCount2 >= timer && DecCount0 == 0) begin  
            LOST <= 1;  
            WIN  <= 0;  
            STOP <= 1;  
        end  
        // Win if 20 points before timeout  
        else if (DecCount2 < timer && DecCount0 == 4'd2 && DecCount1 == 4'd0) begin  
            WIN  <= 1;  
            LOST <= 0;  
            STOP <= 1;  
        end  
  
        if (RESET) begin  
            LOST <= 0;  
            WIN  <= 0;  
            STOP <= 0; // allow timer to run on next PLAY  
        end  
    end  
endmodule  