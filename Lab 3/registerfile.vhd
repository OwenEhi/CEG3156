library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY registerfile IS
	PORT(
		clk ,resetBar : in std_LOGIC;
		readRegister1 : IN	STD_LOGIC_VECTOR(4 downto 0);
		readRegister2 : IN	STD_LOGIC_VECTOR(4 downto 0);
		writeRegister : IN	STD_LOGIC_VECTOR(4 downto 0);
		writeData     : IN   STD_LOGIC_VECTOR(7 downto 0);
		RegWrite      : IN   STD_LOGIC;		
		readData1	  : OUT	STD_LOGIC_VECTOR(7 downto 0);
		readData2	  : OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
END registerfile;

ARCHITECTURE rtl OF registerfile IS

	signal decodeout, out0, out1, out2, out3, out4, out5, out6, out7: std_logic_vector(7 downto 0);
	signal tmp : std_logic_vector(7 downto 0);

	component eightbitregister
	PORT(
		i_resetBar, i_en	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
	END component;
	
	component decoder3to8
	port (
		A: in std_logic_vector(2 downto 0);
		Y: out std_logic_vector(7 downto 0)
	);
	end component;

	component mux3to8
	port (
		a1, a2, a3, a4, a5, a6, a7, a8: in std_logic_vector(7 downto 0);
		s: in std_logic_vector(2 downto 0);
		m: out std_logic_vector(7 downto 0)
	);
	end component;

	BEGIN
	decode: decoder3to8 port map(writeRegister(2 downto 0), decodeout);
	
	tmp(0) <= regwrite and decodeout(7);
	tmp(1) <= regwrite and decodeout(6);
	tmp(2) <= regwrite and decodeout(5);
	tmp(3) <= regwrite and decodeout(4);
	tmp(4) <= regwrite and decodeout(3);
	tmp(5) <= regwrite and decodeout(2);
	tmp(6) <= regwrite and decodeout(1);
	tmp(7) <= regwrite and decodeout(0);

	r0: eightbitregister port map(resetBar, tmp(0), clk, writeData, out0);
	r1: eightbitregister port map(resetBar, tmp(1), clk, writeData, out1);
	r2: eightbitregister port map(resetBar, tmp(2), clk, writeData, out2);
	r3: eightbitregister port map(resetBar, tmp(3), clk, writeData, out3);
	r4: eightbitregister port map(resetBar, tmp(4), clk, writeData, out4);
	r5: eightbitregister port map(resetBar, tmp(5), clk, writeData, out5);
	r6: eightbitregister port map(resetBar, tmp(6), clk, writeData, out6);
	r7: eightbitregister port map(resetBar, tmp(7), clk, writeData, out7);

	mux1: mux3to8 port map(out0, out1, out2, out3, out4, out5, out6, out7, readRegister1(2 downto 0), readData1);
	mux2: mux3to8 port map(out0, out1, out2, out3, out4, out5, out6, out7, readRegister2(2 downto 0), readData2);

END rtl;
