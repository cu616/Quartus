module SW_LED(
 input [ 7: 0] SW_In, //输入端口声明
 output [ 7: 0] LED_Out //输出端口声明
);
assign LED_Out = SW_In; //将开关状态送到 LED
endmodule