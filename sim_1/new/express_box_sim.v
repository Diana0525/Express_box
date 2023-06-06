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
reg clk;//����ʱ���ź�
reg check_bag;//"���"�����ź�
reg make_sure;//"ȷ��"�����ź�
reg get_bag;//"ȡ��"�����ź�
reg [15:0]user_password;//�û���������
reg restart;//"��λ"�ź�����
reg to_input;//���밴���ź�
wire [15:0]LED;//��ʾLED��
wire [7:0] segs0;//���������ͼ��
wire [7:0] segs1;//���������ͼ�� 
wire [7:0] len;
wire [3:0]next_state,current_state;
//�ұ��ĸ����������ʾ�����ݣ�������0~3
wire [3:0] hex0;//���뿪�����Ĳ�������
wire [3:0] hex1;//���뿪�����Ĳ�������
wire [3:0] hex2;//SW8���Ĳ�������
wire [3:0] hex3;//SW8���Ĳ�������
//��������λ������е����ݣ�������4~7
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
    //��17��
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
