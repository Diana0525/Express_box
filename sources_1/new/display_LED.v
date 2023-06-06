`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/18 01:24:42
// Design Name: 
// Module Name: display_LED
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module display_LED(clk,en,hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7,segs0,segs1,len);
input clk;//时钟信号
input [7:0] en;//控制8个数码管的亮灭
input [3:0] hex0;//控制右边四位数码管中的内容
input [3:0] hex1;
input [3:0] hex2;
input [3:0] hex3;
input [3:0] hex4;//控制左四位数码管中的内容
input [3:0] hex5;
input [3:0] hex6;
input [3:0] hex7;

output reg[7:0] len = 8'b00010001;//亮灯位
output reg[7:0] segs0;//左四数码管图案
output reg[7:0] segs1;//右四数码管图案
reg [16:0] divcount1 = 17'd0;
reg clk1 = 1'b1;
//分频模块，clk1为1kHz
always @(posedge clk)
    begin
        if(divcount1 == 17'd49999)
        begin
            divcount1 <= 17'd0;
            clk1 <= ~clk1;
        end
        else divcount1 <= divcount1 +1;
    end
//显示前四位数码管
always @ (posedge clk1)
    begin
         if(len[4] == 1 && en[7] == 1)
            begin
                len[7:4] = 4'b1000;
                case(hex4)
                    0:segs0 = 8'b11111100;
                    1:segs0 = 8'b01100000;
                    2:segs0 = 8'b11011010;
                    3:segs0 = 8'b11110010;
                    4:segs0 = 8'b01100110;
                    5:segs0 = 8'b10110110;
                    6:segs0 = 8'b10111110;
                    7:segs0 = 8'b11100000;
                    8:segs0 = 8'b11111110;
                    9:segs0 = 8'b11100110;
                    10:segs0 = 8'b11101110;
                    11:segs0 = 8'b00111110;
                    12:segs0 = 8'b00011010;
                    13:segs0 = 8'b01111010;
                    14:segs0 = 8'b10011110;
                    15:segs0 = 8'b10001110;
                    default:segs0 = 8'b11111111;
                endcase
            end
        else if(len[7] == 1 && en[6] == 1)
            begin
                len[7:4] = 4'b0100;
                case(hex5)
                    0:segs0 = 8'b11111100;
                    1:segs0 = 8'b01100000;
                    2:segs0 = 8'b11011010;
                    3:segs0 = 8'b11110010;
                    4:segs0 = 8'b01100110;
                    5:segs0 = 8'b10110110;
                    6:segs0 = 8'b10111110;
                    7:segs0 = 8'b11100000;
                    8:segs0 = 8'b11111110;
                    9:segs0 = 8'b11100110;
                    10:segs0 = 8'b11101110;
                    11:segs0 = 8'b00111110;
                    12:segs0 = 8'b00011010;
                    13:segs0 = 8'b01111010;
                    14:segs0 = 8'b10011110;
                    15:segs0 = 8'b10001110;
                    default:segs0 = 8'b11111111;
                endcase
            end
        else if(len[6] == 1 && en[5] == 1)
            begin
                len[7:4] = 4'b0010;
                case(hex6)
                    0:segs0 = 8'b11111100;
                    1:segs0 = 8'b01100000;
                    2:segs0 = 8'b11011010;
                    3:segs0 = 8'b11110010;
                    4:segs0 = 8'b01100110;
                    5:segs0 = 8'b10110110;
                    6:segs0 = 8'b10111110;
                    7:segs0 = 8'b11100000;
                    8:segs0 = 8'b11111110;
                    9:segs0 = 8'b11100110;
                    10:segs0 = 8'b11101110;
                    11:segs0 = 8'b00111110;
                    12:segs0 = 8'b00011010;
                    13:segs0 = 8'b01111010;
                    14:segs0 = 8'b10011110;
                    15:segs0 = 8'b10001110;
                    default:segs0 = 8'b11111111;
                endcase
            end
        else if(len[5] == 1 && en[4] == 1)
            begin
                len[7:4] = 4'b0001;
                case(hex7)
                    0:segs0 = 8'b11111100;
                    1:segs0 = 8'b01100000;
                    2:segs0 = 8'b11011010;
                    3:segs0 = 8'b11110010;
                    4:segs0 = 8'b01100110;
                    5:segs0 = 8'b10110110;
                    6:segs0 = 8'b10111110;
                    7:segs0 = 8'b11100000;
                    8:segs0 = 8'b11111110;
                    9:segs0 = 8'b11100110;
                    10:segs0 = 8'b11101110;
                    11:segs0 = 8'b00111110;
                    12:segs0 = 8'b00011010;
                    13:segs0 = 8'b01111010;
                    14:segs0 = 8'b10011110;
                    15:segs0 = 8'b10001110;
                    default:segs0 = 8'b11111111;
                endcase
            end
         else  if(len[7:4] == 4'b0001) begin len[7:4] = 4'b1000;segs0 = 8'b0;end
         else  begin len[7:4]=len[7:4]>>1;segs0 = 8'b0;end    
    end 
//显示拨码开关以及SW8输入的内容，于右边四位数码管
always @ (posedge clk1)
    begin
        if(len[0] == 1 && en[3] == 1)
            begin
                len[3:0] = 4'b1000;
                case(hex0)
                    0:segs1 = 8'b11111100;
                    1:segs1 = 8'b01100000;
                    2:segs1 = 8'b11011010;
                    3:segs1 = 8'b11110010;
                    4:segs1 = 8'b01100110;
                    5:segs1 = 8'b10110110;
                    6:segs1 = 8'b10111110;
                    7:segs1 = 8'b11100000;
                    8:segs1 = 8'b11111110;
                    9:segs1 = 8'b11100110;
                    10:segs1 = 8'b11101110;
                    11:segs1 = 8'b00111110;
                    12:segs1 = 8'b00011010;
                    13:segs1 = 8'b01111010;
                    14:segs1 = 8'b10011110;
                    15:segs1 = 8'b10001110;
                    default:segs1 = 8'b11111111;
                endcase
            end
        else if(len[3] == 1 && en[2] == 1)
            begin
                len[3:0] = 4'b0100;
                case(hex1)
                    0:segs1 = 8'b11111100;
                    1:segs1 = 8'b01100000;
                    2:segs1 = 8'b11011010;
                    3:segs1 = 8'b11110010;
                    4:segs1 = 8'b01100110;
                    5:segs1 = 8'b10110110;
                    6:segs1 = 8'b10111110;
                    7:segs1 = 8'b11100000;
                    8:segs1 = 8'b11111110;
                    9:segs1 = 8'b11100110;
                    10:segs1 = 8'b11101110;
                    11:segs1 = 8'b00111110;
                    12:segs1 = 8'b00011010;
                    13:segs1 = 8'b01111010;
                    14:segs1 = 8'b10011110;
                    15:segs1 = 8'b10001110;
                    default:segs1 = 8'b11111111;
                endcase
            end
        else if(len[2] == 1 && en[1] == 1)
            begin
                len[3:0] = 4'b0010;
                case(hex2)
                        0:segs1 = 8'b11111100;
                        1:segs1 = 8'b01100000;
                        2:segs1 = 8'b11011010;
                        3:segs1 = 8'b11110010;
                        4:segs1 = 8'b01100110;
                        5:segs1 = 8'b10110110;
                        6:segs1 = 8'b10111110;
                        7:segs1 = 8'b11100000;
                        8:segs1 = 8'b11111110;
                        9:segs1 = 8'b11100110;
                        10:segs1 = 8'b11101110;
                        11:segs1 = 8'b00111110;
                        12:segs1 = 8'b00011010;
                        13:segs1 = 8'b01111010;
                        14:segs1 = 8'b10011110;
                        15:segs1 = 8'b10001110;
                        default:segs1 = 8'b11111111;
                endcase
            end
        else if(len[1] == 1 && en[0] == 1)
            begin
                len[3:0] = 4'b0001;
                case(hex3)
                        0:segs1 = 8'b11111100;
                        1:segs1 = 8'b01100000;
                        2:segs1 = 8'b11011010;
                        3:segs1 = 8'b11110010;
                        4:segs1 = 8'b01100110;
                        5:segs1 = 8'b10110110;
                        6:segs1 = 8'b10111110;
                        7:segs1 = 8'b11100000;
                        8:segs1 = 8'b11111110;
                        9:segs1 = 8'b11100110;
                        10:segs1 = 8'b11101110;
                        11:segs1 = 8'b00111110;
                        12:segs1 = 8'b00011010;
                        13:segs1 = 8'b01111010;
                        14:segs1 = 8'b10011110;
                        15:segs1 = 8'b10001110;
                        default:segs1 = 8'b11111111;
                endcase
            end
         else  if(len[3:0] == 4'b0001) begin len[3:0] = 4'b1000;segs1 = 8'b0;end
         else  begin len[3:0]=len[3:0]>>1;segs1 = 8'b0;end
    end
endmodule

