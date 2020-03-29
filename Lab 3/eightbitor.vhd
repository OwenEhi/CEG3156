library ieee;
use ieee.std_logic_1164.all;

entity eightbitor is
	port (
			valA, valB : in std_logic_vector (7 downto 0);
			valO: out std_logic_vector(7 downto 0)
		);
end eightbitor;

architecture arch_eightbitor of eightbitor is

begin
	valO <= valB OR valA;
end architecture arch_eightbitor;