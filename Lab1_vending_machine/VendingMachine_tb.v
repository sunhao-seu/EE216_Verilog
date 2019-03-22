`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/08 09:33:42
// Design Name: 
// Module Name: VendingMachine_tb
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


module VendingMachine_tb();
reg Enable, RST;
reg CLK = 1'b0;
reg OneDollar, FiftyCents, TenCents, FiveCents;

always #5 CLK = ~CLK;

VendingMachine UUT(
.Enable(Enable), .RST(RST), .CLK(CLK),
.OneDollar(OneDollar), .FiftyCents(FiftyCents), .TenCents(TenCents), .FiveCents(FiveCents)
);

initial
begin
    RST = 1'b0;
    Enable = 1'b0;
    OneDollar = 1'b0;
    FiftyCents = 1'b0;
    TenCents = 1'b0;
    FiveCents = 1'b0;
    #20 RST = 1'b1;
    #30 RST = 1'b0;
    Enable = 1'b1;
    
    #10 FiftyCents = 1'b1;
    #30 FiftyCents = 1'b0;
    
    #10 OneDollar = 1'b1;
    #10 OneDollar = 1'b0;
    
    #30 FiveCents = 1'b1;
    #30 FiveCents = 1'b0;    
    
    #20 Enable = 1'b0;
    #20 OneDollar = 1'b1;
    #30 OneDollar = 1'b0;
    #20 Enable = 1'b1;
    
    #80 OneDollar = 1'b1;
    #30 OneDollar = 1'b0;
    #80 FiveCents = 1'b1;
    #30 FiveCents = 1'b0;       
        
    
end


endmodule
