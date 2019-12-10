module Dflipflop(q, _q, D, clk, clear, set);

input D, clk, clear, set;

output q, _q;

reg q, _q;

//As long as clear and set are not low, then q will wait for

//posedge of the clock and change according to the values

//at D.

// If D is high, q is high.

// If D is low, q is low.

always @(posedge clk or negedge clear or negedge set)

begin

if (~clear) begin

q <= 1'b0;

_q <= 1'b1;

end else if (~set) begin

q <= 1'b1;

_q <= 1'b0;

end else begin

case ({D})

1'b1: begin

q <= 1'b1;

_q <= 1'b0;

end

1'b0: begin

q <= 1'b0;

_q <= 1'b1;

end

endcase

end

end

endmodule

module coin_count (dollar, nickel, cur_stat, reset, enable, clk, coin);

input reset;

input enable;

input clk;

input coin;

output dollar;

output nickel;

output [3:0] cur_stat;

// wire [3:0] cur_stat;

wire s3, sb3, s2, sb2, s1, sb1, so, sb0;

wire d3, d2, d1, d0;

wire x, xb;

wire gclk;

// assigning the outputs of the flops to be current state

assign x = coin;

assign cur_stat[3] = s3;

assign cur_stat[2] = s2;

assign cur_stat[1] = s1;

assign cur_stat[0] = s0;

not not_x(xb, coin);

and clk_g(gclk, clk, enable);

Dflipflop D3(.q(s3), ._q(sb3), .D(d3), .clk(gclk), .set(1'b1), .clear(reset));

Dflipflop D2(.q(s2), ._q(sb2), .D(d2), .clk(gclk), .set(1'b1), .clear(reset));

Dflipflop D1(.q(s1), ._q(sb1), .D(d1), .clk(gclk), .set(1'b1), .clear(reset));

Dflipflop D0(.q(s0), ._q(sb0), .D(d0), .clk(gclk), .set(1'b1), .clear(reset));

//D3
//D2 iverilog main.v -o main.out


//D1

//D0

//dollar

//nickel

endmodule

module project2_tb ();

reg clk ;

reg reset;

reg enable;

reg coin;

reg exp_dlr;

reg exp_nkl;

wire dollar;

wire nickel;

wire [3:0] cur_stat;

integer count = 0;

integer tot = 0;

always begin

#5 clk = ~clk;

end

always @(negedge clk) begin

#6;

if (~reset) begin

exp_dlr = 0;

exp_nkl = 0;

count = 0;

end else if (enable) begin

if (coin == 1 && count == 60) begin

exp_dlr = 1;

exp_nkl = 0;

count = 0;

end else if (coin == 1 && count == 65) begin

exp_dlr = 1;

exp_nkl = 1;

count = 0;

end else if (coin == 0 && count == 45) begin

exp_dlr = 1;

exp_nkl = 0;

count = 0;

end else if (coin == 0 && count == 50) begin

exp_dlr = 1;

exp_nkl = 1;

count = 0;

end else if (coin == 0 && count == 55) begin

exp_dlr = 1;

exp_nkl = 0;

count = 10;

end else if (coin == 0 && count == 60) begin

exp_dlr = 1;

exp_nkl = 1;

count = 10;

end else if (coin == 0 && count == 65) begin

exp_dlr = 1;

exp_nkl = 0;

count = 20;

end else if (coin == 1) begin

exp_dlr = 0;

exp_nkl = 0;

count = count + 10;

end else begin

exp_dlr = 0;

exp_nkl = 0;

count = count + 25;

end

end else begin

exp_dlr = 0;

exp_nkl = 0;

count = count;

end

end

always @(posedge clk) begin

case (cur_stat)

4'b0000: tot = 0;

4'b0001: tot = 10;

4'b0011: tot = 20;

4'b0010: tot = 25;

4'b0110: tot = 30;

4'b0111: tot = 35;

4'b0101: tot = 40;

4'b0100: tot = 45;

4'b1100: tot = 50;

4'b1101: tot = 55;

4'b1111: tot = 60;

4'b1110: tot = 65;

4'b1010: tot = 10;

4'b1011: tot = 10;

4'b1001: tot = 10;

4'b1000: tot = 10;

endcase

$display(" %b %b %b %b %b %b %4b %2d | %4d %b %b %b %b %b %b", reset, enable, clk, coin, dollar, nickel, cur_stat, tot, count, exp_dlr, exp_nkl, u_coin_count.d3, u_coin_count.d2, u_coin_count.d1, u_coin_count.d0);

end

initial begin

$display("reset enable clk coin dollar nickel cur_stat tot | etot edlr enkl D3 D2 D1 D0");

clk = 1'b0;

reset = 1'b0;

enable = 1'b0;

coin = 1'b1;

repeat (2) @(negedge clk);

reset = 1'b1;

enable = 1'b1;

// Insert 8 dimes

repeat (8) @(negedge clk);

@(negedge clk) enable = 1'b0; reset = 1'b0;

// reset counter

@(negedge clk) reset = 1'b1; enable = 1'b1; coin = 1'b0;;

// Insert 5 quarters

repeat (5) @(negedge clk);

@(negedge clk) reset = 1'b0; coin = 1'b0;

@(negedge clk) reset = 1'b1; coin = 1'b0;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b0;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b0;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b0;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b0;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b0;

@(negedge clk) coin = 1'b0;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b0;

@(negedge clk) coin = 1'b0;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b0;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b1;

@(negedge clk) coin = 1'b0;

@(negedge clk) coin = 1'b0;

@(negedge clk) coin = 1'b0;

@(negedge clk) coin = 1'b1;

$finish;

end

coin_count u_coin_count (

.dollar(dollar),

here is the code for the d flip flop

the only part you need to implement on is the green comment where it says (

//J3


//K3

//J2

//K2

//J1

//K1

//J0

//K0

//dollar

//nickel) for jk

or (

//D3
//D2 iverilog main.v -o main.out


//D1

//D0

//dollar

//nickel) for d flip flop
