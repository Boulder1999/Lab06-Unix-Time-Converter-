//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   File Name   : B2BCD_IP.v
//   Module Name : B2BCD_IP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module B2BCD_IP #(parameter WIDTH = 12, parameter DIGIT = 4) (
    // Input signals
    Binary_code,
    // Output signals
    BCD_code
);

// ===============================================================
// Declaration
// ===============================================================
input  [WIDTH-1:0]   Binary_code;
output [DIGIT*4-1:0] BCD_code;

// ===============================================================
// Soft IP DESIGN
// ===============================================================
reg [DIGIT*4-1:0] HDO_binary_2_decimal;
integer i;
// ===============================================================
// Soft IP DESIGN
// ===============================================================
always @(Binary_code)
        begin
            for(i = 0; i <= DIGIT*4-1; i = i+1) 
            begin
                HDO_binary_2_decimal[i] = 0;
            end
            for (i = 0; i < WIDTH; i = i+1) //run for 8 iterations
            begin
                HDO_binary_2_decimal = {HDO_binary_2_decimal[DIGIT*4-2:0],Binary_code[WIDTH-1-i]}; //concatenation
                    
                //if a hex digit of 'bcd' is more than 4, add 3 to it.  
                if(i < WIDTH-1 && HDO_binary_2_decimal[3:0] > 4) 
                    HDO_binary_2_decimal[3:0] = HDO_binary_2_decimal[3:0] + 3;
                if(i < WIDTH-1 && HDO_binary_2_decimal[7:4] > 4)
                    HDO_binary_2_decimal[7:4] = HDO_binary_2_decimal[7:4] + 3;
                if(i < WIDTH-1 && HDO_binary_2_decimal[11:8] > 4)
                    HDO_binary_2_decimal[11:8] =HDO_binary_2_decimal[11:8] + 3;
                if(i < WIDTH-1 && HDO_binary_2_decimal[15:12] > 4)
                    HDO_binary_2_decimal[15:12] =HDO_binary_2_decimal[15:12] + 3;  
            end
        end     
assign BCD_code = HDO_binary_2_decimal;
endmodule