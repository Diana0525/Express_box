`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/18 01:26:39
// Design Name: 
// Module Name: express_box_mealy
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


module express_box_mealy(clk,check_bag,make_sure,get_bag,user_password,restart,to_input,LED,segs0,segs1,len/*,next_state,current_state,hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7*/);
input clk;//输入时钟信号
input check_bag;//"存包"按键信号
input make_sure;//"确认"按键信号
input get_bag;//"取包"按键信号
input [15:0]user_password;//用户输入密码
input restart;//"复位"信号输入
input to_input;//输入按键信号
output reg [15:0]LED = 16'hffff;//显示LED灯
output wire[7:0] segs0;//左四数码管图案
output wire[7:0] segs1;//右四数码管图案 
output wire[7:0] len;//数码管使能
reg [2:0]count_xianshi = 3'b0;//逐位显示密码计数
reg [15:0]save_input;//存储逐位输入的密码
reg noinput_flag;//输入按键未被按下
reg [3:0]count = 4'hf;//记录空箱数,0~15表示1~16
reg allfull = 0;//判断是否还有空箱的标志位
reg [7:0]counter = 8'ha;
reg [15:0]big_counter = 16'b0;
reg [3:0]box_number;//给出的快递柜的编号，0~15表示1~16
reg [15:0] store = 16'hffff;//记录哪些位置是空的，哪些位置被存储了
reg [3:0] i = 4'b0;
reg [3:0] j = 4'b0;
reg [15:0] store_slice[0:15];//存储密码采用的寄存器组
reg [3:0] count_i = 4'h0;
reg [3:0] count_j;
reg [16:0] divcount1 = 17'd0;
reg [16:0] divcount2 = 17'd0;
reg [16:0] divcount3 = 17'd0;//存包按键计数消抖
reg [16:0] divcount4 = 17'd0;//取包按键计数消抖
reg [16:0] divcount5 = 17'd0;//输入按键计数消抖
reg [16:0] divcount6 = 17'd0;//确认按键计数消抖
reg [16:0] divcount7 = 17'd0;//清零按键计数防抖
reg  count2 = 0;
reg [15:0]control_LED = 16'h0;
reg flag_s3 = 0;
reg flag_s6 = 0;
reg flag_s7 = 0;

reg [3:0]next_state = 4'b0,current_state = 4'b0;
reg [7:0] en;//控制8个数码管的亮灭
//右边四个数码管中显示的内容，从左到右0~3
reg [3:0] hex0;//拨码开关左四拨码输入
reg [3:0] hex1;//拨码开关右四拨码输入
reg [3:0] hex2;//SW8左四拨码输入
reg [3:0] hex3;//SW8右四拨码输入
//控制左四位数码管中的内容，从左到右4~7
reg [3:0] hex4;
reg [3:0] hex5;
reg [3:0] hex6;
 reg [3:0] hex7;
//调用数码管显示模块
display_LED d(clk,en,hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7,segs0,segs1,len);
//状态表示参数
parameter s0 = 4'b0,//欢迎界面状态
            s1 = 4'b0001,//按下存包键后的状态
            s2 = 4'b0010,//存包界面之LED灯改变亮暗的状态
            s3 = 4'b0011,//LED改变亮暗之后等待按键的状态
            s4 = 4'b0100,//取包界面状态并且等待用户输入密码
            s5 = 4'b0101,//用户按下“输入”按钮后的状态
            s6 = 4'b0110,
            s7 = 4'b0111,
            s8 = 4'b1000,
            s9 = 4'b1001,
            s10 = 4'b1010,
            s11 = 4'b1011,
            s12 = 4'b1100,
            s13 = 4'b1101,
            s14 = 4'b1110,
            s15 = 4'b1111;
//状态转移模块          
always @ (posedge clk)
begin
    current_state = next_state;
    big_counter <= big_counter+1;
    //利用100MHz时钟计数counter用于生成随机箱号
    if(counter <8'hff)
        begin
            counter <= counter+1;
        end
    else
        begin
            counter <= 8'ha;
        end
    case(current_state)
        s0:
        begin
                en = 8'b11110011;//左边四位显示学号，右边前两位不显示，后两位显示空箱数
                //左边数码管显示学号：0710
                hex4 = 4'b0000;
                hex5 = 4'b0111;
                hex6 = 4'b0001;
                hex7 = 4'b0000;
                if(allfull)//此时count = 0是真的0
                    begin
                        hex2 = 4'b0;
                        hex3 = 4'b0;
                    end
                else if(count > 4'b1000)//若空箱数是两位数,空箱数两位十进制显示，count=9~15表示10~16
                    begin
                        hex2 = 4'b0001;
                        hex3 = count - 4'b1001;
                    end
                else //count=0~8表示1~9，十进制十位显示0，个位显示count+1
                    begin
                        hex2 = 4'b0;
                        hex3 = count + 4'b0001; 
                    end
            if(check_bag && !allfull) 
            begin
                /*next_state <= s1;*/
                next_state <= s10;//进入防抖模块
                i <= 0;
            end
            else if(get_bag)
            begin
                /*next_state <= s4;*/
                next_state <= s10;//进入防抖模块
                i <= 0;
            end
            else if(restart)
            begin
                next_state <= s10;//进入防抖模块
            end
        end
        s1://存包第一步：生成随机包数
        begin
            en = 8'b11001111;
            count <= count-1;//空箱数少一
            if(count != 0)
                begin
                    box_number <= counter%count;//box_number取值范围为0~减去1之后的箱子数
                end
            else if (count == 0)
                begin
                    allfull <= 1;
                    box_number <= 0;
                    count <= 0;
                end
            next_state <= s2;
            i <= 0;
            j <= 0;
            if(restart)
            begin
                next_state <= s10;//进入防抖模块
            end
        end
        s2://存包第二步：根据生成的数字，将第x个空箱放给用户，只让选中的箱子LED灯亮
        begin
            i <= i+1;//之后的i还是上一个时钟沿的i,i用于遍历1~16号LED灯
            if((store[i] == 1) && (j == box_number)) //j的数值是第j个空箱子，j从0开始，box_number也从0开始，当box_number = 0时，尽管第0个箱子已经有了东西，也还是会继续存进去,加一个限制条件，如果已经被存过，则j<=j,而i继续遍历下去
                begin
                    j <= j+1;
                    LED[i] <= 1;
                    store[i] <= 0;//表示这个位置被存了 
                    store_slice[i][15:12] <= big_counter[15:12];
                    store_slice[i][11:8] <= big_counter[11:8];
                    store_slice[i][7:4] <= big_counter[7:4];
                    store_slice[i][3:0] <= big_counter[3:0];
                    hex0 <= big_counter[15:12];
                    hex1 <= big_counter[11:8];
                    hex2 <= big_counter[7:4];
                    hex3 <= big_counter[3:0];
                    if(i > 4'b1000)//第i个箱子对应的号码才是箱号
                        begin
                            hex4 <= 4'b0001;
                            hex5 <= i - 4'b1001;
                        end
                    else
                        begin
                            hex4 <= 4'b0;
                            hex5 <= i + 4'b0001;
                        end
                    
             end
            else if (store[i] == 0) 
                begin 
                    j <= j;
                    LED[i] <= 0;//其他箱子全部不能亮 
                end
            else if(store[i] == 1)
                begin
                    j <= j+1;
                    LED[i] <= 0;//其他箱子全部不能亮 
                end
            if(i == 4'b1111)
                begin
                    i <= 4'b0;
                    j <= 4'b0;
                    next_state <= s3;//遍历完成后进入s3状态
                end  
            if(restart)
            begin
                next_state <= s10;//进入防抖模块
            end       
        end
        s3://LED改变亮暗之后等待按键的状态
        begin
            if(make_sure)
            begin
                i <= 0;
                /*next_state <= s9;*/
                next_state <= s10;
                flag_s3 <= 1;
                if(restart)
                begin
                    next_state <= s10;//进入防抖模块
                end
            end
        end
        s4://取包界面状态并且等待用户输入密码
        begin
            en = 8'b00000000;//数码管全部不亮
                i <= i+1;
                LED[i] <= 0;
                if(i == 4'b1111)//led灯全部熄灭
                begin
                    i <= 0;
                end
                if(to_input)
                begin
                    i <= 0;
                    next_state <= s10;
                end
            if(restart)
            begin
                next_state <= s10;//进入防抖模块
            end
        end 
        s5://用户按下“输入”键之后的状态
        begin
            /*en = 8'b00001111;
            hex0 = user_password[15:12];//后四位数码管显示用户输入的密码
            hex1 = user_password[11:8];
            hex2 = user_password[7:4];
            hex3 = user_password[3:0];*/
            if(count_xianshi == 0)
            begin
                en = 8'b00000001;
                hex3 = user_password[11:8];
                save_input[15:12] <= user_password[11:8];
                if(!to_input || noinput_flag)//松开按键后等待下一次按键进行状态跳转
                begin
                    noinput_flag <= 1;
                    if(to_input)//此状态再按下按键
                    begin
                        count_xianshi <= count_xianshi +1;
                        i <= 0;
                        next_state <= s10;
                        noinput_flag <= 0;
                    end
                end
            end
            else if(count_xianshi == 1)
            begin
                en = 8'b00000011;
                hex3 = user_password[11:8];
                hex2 = save_input[15:12];
                save_input[11:8] <= user_password[11:8];
                if(!to_input || noinput_flag)//松开按键后等待下一次按键进行状态跳转
                begin
                    noinput_flag <= 1;
                    if(to_input)//此状态再按下按键
                    begin
                        count_xianshi <= count_xianshi +1;
                        i <= 0;
                        next_state <= s10;
                        noinput_flag <= 0;
                    end
                end
            end
            else if(count_xianshi == 2)
            begin
                 en = 8'b00000111;
                hex3 = user_password[11:8];
                hex2 = save_input[11:8];
                hex1 = save_input[15:12];
                save_input[7:4] <= user_password[11:8];
                if(!to_input || noinput_flag)//松开按键后等待下一次按键进行状态跳转
                begin
                    noinput_flag <= 1;
                    if(to_input)//此状态再按下按键
                    begin
                        count_xianshi <= count_xianshi +1;
                        i <= 0;
                        next_state <= s10;
                        noinput_flag <= 0;
                    end
                end
            end
            else if(count_xianshi == 3)
            begin
                en = 8'b00001111;
                hex3 = user_password[11:8];
                hex2 = save_input[7:4];
                hex1 = save_input[11:8];
                hex0 = save_input[15:12];
                save_input[3:0] <= user_password[11:8];
                if(!to_input || noinput_flag)//松开按键后等待下一次按键进行状态跳转
                begin
                    noinput_flag <= 1;
                    if(to_input)//此状态再按下按键
                    begin
                        count_xianshi <= count_xianshi +1;
                        i <= 0;
                        next_state <= s10;
                        noinput_flag <= 0;
                    end
                end
            end
            else if(count_xianshi >= 4)
            begin
                en = 8'b00001111;
                hex3 = save_input[3:0];
                hex2 = save_input[7:4];
                hex1 = save_input[11:8];
                hex0 = save_input[15:12];
                i <= i+1;
            end
            if(save_input == store_slice[i] && count_xianshi >= 4)
            begin
                store[i] <= 1;
                count_j <= i;//记录此时闪烁的灯编号
                store_slice[i] <= 0;
                i <= 0;
                next_state <= s6;
            end
            else if(i == 4'b1111)
            begin
                next_state <= s7;
            end
            if(restart)
            begin
                next_state <= s10;//进入防抖模块
            end
        end  
        s6://用户输入正确密码后的LED灯闪烁状态
        begin
            
            if(divcount1 == 17'd49999)
            begin
                divcount1 <= 17'd0;
                divcount2 <= divcount2 +1;
            end
            else divcount1 <= divcount1 +1;
            if(divcount2 == 17'd1999)
            begin
                divcount2 <= 17'd0;
                count2 <= count2+1;
                en <= 8'b0;//判断结束后数码管不亮
                if(count2) begin control_LED[count_j] <= 1;end
                else begin control_LED[count_j] <= 0;end
            end
            i <= i+1;
            LED[i] <= control_LED[i];
            if(make_sure) begin /*next_state <= s8;*/flag_s6 <= 1;next_state <= s10;control_LED <= 16'h0;end
            if(restart)
            begin
                next_state <= s10;//进入防抖模块
            end
        end
        s7://用户输入密码错误后的状态
        begin
            if(divcount1 == 17'd49999)
            begin
                divcount1 <= 17'd0;
                divcount2 <= divcount2 +1;
            end
            else divcount1 <= divcount1 +1;
            if(divcount2 == 17'd1999)
            begin
                divcount2 <= 17'd0;
                en = 8'b11111111;
                hex0 = 4'b1000;
                hex1 = 4'b1000;
                hex2 = 4'b1000;
                hex3 = 4'b1000;
                hex4 = 4'b1000;
                hex5 = 4'b1000;
                hex6 = 4'b1000;
                hex7 = 4'b1000;
            end
            if(make_sure)begin  /*next_state = s9;*/flag_s7 <= 1;next_state <= s10;end
            if(restart)
            begin
                next_state <= s10;//进入防抖模块
            end
        end
        s8://取物成功后count+1的状态
        begin
            if(allfull)
            begin
                allfull <= 0;
                count <= 0;//此时的0代表1
            end
            else count <= count +1;
            i = 0;
            next_state <= s9;
            if(restart)
            begin
                next_state <= s10;//进入防抖模块
            end
        end
        s9://将LED由更改后变回欢迎界面亮灯状态
        begin
            i <= i+1;
            LED[i] <= store[i];
            if(i == 4'b1111)
            begin
                next_state <= s0;
                i <= 0;
                j <= 0;
            end
            if(restart)
            begin
                next_state <= s10;//进入防抖模块
            end
        end
        s10://按键消抖状态
        begin
            if(divcount3 == 17'd49999)
            begin
                divcount3 <= 0;
                next_state <= s1;
            end
            else if(divcount4 == 17'd49999)
            begin
                divcount4 <= 0;
                next_state <= s4;
            end
            else if(divcount5 == 17'd49999)
            begin
                divcount5 <= 0;
                next_state <= s5;
            end
            else if(divcount6 == 17'd49999)
            begin
                divcount6 <= 0;
                count_xianshi <= 0;
                if(flag_s3)begin next_state <= s9;flag_s3 <= 0;end
                else if(flag_s6)begin next_state <= s8;flag_s6 <= 0;end
                else if(flag_s7)begin next_state <= s9;flag_s7 <= 0;end
                
            end
            else if(divcount7 == 17'd49999)
            begin
                divcount7 <= 0;
                next_state <= s11;//进入重置模块
                i <= 0;
            end
            if(check_bag)
            begin
                divcount3 <= divcount3+1;
            end
            else if(get_bag)
            begin
                divcount4 <= divcount4 + 1;
            end
            else if(to_input)
            begin
                divcount5 <= divcount5 +1;
            end
            else if(make_sure)
            begin
                divcount6 <= divcount6 +1;
            end
            else if(restart)
            begin
                divcount7 <= divcount7 +1;
            end
        end
        s11://重置一切的模块
        begin
            i<= i + 1;
            LED[i] <= 1;
            count <= 4'hf;
            store[i] <= 1;
            store_slice[i] <= 0;
            allfull <= 0;
            control_LED <= 16'h0;
            if(i == 4'b1111)
            begin
                i <= 0;
                next_state <= s0;//重置完成回到欢迎界面
            end
        end
        default:begin end
    endcase
    
end


endmodule
