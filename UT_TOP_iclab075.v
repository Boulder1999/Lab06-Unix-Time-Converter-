//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : UT_TOP.v
//   Module Name : UT_TOP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

//synopsys translate_off
`include "B2BCD_IP.v"
//synopsys translate_on

module UT_TOP (
    // Input signals
    clk, rst_n, in_valid, in_time,
    // Output signals
    out_valid, out_display, out_day
);

// ===============================================================
// Input & Output Declaration
// ===============================================================
input clk, rst_n, in_valid;
input [30:0] in_time;
output reg out_valid;
output reg [3:0] out_display;
output reg [2:0] out_day;

// ===============================================================
// Parameter & Integer Declaration
// ===============================================================
parameter IDLE=2'd0,LOAD=2'd1,PROCESS=2'd2,OUT=2'd3;
reg [1:0]cs,ns;
reg [30:0] time_reg;
//================================================================
// Wire & Reg Declaration
//================================================================
reg year_cnt_flag,kind_year_flag,month_flag,sec_flag;
reg [5:0] year_cnt;
reg [1:0] kind_year;
reg [30:0] remain_time;
reg [11:0] year;
reg [3:0] month;
reg [7:0] day;
reg [7:0] hour;
reg [7:0] min;
reg [7:0] sec;
reg [3:0] today;
wire [11:0] sec_bcd;
wire [11:0] min_bcd;
wire [11:0] hour_bcd;
wire [11:0] day_bcd;
wire [7:0] month_bcd;
wire [15:0] year_bcd;
reg [7:0] cnt,cnt_out;
reg [30:0] temp0;
reg [30:0] temp1;
//================================================================
// DESIGN
//================================================================

B2BCD_IP #(.WIDTH(12), .DIGIT(4)) I_B2BCD_IP_1 ( .Binary_code(year), .BCD_code(year_bcd) );
B2BCD_IP #(.WIDTH(4), .DIGIT(2)) I_B2BCD_IP_2 ( .Binary_code(month), .BCD_code(month_bcd) );
B2BCD_IP #(.WIDTH(8), .DIGIT(3)) I_B2BCD_IP_3 ( .Binary_code(day), .BCD_code(day_bcd) );
B2BCD_IP #(.WIDTH(8), .DIGIT(3)) I_B2BCD_IP_4 ( .Binary_code(hour), .BCD_code(hour_bcd) );
B2BCD_IP #(.WIDTH(8), .DIGIT(3)) I_B2BCD_IP_5 ( .Binary_code(min), .BCD_code(min_bcd) );
B2BCD_IP #(.WIDTH(8), .DIGIT(3)) I_B2BCD_IP_6 ( .Binary_code(sec), .BCD_code(sec_bcd) );

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        cs<=IDLE;
    end
    else begin
        cs<=ns;
    end
end
always@(*) begin
    case(cs)
    IDLE:begin
        if(in_valid) begin
            ns = LOAD;
        end
        else begin
            ns = IDLE;
        end
    end
    LOAD:begin
        if(in_valid) begin
            ns = LOAD;
        end
        else begin
            ns = PROCESS;
        end
    end
    PROCESS:begin
        if(sec_flag) begin
            ns = OUT;
        end
        else begin
            ns = PROCESS ; 
        end
    end
    OUT:begin
        if(cnt_out < 15) begin
            ns = OUT;
        end
        else begin
            ns = IDLE;
        end
    end
    endcase
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        time_reg <= 31'd0;
    end
    else if( ns == IDLE ) begin
        time_reg<=31'd0;
    end
    else if( ns == LOAD ) begin
        if(in_valid)
        time_reg <= in_time ;
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        year_cnt <= 5'd0;
        year_cnt_flag <= 1'b0;
    end
    else if( ns == IDLE ) begin
        year_cnt <= 5'd0;
        year_cnt_flag <= 1'b0;
    end
    else if( ns == PROCESS ) begin
        if( time_reg < 31'd126230400 ) begin
            year_cnt <= 5'd0;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd126230399 && time_reg < 31'd252460800) begin 
            year_cnt <= 5'd1;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd252460799 && time_reg < 31'd378691200) begin
            year_cnt <= 5'd2;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd378691199 && time_reg < 31'd504921600) begin 
            year_cnt <= 5'd3;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd504921599 && time_reg < 31'd631152000) begin
            year_cnt <= 5'd4;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd631151999 && time_reg < 31'd757382400) begin
            year_cnt <= 5'd5;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd757382399 && time_reg < 31'd883612800) begin
            year_cnt <= 5'd6;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd883612799 && time_reg < 31'd1009843200) begin
            year_cnt <= 5'd7;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd1009843199 && time_reg < 31'd1136073600) begin
            year_cnt <= 5'd8;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd1136073599 && time_reg < 31'd1262304000) begin
            year_cnt <= 5'd9;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd1262303999 && time_reg < 31'd1388534400) begin
            year_cnt <= 5'd10;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd1388534399 && time_reg < 31'd1514764800) begin
            year_cnt <= 5'd11;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd1514764799 && time_reg < 31'd1640995200) begin
            year_cnt <= 5'd12;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd1640995199 && time_reg < 31'd1767225600) begin
            year_cnt <= 5'd13;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd1767225599 && time_reg < 31'd1893456000) begin
            year_cnt <= 5'd14;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd1893455999 && time_reg < 31'd2019686400) begin
            year_cnt <= 5'd15;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd2019686399 && time_reg < 31'd2145916800) begin
            year_cnt <= 5'd16;
            year_cnt_flag <= 1'b1;
        end
        else if(time_reg > 31'd2145916799 ) begin
            year_cnt <= 6'd17;
            year_cnt_flag <= 1'b1;
        end
    end
end


always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        kind_year <= 2'd0;
        kind_year_flag <= 1'b0;
    end
    else if( ns == IDLE ) begin
        kind_year <= 2'd0;
        kind_year_flag <= 1'b0;
    end
    else if( ns == PROCESS ) begin
        if(cnt==8'd2) begin
            if(remain_time < 31'd31536000) begin
                kind_year <= 2'd0;
                kind_year_flag<=1'b1;
            end
            else if(remain_time > 31'd31535999 && remain_time < 31'd63072000) begin
                 kind_year <= 2'd1;
                kind_year_flag<=1'b1;
            end
            else if(remain_time > 31'd63071999 && remain_time < 31'd94694400) begin
                 kind_year <= 2'd2;
                kind_year_flag<=1'b1;
            end
            else if(remain_time > 31'd94694399 && remain_time < 31'd126230400) begin
                 kind_year <= 2'd3;
                kind_year_flag<=1'b1;
            end
        end
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        year <= 16'd0;
    end
    else if( ns == IDLE)
    begin
        year <= 16'd0;
    end
    else if(ns == PROCESS) begin
        if(kind_year_flag == 1'b1) begin
            year <= 1970+year_cnt*4+kind_year;
        end
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        month <= 4'd0;
    end
    else if(ns == IDLE)
    begin
        month <= 4'd0;
    end
    else if(ns == PROCESS)
    begin
        if(cnt==8'd4) begin
            if(kind_year==2'd0 || kind_year == 2'd1 || kind_year == 2'd3) begin
                if(remain_time < 31'd2678400) begin
                    month<=4'd1;
                    //month_flag<=1'b1;
                end
                else if(remain_time > 31'd2678399 && remain_time < 31'd5097600) begin
                    month<=4'd2;
                   // month_flag<=1'b1;
                end
                else if(remain_time > 31'd5097599 && remain_time < 31'd7776000) begin
                    month<=4'd3;
                   // month_flag<=1'b1;
                end
                else if(remain_time > 31'd7775999 && remain_time < 31'd10368000) begin
                    month<=4'd4;
                   // month_flag<=1'b1;
                end
                else if(remain_time > 31'd10367999 && remain_time < 31'd13046400) begin
                    month<=4'd5;
                    //month_flag<=1'b1;
                end
                else if(remain_time > 31'd13036399 && remain_time < 31'd15638400) begin
                    month<=4'd6;
                   // month_flag<=1'b1;
                end
                else if(remain_time > 31'd15638399 && remain_time < 31'd18316800) begin
                    month<=4'd7;
                   // month_flag<=1'b1;
                end
                else if(remain_time > 31'd18316799 && remain_time < 31'd20995200) begin
                    month<=4'd8;
                    //month_flag<=1'b1;
                end
                else if(remain_time > 31'd20995199 && remain_time < 31'd23587200) begin
                    month<=4'd9;
                  //  month_flag<=1'b1;
                end
                else if(remain_time > 31'd23587199 && remain_time < 31'd26265600) begin
                    month<=4'd10;
                  //  month_flag<=1'b1;
                end
                else if(remain_time > 31'd26265599 && remain_time < 31'd28857600) begin
                    month<=4'd11;
                   // month_flag<=1'b1;
                end
                else if(remain_time > 31'd28857599 ) begin
                    month<=4'd12;
                  //  month_flag<=1'b1;
                end
            end
            else if(kind_year==2'd2 ) begin
                if(remain_time < 31'd2678400) begin
                    month<=4'd1;
                  //  month_flag<=1'b1;
                end
                else if(remain_time > 31'd2678399 && remain_time < 31'd5184000) begin
                    month<=4'd2;
                   // month_flag<=1'b1;
                end
                else if(remain_time > 31'd5183999 && remain_time < 31'd7862400) begin
                    month<=4'd3;
                  //  month_flag<=1'b1;
                end
                else if(remain_time > 31'd7862399 && remain_time < 31'd10454400) begin
                    month<=4'd4;
                  //  month_flag<=1'b1;
                end
                else if(remain_time > 31'd10454399 && remain_time < 31'd13132800) begin
                    month<=4'd5;
                  //  month_flag<=1'b1;
                end
                else if(remain_time > 31'd13132799 && remain_time < 31'd15724800) begin
                    month<=4'd6;
                  //  month_flag<=1'b1;
                end
                else if(remain_time > 31'd15724799 && remain_time < 31'd18403200) begin
                    month<=4'd7;
                   // month_flag<=1'b1;
                end
                else if(remain_time > 31'd18403199 && remain_time < 31'd21081600) begin
                    month<=4'd8;
                  //  month_flag<=1'b1;
                end
                else if(remain_time > 31'd21081599 && remain_time < 31'd23673600) begin
                    month<=4'd9;
                  //  month_flag<=1'b1;
                end
                else if(remain_time > 31'd23673599 && remain_time < 31'd26352000) begin
                    month<=4'd10;
                   // month_flag<=1'b1;
                end
                else if(remain_time > 31'd26351999 && remain_time < 31'd28944000) begin
                    month<=4'd11;
                  //  month_flag<=1'b1;
                end
                else if(remain_time > 31'd28943999 ) begin
                    month<=4'd12;
                   // month_flag<=1'b1;
                end
            end
        end
    end
end

always@(posedge clk or negedge rst_n) begin
if(!rst_n)
begin
    day <= 8'd0;
end
else if( ns == IDLE)
begin
    day <= 8'd0;
end
else if(ns == PROCESS) begin
    if(cnt==8'd6) begin
        //day <= remain_time/86400+1;
        if( remain_time<86400 ) day<=8'd1;
        else if(remain_time < 172800 && remain_time > 86399) day<=8'd2;
        else if(remain_time < 259200 && remain_time > 172799) day<=8'd3;
        else if(remain_time < 345600 && remain_time > 259199) day<=8'd4;
        else if(remain_time < 432000&& remain_time > 345599) day<=8'd5;
        else if(remain_time < 518400&& remain_time > 431999) day<=8'd6;
        else if(remain_time < 604800&& remain_time > 518399) day<=8'd7;
        else if(remain_time < 691200&& remain_time > 604799) day<=8'd8;
        else if(remain_time < 777600&& remain_time > 691199) day<=8'd9;
        else if(remain_time < 864000&& remain_time > 777599) day<=8'd10;
        else if(remain_time < 950400&& remain_time > 863999) day<=8'd11;
        else if(remain_time < 1036800&& remain_time >950399) day<=8'd12;
        else if(remain_time < 1123200&& remain_time > 1036799) day<=8'd13;
        else if(remain_time < 1209600&& remain_time > 1123199) day<=8'd14;
        else if(remain_time < 1296000&& remain_time > 1209599) day<=8'd15;
        else if(remain_time < 1382400&& remain_time > 1295999) day<=8'd16;
        else if(remain_time < 1468800&& remain_time > 1382399) day<=8'd17;
        else if(remain_time < 1555200&& remain_time > 1468799) day<=8'd18;
        else if(remain_time < 1641600&& remain_time > 1555199) day<=8'd19;
        else if(remain_time < 1728000&& remain_time > 1641599) day<=8'd20;
        else if(remain_time < 1814400&& remain_time > 1727999) day<=8'd21;
        else if(remain_time < 1900800&& remain_time > 1814399) day<=8'd22;
        else if(remain_time < 1987200&& remain_time > 1900799) day<=8'd23;
        else if(remain_time < 2073600&& remain_time > 1987199) day<=8'd24;
        else if(remain_time < 2160000&& remain_time > 2073599) day<=8'd25;
        else if(remain_time < 2246400&& remain_time > 2159999) day<=8'd26;
        else if(remain_time < 2332800&& remain_time > 2246399) day<=8'd27;
        else if(remain_time < 2419200&& remain_time > 2332799) day<=8'd28;
        else if(remain_time < 2505600&& remain_time > 2419199) day<=8'd29;
        else if(remain_time < 2592000&& remain_time > 2505599) day<=8'd30;
        else if(remain_time < 2678400&& remain_time > 2591999) day<=8'd31;
    end
end
end
 

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        hour <= 8'd0;
    end
    else if( ns == IDLE)
    begin
        hour <= 8'd0;
    end
    else if(ns == PROCESS) begin
        if(cnt==8'd8) begin
            //hour <= remain_time/3600;
            if(remain_time <3600) hour<=8'd0;
            else if(remain_time < 7200 && remain_time > 3599) hour<=8'd1;
            else if(remain_time < 10800 && remain_time > 7199) hour<=8'd2;
            else if(remain_time < 14400 && remain_time > 10799) hour<=8'd3;
            else if(remain_time < 18000 && remain_time > 14399) hour<=8'd4;
            else if(remain_time < 21600 && remain_time > 17999) hour<=8'd5;
            else if(remain_time < 25200 && remain_time > 21599) hour<=8'd6;
            else if(remain_time < 28800 && remain_time > 25199) hour<=8'd7;
            else if(remain_time < 32400 && remain_time > 28799) hour<=8'd8;
            else if(remain_time < 36000 && remain_time > 32399) hour<=8'd9;
            else if(remain_time < 39600 && remain_time > 35999) hour<=8'd10;
            else if(remain_time < 43200 && remain_time > 39599) hour<=8'd11;
            else if(remain_time < 46800 && remain_time > 43199) hour<=8'd12;
            else if(remain_time < 50400 && remain_time > 46799) hour<=8'd13;
            else if(remain_time < 54000 && remain_time > 50399) hour<=8'd14;
            else if(remain_time < 57600 && remain_time > 53999) hour<=8'd15;
            else if(remain_time < 61200 && remain_time > 57599) hour<=8'd16;
            else if(remain_time < 64800 && remain_time > 61199) hour<=8'd17;
            else if(remain_time < 68400 && remain_time > 64799) hour<=8'd18;
            else if(remain_time < 72000 && remain_time > 68399) hour<=8'd19;
            else if(remain_time < 75600 && remain_time > 71999) hour<=8'd20;
            else if(remain_time < 79200 && remain_time > 75599) hour<=8'd21;
            else if(remain_time < 82800 && remain_time > 79199) hour<=8'd22;
            else if(remain_time < 86400 && remain_time > 82799) hour<=8'd23;
        end
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        min <= 8'd0;
    end
    else if( ns == IDLE)
    begin
        min <= 8'd0;
    end
    else if(ns == PROCESS) begin
        if(cnt==8'd10) begin
            min <= remain_time/60;
        end
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        sec <= 8'd0;
        sec_flag <= 1'b0;
    end
    else if( ns == IDLE)
    begin
        sec <= 8'd0;
        sec_flag <= 1'b0;
    end
    else if(ns == PROCESS) begin
        if(cnt==8'd12) begin
            sec <= remain_time;
            sec_flag<=1'b1;
        end
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        remain_time <= 31'd0;
    end
    else if(ns == IDLE) begin
        remain_time <= 31'd0;
    end
    else if( ns == PROCESS) begin
        if(year_cnt_flag==1'b1 && kind_year_flag == 1'b0) remain_time <= time_reg - 31'd126230400*(year_cnt) ;
        else if(cnt==8'd3) begin
            case(kind_year)
            2'd00:begin
                remain_time<=remain_time;
            end
            2'd01:begin
                remain_time<=remain_time-31'd31536000;
            end
            2'd2:begin
                remain_time<=remain_time-31'd63072000;
            end
            2'd3:begin
                remain_time<=remain_time-31'd94694400;
            end
            endcase
        end
        else if(cnt==8'd5) begin
            if(kind_year==2'd0 || kind_year == 2'd1 || kind_year == 2'd3 ) begin
                case(month)
                4'd1:remain_time<=remain_time ;
                4'd2:remain_time<=remain_time-31*86400;
                4'd3:remain_time<=remain_time-(31+28)*86400;
                4'd4:remain_time<=remain_time-(31+28+31)*86400;
                4'd5:remain_time<=remain_time-(31+28+31+30)*86400;
                4'd6:remain_time<=remain_time-(31+28+31+30+31)*86400;
                4'd7:remain_time<=remain_time-(31+28+31+30+31+30)*86400;
                4'd8:remain_time<=remain_time-(31+28+31+30+31+30+31)*86400;
                4'd9:remain_time<=remain_time-(31+28+31+30+31+30+31+31)*86400;
                4'd10:remain_time<=remain_time-(31+28+31+30+31+30+31+31+30)*86400;
                4'd11:remain_time<=remain_time-(31+28+31+30+31+30+31+31+30+31)*86400;
                4'd12:remain_time<=remain_time-(31+28+31+30+31+30+31+31+30+31+30)*86400;
                endcase
            end
            else if(kind_year==2'd2 ) begin
                case(month)
                4'd1:remain_time<=remain_time ;
                4'd2:remain_time<=remain_time-31*86400;
                4'd3:remain_time<=remain_time-(31+29)*86400;
                4'd4:remain_time<=remain_time-(31+29+31)*86400;
                4'd5:remain_time<=remain_time-(31+29+31+30)*86400;
                4'd6:remain_time<=remain_time-(31+29+31+30+31)*86400;
                4'd7:remain_time<=remain_time-(31+29+31+30+31+30)*86400;
                4'd8:remain_time<=remain_time-(31+29+31+30+31+30+31)*86400;
                4'd9:remain_time<=remain_time-(31+29+31+30+31+30+31+31)*86400;
                4'd10:remain_time<=remain_time-(31+29+31+30+31+30+31+31+30)*86400;
                4'd11:remain_time<=remain_time-(31+29+31+30+31+30+31+31+30+31)*86400;
                4'd12:remain_time<=remain_time-(31+29+31+30+31+30+31+31+30+31+30)*86400;
                endcase
            end
        end
        else if(cnt==8'd7) begin
            remain_time<=remain_time-(day-1)*86400;
        end
        else if(cnt==8'd9) begin
            remain_time<=remain_time-hour*3600;
        end
        else if( cnt==8'd11) begin
            remain_time<=remain_time-min*60;
        end
    end
end
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        today<=4'd0;
    end
    else if( ns == IDLE)
    begin
        today<=4'd0;
    end
    else if(ns == PROCESS) begin
        if(cnt == 8'd8)
        today<=temp1%7;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        temp0<=31'd0;
    end
    else if( ns == IDLE)
    begin
        temp0<=31'd0;
    end
    else if(ns == PROCESS) begin
        if(cnt==8'd2) temp0<=1461*year_cnt;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        temp1<=31'd0;
    end
    else if( ns == IDLE)
    begin
        temp1<=31'd0;
    end
    else if(ns == PROCESS) begin
        if(cnt==8'd7) begin
            if(kind_year == 2'd2) begin
                case(month)
                4'd1:temp1<=( temp0+365*2+day-1);
                4'd2:temp1<=( temp0+365*2+31+day-1);
                4'd3:temp1<=( temp0+365*2+31+29+day-1);
                4'd4:temp1<=( temp0+365*2+31+29+31+day-1);
                4'd5:temp1<=( temp0+365*2+31+29+31+30+day-1);
                4'd6:temp1<=( temp0+365*2+31+29+31+30+31+day-1);
                4'd7:temp1<=( temp0+365*2+31+29+31+30+31+30+day-1);
                4'd8:temp1<=( temp0+365*2+31+29+31+30+31+30+31+day-1);
                4'd9:temp1<=( temp0+365*2+31+29+31+30+31+30+31+31+day-1);
                4'd10:temp1<=( temp0+365*2+31+29+31+30+31+30+31+31+30+day-1);
                4'd11:temp1<=( temp0+365*2+31+29+31+30+31+30+31+31+30+31+day-1);
                4'd12:temp1<=( temp0+365*2+31+29+31+30+31+30+31+31+30+31+30+day-1);
                endcase
            end
            else if(kind_year == 2'd0) begin
                case(month)
                4'd1:temp1<=( temp0+day-1);
                4'd2:temp1<=( temp0+31+day-1);
                4'd3:temp1<=( temp0+31+28+day-1);
                4'd4:temp1<=( temp0+31+28+31+day-1);
                4'd5:temp1<=( temp0+31+28+31+30+day-1);
                4'd6:temp1<=( temp0+31+28+31+30+31+day-1);
                4'd7:temp1<=( temp0+31+28+31+30+31+30+day-1);
                4'd8:temp1<=( temp0+31+28+31+30+31+30+31+day-1);
                4'd9:temp1<=( temp0+31+28+31+30+31+30+31+31+day-1);
                4'd10:temp1<=(temp0+31+28+31+30+31+30+31+31+30+day-1);
                4'd11:temp1<=( temp0+31+28+31+30+31+30+31+31+30+31+day-1);
                4'd12:temp1<=( temp0+31+28+31+30+31+30+31+31+30+31+30+day-1);
                endcase
            end
            else if(kind_year == 2'd1) begin
                case(month)
                4'd1:temp1<=( temp0+365+day-1);
                4'd2:temp1<=( temp0+365+31+day-1);
                4'd3:temp1<=( temp0+365+31+28+day-1);
                4'd4:temp1<=( temp0+365+31+28+31+day-1);
                4'd5:temp1<=( temp0+365+31+28+31+30+day-1);
                4'd6:temp1<=( temp0+365+31+28+31+30+31+day-1);
                4'd7:temp1<=( temp0+365+31+28+31+30+31+30+day-1);
                4'd8:temp1<=( temp0+365+31+28+31+30+31+30+31+day-1);
                4'd9:temp1<=( temp0+365+31+28+31+30+31+30+31+31+day-1);
                4'd10:temp1<=( temp0+365+31+28+31+30+31+30+31+31+30+day-1);
                4'd11:temp1<=( temp0+365+31+28+31+30+31+30+31+31+30+31+day-1);
                4'd12:temp1<=( temp0+365+31+28+31+30+31+30+31+31+30+31+30+day-1);
                endcase
            end
            else if(kind_year == 2'd3) begin
                case(month)
                4'd1:temp1<=( temp0+365*2+366+day-1);
                4'd2:temp1<=( temp0+365*2+366+31+day-1);
                4'd3:temp1<=( temp0+365*2+366+31+28+day-1);
                4'd4:temp1<=( temp0+365*2+366+31+28+31+day-1);
                4'd5:temp1<=( temp0+365*2+366+31+28+31+30+day-1);
                4'd6:temp1<=( temp0+365*2+366+31+28+31+30+31+day-1);
                4'd7:temp1<=( temp0+365*2+366+31+28+31+30+31+30+day-1);
                4'd8:temp1<=( temp0+365*2+366+31+28+31+30+31+30+31+day-1);
                4'd9:temp1<=( temp0+365*2+366+31+28+31+30+31+30+31+31+day-1);
                4'd10:temp1<=( temp0+365*2+366+31+28+31+30+31+30+31+31+30+day-1);
                4'd11:temp1<=( temp0+365*2+366+31+28+31+30+31+30+31+31+30+31+day-1);
                4'd12:temp1<=( temp0+365*2+366+31+28+31+30+31+30+31+31+30+31+30+day-1);
                endcase
            end
        end
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    begin
        cnt<=8'd0;
    end
    else if(ns == IDLE) begin
        cnt<=8'd0;
    end
    else if(ns == PROCESS) begin
        cnt<=cnt+8'd1;
    end
    else if(ns == OUT) begin
        cnt<=8'd0;
    end
end
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
    begin
        cnt_out<=8'd0;
    end
    else if(ns == IDLE) begin
        cnt_out<=8'd0;
    end
    else if(ns == OUT) begin
        cnt_out<=cnt_out+8'd1;
    end
end
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
    begin
        out_day<=3'd0;
    end
    else if(ns == IDLE) begin
        out_day<=3'd0;
    end
    else if(ns == OUT) begin
        case(today)
        1:out_day<=5;
        2:out_day<=6;
        3:out_day<=0;
        4:out_day<=1;
        5:out_day<=2;
        6:out_day<=3;
        default:out_day<=4;
        endcase
    end
end
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
    begin
        out_valid<=1'd0;
    end
    else if(ns == IDLE) begin
        out_valid<=1'd0;
    end
    else if(ns == OUT) begin
        if(cnt_out>0)
        out_valid<=1'd1;
    end
end
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
    begin
        out_display<=4'd0;
    end
    else if(ns == IDLE) begin
        out_display<=4'd0;
    end
    else if(ns == OUT) begin
        case(cnt_out)
        8'd1:out_display<=year_bcd[15:12];
        8'd2:out_display<=year_bcd[11:8];
        8'd3:out_display<=year_bcd[7:4];
        8'd4:out_display<=year_bcd[3:0];
        8'd5:out_display<=month_bcd[7:4];
        8'd6:out_display<=month_bcd[3:0];
        8'd7:out_display<=day_bcd[7:4];
        8'd8:out_display<=day_bcd[3:0];
        8'd9:out_display<=hour_bcd[7:4];
        8'd10:out_display<=hour_bcd[3:0];
        8'd11:out_display<=min_bcd[7:4];
        8'd12:out_display<=min_bcd[3:0];
        8'd13:out_display<=sec_bcd[7:4];
        8'd14:out_display<=sec_bcd[3:0];
        endcase
    end
end
endmodule