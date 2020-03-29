library ieee;
use ieee.std_logic_1164.all;

entity mux_1_2 is
	port(
		a, b : in std_logic;
		sel : in std_logic;
		y : out std_logic
	);
end mux_1_2;

architecture arch_mux_1_2 of mux_1_2 is
begin
with sel select
	y 	<= a when '0',
			b when others;
end arch_mux_1_2;