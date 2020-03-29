library ieee;
use ieee.std_logic_1164.all;

entity mux_8_4 is
	port(
		a, b, c, d : in std_logic_vector(7 downto 0);
		sel : in std_logic_vector(1 downto 0);
		y : out std_logic_vector(7 downto 0));
end mux_8_4;

architecture arch_mux_8_4 of mux_8_4 is
begin
with sel select
	y 	<= a when "00",
			b when "01",
			c when "10",
			d when others;
end arch_mux_8_4;