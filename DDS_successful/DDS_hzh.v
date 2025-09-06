module DDS_hzh(clk,keyin,switchin,wavevalue,sm_db0,sm_db1,sm_db2,sm_db3,led,hexdd,DW);
     input clk;
     input [2:0] keyin;
     input switchin;
     input [4:0] DW;   
     wire [9:0] address; 
     output [9:0] wavevalue; 
     wire [1:0] wavemode;
     wire [31:0] length;//change 32
     wire [2:0] keyout;
     output  [3:0] hexdd;
     output  [6:0] sm_db0;
     output  [6:0] sm_db1;
     output  [6:0] sm_db2;
     output  [6:0] sm_db3;
     output  [2:0] led;
   key U1(clk,keyin,keyout);
   control U2(clk,keyout,switchin,length,wavemode,DW);
   counter U3(clk,length,address);
   shumaguan U4(clk,length,sm_db0,sm_db1,sm_db2,sm_db3,led,hexdd);
   boxing U5(address,clk,wavemode,wavevalue);
endmodule

module boxing(address,clk,wavemode,wavevalue);
       input clk;
       input [9:0] address;
       input [1:0] wavemode;
       output [9:0] wavevalue;
       reg [9:0] wavevalue;
       wire [9:0] wavevalue1,wavevalue2,wavevalue3;
       sin M1(address,clk,wavevalue1);
       fangbo M2(address,clk,wavevalue2);
       sanjiao M3(address,clk,wavevalue3);
       always@(posedge clk)
       case(wavemode)
       2'b01:wavevalue= wavevalue1;
       2'b10:wavevalue= wavevalue2;
       2'b11:wavevalue= wavevalue3;
       endcase
endmodule

module counter(clk,fre_word,address);
  input clk;
  output reg [9:0] address;
  input [31:0] fre_word;
  reg[31:0] phaseadder;
  always@(posedge clk)
    begin
         phaseadder= phaseadder+ fre_word;
         address= phaseadder[31:22];
    end
endmodule 



module control(clk,keyin,switchin,length,wavemode,DW);//changed 
  input [2:0] keyin; 
  input clk;
  input [4:0] DW;
  input switchin;
  output reg [31:0] length;
  output reg [1:0] wavemode;
  reg [31:0]fredata;
  reg [2:0]key;
  reg switch;
  integer single_state= 1;
  reg [32:0] single_frc;
  
  always@(posedge clk)
  begin
    key=keyin;
    switch=switchin;
	if(DW == 5'b00001) begin
			single_frc = 32'd286;
			end
	else if(DW == 5'b00010) begin
			single_frc = 32'd28633;
			end
	else if(DW == 5'b00100) begin
			single_frc = 32'd286331;
			end
	else if(DW == 5'b01000) begin
			single_frc = 32'd2863311;
			end
	else if(DW == 5'b10000) begin
			single_frc = 32'd28633115;
			end
	else begin single_frc = 32'd28; end;										
    case(key)
     3'b001:begin 
            length= 32'd28633; //1kHz
            wavemode= 2'b01;//sin
            end
     3'b010:begin 
            case(single_state)
            1:wavemode= 2'b01;//sin
            2:wavemode= 2'b10;//fangbo
            3:wavemode= 2'b11;//sanjiaobo
            default:
            begin
            wavemode=2'b01;
            single_state= 0;
            end
            endcase
            single_state= single_state+1;
            end

      3'b100:begin
            if(switch==1)
            begin
				length= length - single_frc;
				/*case(single_frc)
				1:length= length- 32'd286;//-10Hz
				2:length= length- 32'd28633;//-1kHz
				3:length= length- 32'd286331;//-10kHz
				4:length= length- 32'd2863311;//-100kHz
				5:length= length- 32'd28633115;//-1MHz
				default:length= length- 0;
				endcase*/
            end
            else
            begin
				length = length + single_frc;
				/*case(single_frc)
				1:length= length+ 32'd286;//+10Hz
				2:length= length+ 32'd28633;//+1kHz
				3:length= length+ 32'd286331;//+10kHz
				4:length= length+ 32'd2863311;//+100kHz
				5:length= length+ 32'd28633115;//+1MHz
				default:length= length+ 0;
				endcase*/
			end
        end
    endcase
end
endmodule   
            

module shumaguan(clk,length,sm_db0,sm_db1,sm_db2,sm_db3,led,hexdd);//changed
  input clk;
  output reg [6:0] sm_db0;
  output reg [6:0] sm_db1;
  output reg [6:0] sm_db2;
  output reg [6:0] sm_db3;
  output reg [2:0] led;
  output reg [3:0] hexdd;
  input   [31:0] length;
  
  parameter seg0=7'h40,
            seg1=7'h79,
            seg2=7'h24,
            seg3=7'h30,
            seg4=7'h19,
            seg5=7'h12,
            seg6=7'h02,
            seg7=7'h78,
            seg8=7'h00,
            seg9=7'h10;
            
   
   reg [17:0] temp= 18'd34925;
   reg [47:0] AA;
   reg [31:0] fre;
   reg [3:0] A1,A2,A3,A4,A5,A6,A7;

   always@(posedge clk)
     begin
        AA= length*temp;
        fre= AA/24'd1000000;
        A1=(fre/24'd1000000);
        A2=(fre/24'd100000)%4'd10;
        A3=(fre/24'd10000)%4'd10;
        A4=(fre/24'd1000)%4'd10;
        A5=(fre/24'd100)%4'd10;
        A6=(fre/24'd10)%4'd10;
        A7=fre%4'd10; 
 
        if(A1!=4'd0) 
           begin
		   led =3'b100;
           if(A1<4'd10)
           begin
            hexdd = 4'b0111;
            case(A1)
               4'd1:  sm_db0 <= seg1;
               4'd2:  sm_db0 <= seg2;
               4'd3:  sm_db0 <= seg3;
               4'd4:  sm_db0 <= seg4;
               4'd5:  sm_db0 <= seg5;
               4'd6:  sm_db0 <= seg6;
               4'd7:  sm_db0 <= seg7;
               4'd8:  sm_db0 <= seg8;
               4'd9:  sm_db0 <= seg9;   
               default:  ;
            endcase
               
            case(A2)
               4'd0:  sm_db1 <= seg0;
               4'd1:  sm_db1 <= seg1;
               4'd2:  sm_db1 <= seg2;
               4'd3:  sm_db1 <= seg3;
               4'd4:  sm_db1 <= seg4;
               4'd5:  sm_db1 <= seg5;
               4'd6:  sm_db1 <= seg6;
               4'd7:  sm_db1 <= seg7;
               4'd8:  sm_db1 <= seg8;
               4'd9:  sm_db1 <= seg9;   
               default:  ;
             endcase
               
             case(A3)
               4'd0:  sm_db2 <= seg0;
               4'd1:  sm_db2 <= seg1;
               4'd2:  sm_db2 <= seg2;
               4'd3:  sm_db2 <= seg3;
               4'd4:  sm_db2 <= seg4;
               4'd5:  sm_db2 <= seg5;
               4'd6:  sm_db2 <= seg6;
               4'd7:  sm_db2 <= seg7;
               4'd8:  sm_db2 <= seg8;
               4'd9:  sm_db2 <= seg9;   
               default:  ;
             endcase
               
              case(A4)
               4'd0:  sm_db3 <= seg0;
               4'd1:  sm_db3 <= seg1;
               4'd2:  sm_db3 <= seg2;
               4'd3:  sm_db3 <= seg3;
               4'd4:  sm_db3 <= seg4;
               4'd5:  sm_db3 <= seg5;
               4'd6:  sm_db3 <= seg6;
               4'd7:  sm_db3 <= seg7;
               4'd8:  sm_db3 <= seg8;
               4'd9:  sm_db3 <= seg9;   
               default:  ;
              endcase
           end
           else
           begin
			hexdd <= 4'b1011;
		   case(A1/10)
			   4'd1:  sm_db0 <= seg1;
               4'd2:  sm_db0 <= seg2;
               4'd3:  sm_db0 <= seg3;
               4'd4:  sm_db0 <= seg4;
               4'd5:  sm_db0 <= seg5;
               4'd6:  sm_db0 <= seg6;
               4'd7:  sm_db0 <= seg7;
               4'd8:  sm_db0 <= seg8;
               4'd9:  sm_db0 <= seg9;   
               default:  ;
            endcase
            case(A1%10)
		       4'd0:  sm_db1 <= seg0;
               4'd1:  sm_db1 <= seg1;
               4'd2:  sm_db1 <= seg2;
               4'd3:  sm_db1 <= seg3;
               4'd4:  sm_db1 <= seg4;
               4'd5:  sm_db1 <= seg5;
               4'd6:  sm_db1 <= seg6;
               4'd7:  sm_db1 <= seg7;
               4'd8:  sm_db1 <= seg8;
               4'd9:  sm_db1 <= seg9; 
               default:  ;
             endcase
            case(A2)
		       4'd0:  sm_db2 <= seg0;
               4'd1:  sm_db2 <= seg1;
               4'd2:  sm_db2 <= seg2;
               4'd3:  sm_db2 <= seg3;
               4'd4:  sm_db2 <= seg4;
               4'd5:  sm_db2 <= seg5;
               4'd6:  sm_db2 <= seg6;
               4'd7:  sm_db2 <= seg7;
               4'd8:  sm_db2 <= seg8;
               4'd9:  sm_db2 <= seg9;   
               default:  ;
             endcase
            case(A3)
		       4'd0:  sm_db3 <= seg0;
               4'd1:  sm_db3 <= seg1;
               4'd2:  sm_db3 <= seg2;
               4'd3:  sm_db3 <= seg3;
               4'd4:  sm_db3 <= seg4;
               4'd5:  sm_db3 <= seg5;
               4'd6:  sm_db3 <= seg6;
               4'd7:  sm_db3 <= seg7;
               4'd8:  sm_db3 <= seg8;
               4'd9:  sm_db3 <= seg9;   
               default:  ;
            endcase
		   end
         end
     
         else if(A2!=4'd0)
            begin
              led = 3'b010;
              hexdd = 4'b1101;
             case(A2)
               4'd1:  sm_db0 <= seg1;
               4'd2:  sm_db0 <= seg2;
               4'd3:  sm_db0 <= seg3;
               4'd4:  sm_db0 <= seg4;
               4'd5:  sm_db0 <= seg5;
               4'd6:  sm_db0 <= seg6;
               4'd7:  sm_db0 <= seg7;
               4'd8:  sm_db0 <= seg8;
               4'd9:  sm_db0 <= seg9;   
               default:  ;
            endcase
               
            case(A3)
               4'd0:  sm_db1 <= seg0;
               4'd1:  sm_db1 <= seg1;
               4'd2:  sm_db1 <= seg2;
               4'd3:  sm_db1 <= seg3;
               4'd4:  sm_db1 <= seg4;
               4'd5:  sm_db1 <= seg5;
               4'd6:  sm_db1 <= seg6;
               4'd7:  sm_db1 <= seg7;
               4'd8:  sm_db1 <= seg8;
               4'd9:  sm_db1 <= seg9;   
               default:  ;
             endcase
               
             case(A4)
               4'd0:  sm_db2 <= seg0;
               4'd1:  sm_db2 <= seg1;
               4'd2:  sm_db2 <= seg2;
               4'd3:  sm_db2 <= seg3;
               4'd4:  sm_db2 <= seg4;
               4'd5:  sm_db2 <= seg5;
               4'd6:  sm_db2 <= seg6;
               4'd7:  sm_db2 <= seg7;
               4'd8:  sm_db2 <= seg8;
               4'd9:  sm_db2 <= seg9;   
               default:  ;
             endcase
               
              case(A5)
               4'd0:  sm_db3 <= seg0;
               4'd1:  sm_db3 <= seg1;
               4'd2:  sm_db3 <= seg2;
               4'd3:  sm_db3 <= seg3;
               4'd4:  sm_db3 <= seg4;
               4'd5:  sm_db3 <= seg5;
               4'd6:  sm_db3 <= seg6;
               4'd7:  sm_db3 <= seg7;
               4'd8:  sm_db3 <= seg8;
               4'd9:  sm_db3 <= seg9;   
               default:  ;
              endcase
           end
           
           else if(A3!=4'd0)
            begin
              led = 3'b010;
              hexdd = 4'b1011;
             case(A3)
               4'd1:  sm_db0 <= seg1;
               4'd2:  sm_db0 <= seg2;
               4'd3:  sm_db0 <= seg3;
               4'd4:  sm_db0 <= seg4;
               4'd5:  sm_db0 <= seg5;
               4'd6:  sm_db0 <= seg6;
               4'd7:  sm_db0 <= seg7;
               4'd8:  sm_db0 <= seg8;
               4'd9:  sm_db0 <= seg9;   
               default:  ;
            endcase
               
            case(A4)
               4'd0:  sm_db1 <= seg0;
               4'd1:  sm_db1 <= seg1;
               4'd2:  sm_db1 <= seg2;
               4'd3:  sm_db1 <= seg3;
               4'd4:  sm_db1 <= seg4;
               4'd5:  sm_db1 <= seg5;
               4'd6:  sm_db1 <= seg6;
               4'd7:  sm_db1 <= seg7;
               4'd8:  sm_db1 <= seg8;
               4'd9:  sm_db1 <= seg9;   
               default:  ;
             endcase
               
             case(A5)
               4'd0:  sm_db2 <= seg0;
               4'd1:  sm_db2 <= seg1;
               4'd2:  sm_db2 <= seg2;
               4'd3:  sm_db2 <= seg3;
               4'd4:  sm_db2 <= seg4;
               4'd5:  sm_db2 <= seg5;
               4'd6:  sm_db2 <= seg6;
               4'd7:  sm_db2 <= seg7;
               4'd8:  sm_db2 <= seg8;
               4'd9:  sm_db2 <= seg9;   
               default:  ;
             endcase
               
              case(A6)
               4'd0:  sm_db3 <= seg0;
               4'd1:  sm_db3 <= seg1;
               4'd2:  sm_db3 <= seg2;
               4'd3:  sm_db3 <= seg3;
               4'd4:  sm_db3 <= seg4;
               4'd5:  sm_db3 <= seg5;
               4'd6:  sm_db3 <= seg6;
               4'd7:  sm_db3 <= seg7;
               4'd8:  sm_db3 <= seg8;
               4'd9:  sm_db3 <= seg9;   
               default:  ;
              endcase
           end
 
           
           else 
            begin
              led = 3'b001;
              hexdd = 4'b1110;
             case(A4)
               4'd1:  sm_db0 <= seg1;
               4'd2:  sm_db0 <= seg2;
               4'd3:  sm_db0 <= seg3;
               4'd4:  sm_db0 <= seg4;
               4'd5:  sm_db0 <= seg5;
               4'd6:  sm_db0 <= seg6;
               4'd7:  sm_db0 <= seg7;
               4'd8:  sm_db0 <= seg8;
               4'd9:  sm_db0 <= seg9;   
               default:  ;
            endcase
               
            case(A5)
               4'd0:  sm_db1 <= seg0;
               4'd1:  sm_db1 <= seg1;
               4'd2:  sm_db1 <= seg2;
               4'd3:  sm_db1 <= seg3;
               4'd4:  sm_db1 <= seg4;
               4'd5:  sm_db1 <= seg5;
               4'd6:  sm_db1 <= seg6;
               4'd7:  sm_db1 <= seg7;
               4'd8:  sm_db1 <= seg8;
               4'd9:  sm_db1 <= seg9;   
               default:  ;
             endcase
               
             case(A6)
               4'd0:  sm_db2 <= seg0;
               4'd1:  sm_db2 <= seg1;
               4'd2:  sm_db2 <= seg2;
               4'd3:  sm_db2 <= seg3;
               4'd4:  sm_db2 <= seg4;
               4'd5:  sm_db2 <= seg5;
               4'd6:  sm_db2 <= seg6;
               4'd7:  sm_db2 <= seg7;
               4'd8:  sm_db2 <= seg8;
               4'd9:  sm_db2 <= seg9;   
               default:  ;
             endcase
               
              case(A7)
               4'd0:  sm_db3 <= seg0;
               4'd1:  sm_db3 <= seg1;
               4'd2:  sm_db3 <= seg2;
               4'd3:  sm_db3 <= seg3;
               4'd4:  sm_db3 <= seg4;
               4'd5:  sm_db3 <= seg5;
               4'd6:  sm_db3 <= seg6;
               4'd7:  sm_db3 <= seg7;
               4'd8:  sm_db3 <= seg8;
               4'd9:  sm_db3 <= seg9;   
               default:  ;
              endcase
           end
     end
     
endmodule

module key(clk,keyin,keyout);//changed
     input clk;
     input [2:0]keyin;
     output [2:0]keyout;
     reg [2:0]keyout;
     reg [24:0]scan;
     reg [2:0]key;
     reg keyen;
     integer i=0;
     always@(posedge clk)
      if(keyin!=3'h7)
          if(scan==25'd26000000)
             begin keyen<=1'b1; scan<=1'b0; end
          else  begin keyen<=1'b0; scan<=scan+1'b1; end
      else  begin
            if(scan!=0)  scan<=scan-1'b1;
            else scan<=scan;
            keyen<=1'b0;
            end
     always@(posedge clk)
       if(keyen)
          keyout<= ~keyin;
       else keyout<= 3'h0;//???????????
endmodule