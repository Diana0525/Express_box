`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/18 02:55:05
// Design Name: 
// Module Name: express_box_sim
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


module express_box_sim();
reg clk;//输入时钟信号
reg check_bag;//"存包"按键信号
reg make_sure;//"确认"按键信号
reg get_bag;//"取包"按键信号
reg [15:0]user_password;//用户输入密码
reg restart;//"复位"信号输入
reg to_input;//输入按键信号
wire [15:0]LED;//显示LED灯
wire [7:0] segs0;//左四数码管图案
wire [7:0] segs1;//右四数码管图案 
wire [7:0] len;
wire [3:0]next_state,current_state;
//右边四个数码管中显示的内容，从左到右0~3
wire [3:0] hex0;//拨码开关左四拨码输入
wire [3:0] hex1;//拨码开关右四拨码输入
wire [3:0] hex2;//SW8左四拨码输入
wire [3:0] hex3;//SW8右四拨码输入
//控制左四位数码管中的内容，从左到右4~7
wire [3:0] hex4;
wire [3:0] hex5;
wire [3:0] hex6;
wire [3:0] hex7;
express_box_mealy U(.clk(clk),.check_bag(check_bag),.make_sure(make_sure),.get_bag(get_bag),.user_password(user_password),.restart(restart),.to_input(to_input),
.LED(LED),.segs0(segs0),.segs1(segs1),.len(len),.next_state(next_state),.current_state(current_state),.hex0(hex0),.hex1(hex1),.hex2(hex2),.hex3(hex3)
,.hex4(hex4),.hex5(hex5),.hex6(hex6),.hex7(hex7));
initial
begin
    clk = 0;
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    //第17次
    #25000000 check_bag = 1;
    #5000000 check_bag = 0;
    #50000000 make_sure = 1;
    #5000000 make_sure = 0;
    
/*    #5000000 get_bag = 1;
    #5000000 get_bag = 0;
    user_password = 16'h12da;
        
    #10000000 to_input = 1;
    #5000000 to_input = 0;*/
    
end
always 
begin
    #10 clk = ~clk;
    
end

endmodule
