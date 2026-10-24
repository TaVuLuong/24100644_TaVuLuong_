`timescale 1ns/1ps

module tb;
    reg [7:0] ui_in;
    reg [7:0] uio_in;
    wire [7:0] uo_out;
    reg clk = 0, rst_n = 1;

    tt_um_b08_mux_demux dut (
        .ui_in(ui_in), .uo_out(uo_out), .uio_in(uio_in),
        .uio_out(), .uio_oe(), .ena(1'b1), .clk(clk), .rst_n(rst_n)
    );

    integer i;
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        ui_in = 8'b1010_1010; // Dữ liệu mẫu MUX
        uio_in[3] = 1'b1;     // Dữ liệu mẫu DEMUX = 1

        // Ca 1: Quét đủ 8 giá trị chọn (000 -> 111)
        for (i = 0; i < 8; i = i + 1) begin
            uio_in[2:0] = i;
            #10;
            $display("SEL=%d | MUX Out=%b | DEMUX Out=%b", i, uo_out[0], uo_out);
        end

        // Ca 2 (Tự nghĩ thêm): Đổi dữ liệu DEMUX = 0
        uio_in[3] = 1'b0;
        #10;

        // Ca 3 (Tự nghĩ thêm): Đổi toàn bộ dữ liệu MUX
        ui_in = 8'b1111_0000;
        #10;

        $finish;
    end
endmodule