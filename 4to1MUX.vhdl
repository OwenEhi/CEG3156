library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MUX is

Port ( A1,A2,A3,A4 : in STD_LOGIC;

                 S : in STD_LOGIC_VECTOR (1 downto 0);

                 X : out STD_LOGIC);

end mux;

architecture dataflow of MUX is

begin

with S select

X <=       A1 when "00",

           A2 when "01",

           A3 when "10",

           A4 when others;

end dataflow;
