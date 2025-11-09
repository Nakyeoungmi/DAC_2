module binary_to_bcd(
    input [7:0] bin,
    output reg [3:0] bcd2, bcd1, bcd0
);
    integer i;
    reg [19:0] shift;
    always @(*) begin
        shift = 0;
        shift[7:0] = bin;
        for(i=0;i<8;i=i+1) begin
            if(shift[11:8] >= 5) shift[11:8] = shift[11:8] + 3;
            if(shift[15:12] >= 5) shift[15:12] = shift[15:12] + 3;
            if(shift[19:16] >= 5) shift[19:16] = shift[19:16] + 3;
            shift = shift << 1;
        end
        bcd2 = shift[19:16];
        bcd1 = shift[15:12];
        bcd0 = shift[11:8];
    end
endmodule
