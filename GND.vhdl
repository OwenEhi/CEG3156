library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ground is

Port ( N : inout STD_LOGIC);

end ground;

architecture dataflow of ground is

begin

N <= 'U';

end dataflow;

--The GND component (U0) is assigned to the STD_LOGIC ‘U’ which stands for Uninitialized. Here, it means, that we are yet to initialize the signal.
