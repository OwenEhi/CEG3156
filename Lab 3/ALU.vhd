library ieee;
use ieee.std_logic_1164.all;

entity alu is
port (
	A, B: in std_logic_vector(7 downto 0);
	ALUOP: in std_logic_vector(2 downto 0);
	zero: out std_logic;
	result: out std_logic_vector(7 downto 0)
);
end alu;

architecture arch_alu of alu is

signal aluresult, addresult, subresult, andresult, orresult : std_logic_vector(7 downto 0);

component eightbitfulladder is
	port(
		M : in std_logic_vector (7 downto 0);
		N : in std_logic_vector (7 downto 0);
		Cin : in std_logic;
		Cout : out std_logic;
		Sum : out std_logic_vector (7 downto 0)
	);
end component;

component eightbitsubtractor is
	port(
		M : in std_logic_vector (7 downto 0);
		N : in std_logic_vector (7 downto 0);
		Din : in std_logic;
		Cout : out std_logic;
		Sum : out std_logic_vector (7 downto 0)
	);
end component;

component eightbitor is
	port (
			valA, valB : in std_logic_vector (7 downto 0);
			valO: out std_logic_vector(7 downto 0)
		);
end component;

component eightbitand is
	port (
			valA, valB : in std_logic_vector (7 downto 0);
			valO: out std_logic_vector(7 downto 0)
		);
end component;

begin
	ALU_ADD: eightbitfulladder port map(A, B, '0', open, addresult);
	ALU_SUB: eightbitsubtractor port map(A, B, '0', open, subresult);
	ALU_AND: eightbitand port map(A, B, andresult);
	ALU_OR: eightbitor port map(A, B, orresult);

	with ALUOP select
		aluresult <= andresult when "000",
			orresult when "001",
			addresult when "010",
			subresult when "110",
			"00000000" when others;
		
	result <= aluresult;

	zero <= not (aluresult(0) or aluresult(1) or aluresult(2) or aluresult(3) or aluresult(4) or aluresult(5) or aluresult(6) or aluresult(7));
	
end arch_alu;
