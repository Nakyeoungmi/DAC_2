module seg7_dynamic(
    input clk, rst,
    input [3:0] digit3, digit2, digit1, digit0,
    output reg [6:0] seg,
    output reg [3:0] seg_sel
);
    reg [1:0] sel;
    reg [3:0] data;
    reg [15:0] cnt;

    always @(posedge clk or negedge rst) begin
        if(!rst) cnt <= 0;
        else cnt <= cnt + 1;
    end

    always @(posedge cnt[15] or negedge rst) begin
        if(!rst) sel <= 0;
        else sel <= sel + 1;
    end

    always @(*) begin
        case(sel)
            2'd0: begin seg_sel=4'b1110; data=digit0; end
            2'd1: begin seg_sel=4'b1101; data=digit1; end
            2'd2: begin seg_sel=4'b1011; data=digit2; end
            2'd3: begin seg_sel=4'b0111; data=digit3; end
        endcase
    end

    always @(*) begin
        case(data)
            4'd0: seg=7'b1000000;
            4'd1: seg=7'b1111001;
            4'd2: seg=7'b0100100;
            4'd3: seg=7'b0110000;
            4'd4: seg=7'b0011001;
            4'd5: seg=7'b0010010;
            4'd6: seg=7'b0000010;
            4'd7: seg=7'b1111000;
            4'd8: seg=7'b0000000;
            4'd9: seg=7'b0010000;
            default: seg=7'b1111111;
        endcase
    end
endmodule
