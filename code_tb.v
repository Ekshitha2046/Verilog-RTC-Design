`timescale 1ns/1ps

module code_tb;

    reg clk;
    reg rst;

    wire [6:0] seg0, seg1, seg2, seg3, seg4, seg5;

    rtc_to_display DUT (
        .clk(clk),
        .rst(rst),
        .seg0(seg0),
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3),
        .seg4(seg4),
        .seg5(seg5)
    );

    //  CLOCK
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //  RESET + RUN
    initial begin
        rst = 1;
        #20 rst = 0;

        #2000000;  // long enough to see min/hr change
        $finish;
    end

    //  DUMP
    initial begin
        $dumpfile("code.vcd");
        $dumpvars(0, code_tb);
    end

endmodule