module contador_163 ( CLK, CLR, LD, ENP, ENT, D, Q, RCO );
    input CLK, CLR, LD, ENP, ENT;
    input [3:0] D;
    output reg [3:0] Q;
    output reg RCO;

    always @ (posedge CLK)  // Create the counter f-f behavior
        if (~CLR)               Q <= 4'd0;
        else if (~LD)           Q <= D;
        else if (ENT && ENP)    Q <= Q + 1;
        else                    Q <= Q;
 
    always @ (Q or ENT)     // Create RCO combinational output
        if (ENT && (Q == 4'd15))   RCO = 1;
        else                       RCO = 0;
endmodule