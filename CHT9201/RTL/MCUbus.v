//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    2024/11/27
// Design Name:     FPGA-MCU 8-bit Bus Communication
// Module Name:     bus_comm
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MCUbus (
    input wire clk,             // 系统时钟
    input wire rst_n,           // 系统复位信号

    inout wire [7:0] DB,  // 八位双向数据总线
    input wire ALE,             // 地址锁存使能，低有效
    input wire WR,              // 写使能，低有效
    input wire RD,               // 读使能，低有效
    output reg [7:0] data_regs50, // 8位数据寄存器 (0x50 - 0x54)
    input wire [15:0] ad_ch1,
    input wire [15:0] ad_ch2,
    input wire [15:0] ad_ch3,
    input wire [15:0] ad_ch4,
    input wire [15:0] ad_ch5,
    input wire [15:0] ad_ch6,
    input wire [15:0] ad_ch7,
    input wire [15:0] ad_ch8
);

//////////////////////////////////////////////////////////////////////////////////
// 定义内部寄存器
reg [7:0] address; // 地址锁存寄存器
//reg [7:0] data_regs50; // 8位数据寄存器 (0x50 - 0x54)
reg [7:0] data_regs51;
reg [7:0] data_regs52;
reg [7:0] data_regs53;
reg [7:0] data_regs54;
reg [7:0] data_out; // 用于驱动 DB 的数据
reg DB_tristate; // 控制 DB 是否驱动
reg [7:0] check_regs ;
//////////////////////////////////////////////////////////////////////////////////
// 初始化寄存器
integer i;
initial begin
    data_regs50 <= 8'h00;
    data_regs51 <= 8'h00;
    data_regs52 <= 8'h00;
    data_regs53 <= 8'h00;
    data_regs54 <= 8'h00;
    address = 8'h50;
    data_out = 8'h00;
    DB_tristate = 1'b0;
end
// 地址锁存逻辑
always @(*) begin
    if (~ALE) begin
            DB_tristate <= 1'b0; // 启动驱动
            address <= DB;
        end 
    else if ((~WR) && ALE)
        begin
            DB_tristate <= 1'b0; // 启动驱动
        end
    else if ((~RD) && ALE)
        begin
            DB_tristate <= 1'b1; // 启动驱动
        end
end

//读取写入数据逻辑
always @(*) begin
    if ((~WR) && ALE) begin // 确保 ALE 已完成地址锁存
        case (address)
            8'h50: data_regs50 <= DB ;
            8'h51: data_regs51 <= DB ;
            8'h52: data_regs52 <= DB ;
            8'h53: data_regs53 <= DB ;
            8'h54: data_regs54 <= DB ;
            8'hAA: check_regs <= DB;
            default: begin
                     data_regs50 <= (8'hZZ);
                     data_regs51 <= (8'hZZ);
                     data_regs52 <= (8'hZZ);
                     data_regs53 <= (8'hZZ);
                     data_regs54 <= (8'hZZ);
                     end 
        endcase
    end
    if ((~RD) && ALE) begin // 确保 ALE 已完成地址锁存
        
        case (address)
            8'h50: data_out <= data_regs50;
            8'h51: data_out <= data_regs51;
            8'h52: data_out <= data_regs52;
            8'h53: data_out <= data_regs53;
            8'h54: data_out <= data_regs54;
            8'hAA: data_out <= check_regs; 
            8'h10: data_out <= ad_ch1[7:0];
            8'h11: data_out <= ad_ch1[15:8];
            8'h12: data_out <= ad_ch2[7:0];
            8'h13: data_out <= ad_ch2[15:8];
            8'h14: data_out <= ad_ch3[7:0];
            8'h15: data_out <= ad_ch3[15:8];
            8'h16: data_out <= ad_ch4[7:0];
            8'h17: data_out <= ad_ch4[15:8];
            8'h18: data_out <= ad_ch5[7:0];
            8'h19: data_out <= ad_ch5[15:8];
            8'h1A: data_out <= ad_ch6[7:0];
            8'h1B: data_out <= ad_ch6[15:8];
            8'h1C: data_out <= ad_ch7[7:0];
            8'h1D: data_out <= ad_ch7[15:8];
            8'h1E: data_out <= ad_ch8[7:0];
            8'h1F: data_out <= ad_ch8[15:8];
            default: begin
                     data_out <= (8'hZZ);
                     end 

        endcase
        // 可选择处理地址越界的情况
    end
end

// 三态缓冲区驱动
assign DB = (DB_tristate) ? data_out : 8'hZZ;
//assign data_ad_os = data_regs50 [2:0];
//assign freq_select = data_regs50 [4:3];
//always @(posedge clk) begin
//    DB_tristate<=1;
//    data_out <=8'h0F;
//end


endmodule
