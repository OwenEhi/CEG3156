library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity multiplier is

Port ( MA, MB : in STD_LOGIC;

      PRODUCT : out STD_LOGIC);

end multiplier;

architecture dataflow of multiplier is

begin

PRODUCT <= MA AND MB;

end dataflow;
