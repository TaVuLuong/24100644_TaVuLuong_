`default_nettype none

module tt_um_b08_mux_demux (
    input  wire [7:0] ui_in,    // 8 đường vào cho MUX
    output wire [7:0] uo_out,   // 8 đường ra cho DEMUX (uo_out[0] cũng chứa ra MUX)
    input  wire [7:0] uio_in,   // uio_in[2:0]: chọn, uio_in[3]: vào DEMUX
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // Gán hướng cổng cố định cho Tiny Tapeout
    assign uio_oe  = 8'b0000_0000; // Tất cả uio là input
    assign uio_out = 8'b0000_0000;

    // Tách tín hiệu
    wire [2:0] sel       = uio_in[2:0]; // 3 bit chọn dùng chung
    wire       demux_in  = uio_in[3];   // Đầu vào DEMUX
    wire       mux_out;

    // 1. Logic MUX 8->1 (Ghép kênh)
    assign mux_out = ui_in[sel];

    // 2. Logic DEMUX 1->8 (Tách kênh)
    reg [7:0] demux_out;
    always @(*) begin
        demux_out = 8'b0000_0000;
        demux_out[sel] = demux_in;
    end

    // Gán đầu ra (uo_out[0] dành cho MUX ra, uo_out[7:0] cho DEMUX)
    // Để tránh trùng uo_out[0], có thể gộp mux_out vào uo_out[0] khi chạy chế độ MUX
    assign uo_out = demux_out | {7'b0000000, mux_out};

endmodule