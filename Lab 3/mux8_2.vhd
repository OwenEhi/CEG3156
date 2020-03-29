library ieee;
use ieee.std_logic_1164.all;

entity mux_8_2 is
	port(
		a, b : in std_logic_vector(7 downto 0);
		sel : in std_logic;
		y : out std_logic_vector(7 downto 0));
end mux_8_2;

architecture arch_mux_8_2 of mux_8_2 is
begin
with sel select
	y 	<= a when '0',
			b when others;
end arch_mux_8_2;