// =======================================================
// apple_beep
// Produces a short 880 Hz beep (~150 ms) each time
// "trigger" goes high (TARGET_REACHED from snake control).
// While beep is active: freq=880, volume=25
// While silent:         freq=0,   volume=0
// =======================================================
module apple_beep (
    input  wire        clk,
    input  wire        rst,
    input  wire        trigger,    // one-cycle pulse: apple eaten
    output reg  [31:0] freq,
    output reg  [6:0]  volume
);
    // 100 MHz clock -> 1 ms = 100_000 cycles
    // 150 ms beep duration
    parameter BEEP_FREQ     = 32'd880;
    parameter BEEP_VOLUME   = 7'd25;
    parameter BEEP_DURATION = 32'd15_000_000; // 150 ms @ 100 MHz

    reg [31:0] beep_counter;
    reg        beeping;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            beep_counter <= 0;
            beeping      <= 0;
        end else begin
            if (trigger && !beeping) begin
                // Start a fresh beep
                beeping      <= 1;
                beep_counter <= 0;
            end else if (beeping) begin
                if (beep_counter < BEEP_DURATION - 1)
                    beep_counter <= beep_counter + 1;
                else begin
                    beeping      <= 0;
                    beep_counter <= 0;
                end
            end
        end
    end

    always @(*) begin
        if (beeping) begin
            freq   = BEEP_FREQ;
            volume = BEEP_VOLUME;
        end else begin
            freq   = 32'd0;
            volume = 7'd0;
        end
    end

endmodule