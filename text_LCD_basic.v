module text_LCD_basic(
    input clk, rst,
    input [127:0] line1, 
    input [7:0] line2,  
    output reg LCD_E, LCD_RS, LCD_RW,
    output reg [7:0] LCD_DATA
);
    
endmodule
