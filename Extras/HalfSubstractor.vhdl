library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity HS is

Port ( HSA, HSB : in STD_LOGIC;

DIFFERENCE, BORROW : out STD_LOGIC);

end HS;

architecture dataflow of HS is

begin

DIFFERENCE <= HSA XOR HSB;

BORROW <= (not HSA) AND HSB;

end dataflow;
