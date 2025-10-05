module counter99(//默认计到{NUM_H,NUM_L}
    input CP, nCR, EN,//CP时计，nCR清零，EN暂停
    output reg [3:0] CntH, CntL
);
parameter [3:0] NUM_H=9;
parameter [3:0] NUM_L=9;
    always @(posedge CP or negedge nCR)
    begin
        if (~nCR)
            {CntH, CntL} <= 8'h00;
        else if (~EN)
            {CntH, CntL} <= {CntH, CntL};
        else if ((CntH > NUM_H) || ((CntH == NUM_H) && (CntL > NUM_L)))
            {CntH, CntL} <= 8'h00;
        else if (CntL == 9)
            begin CntH <= CntH + 1'b1;CntL <= 4'h0;end
        else
            begin CntH <= CntH;CntL <= CntL + 1'b1;end
    end
endmodule