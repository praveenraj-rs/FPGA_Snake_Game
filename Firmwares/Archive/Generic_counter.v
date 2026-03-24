`timescale 1ns / 1ps  
// =======================================================  
// Generic_counter: reusable synchronous counter  
// =======================================================  
module Generic_counter(  
        CLK,  
        RESET,  
        ENABLE_IN,  
        TRIG_OUT,  
        COUNT  
    );  
    parameter COUNTER_WIDTH = 1;  
    parameter COUNTER_MAX   = 1;  
    input  CLK;  
    input  RESET;  
    input  ENABLE_IN;  
    output TRIG_OUT;  
    output [COUNTER_WIDTH-1:0] COUNT;  
  
    reg [COUNTER_WIDTH-1:0] count_value = 0;  
    reg Trigger_out;  
  
    always@(posedge CLK) begin  
        if(RESET)  
            count_value <= 0;  
        else if (ENABLE_IN) begin  
            if(count_value == COUNTER_MAX)  
                count_value <= 0;  
            else  
                count_value <= count_value + 1;  
        end  
    end  
  
    always@(posedge CLK) begin  
        if (RESET)  
            Trigger_out <= 0;  
        else begin  
            if (ENABLE_IN && (count_value == COUNTER_MAX))  
                Trigger_out <= 1;  
            else  
                Trigger_out <= 0;  
        end  
    end  
  
    assign COUNT    = count_value;  
    assign TRIG_OUT = Trigger_out;  
endmodule 
