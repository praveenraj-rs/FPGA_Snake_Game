// =======================================================  
// VGA_module 640x480@60Hz  
// =======================================================  
module VGA_Module(  
    input CLK,  
    input wire [11:0] COLOUR_IN,  
    output reg [11:0] COLOUR_OUT,  
    output reg HS,  
    output reg VS,  
    output reg [9:0] ADDRH,  
    output reg [8:0] ADDRY  
);  
    wire  TRIG_1;  
    wire  HorTriggOut;  
    wire  [9:0] HorCount;  
    wire  [9:0] VerticalCount;  
  
    parameter VertTimeToPulseWidthEnd   = 10'd2;  
    parameter VertTimeToBackPorchEnd    = 10'd31;  
    parameter VertTimeToDisplayTimeEnd  = 10'd511;  
    parameter HorzTimeToPulseWidthEnd   = 10'd96;  
    parameter HorzTimeToBackPorchEnd    = 10'd144;  
    parameter HorzTimeToDisplayTimeEnd  = 10'd784;  
  
    Generic_Counter_Module # (.COUNTER_WIDTH(2), .COUNTER_MAX(3))  
    FreqCounter (.CLK(CLK), .ENABLE_IN(1'b1), .RESET(1'b0), .TRIG_OUT(TRIG_1));  
  
    Generic_Counter_Module # (.COUNTER_WIDTH(10), .COUNTER_MAX(799))  
    HorizCounter (.CLK(CLK), .ENABLE_IN(TRIG_1), .RESET(1'b0),  
                  .TRIG_OUT(HorTriggOut), .COUNT(HorCount));  
  
    Generic_Counter_Module # (.COUNTER_WIDTH(10), .COUNTER_MAX(520))  
    VerticalCounter (.CLK(CLK), .ENABLE_IN(HorTriggOut), .RESET(1'b0),  
                     .COUNT(VerticalCount));  
  
    always@(posedge CLK) begin  
        HS <= (HorCount >= HorzTimeToPulseWidthEnd);  
        VS <= (VerticalCount >= VertTimeToPulseWidthEnd);  
    end  
  
    always@(posedge CLK) begin  
        if (HorCount < HorzTimeToDisplayTimeEnd && HorCount > HorzTimeToBackPorchEnd &&  
            VerticalCount < VertTimeToDisplayTimeEnd && VerticalCount > VertTimeToBackPorchEnd)  
            COLOUR_OUT <= COLOUR_IN;  
        else  
            COLOUR_OUT <= 12'b0;  
    end  
  
    always@(posedge CLK) begin  
        if (HorCount < HorzTimeToDisplayTimeEnd && HorCount > HorzTimeToBackPorchEnd)  
            ADDRH <= HorCount - HorzTimeToBackPorchEnd;  
        else  
            ADDRH <= 0;  
    end  
  
    always@(posedge CLK) begin  
        if (VerticalCount < VertTimeToDisplayTimeEnd && VerticalCount > VertTimeToBackPorchEnd)  
            ADDRY <= VerticalCount - VertTimeToBackPorchEnd;  
        else  
            ADDRY <= 0;  
    end  
endmodule 