`timescale 1ns / 1ps

module VendingMachine(
input Enable, input RST, input CLK,
input OneDollar, input FiftyCents, input TenCents, input FiveCents,
output reg Deliver,
output reg [7:0] Money);

// preset the price of the commodity
parameter Price = 8'd125;

//pack the four states
localparam[1:0]
    Poweroff   = 2'b00,
    LowPower   = 2'b01,
    Paying     = 2'b10,
    Delivering = 2'b11;

reg [1:0] CURR_STATE,NEXT_STATE;
wire[3:0] CENTS; //used to combine inputs money
reg[7:0] PAY_MONEY;

//one cent input may contunue several cycles, but we only can add the money once,so we need a flag 
reg Cent_prepare;   

//pack the cents input
assign CENTS = {OneDollar, FiftyCents, TenCents, FiveCents};

//reset and state change
always@(posedge CLK, posedge RST)
begin: Init
    if(RST == 1'b1)
        begin
        CURR_STATE <= Poweroff;
        Money = 8'b00000000;
        Deliver = 1'b0;
        PAY_MONEY = 8'b00000000;
        Cent_prepare = 1'b1;
        end
    else
        CURR_STATE <= NEXT_STATE;
end

// FSM
always@(CURR_STATE, PAY_MONEY, Enable, Cent_prepare)
begin: FSM
    case(CURR_STATE)
    Poweroff:
        begin
            if(Enable == 1'b1)
                begin
                NEXT_STATE = LowPower;  
                Cent_prepare = 1'b1;
                Deliver = 1'b0;
                Money = 8'b00000000;
                PAY_MONEY = 8'b00000000;
                end
            else
                NEXT_STATE = Poweroff;
        end
    LowPower:
        begin
            Deliver = 1'b0;
            if(PAY_MONEY != 0)
                NEXT_STATE = Paying;
            else
                NEXT_STATE = LowPower;
        end
    Paying:
        begin
            Money = PAY_MONEY;
            if(PAY_MONEY >= Price && Cent_prepare == 1'b1)
                NEXT_STATE = Delivering;
            else
                NEXT_STATE = Paying;
                //maybe need a counter function
        end
    Delivering:
        begin
            Money = 8'b00000000;
            PAY_MONEY = 8'b00000000;
            Deliver = 1'b1;
            NEXT_STATE = LowPower;
        end
    default:
        begin
            NEXT_STATE = Poweroff;
        end
    endcase
end

//process input cents
always@(CENTS)
begin:Peocess_CENTS
    if(Enable == 1'b1)
    begin
        if(Cent_prepare == 1'b1)
        begin
            Cent_prepare = 1'b0;
            case(CENTS)
                4'b0001:
                begin
                    PAY_MONEY = PAY_MONEY + 5;
                end
                4'b0010:
                begin
                    PAY_MONEY = PAY_MONEY + 10;
                end
                4'b0100:
                begin
                    PAY_MONEY = PAY_MONEY + 50;
                end
                4'b1000:
                begin
                    PAY_MONEY = PAY_MONEY + 100;
                end
                default:
                begin
                    PAY_MONEY = PAY_MONEY;
                end
            endcase;
        end
        else
            PAY_MONEY = PAY_MONEY;
    end
    else
        PAY_MONEY = PAY_MONEY;
end

//an input cents will last several cycles.But the money only can be added once.
always@(posedge CLK)
begin
    if (CENTS == 4'b0000)
        Cent_prepare = 1'b1;
    else
        Cent_prepare = 1'b0;
end
endmodule

// assume the key input last 10ms; the frequency is 100 000 000;   5 000 000
// Debouncing
module debouncing(
input CLK,
input ButtonIn,
output reg ButtonOut
);

reg[23:0] counter;
parameter debouncing_number = 4'b0100;  //in actually use, the number may be set to a proper number.



always@(posedge CLK)
begin
    if(ButtonIn == 1'b1)
        counter <= counter + 1'b1;
    else
    begin
        counter <= 24'h000000;
    end
end

always@(counter)
begin
    if(counter > debouncing_number)
        begin
        ButtonOut <= 1'b1;
        counter <= debouncing_number+1'b1;
        end
    else
        ButtonOut <= 1'b0;
end
endmodule

