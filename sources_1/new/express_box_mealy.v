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
input clk;//����ʱ���ź�
input check_bag;//"���"�����ź�
input make_sure;//"ȷ��"�����ź�
input get_bag;//"ȡ��"�����ź�
input [15:0]user_password;//�û���������
input restart;//"��λ"�ź�����
input to_input;//���밴���ź�
output reg [15:0]LED = 16'hffff;//��ʾLED��
output wire[7:0] segs0;//���������ͼ��
output wire[7:0] segs1;//���������ͼ�� 
output wire[7:0] len;//�����ʹ��
reg [2:0]count_xianshi = 3'b0;//��λ��ʾ�������
reg [15:0]save_input;//�洢��λ���������
reg noinput_flag;//���밴��δ������
reg [3:0]count = 4'hf;//��¼������,0~15��ʾ1~16
reg allfull = 0;//�ж��Ƿ��п���ı�־λ
reg [7:0]counter = 8'ha;
reg [15:0]big_counter = 16'b0;
reg [3:0]box_number;//�����Ŀ�ݹ�ı�ţ�0~15��ʾ1~16
reg [15:0] store = 16'hffff;//��¼��Щλ���ǿյģ���Щλ�ñ��洢��
reg [3:0] i = 4'b0;
reg [3:0] j = 4'b0;
reg [15:0] store_slice[0:15];//�洢������õļĴ�����
reg [3:0] count_i = 4'h0;
reg [3:0] count_j;
reg [16:0] divcount1 = 17'd0;
reg [16:0] divcount2 = 17'd0;
reg [16:0] divcount3 = 17'd0;//���������������
reg [16:0] divcount4 = 17'd0;//ȡ��������������
reg [16:0] divcount5 = 17'd0;//���밴����������
reg [16:0] divcount6 = 17'd0;//ȷ�ϰ�����������
reg [16:0] divcount7 = 17'd0;//���㰴����������
reg  count2 = 0;
reg [15:0]control_LED = 16'h0;
reg flag_s3 = 0;
reg flag_s6 = 0;
reg flag_s7 = 0;

reg [3:0]next_state = 4'b0,current_state = 4'b0;
reg [7:0] en;//����8������ܵ�����
//�ұ��ĸ����������ʾ�����ݣ�������0~3
reg [3:0] hex0;//���뿪�����Ĳ�������
reg [3:0] hex1;//���뿪�����Ĳ�������
reg [3:0] hex2;//SW8���Ĳ�������
reg [3:0] hex3;//SW8���Ĳ�������
//��������λ������е����ݣ�������4~7
reg [3:0] hex4;
reg [3:0] hex5;
reg [3:0] hex6;
 reg [3:0] hex7;
//�����������ʾģ��
display_LED d(clk,en,hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7,segs0,segs1,len);
//״̬��ʾ����
parameter s0 = 4'b0,//��ӭ����״̬
            s1 = 4'b0001,//���´�������״̬
            s2 = 4'b0010,//�������֮LED�Ƹı�������״̬
            s3 = 4'b0011,//LED�ı�����֮��ȴ�������״̬
            s4 = 4'b0100,//ȡ������״̬���ҵȴ��û���������
            s5 = 4'b0101,//�û����¡����롱��ť���״̬
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
//״̬ת��ģ��          
always @ (posedge clk)
begin
    current_state = next_state;
    big_counter <= big_counter+1;
    //����100MHzʱ�Ӽ���counter��������������
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
                en = 8'b11110011;//�����λ��ʾѧ�ţ��ұ�ǰ��λ����ʾ������λ��ʾ������
                //����������ʾѧ�ţ�0710
                hex4 = 4'b0000;
                hex5 = 4'b0111;
                hex6 = 4'b0001;
                hex7 = 4'b0000;
                if(allfull)//��ʱcount = 0�����0
                    begin
                        hex2 = 4'b0;
                        hex3 = 4'b0;
                    end
                else if(count > 4'b1000)//������������λ��,��������λʮ������ʾ��count=9~15��ʾ10~16
                    begin
                        hex2 = 4'b0001;
                        hex3 = count - 4'b1001;
                    end
                else //count=0~8��ʾ1~9��ʮ����ʮλ��ʾ0����λ��ʾcount+1
                    begin
                        hex2 = 4'b0;
                        hex3 = count + 4'b0001; 
                    end
            if(check_bag && !allfull) 
            begin
                /*next_state <= s1;*/
                next_state <= s10;//�������ģ��
                i <= 0;
            end
            else if(get_bag)
            begin
                /*next_state <= s4;*/
                next_state <= s10;//�������ģ��
                i <= 0;
            end
            else if(restart)
            begin
                next_state <= s10;//�������ģ��
            end
        end
        s1://�����һ���������������
        begin
            en = 8'b11001111;
            count <= count-1;//��������һ
            if(count != 0)
                begin
                    box_number <= counter%count;//box_numberȡֵ��ΧΪ0~��ȥ1֮���������
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
                next_state <= s10;//�������ģ��
            end
        end
        s2://����ڶ������������ɵ����֣�����x������Ÿ��û���ֻ��ѡ�е�����LED����
        begin
            i <= i+1;//֮���i������һ��ʱ���ص�i,i���ڱ���1~16��LED��
            if((store[i] == 1) && (j == box_number)) //j����ֵ�ǵ�j�������ӣ�j��0��ʼ��box_numberҲ��0��ʼ����box_number = 0ʱ�����ܵ�0�������Ѿ����˶�����Ҳ���ǻ�������ȥ,��һ����������������Ѿ����������j<=j,��i����������ȥ
                begin
                    j <= j+1;
                    LED[i] <= 1;
                    store[i] <= 0;//��ʾ���λ�ñ����� 
                    store_slice[i][15:12] <= big_counter[15:12];
                    store_slice[i][11:8] <= big_counter[11:8];
                    store_slice[i][7:4] <= big_counter[7:4];
                    store_slice[i][3:0] <= big_counter[3:0];
                    hex0 <= big_counter[15:12];
                    hex1 <= big_counter[11:8];
                    hex2 <= big_counter[7:4];
                    hex3 <= big_counter[3:0];
                    if(i > 4'b1000)//��i�����Ӷ�Ӧ�ĺ���������
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
                    LED[i] <= 0;//��������ȫ�������� 
                end
            else if(store[i] == 1)
                begin
                    j <= j+1;
                    LED[i] <= 0;//��������ȫ�������� 
                end
            if(i == 4'b1111)
                begin
                    i <= 4'b0;
                    j <= 4'b0;
                    next_state <= s3;//������ɺ����s3״̬
                end  
            if(restart)
            begin
                next_state <= s10;//�������ģ��
            end       
        end
        s3://LED�ı�����֮��ȴ�������״̬
        begin
            if(make_sure)
            begin
                i <= 0;
                /*next_state <= s9;*/
                next_state <= s10;
                flag_s3 <= 1;
                if(restart)
                begin
                    next_state <= s10;//�������ģ��
                end
            end
        end
        s4://ȡ������״̬���ҵȴ��û���������
        begin
            en = 8'b00000000;//�����ȫ������
                i <= i+1;
                LED[i] <= 0;
                if(i == 4'b1111)//led��ȫ��Ϩ��
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
                next_state <= s10;//�������ģ��
            end
        end 
        s5://�û����¡����롱��֮���״̬
        begin
            /*en = 8'b00001111;
            hex0 = user_password[15:12];//����λ�������ʾ�û����������
            hex1 = user_password[11:8];
            hex2 = user_password[7:4];
            hex3 = user_password[3:0];*/
            if(count_xianshi == 0)
            begin
                en = 8'b00000001;
                hex3 = user_password[11:8];
                save_input[15:12] <= user_password[11:8];
                if(!to_input || noinput_flag)//�ɿ�������ȴ���һ�ΰ�������״̬��ת
                begin
                    noinput_flag <= 1;
                    if(to_input)//��״̬�ٰ��°���
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
                if(!to_input || noinput_flag)//�ɿ�������ȴ���һ�ΰ�������״̬��ת
                begin
                    noinput_flag <= 1;
                    if(to_input)//��״̬�ٰ��°���
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
                if(!to_input || noinput_flag)//�ɿ�������ȴ���һ�ΰ�������״̬��ת
                begin
                    noinput_flag <= 1;
                    if(to_input)//��״̬�ٰ��°���
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
                if(!to_input || noinput_flag)//�ɿ�������ȴ���һ�ΰ�������״̬��ת
                begin
                    noinput_flag <= 1;
                    if(to_input)//��״̬�ٰ��°���
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
                count_j <= i;//��¼��ʱ��˸�ĵƱ��
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
                next_state <= s10;//�������ģ��
            end
        end  
        s6://�û�������ȷ������LED����˸״̬
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
                en <= 8'b0;//�жϽ���������ܲ���
                if(count2) begin control_LED[count_j] <= 1;end
                else begin control_LED[count_j] <= 0;end
            end
            i <= i+1;
            LED[i] <= control_LED[i];
            if(make_sure) begin /*next_state <= s8;*/flag_s6 <= 1;next_state <= s10;control_LED <= 16'h0;end
            if(restart)
            begin
                next_state <= s10;//�������ģ��
            end
        end
        s7://�û��������������״̬
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
                next_state <= s10;//�������ģ��
            end
        end
        s8://ȡ��ɹ���count+1��״̬
        begin
            if(allfull)
            begin
                allfull <= 0;
                count <= 0;//��ʱ��0����1
            end
            else count <= count +1;
            i = 0;
            next_state <= s9;
            if(restart)
            begin
                next_state <= s10;//�������ģ��
            end
        end
        s9://��LED�ɸ��ĺ��ػ�ӭ��������״̬
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
                next_state <= s10;//�������ģ��
            end
        end
        s10://��������״̬
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
                next_state <= s11;//��������ģ��
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
        s11://����һ�е�ģ��
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
                next_state <= s0;//������ɻص���ӭ����
            end
        end
        default:begin end
    endcase
    
end


endmodule
