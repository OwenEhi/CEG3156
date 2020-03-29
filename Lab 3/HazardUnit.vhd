LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity HazardUnit is
port (
	IDEXreadMEM: in std_logic;
	IDEXrt, IFIDrs, IFIDrt: in std_logic_vector(4 downto 0);
	stall: out std_logic
);
end HazardUnit;

architecture arch_HazardUnit of HazardUnit is

signal eq1, eq2: std_logic;

begin

eq1 <= (IDEXrt(4) xnor IFIDrs(4)) and (IDEXrt(3) xnor IFIDrs(3)) and (IDEXrt(2) xnor IFIDrs(2)) and (IDEXrt(1) xnor IFIDrs(1)) and (IDEXrt(0) xnor IFIDrs(0));
eq2 <= (IDEXrt(4) xnor IFIDrt(4)) and (IDEXrt(3) xnor IFIDrt(3)) and (IDEXrt(2) xnor IFIDrt(2)) and (IDEXrt(1) xnor IFIDrt(1)) and (IDEXrt(0) xnor IFIDrt(0));

stall <= IDEXreadMEM and (eq1 or eq2);

end arch_HazardUnit;