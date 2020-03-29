library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity fulladder is
port (
	A: in std_logic;
	B: in std_logic;
	Cin: in std_logic;
	F: out std_logic;
	Cout: out std_logic
	);
end fulladder;

architecture circuit of fulladder is
begin
	F <= A xor B xor Cin;
	Cout <= (A and B) or (Cin and A) or (Cin and B);
end circuit;