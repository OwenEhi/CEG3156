library ieee;
use ieee.std_logic_1164.all;

entity srlatch is
port(s,r,clk:in std_logic;
q,qo:out std_logic);
end srlatch;

architecture srlatch_arch of srlatch is
component nand_gate is
port(a,b:in std_logic;
y:out std_logic);
end component;

signal x,y,m,n:std_logic;

begin
r1:nand_gate port map(s,clk,x);
r2:nand_gate port map(r,clk,y);
r3:nand_gate port map(x,n,m);
r4:nand_gate port map(y,m,n);
q<=m;
qo<=n;
end srlatch_arch;
