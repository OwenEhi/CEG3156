library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fullsubstractor is
Port ( 
	A, B, C : in  STD_LOGIC;
	DIFFERENCE, BORROW : out  STD_LOGIC
);
end fullsubstractor;

architecture arch_fullsubstractor of fullsubstractor is
begin

DIFFERENCE <= A xor B xor C;
BORROW <= ((not A) and (B or C)) or (B and C);

end arch_fullsubstractor;