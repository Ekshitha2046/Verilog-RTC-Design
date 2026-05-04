`timescale 1ns/1ps

module rtc_to_display(
    input clk,
    input rst,
    output [6:0] seg0, seg1, seg2, seg3, seg4, seg5
);

    reg [5:0] sec;
    reg [5:0] min;
    reg [4:0] hr;

    reg [3:0] sec_u, sec_t;
    reg [3:0] min_u, min_t;
    reg [3:0] hr_u, hr_t;

    reg [31:0] count;

    //  FAST CLOCK DIVIDER (for simulation)
    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 0;
        else if (count == 1)
            count <= 0;
        else
            count <= count + 1;
    end

    wire clk_1hz = (count == 1);

    //  TIME LOGIC (FIXED)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sec <= 0;
            min <= 0;
            hr  <= 0;
        end else if (clk_1hz) begin
            if (sec == 59) begin
                sec <= 0;
                if (min == 59) begin
                    min <= 0;
                    if (hr == 23)
                        hr <= 0;
                    else
                        hr <= hr + 1;
                end else begin
                    min <= min + 1;
                end
            end else begin
                sec <= sec + 1;
            end
        end
    end

    //  SPLIT DIGITS
    always @(*) begin
        sec_u = sec % 10;
        sec_t = sec / 10;
        min_u = min % 10;
        min_t = min / 10;
        hr_u  = hr % 10;
        hr_t  = hr / 10;
    end

    //  7-SEGMENT DECODER
    function [6:0] decode;
        input [3:0] num;
        case (num)
            0: decode = 7'b1000000;
            1: decode = 7'b1111001;
            2: decode = 7'b0100100;
            3: decode = 7'b0110000;
            4: decode = 7'b0011001;
            5: decode = 7'b0010010;
            6: decode = 7'b0000010;
            7: decode = 7'b1111000;
            8: decode = 7'b0000000;
            9: decode = 7'b0010000;
            default: decode = 7'b1111111;
        endcase
    endfunction

    assign seg0 = decode(sec_u);
    assign seg1 = decode(sec_t);
    assign seg2 = decode(min_u);
    assign seg3 = decode(min_t);
    assign seg4 = decode(hr_u);
    assign seg5 = decode(hr_t);

endmodule