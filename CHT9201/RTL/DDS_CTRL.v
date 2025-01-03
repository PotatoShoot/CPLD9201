
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    2024/04/27
// Design Name:     DDS Waveform Generator
// Module Name:     dds_waveform
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
// 
// A Direct Digital Synthesis (DDS) module that generates sine waves at
// 50Hz, 60Hz, and 800Hz frequencies and outputs them to an 8-bit DAC.
// The sine wave data is stored in a 64-depth, 8-bit wide lookup table (LUT).
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module DDS_CTRL (
    input wire clk,             // 系统时钟 50 MHz
    input wire rst_n,           // 复位信号，低电平有效
    input wire [1:0] freq_select, // 频率选择信号
    output reg [7:0] sine_out,   // 输出到 DAC 的 8 位波形数据
    output reg wave_start,
    output reg [1:0] wave_freq
);


//always @(posedge clk)
//begin
//    sine_out <= 8'b11111111;
//end 


    // 定义 DAC 时钟为 1 MHz，通过分频器生成
    reg [2:0] clk_div_counter; // 用于分频计数器（50 截断到 1 MHz）
    wire dac_clk;

    // DAC 时钟分频逻辑
    // 50 MHz / 50 = 1 MHz，因此需要计数 50 个系统时钟周期
    // 4 MHz / 4 = 1 MHz，因此需要计数4个系统时钟周期
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div_counter <= 2'd0;
        end else begin
            if (clk_div_counter == 2'd3) begin
                clk_div_counter <= 2'd0;
            end else begin
                clk_div_counter <= clk_div_counter + 1;
            end
        end
    end

    assign dac_clk = (clk_div_counter == 2'd3) ? 1'b1 : 1'b0;

    // 相位累加器
    reg [31:0] phase_accumulator;
    reg [31:0] phase_step;

    // 步进值计算
    // 步进值 = (频率 * 2^32) / 1,000,000
    // 对于：
    // 50 Hz: step = 50 * 4294967296 / 1000000 ≈ 214748
    // 60 Hz: step = 60 * 4294967296 / 1000000 ≈ 257698
    // 800 Hz: step = 800 * 4294967296 / 1000000 ≈ 3435973
    // ADC速度
    // 在一个50Hz周期内，200kHz可以运行 4000 个周期。
    // 在一个60Hz周期内，200kHz可以运行 3334 个周期。
    // 在一个800Hz周期内，200kHz可以运行 250 个周期。
    // 使用参数定义步进值
    localparam [31:0] STEP_50HZ  = 32'd214748;
    localparam [31:0] STEP_60HZ  = 32'd257698;
    localparam [31:0] STEP_800HZ = 32'd3435973;

    always @(*) begin
        case (freq_select)
            2'b00: phase_step = STEP_50HZ;    // 50 Hz
            2'b01: phase_step = STEP_60HZ;    // 60 Hz
            2'b10: phase_step = STEP_800HZ;   // 800 Hz
            default: phase_step = STEP_50HZ;   // 默认 50 Hz
        endcase
        wave_freq <= freq_select;
    end

    // 相位累加器更新
    always @(posedge dac_clk or negedge rst_n) begin
        if (!rst_n) begin
            phase_accumulator <= 32'd0;
        end else begin
            phase_accumulator <= phase_accumulator + phase_step;
        end
    end

    // 查找表地址（取相位累加器的高 6 位作为索引）
    wire [5:0] lut_addr;
    reg  [5:0] last_lut_addr;
    assign lut_addr = phase_accumulator[31:26];

    // 定义 64 深度、8 位宽的查找表
    reg [7:0] sine_lut [63:0];

 // 初始化查找表
    initial begin
        sine_lut[0]  = 8'b11111110;
        sine_lut[1]  = 8'b11010001;
        sine_lut[2]  = 8'b11101001;
        sine_lut[3]  = 8'b11000101;
        sine_lut[4]  = 8'b11110101;
        sine_lut[5]  = 8'b01011101;
        sine_lut[6]  = 8'b10100011;
        sine_lut[7]  = 8'b11110011;
        sine_lut[8]  = 8'b00011011;
        sine_lut[9]  = 8'b10000111;
        sine_lut[10] = 8'b00010111;
        sine_lut[11] = 8'b11110111;
        sine_lut[12] = 8'b00101111;
        sine_lut[13] = 8'b00011111;
        sine_lut[14] = 8'b11011111;
        sine_lut[15] = 8'b10111111;
        sine_lut[16] = 8'b01111111;
        sine_lut[17] = 8'b10111111;
        sine_lut[18] = 8'b11011111;
        sine_lut[19] = 8'b00011111;
        sine_lut[20] = 8'b00101111;
        sine_lut[21] = 8'b11110111;
        sine_lut[22] = 8'b00010111;
        sine_lut[23] = 8'b10000111;
        sine_lut[24] = 8'b00011011;
        sine_lut[25] = 8'b11110011;
        sine_lut[26] = 8'b10100011;
        sine_lut[27] = 8'b01011101;
        sine_lut[28] = 8'b11110101;
        sine_lut[29] = 8'b11000101;
        sine_lut[30] = 8'b11101001;
        sine_lut[31] = 8'b11010001;
        sine_lut[32] = 8'b11111110;
        sine_lut[33] = 8'b01001110;
        sine_lut[34] = 8'b01100110;
        sine_lut[35] = 8'b01011010;
        sine_lut[36] = 8'b01110010;
        sine_lut[37] = 8'b11000010;
        sine_lut[38] = 8'b00011100;
        sine_lut[39] = 8'b01110100;
        sine_lut[40] = 8'b10100100;
        sine_lut[41] = 8'b00111000;
        sine_lut[42] = 8'b10101000;
        sine_lut[43] = 8'b01110000;
        sine_lut[44] = 8'b10010000;
        sine_lut[45] = 8'b10100000;
        sine_lut[46] = 8'b01000000;
        sine_lut[47] = 8'b00000000;
        sine_lut[48] = 8'b00000000;
        sine_lut[49] = 8'b00000000;
        sine_lut[50] = 8'b01000000;
        sine_lut[51] = 8'b10100000;
        sine_lut[52] = 8'b10010000;
        sine_lut[53] = 8'b01110000;
        sine_lut[54] = 8'b10101000;
        sine_lut[55] = 8'b00111000;
        sine_lut[56] = 8'b10100100;
        sine_lut[57] = 8'b01110100;
        sine_lut[58] = 8'b00011100;
        sine_lut[59] = 8'b11000010;
        sine_lut[60] = 8'b01110010;
        sine_lut[61] = 8'b01011010;
        sine_lut[62] = 8'b01100110;
        sine_lut[63] = 8'b01001110;
    end    

    // 从查找表读取数据并输出
    always @(posedge dac_clk or negedge rst_n) begin
        if (!rst_n) begin
            sine_out <= 8'd0;
        end else begin
            sine_out <= sine_lut[lut_addr];
        end
    end

    always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        last_lut_addr <= 6'b0; // 复位时将last_lut_addr清零
    end else begin
        if (lut_addr != last_lut_addr) begin
            wave_start <= 1'b0;
        end else begin
            wave_start <= 1'b1;
        end
        last_lut_addr <= lut_addr; // 更新last_lut_addr为当前的lut_addr
    end
end
 
endmodule

