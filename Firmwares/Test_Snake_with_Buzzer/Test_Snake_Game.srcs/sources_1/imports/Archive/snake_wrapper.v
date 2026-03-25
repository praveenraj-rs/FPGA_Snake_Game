// =======================================================
// snake_wrapper (Top) - with buzzer audio
// CHANGES from original:
//   1. Added output wire  pwm_out
//   2. Added buzzer_controller instance at the bottom
//   All other wiring is IDENTICAL to the original.
// =======================================================
module snake_wrapper(
    input  CLK,
    input  RESET,
    input  BTNU,
    input  BTND,
    input  BTNL,
    input  BTNR,
    input  GAME_IN,
    output [11:0] COLOUR_OUT,
    output HS,
    output VS,
    output [3:0] SEG_SELECT_OUT,
    output [7:0] DEC_OUT,
    output        pwm_out          // <-- NEW: buzzer output
);

    wire [1:0]  MSM_STATE, NAV_STATE;
    wire [7:0]  TARGET_ADDR_H;
    wire [6:0]  TARGET_ADDR_V;
    wire [11:0] COLOUR_OUTS;
    wire [9:0]  ADDRH;
    wire [8:0]  ADDRV;
    wire TARGET_REACHED, SCORE_WIN, LOST, WIN, SELF_HIT, NEW_GAME, Timed_Mode;

    wire SOFT_RESET = RESET | NEW_GAME;

    // -------------------------------------------------------
    // All original module instances - UNCHANGED
    // -------------------------------------------------------
    Master_state_machine Master(
        .BTNU(BTNU), .BTND(BTND), .BTNR(BTNR), .BTNL(BTNL),
        .CLK(CLK), .RESET(RESET), .SCORE_WIN(SCORE_WIN),
        .LOST(LOST), .WIN(WIN),
        .MSM_STATE(MSM_STATE), .NEW_GAME(NEW_GAME)
    );

    Navigation_state_machine Navigation(
        .BTNU(BTNU), .BTND(BTND), .BTNR(BTNR), .BTNL(BTNL),
        .CLK(CLK), .RESET(SOFT_RESET), .NAV_STATE(NAV_STATE)
    );

    random_num_gen Target(
        .RESET(SOFT_RESET), .CLK(CLK),
        .TARGET_REACHED(TARGET_REACHED),
        .TARGET_ADDR_H(TARGET_ADDR_H),
        .TARGET_ADDR_V(TARGET_ADDR_V)
    );

    Score_counter Score(
        .RESET(SOFT_RESET), .CLK(CLK),
        .TARGET_REACHED(TARGET_REACHED),
        .SELF_HIT(SELF_HIT),
        .SEG_SELECT_OUT(SEG_SELECT_OUT),
        .DEC_OUT(DEC_OUT),
        .SCORE_WIN(SCORE_WIN),
        .Timed_Mode(Timed_Mode),
        .MSM_STATE(MSM_STATE),
        .LOST(LOST),
        .WIN(WIN)
    );

    VGA_module VGA(
        .COLOUR_IN(COLOUR_OUTS), .CLK(CLK),
        .HS(HS), .VS(VS),
        .ADDRH(ADDRH), .ADDRY(ADDRV),
        .COLOUR_OUT(COLOUR_OUT)
    );

    Snake_control Control(
        .MSM_STATE(MSM_STATE),
        .NAV_STATE(NAV_STATE),
        .TARGET_ADDR_H(TARGET_ADDR_H),
        .TARGET_ADDR_V(TARGET_ADDR_V),
        .ADDRH(ADDRH),
        .ADDRY(ADDRV),
        .COLOUR_OUT(COLOUR_OUTS),
        .TARGET_REACHED(TARGET_REACHED),
        .SELF_HIT(SELF_HIT),
        .CLK(CLK),
        .GAME_IN(GAME_IN),
        .Timed_Mode(Timed_Mode),
        .LOST(LOST),
        .WIN(WIN),
        .RESET(SOFT_RESET)
    );

    // -------------------------------------------------------
    // NEW: Buzzer audio controller
    // Uses MSM_STATE and TARGET_REACHED - already wired above
    // -------------------------------------------------------
    buzzer_controller Buzzer(
        .CLK           (CLK),
        .RESET         (RESET),
        .MSM_STATE     (MSM_STATE),
        .TARGET_REACHED(TARGET_REACHED),
        .WIN           (WIN),
        .pwm_out       (pwm_out)
    );

endmodule