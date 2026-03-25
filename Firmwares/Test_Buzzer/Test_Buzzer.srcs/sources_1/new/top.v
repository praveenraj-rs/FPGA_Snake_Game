module top (
    input clk,       // 100 MHz
    input rst,       // button
    output pwm_out   // to buzzer
);

    wire [31:0] freq;
    wire [6:0] volume;

    // Melody generator
    melody_starwars melody (
        .clk(clk),
        .rst(rst),
        .freq(freq),
        .volume(volume)
    );
    
    // Melody generator
//    melody_mario melody (
//        .clk(clk),
//        .rst(rst),
//        .freq(freq),
//        .volume(volume)
//    );

    // PWM generator
    pwm_variable pwm (
        .clk(clk),
        .rst(rst),
        .freq(freq),
        .duty(volume),
        .pwm_out(pwm_out)
    );

endmodule