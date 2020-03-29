Library IEEE;
use ieee.std_logic_1164.all;

entity eightbitfulladder is
	port(
		M : in std_logic_vector (7 downto 0);
		N : in std_logic_vector (7 downto 0);
		Cin : in std_logic;
		Cout : out std_logic;
		Sum : out std_logic_vector (7 downto 0)
	);
end eightbitfulladder;

architecture arch_eightbitfulladder of eightbitfulladder is
	signal s0, s1, s2, s3, s4, s5, s6 : std_logic;
	
	component fulladder
		port(
		A: in std_logic;
		B: in std_logic;
		Cin: in std_logic;
		F: out std_logic;
		Cout: out std_logic
		);
	end component;
	
begin

l0: fulladder port map (M(0), N(0), Cin, Sum(0), s0);
l1: fulladder port map (M(1), N(1), s0, Sum(1), s1);
l2: fulladder port map (M(2), N(2), s1, Sum(2), s2);
l3: fulladder port map (M(3), N(3), s2, Sum(3), s3);
l4: fulladder port map (M(4), N(4), s3, Sum(4), s4);
l5: fulladder port map (M(5), N(5), s4, Sum(5), s5);
l6: fulladder port map (M(6), N(6), s5, Sum(6), s6);
l7: fulladder port map (M(7), N(7), s6, Sum(7), Cout);

end arch_eightbitfulladder;

