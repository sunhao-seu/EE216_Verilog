`timescale 1ns / 1ps

module debouncing_tb();
reg CLK = 1'b0;
reg ButtonIn;

always #5 CLK = ~CLK;

debouncing dUUT(
.CLK(CLK),
.ButtonIn(ButtonIn),
.ButtonOut(ButtonOut)
);

initial
begin
    ButtonIn = 1'b0;
    
    #20 ButtonIn = 1'b1;
    #5 ButtonIn = 1'b0;
    #5 ButtonIn = 1'b1;
    #5 ButtonIn = 1'b0;
    #5 ButtonIn = 1'b1;
    #5 ButtonIn = 1'b0;
    #5 ButtonIn = 1'b1;
    #30 ButtonIn = 1'b0;
    #20 ButtonIn = 1'b1;   
    #50 ButtonIn = 1'b0;
    #50 ButtonIn = 1'b1;
    #200 ButtonIn = 1'b0;
    #50 ButtonIn = 1'b1;
    #100 ButtonIn = 1'b0;
end

endmodule