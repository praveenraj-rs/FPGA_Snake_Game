module Top_Module(
    input CLK,
    input RESET,
    output [11:0] COLOUR_OUT,
    output HS,
    output VS
);

    wire [9:0] X;
    wire [8:0] Y;
    wire [11:0] pixel_colour;

    VGA_Module vga(
        .CLK(CLK),
        .COLOUR_IN(pixel_colour),
        .COLOUR_OUT(COLOUR_OUT),
        .HS(HS),
        .VS(VS),
        .ADDRH(X),
        .ADDRY(Y)
    );

    FPGA_Display_Module name(
        .CLK(CLK),
        .X(X),
        .Y(Y),
        .COLOUR_OUT(pixel_colour)
    );

endmodule
