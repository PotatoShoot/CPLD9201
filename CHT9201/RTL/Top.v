module Top(
    input wire clk,             // 系统时钟
    input wire rst_n,           // 系统复位信号

    inout wire [7:0] DB,  // 八位双向数据总线
    input wire ALE,             // 地址锁存使能，低有效
    input wire WR,              // 写使能，低有效
    input wire RD,               // 读使能，低有效
    output [8:0] sine_out,
    input[15:0]ad_data,  // ad7606 采样数据
    input ad_busy    ,  // ad7606 忙标志位 
    input ad_first_data ,  // ad7606 第一个数据标志位 	
    output [2:0] ad_os,  // ad7606 过采样倍率选择
    output ad_cs      ,  // ad7606 AD cs
    output ad_rd      ,  // ad7606 AD data read
    output ad_reset   ,  // ad7606 AD reset
    output ad_convstb,  // ad7606 AD convert start
    output ad_convsta,
    output ad_stby,
    output ad_range
);
//////////////////////////////////////////////////////////////////////////////////
//实例化 MCUbus 模块
    wire [7:0] t_data_regs50;
    MCUbus mcu_bus_inst (
        .clk        (clk),
        .rst_n      (rst_n),
        .DB         (DB),
        .ALE        (ALE),
        .WR         (WR),
        .RD         (RD),
        .data_regs50 (t_data_regs50),
        .ad_ch1     (ad_ch1),
        .ad_ch2     (ad_ch2),
        .ad_ch3     (ad_ch3),
        .ad_ch4     (ad_ch4),
        .ad_ch5     (ad_ch5),
        .ad_ch6     (ad_ch6),
        .ad_ch7     (ad_ch7),
        .ad_ch8     (ad_ch8)
    );
    
//////////////////////////////////////////////////////////////////////////////////
// 实例化 AD7606_CTRL 模块
    AD7606_CTRL ad_ctrl_inst (
        .clk        (clk),
        .rst_n      (rst_n),
        .ad_data    (ad_data),
        .ad_busy    (ad_busy),
        .ad_first_data (ad_first_data),
        .ad_os      (ad_os),
        .ad_cs      (ad_cs),
        .ad_rd      (ad_rd),
        .ad_reset   (ad_reset),
        .ad_convstb (ad_convstb),
        .ad_convsta (ad_convsta),
        .ad_stby    (ad_stby),
        .ad_range   (ad_range),
        .ad_ch1     (ad_ch1),
        .ad_ch2     (ad_ch2),
        .ad_ch3     (ad_ch3),
        .ad_ch4     (ad_ch4),
        .ad_ch5     (ad_ch5),
        .ad_ch6     (ad_ch6),
        .ad_ch7     (ad_ch7),
        .ad_ch8     (ad_ch8),
        .wave_start (wave_start),
        .wave_freq  (wave_freq)
    );

    wire [15:0]   ad_ch1;
    wire [15:0]   ad_ch2;
    wire [15:0]   ad_ch3;
    wire [15:0]   ad_ch4;
    wire [15:0]   ad_ch5;
    wire [15:0]   ad_ch6;
    wire [15:0]   ad_ch7;
    wire [15:0]   ad_ch8;
    wire [2:0]    data_ad_os;
//////////////////////////////////////////////////////////////////////////////////
//DAC寄存器
//////////////////////////////////////////////////////////////////////////////////
//DAC_DDS Out
  DDS_CTRL dds_inst (
        .clk    (clk),
        .rst_n  (rst_n),
        .freq_select(t_data_regs50 [4:3]),
        .sine_out(sine_out),
        .wave_start(wave_start),
        .wave_freq(wave_freq)
  );

    wire [7:0] sine_out_data;
    wire [2:0] freq_select;
    wire wave_start;
    wire [1:0] wave_freq;


endmodule