library ieee;
use ieee.std_logic_1164.all;

entity mux3to8 is
port (
	a1, a2, a3, a4, a5, a6, a7, a8: in std_logic_vector(7 downto 0);
	s: in std_logic_vector(2 downto 0);
	m: out std_logic_vector(7 downto 0)
	);
end mux3to8;

architecture circuit of mux3to8 is
begin
	m <=  a1 when s="000" else
			a2 when s="001" else
			a3 when s="010" else
			a4 when s="011" else
			a5 when s="100" else
			a6 when s="011" else
			a7 when s="110" else
			a8 when s="111";
end circuit;