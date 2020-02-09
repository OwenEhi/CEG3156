library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity HA is

Port ( HAA, HAB : in STD_LOGIC;

     SUM, CARRY : out STD_LOGIC);

end HA;

architecture dataflow of HA is

begin

SUM <= HAA XOR HAB;

CARRY <= HAA AND HAB;

end dataflow;
