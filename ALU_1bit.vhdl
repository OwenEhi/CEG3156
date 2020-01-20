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

library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ALU is

Port ( A,B,SEL1,SEL2 : in  STD_LOGIC;

           ALU1,ALU2 : out  STD_LOGIC);

end ALU;

architecture Structural of ALU is


component HA is

Port ( HAA, HAB : in STD_LOGIC;

     SUM, CARRY : out STD_LOGIC);

end component;


component HS is

Port ( HSA, HSB : in STD_LOGIC;

DIFFERENCE, BORROW : out STD_LOGIC);

end component;


component multiplier is

Port ( MA, MB : in STD_LOGIC;

      PRODUCT : out STD_LOGIC);

end component;


component MUX is

Port ( A1,A2,A3,A4 : in STD_LOGIC;

                 S : in STD_LOGIC_VECTOR (1 downto 0);

                 X : out STD_LOGIC);

end component;


component ground is

Port ( N : inout STD_LOGIC);

end component;


signal S0,S1,S2,S3,S4,S5: STD_LOGIC;


begin

U0: ground PORT MAP(N=>S5);

U1: HA PORT MAP(HAA=>A,HAB=>B,SUM=>S0,CARRY=>S3);

U2: HS PORT MAP(HSA=>A,HSB=>B,DIFFERENCE=>S1,BORROW=>S4);

U3: multiplier PORT MAP(MA=>A,MB=>B,PRODUCT=>S2);

U4: MUX PORT MAP(A1=>S0,A2=>S1,A3=>S2,A4=>S5,X=>ALU1,S(0)=>SEL1,S(1)=>SEL2);

U5: MUX PORT MAP(A1=>S3,A2=>S4,A3=>S5,A4=>S5,X=>ALU2,S(0)=>SEL1,S(1)=>SEL2);

end Structural;
