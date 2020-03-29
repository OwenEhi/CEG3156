library ieee;
use ieee.std_logic_1164.all;

entity decoder3to8 is
port(
	A: in std_logic_vector(2 downto 0);
	Y: out std_logic_vector(7 downto 0)
);
end decoder3to8;

architecture decode of decoder3to8 is
begin
	Y <= "10000000" when A = "000" else
		  "01000000" when A = "001" else
		  "00100000" when A = "010" else
		  "00010000" when A = "011" else
		  "00001000" when A = "100" else
		  "00000100" when A = "101" else
		  "00000010" when A = "110" else
		  "00000001";
end decode;