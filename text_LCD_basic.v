module text_LCD_basic(
    input clk, rst,
    input [127:0] line1, 
    input [7:0] line2,  `timescale 1ns / 1ps
module text_LCD_basic(
    input clk, rst,
    input [7:0] val,
    output reg LCD_E, LCD_RS, LCD_RW,
    output reg [7:0] LCD_DATA
);
    localparam CLEAR=8'h01, FUNCTION_SET=8'h38, DISP_ONOFF=8'h0C, ENTRY_MODE=8'h06;
    localparam LINE1_ADDR=8'h80, LINE2_ADDR=8'hC0;
    localparam S_DELAY=3'd0, S_FUNC=3'd1, S_DISP=3'd2, S_ENTRY=3'd3,
               S_CLEAR=3'd4, S_L1=3'd5, S_L2=3'd6, S_WAIT=3'd7;

    reg [2:0]  st;
    reg [15:0] cnt;
    reg [4:0]  idx;

    wire [3:0] h = (val/100)%10;
    wire [3:0] t = (val/10)%10;
    wire [3:0] o = val%10;

    function [7:0] dec2asc;
        input [3:0] d;
        begin dec2asc = 8'd48 + d; end
    endfunction

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            st<=S_DELAY; cnt<=0; idx<=0;
            LCD_E<=1'b0; LCD_RS<=1'b0; LCD_RW<=1'b0; LCD_DATA<=8'h00;
        end else begin
            case(st)
                S_DELAY: begin
                    LCD_E<=1'b0; LCD_RS<=1'b0; LCD_RW<=1'b0;
                    if(cnt>=16'd1000) begin cnt<=0; st<=S_FUNC; end
                    else cnt<=cnt+1;
                end
                S_FUNC:  begin LCD_RS<=1'b0; LCD_DATA<=FUNCTION_SET; st<=S_DISP; end
                S_DISP:  begin LCD_RS<=1'b0; LCD_DATA<=DISP_ONOFF;    st<=S_ENTRY; end
                S_ENTRY: begin LCD_RS<=1'b0; LCD_DATA<=ENTRY_MODE;    st<=S_CLEAR; end
                S_CLEAR: begin LCD_RS<=1'b0; LCD_DATA<=CLEAR;         st<=S_L1;    idx<=0; end

                S_L1: begin
                    if(idx==0) begin LCD_RS<=1'b0; LCD_DATA<=LINE1_ADDR; idx<=idx+1; end
                    else begin
                        LCD_RS<=1'b1;
                        case(idx)
                            1:  LCD_DATA<="D";
                            2:  LCD_DATA<="A";
                            3:  LCD_DATA<="C";
                            4:  LCD_DATA<=" ";
                            5:  LCD_DATA<="V";
                            6:  LCD_DATA<="a";
                            7:  LCD_DATA<="l";
                            8:  LCD_DATA<="u";
                            9:  LCD_DATA<="e";
                            10: LCD_DATA<=":";
                            11: LCD_DATA<=" ";
                            default: begin idx<=0; st<=S_L2; end
                        endcase
                        if(idx!=0) idx<=idx+1;
                    end
                end

                S_L2: begin
                    if(idx==0) begin LCD_RS<=1'b0; LCD_DATA<=LINE2_ADDR; idx<=idx+1; end
                    else begin
                        LCD_RS<=1'b1;
                        case(idx)
                            1:  LCD_DATA <= dec2asc(h);
                            2:  LCD_DATA <= dec2asc(t);
                            3:  LCD_DATA <= dec2asc(o);
                            default: begin idx<=0; st<=S_WAIT; end
                        endcase
                        if(idx!=0) idx<=idx+1;
                    end
                end

                S_WAIT: begin
                    if(cnt>=16'd50000) begin cnt<=0; st<=S_L2; end
                    else cnt<=cnt+1;
                end
            endcase

            LCD_E <= ~LCD_E; 
        end
    end
endmodule

    output reg LCD_E, LCD_RS, LCD_RW,
    output reg [7:0] LCD_DATA
);
    
endmodule
