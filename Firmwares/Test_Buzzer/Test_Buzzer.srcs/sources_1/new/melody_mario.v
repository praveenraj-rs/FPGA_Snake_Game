module melody_mario (
    input clk,
    input rst,
    output reg [31:0] freq,
    output reg [6:0] volume
);

    reg [31:0] counter = 0;
    reg [4:0] state = 0;

    // Assume 100 MHz clock
    // 1 ms = 100,000 cycles
    parameter MS = 100_000;

    // Durations
    parameter T150 = 150 * MS;
    parameter T100 = 100 * MS;
    parameter T300 = 300 * MS;
    parameter T500 = 500 * MS;

    reg [31:0] note_time;

    // --------------------------
    // State Timing Control
    // --------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            state <= 0;
        end else begin
            if (counter < note_time)
                counter <= counter + 1;
            else begin
                counter <= 0;
                state <= state + 1;
            end
        end
    end

    // --------------------------
    // Melody Logic (Mario)
    // --------------------------
    always @(*) begin
        volume = 20;

        case(state)

            // 660, 660, delay, 660
            0: begin freq = 660; note_time = T150; end
            1: begin freq = 660; note_time = T150; end
            2: begin freq = 0;   note_time = T100; end
            3: begin freq = 660; note_time = T150; end

            // delay
            4: begin freq = 0;   note_time = T150; end

            // 510, 660
            5: begin freq = 510; note_time = T150; end
            6: begin freq = 660; note_time = T150; end

            // delay
            7: begin freq = 0;   note_time = T150; end

            // 770
            8: begin freq = 770; note_time = T150; end

            // delay
            9: begin freq = 0;   note_time = T300; end

            // 380
            10: begin freq = 380; note_time = T150; end

            // long delay
            11: begin freq = 0;   note_time = T500; end

            default: begin
                freq = 0;
                note_time = T500;
            end

        endcase
    end

endmodule