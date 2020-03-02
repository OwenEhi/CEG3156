library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	port (ALUContol : in std_logic_vector(3 downto 0);
			A, B : in std_logic_vector(7 downto 0);
			ALUresult : out std_logic_vector(7 downto 0);
			zero : out std_logic
	);
end ALU;

architecture aluArch of ALU is

component CLA is
	port (Cin : in std_logic;	
			A, B : in std_logic_vector(7 downto 0); 
			result: out std_logic_vector(7 downto 0);	
			Cout : out std_logic
	);
end component;

signal Cin, Cout : std_logic;
signal Op1, Op2, CLAout, ALUanswer : std_logic_vector(7 downto 0);

begin
	
	
	process(ALUContol, A, B, CLAout, Cout)
		begin
			case ALUContol is
				--AND
				when "0000" => 
					ALUanswer <= (A AND B);
				--OR
				when "0001" => 
					ALUanswer <= (A OR B);
				--ADD
				when "0010" =>
					Op1 <= A;
					Op2 <= B;
					Cin <= '0';
					ALUanswer <= CLAout;
				--SUBTRACT
				when "0110" =>
					Op1 <= A;
					Op2 <= NOT B;
					Cin <= '1';
					ALUanswer <= CLAout;
				--Set on less than
				when "0111" =>
					if(B = "00000000") then
						ALUanswer <= (others => '0');
					else 
						Op1 <= A;
						Op2 <= NOT B;
						Cin <= '1';
						if (CLAout(7) = '0') then
							ALUanswer <= (others => '0');
						else
ALUanswer <= ("0000000" & (Cout XOR CLAout(7)));
						end if;
					end if;
				--others
				when others => 
					--nothing
			end case;
			
	end process;
	
	zero <= NOT (ALUanswer(0) OR ALUanswer(1) OR ALUanswer(2) 
OR ALUanswer(3) OR ALUanswer(4) OR ALUanswer(5) OR ALUanswer(6));
	
	ALUresult <= ALUanswer;
	
	CLA_0: CLA port map (Cin, Op1, Op2, CLAout, Cout);
	
end aluArch;
