`timescale 1ns / 1ps

module DAC(
    input clk, rst,
    input [5:0] btn,
    input add_sel,
    output reg dac_csn, dac_ldacn, dac_wrn, dac_a_b,
    output reg [7:0] dac_d,
    output reg [7:0] led_out,

    output [6:0] seg,
    output [3:0] seg_sel,

    output LCD_E, LCD_RS, LCD_RW,
    output [7:0] LCD_DATA
);

reg [7:0] dac_d_temp;
reg [7:0] cnt;
wire [5:0] btn_t;
reg [1:0] state;

parameter DELAY   = 2'b00,
          SET_WRN = 2'b01,
          UP_DATA = 2'b10;

oneshot_universal #(.WIDTH(6)) O1(clk, rst, {btn[5:0]}, {btn_t[5:0]});

always @(posedge clk or negedge rst) begin
    if(!rst) state <= DELAY;
    else begin
        case(state)
            DELAY   : if(cnt == 200) state <= SET_WRN;
            SET_WRN : if(cnt == 50)  state <= UP_DATA;
            UP_DATA : if(cnt == 30)  state <= DELAY;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) cnt <= 8'd0;
    else begin
        case(state)
            DELAY   : cnt <= (cnt >= 8'd200) ? 8'd0 : cnt + 1'b1;
            SET_WRN : cnt <= (cnt >= 8'd50 ) ? 8'd0 : cnt + 1'b1;
            UP_DATA : cnt <= (cnt >= 8'd30 ) ? 8'd0 : cnt + 1'b1;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) dac_wrn <= 1'b1;
    else begin
        case(state)
            DELAY   : dac_wrn <= 1'b1;
            SET_WRN : dac_wrn <= 1'b0;
            UP_DATA : dac_d   <= dac_d_temp;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dac_d_temp <= 8'd0;
        led_out    <= 8'h55;
    end
    else begin
        if      (btn_t == 6'b100000) dac_d_temp <= dac_d_temp - 8'd1;
        else if (btn_t == 6'b010000) dac_d_temp <= dac_d_temp + 8'd1;
        else if (btn_t == 6'b001000) dac_d_temp <= dac_d_temp - 8'd2;
        else if (btn_t == 6'b000100) dac_d_temp <= dac_d_temp + 8'd2;
        else if (btn_t == 6'b000010) dac_d_temp <= dac_d_temp - 8'd8;
        else if (btn_t == 6'b000001) dac_d_temp <= dac_d_temp + 8'd8;

        led_out <= dac_d_temp;
    end
end

always @(posedge clk) begin
    dac_csn   <= 1'b0;
    dac_ldacn <= 1'b0;
    dac_a_b   <= add_sel; 
end


wire [3:0] bcd0, bcd1, bcd2;
binary_to_bcd u_b2b (
    .bin (dac_d_temp),
    .bcd2(bcd2),
    .bcd1(bcd1),
    .bcd0(bcd0)
);

seg7_dynamic u_seg (
    .clk(clk),
    .rst(rst),
    .digit3(bcd2),
    .digit2(bcd1),
    .digit1(bcd0),
    .digit0(4'd0),
    .seg(seg),
    .seg_sel(seg_sel)
);


text_LCD_basic u_lcd (
    .clk(clk),
    .rst(rst),
    .val(dac_d_temp),
    .LCD_E(LCD_E),
    .LCD_RS(LCD_RS),
    .LCD_RW(LCD_RW),
    .LCD_DATA(LCD_DATA)
);

endmodule
