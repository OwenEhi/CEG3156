LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity ALUcontroller is
port (
	F: in std_logic_vector(5 downto 0);
	ALUOP: in std_logic_vector(1 downto 0);
	Operation: out std_logic_vector(2 downto 0)
);
end ALUcontroller;

architecture struct of ALUcontroller is

begin

Operation(0) <= ALUOP(1) and (F(0) or F(3));
Operation(1) <= (not F(2)) or (not ALUOP(1));
Operation(2) <= ALUOP(0) or (ALUOP(1) and F(1));

end struct;