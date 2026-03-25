module pwm_variable ( 
    input wire clk,             // 100 MHz 
    input wire rst, 
    input wire [31:0] freq,     // Hz 
    input wire [6:0] duty,      // 0-100% 
    output reg pwm_out 
); 
 
    reg [31:0] period; 
    reg [31:0] high_time; 
    reg [31:0] counter = 0; 
 
    always @(*) begin 
        if (freq > 0) 
            period = 100_000_000 / freq; 
        else 
            period = 1; 
    end 
 
    always @(*) begin 
        high_time = (period * duty) / 100; 
    end 
 
    always @(posedge clk or posedge rst) begin 
        if (rst) begin 
            counter <= 0; 
            pwm_out <= 0; 
        end else begin 
            if (counter < period - 1) 
                counter <= counter + 1; 
            else 
                counter <= 0; 
 
            if (counter < high_time) 
                pwm_out <= 1; 
            else 
                pwm_out <= 0; 
        end 
    end 
 
endmodule 