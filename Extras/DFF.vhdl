library ieee;
use ieee.std_logic_1164.all;

entity my_nand is
	port(
	a,b,c: in std_logic;
	y: out std_logic);
end my_nand

architecture behave of my_nand is 
begin -- behave
	y<= not (a and b and c);
end behave;

library ieee;
use ieee.std_logic1164.all;
use work.all;

entity d_ff is
	port(
	clk, rst_n, set_n, d: in std_logic;
	q, q_n: out std_logic;
end d_ff;

architecture struct of d_ff is
component my_nand
	port(
	a, b, c: in std_logic;
	y: out std_logic;
end component;

signal y0,y1,y2,y3: std_logic;
signal y4: std_logic; --:='0';
signal y5: std_logic; --:='1';

begin --struct
	q <= y4;
	q_n <= y5;
	my_nand0: my_nand port map (set_n, y1, y3, y0);
	my_nand1: my_nand port map (clk, rst_n, y0, y1);
	my_nand2: my_nand port map (sclk, y3, y1, y2);
	my_nand3: my_nand port map (d, rst_n, y2, y3);
	my_nand4: my_nand port map (set_n, y1, y5, y4);
	my_nand5: my_nand port map (rst_n, y2, y4, y5);
end struct;
