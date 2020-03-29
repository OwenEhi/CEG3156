library ieee;
use ieee.std_logic_1164.all;

entity eightbitand is
	port (
			valA, valB : in std_logic_vector (7 downto 0);
			valO: out std_logic_vector(7 downto 0)
		);
end eightbitand;

architecture arch_eightbitand of eightbitand is
begin
	valO <= valB AND valA;
end architecture arch_eightbitand;