`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ad7606 
//////////////////////////////////////////////////////////////////////////////////
module AD7606_CTRL(
    input              clk        ,  // 4mhz
    input              rst_n      ,     
                                       
    input     [15:0] ad_data    ,  // ad7606 采样数据
    input            ad_busy    ,  // ad7606 忙标志位 
    input            ad_first_data ,  // ad7606 第一个数据标志位
    input wire [2:0] data_ad_os,        
    output wire [2:0] ad_os      ,  // ad7606 过采样倍率选择
    output wire       ad_cs      ,  // ad7606 AD cs
    output reg       ad_rd      ,  // ad7606 AD data read
    output reg       ad_reset   ,  // ad7606 AD reset
    output reg       ad_convstb,  // ad7606 AD convert start
    output reg       ad_convsta,
    output wire       ad_stby,
    output wire       ad_range,
    //用于观察或进一步处理 ad_ch1 到 ad_ch8 的输出
    output reg [15:0]  ad_ch1,
    output reg [15:0]  ad_ch2,
    output reg [15:0]  ad_ch3,
    output reg [15:0]  ad_ch4,
    output reg [15:0]  ad_ch5,
    output reg [15:0]  ad_ch6,
    output reg [15:0]  ad_ch7,
    output reg [15:0]  ad_ch8,
    input  wire wave_start,
    input  wire [1:0] wave_freq
    );

reg [15:0] cnt;
reg [ 5:0] i;
reg [ 3:0] state;

parameter IDLE      = 4'd1;
parameter AD_CONV   = 4'd2;
parameter Wait_busy = 4'd3;
parameter READ_CH1  = 4'd4;
parameter READ_CH2  = 4'd5;
parameter READ_CH3  = 4'd6;
parameter READ_CH4  = 4'd7;
parameter READ_CH5  = 4'd8;
parameter READ_CH6  = 4'd9;
parameter READ_CH7  = 4'd10;
parameter READ_CH8  = 4'd11;
parameter READ_DONE = 4'd12;

assign  ad_os      = data_ad_os;
assign  ad_stby    = 1'b1;
assign  ad_range   = 1'b1;
assign  ad_cs      = 1'b0;
reg [1:0] reset_counter; // 声明一个2位的计数器

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;          // 复位时进入 IDLE 状态
        i <= 0;
        cnt <= 0;
        ad_convsta <= 1'b0;
        ad_convstb <= 1'b0;
        ad_rd <= 1'b0;
    end else begin
        case(state)
            IDLE: begin
                if (wave_start) begin
                    state <= AD_CONV;
                    ad_convsta <= 1'b0;
                    ad_convstb <= 1'b0;
                    ad_rd <= 1'b0;
                end
                // 其他情况下保持在 IDLE 状态
            end

            AD_CONV: begin	   
                if(i == 1) begin                             //等待1个clock
                    ad_convsta <= 1'b1;  
                    ad_convstb <= 1'b1;
                    state <= READ_CH1;
                    ad_rd <= 1'b0;
                    i <= 0;
                end else begin
                    i <= i + 1'b1;
                    ad_convsta <= 1'b0;                     //启动AD转换
                    ad_convstb <= 1'b0;
                end
            end

            READ_CH1: begin 
                if(ad_first_data == 1'b1) begin
                    ad_ch1 <= ad_data;                       //读CH1
                    state <= READ_CH2;
                    ad_rd <= 1'b0;				 
                end else begin 
                    ad_rd <= 1'b1;	
                    state <= AD_CONV;
                end
            end

            READ_CH2: begin 
                if(i==1) begin
                    ad_rd<=1'b0;
                    i<=0;
                    ad_ch2<=ad_data;                       //读CH2
                    state<=READ_CH3;				 
                end
                else begin
                    ad_rd<=1'b1;	
                    i<=i+1'b1;
                end
            end

            READ_CH3: begin 
                if(i==1) begin
                    ad_rd<=1'b0;
                    i<=0;
                    ad_ch3<=ad_data;                       //读CH3
                    state<=READ_CH4;				 
                end
                else begin
                    ad_rd<=1'b1;	
                    i<=i+1'b1;
                end
            end

            READ_CH4: begin 
                if(i==1) begin
                    ad_rd<=1'b0;
                    i<=0;
                    ad_ch4<=ad_data;                       //读CH4
                    state<=READ_CH5;				 
                end
                else begin
                    ad_rd<=1'b1;	
                    i<=i+1'b1;
                end
            end

            READ_CH5: begin 
                if(i==1) begin
                    ad_rd<=1'b0;
                    i<=0;
                    ad_ch5<=ad_data;                       //读CH5
                    state<=READ_CH6;				 
                end
                else begin
                    ad_rd<=1'b1;	
                    i<=i+1'b1;
                end
            end

            READ_CH6: begin 
                if(i==1) begin
                    ad_rd<=1'b0;
                    i<=0;
                    ad_ch6<=ad_data;                       //读CH6
                    state<=READ_CH7;				 
                end
                else begin
                    ad_rd<=1'b1;	
                    i<=i+1'b1;
                end
            end

            READ_CH7: begin 
                if(i==1) begin
                    ad_rd<=1'b0;
                    i<=0;
                    ad_ch7<=ad_data;                       //读CH7
                    state<=READ_CH8;				 
                end
                else begin
                    ad_rd<=1'b1;	
                    i<=i+1'b1;
                end
            end

            READ_CH8: begin 
                if(i==1) begin
                    ad_rd<=1'b0;
                    i<=0;
                    ad_ch8<=ad_data;                       //读CH8
                    state<=AD_CONV;				 
                end
                else begin
                    ad_rd<=1'b1;	
                    i<=i+1'b1;
                end
            end

            default:	begin
                state <= IDLE;
                i <= 0;
                cnt <= 0;
            end
        endcase	
    end
end 

endmodule
