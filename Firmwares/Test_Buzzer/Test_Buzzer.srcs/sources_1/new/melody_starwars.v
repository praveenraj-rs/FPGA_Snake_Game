module melody_starwars (
    input clk,
    input rst,
    output reg [31:0] freq,
    output reg [6:0] volume
);

    reg [31:0] counter = 0;
    reg [3:0] state = 0;

    // 0.5 sec per note (100MHz clock)
    parameter NOTE_TIME = 50_000_000;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            state <= 0;
        end else begin
            if (counter < NOTE_TIME)
                counter <= counter + 1;
            else begin
                counter <= 0;
                state <= state + 1;
            end
        end
    end

    always @(*) begin
        volume = 20; // constant volume

        case(state)
            0,1,2: freq = 440;
            3:     freq = 349;
            4:     freq = 523;
            5:     freq = 440;

            6:     freq = 349;
            7:     freq = 523;
            8:     freq = 440;

            default: freq = 0;
        endcase
    end

endmodule