Library IEEE;
use ieee.std_logic_1164.all;

entity eightbitsubtractor is
	port(
		M : in std_logic_vector (7 downto 0);
		N : in std_logic_vector (7 downto 0);
		Din : in std_logic;
		Cout : out std_logic;
		Sum : out std_logic_vector (7 downto 0)
	);
end eightbitsubtractor;

architecture arch_eightbitsubtractor of eightbitsubtractor is
	signal s0, s1, s2, s3, s4, s5, s6 : std_logic;
	signal output : std_logic_vector(7 downto 0);
	component fullsubstractor
		port(
			A :  IN  STD_LOGIC;
			B :  IN  STD_LOGIC;
			C :  IN  STD_LOGIC;
			DIFFERENCE :  OUT  STD_LOGIC;
			BORROW :  OUT  STD_LOGIC
		);
	end component;
	
begin

l0: fullsubstractor port map (M(0), N(0), Din, output(0), s0);
l1: fullsubstractor port map (M(1), N(1), s0, output(1), s1);
l2: fullsubstractor port map (M(2), N(2), s1, output(2), s2);
l3: fullsubstractor port map (M(3), N(3), s2, output(3), s3);
l4: fullsubstractor port map (M(4), N(4), s3, output(4), s4);
l5: fullsubstractor port map (M(5), N(5), s4, output(5), s5);
l6: fullsubstractor port map (M(6), N(6), s5, output(6), s6);
l7: fullsubstractor port map (M(7), N(7), s6, output(7), cout);

Sum <= output;

end arch_eightbitsubtractor;