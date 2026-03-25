// =======================================================
// buzzer_controller
// Selects audio based on game state:
//   START  (MSM=00) -> Star Wars melody (loops)
//   PLAY   (MSM=01) -> silent, except beep on TARGET_REACHED
//   WINNER (MSM=10) -> Mario melody (loops)
//   LOSER  (MSM=11) -> silent
// =======================================================
module buzzer_controller(
    input  wire        CLK,        // 100 MHz
    input  wire        RESET,
    input  wire [1:0]  MSM_STATE,
    input  wire        TARGET_REACHED,  // pulse when apple eaten
    input  wire        WIN,
    output wire        pwm_out
);

    wire [31:0] freq_starwars;
    wire [6:0]  vol_starwars;

    wire [31:0] freq_mario;
    wire [6:0]  vol_mario;

    wire [31:0] freq_beep;
    wire [6:0]  vol_beep;

    reg  [31:0] freq_sel;
    reg  [6:0]  vol_sel;

    // -------------------------------------------------------
    // Star Wars melody instance
    // -------------------------------------------------------
    melody_starwars sw_inst (
        .clk   (CLK),
        .rst   (RESET),
        .freq  (freq_starwars),
        .volume(vol_starwars)
    );

    // -------------------------------------------------------
    // Mario melody instance (plays on WIN)
    // -------------------------------------------------------
    melody_mario mario_inst (
        .clk   (CLK),
        .rst   (RESET),
        .freq  (freq_mario),
        .volume(vol_mario)
    );

    // -------------------------------------------------------
    // Apple beep: short 880 Hz tone, ~150 ms
    // -------------------------------------------------------
    apple_beep beep_inst (
        .clk           (CLK),
        .rst           (RESET),
        .trigger       (TARGET_REACHED),
        .freq          (freq_beep),
        .volume        (vol_beep)
    );

    // -------------------------------------------------------
    // Mux: pick the right audio source
    // -------------------------------------------------------
    always @(*) begin
        case (MSM_STATE)
            2'b00: begin   // START -> Star Wars
                freq_sel = freq_starwars;
                vol_sel  = vol_starwars;
            end
            2'b01: begin   // PLAY -> beep only on apple catch
                freq_sel = freq_beep;
                vol_sel  = vol_beep;
            end
            2'b10: begin   // WINNER -> Mario
                freq_sel = freq_mario;
                vol_sel  = vol_mario;
            end
            default: begin // LOSER -> silence
                freq_sel = 32'd0;
                vol_sel  = 7'd0;
            end
        endcase
    end

    // -------------------------------------------------------
    // Shared PWM generator (reuse your existing module)
    // -------------------------------------------------------
    pwm_variable pwm_inst (
        .clk    (CLK),
        .rst    (RESET),
        .freq   (freq_sel),
        .duty   (vol_sel),
        .pwm_out(pwm_out)
    );

endmodule