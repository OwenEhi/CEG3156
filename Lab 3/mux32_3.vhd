library ieee;
use ieee.std_logic_1164.all;

entity mux32_3 is
	port (
		a, b, c, d, e, f: in std_logic_vector(31 downto 0);
		s : in std_logic_vector(2 downto 0);
		y : out std_logic_vector(31 downto 0));
end mux32_3;

architecture arch_mux32_3 of mux32_3 is
	begin
	
	with s select
		y <= a when "000",
			  b when "001",
		     c when "010",
		     d when "011",
		     e when "100",
		     f when others;
end arch_mux32_3;