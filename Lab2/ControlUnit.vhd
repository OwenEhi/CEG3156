library ieee;
use ieee.std_logic_1164.all;

entity controllerUnit is
	port (opcode : in std_logic_vector(5 downto 0);
			RegDst, ALUSrc, MemToReg, RegWrite, MemRead,
			MemWrite,Branch, Jump : out std_logic;    
			ALUOp : out std_logic_vector(1 downto 0)
			);
end controllerUnit;

architecture setSignals of controllerUnit is
signal controlSignalArray : std_logic_vector(9 downto 0);
begin
	process (opcode)
		begin
		case opcode is
			--R-Type
			when "000000" => 
				controlSignalArray <= "1001000100";
			
			--lw type
			when "100011" =>
				controlSignalArray <= "0111100000";
			
			--Sw type
			when "101011" =>
				controlSignalArray <= "-1-0010000";
			
			--Branch type
			when "000100" =>
				controlSignalArray <= "-0-0001010";
			
			--Jump type
			when "000010" =>
				controlSignalArray <= "0000000001";
			
			when others =>
				--nothing
		end case;
	end process;
	RegDst <= controlSignalArray(9);
	ALUSrc <= controlSignalArray(8);
	MemToReg <= controlSignalArray(7);
	RegWrite <= controlSignalArray(6);
	MemRead <= controlSignalArray(5);
	MemWrite <= controlSignalArray(4);
	Branch <= controlSignalArray(3);
	--ALUOp1 <= controlSignalArray(2);
	--ALUOp2 <= controlSignalArray(1);
	ALUOp <= controlSignalArray(2 downto 1);
	
	Jump <= controlSignalArray(0);
	
end setSignals;
