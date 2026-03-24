module FPGA_Display_Module(
    input wire CLK,
    input wire [9:0] X,     // ADDRH from VGA
    input wire [8:0] Y,     // ADDRY from VGA
    output reg [11:0] COLOUR_OUT
);

   // Screen center position
    parameter START_X = 200;
    parameter START_Y = 190;

    // Letter size
    parameter WIDTH  = 60;
    parameter HEIGHT = 100;
    parameter THICK  = 8;   // Stroke thickness

    always @(*) begin
        // Default BLACK background
        COLOUR_OUT = 12'b0000_0000_0000;

        //-----------------------
        // Letter F
        //-----------------------
        if (X >= START_X && X < START_X + WIDTH &&
            Y >= START_Y && Y < START_Y + HEIGHT) begin

            if (X < START_X + THICK ||                      // Left vertical
                Y < START_Y + THICK ||                      // Top bar
                (Y > START_Y + HEIGHT/2 - THICK/2 &&
                 Y < START_Y + HEIGHT/2 + THICK/2))         // Middle bar
                COLOUR_OUT = 12'b1111_1111_1111; // WHITE
        end

        //-----------------------
        // Letter P
        //-----------------------
        else if (X >= START_X + WIDTH + 20 &&
                 X < START_X + 2*WIDTH + 20 &&
                 Y >= START_Y &&
                 Y < START_Y + HEIGHT) begin

            if (X < START_X + WIDTH + 20 + THICK ||         // Left vertical
                Y < START_Y + THICK ||                      // Top bar
                (Y > START_Y + HEIGHT/2 - THICK/2 &&
                 Y < START_Y + HEIGHT/2 + THICK/2) ||       // Middle
                (X > START_X + 2*WIDTH + 20 - THICK &&
                 Y < START_Y + HEIGHT/2))                   // Right top
                COLOUR_OUT = 12'b1111_1111_1111;
        end

        //-----------------------
        // Letter G
        //-----------------------
        else if (X >= START_X + 2*(WIDTH + 20) &&
                 X < START_X + 3*WIDTH + 40 &&
                 Y >= START_Y &&
                 Y < START_Y + HEIGHT) begin

            if (Y < START_Y + THICK ||                      // Top
                Y > START_Y + HEIGHT - THICK ||             // Bottom
                X < START_X + 2*(WIDTH+20) + THICK ||       // Left
                (X > START_X + 3*WIDTH + 40 - THICK &&
                 Y > START_Y + HEIGHT/2) ||                 // Right bottom
                (Y > START_Y + HEIGHT/2 - THICK/2 &&
                 X > START_X + 2*(WIDTH+20) + WIDTH/2))     // Middle right
                COLOUR_OUT = 12'b1111_1111_1111;
        end

        //-----------------------
        // Letter A
        //-----------------------
        else if (X >= START_X + 3*(WIDTH + 20) &&
                 X < START_X + 4*WIDTH + 60 &&
                 Y >= START_Y &&
                 Y < START_Y + HEIGHT) begin

            if (Y < START_Y + THICK ||                      // Top
                (Y > START_Y + HEIGHT/2 - THICK/2 &&
                 Y < START_Y + HEIGHT/2 + THICK/2) ||       // Middle
                X < START_X + 3*(WIDTH+20) + THICK ||       // Left
                X > START_X + 4*WIDTH + 60 - THICK)         // Right
                COLOUR_OUT = 12'b1111_1111_1111;
        end

    end

endmodule
