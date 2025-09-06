module Basketball(TimerH, TimerL, Alarm, nRST,nPAUSE,CP); 
input nRST,nPAUSE, CP; 
output [3:0] TimerH, TimerL;
 reg [3:0]TimerH, TimerL; 
 output Alarm; 
assign Alarm=({TimerH, TimerL}==8'h00) & (nRST==1'b1);
 always @ (posedge CP or negedge nRST or negedge nPAUSE) 
 begin 
 if (~ nRST){TimerH, TimerL}<=8'h24;
else if (~ nPAUSE)
{TimerH, TimerL}<={TimerH, TimerL};
//复位时置初值 30
else if({TimerH, TimerL}==8'h00)
begin {TimerH, TimerL}<={TimerH, TimerL}; end
//暂停计时
//定时时间到，保持0不变
else if (TimerL==4'h0)
begin TimerH<=TimerH-1'b1; TimerL<=4'h9; end
else
begin TimerH<=TimerH; TimerL<=TimerL-1'b1; end
end
endmodule
