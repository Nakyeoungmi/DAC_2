`timescale 1ns / 1ps
module seg7_dynamic(
    input clk, rst,
    input [3:0] digit3, digit2, digit1, digit0,
    output reg [6:0] seg,
    output reg [3:0] seg_sel
);
    reg [15:0] div;
    reg [1:0] sel;
    reg [3:0] d;

    always @(posedge clk or negedge rst) begin
        if(!rst) div <= 16'd0;
        else     div <= div + 1'b1;
    end

    always @(posedge div[15] or negedge rst) begin
        if(!rst) sel <= 2'd0;
        else     sel <= sel + 1'b1;
    end

    always @(*) begin
        case(sel)
            2'd0: begin seg_sel = 4'b1110; d = digit0; end
            2'd1: begin seg_sel = 4'b1101; d = digit1; end
            2'd2: begin seg_sel = 4'b1011; d = digit2; end
            2'd3: begin seg_sel = 4'b0111; d = digit3; end
        endcase
    end

    always @(*) begin
        case(d)
            4'd0: seg = 7'b0111111;
            4'd1: seg = 7'b0000110;
            4'd2: seg = 7'b1011011;
            4'd3: seg = 7'b1001111;
            4'd4: seg = 7'b1100110;
            4'd5: seg = 7'b1101101;
            4'd6: seg = 7'b1111101;
            4'd7: seg = 7'b0000111;
            4'd8: seg = 7'b1111111;
            4'd9: seg = 7'b1101111;
            default: seg = 7'b0000000;
        endcase
    end
endmodule
