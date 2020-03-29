LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity controlLogic is
port (
	OP: in std_logic_vector(5 downto 0);
	RegDst, Jump, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0: out std_logic
);
end controlLogic;

architecture struct of controlLogic is

signal Rformat, lw, sw, beq: std_logic;

begin

Rformat <= not OP(5) and not OP(4) and not OP(3) and not OP(2) and not OP(1) and not OP(0);
lw <= OP(5) and not OP(4) and not OP(3) and not OP(2) and OP(1) and OP(0);
sw <= OP(5) and not OP(4) and OP(3) and not OP(2) and OP(1) and OP(0);
beq <= not OP(5) and not OP(4) and not OP(3) and OP(2) and not OP(1) and not OP(0);

RegDst <= Rformat;
Jump <= not OP(5) and not OP(4) and not OP(3) and not OP(2) and OP(1) and not OP(0);
ALUSrc <= lw or sw;
MemtoReg <= lw;
RegWrite <= Rformat or lw;
MemRead <= lw;
MemWrite <= sw;
Branch <= beq;
ALUOp1 <= Rformat;
ALUOp0 <= beq;

end struct;