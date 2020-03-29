library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY thirtytwobitregister IS
	PORT(
		i_resetBar, i_en	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(31 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(31 downto 0));
END thirtytwobitregister;

ARCHITECTURE rtl OF thirtytwobitregister IS
	SIGNAL q_value, q_notvalue : STD_LOGIC_VECTOR(31 downto 0);

	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

	BEGIN
	
	b0: enARdFF_2 PORT MAP (i_resetBar, i_Value(0), i_en, i_clock, q_value(0), q_notvalue(0));
	b1: enARdFF_2 PORT MAP (i_resetBar, i_Value(1), i_en, i_clock, q_value(1), q_notvalue(1));
	b2: enARdFF_2 PORT MAP (i_resetBar, i_Value(2), i_en, i_clock, q_value(2), q_notvalue(2));
	b3: enARdFF_2 PORT MAP (i_resetBar, i_Value(3), i_en, i_clock, q_value(3), q_notvalue(3));
	b4: enARdFF_2 PORT MAP (i_resetBar, i_Value(4), i_en, i_clock, q_value(4), q_notvalue(4));
	b5: enARdFF_2 PORT MAP (i_resetBar, i_Value(5), i_en, i_clock, q_value(5), q_notvalue(5));
	b6: enARdFF_2 PORT MAP (i_resetBar, i_Value(6), i_en, i_clock, q_value(6), q_notvalue(6));
	b7: enARdFF_2 PORT MAP (i_resetBar, i_Value(7), i_en, i_clock, q_value(7), q_notvalue(7));
	b8: enARdFF_2 PORT MAP (i_resetBar, i_Value(8), i_en, i_clock, q_value(8), q_notvalue(8));
	b9: enARdFF_2 PORT MAP (i_resetBar, i_Value(9), i_en, i_clock, q_value(9), q_notvalue(9));
	b10: enARdFF_2 PORT MAP (i_resetBar, i_Value(10), i_en, i_clock, q_value(10), q_notvalue(10));
	b11: enARdFF_2 PORT MAP (i_resetBar, i_Value(11), i_en, i_clock, q_value(11), q_notvalue(11));
	b12: enARdFF_2 PORT MAP (i_resetBar, i_Value(12), i_en, i_clock, q_value(12), q_notvalue(12));
	b13: enARdFF_2 PORT MAP (i_resetBar, i_Value(13), i_en, i_clock, q_value(13), q_notvalue(13));
	b14: enARdFF_2 PORT MAP (i_resetBar, i_Value(14), i_en, i_clock, q_value(14), q_notvalue(14));
	b15: enARdFF_2 PORT MAP (i_resetBar, i_Value(15), i_en, i_clock, q_value(15), q_notvalue(15));
	b16: enARdFF_2 PORT MAP (i_resetBar, i_Value(16), i_en, i_clock, q_value(16), q_notvalue(16));
	b17: enARdFF_2 PORT MAP (i_resetBar, i_Value(17), i_en, i_clock, q_value(17), q_notvalue(17));
	b18: enARdFF_2 PORT MAP (i_resetBar, i_Value(18), i_en, i_clock, q_value(18), q_notvalue(18));
	b19: enARdFF_2 PORT MAP (i_resetBar, i_Value(19), i_en, i_clock, q_value(19), q_notvalue(19));
	b20: enARdFF_2 PORT MAP (i_resetBar, i_Value(20), i_en, i_clock, q_value(20), q_notvalue(20));
	b21: enARdFF_2 PORT MAP (i_resetBar, i_Value(21), i_en, i_clock, q_value(21), q_notvalue(21));
	b22: enARdFF_2 PORT MAP (i_resetBar, i_Value(22), i_en, i_clock, q_value(22), q_notvalue(22));
	b23: enARdFF_2 PORT MAP (i_resetBar, i_Value(23), i_en, i_clock, q_value(23), q_notvalue(23));
	b24: enARdFF_2 PORT MAP (i_resetBar, i_Value(24), i_en, i_clock, q_value(24), q_notvalue(24));
	b25: enARdFF_2 PORT MAP (i_resetBar, i_Value(25), i_en, i_clock, q_value(25), q_notvalue(25));
	b26: enARdFF_2 PORT MAP (i_resetBar, i_Value(26), i_en, i_clock, q_value(26), q_notvalue(26));
	b27: enARdFF_2 PORT MAP (i_resetBar, i_Value(27), i_en, i_clock, q_value(27), q_notvalue(27));
	b28: enARdFF_2 PORT MAP (i_resetBar, i_Value(28), i_en, i_clock, q_value(28), q_notvalue(28));
	b29: enARdFF_2 PORT MAP (i_resetBar, i_Value(29), i_en, i_clock, q_value(29), q_notvalue(29));
	b30: enARdFF_2 PORT MAP (i_resetBar, i_Value(30), i_en, i_clock, q_value(30), q_notvalue(30));
	b31: enARdFF_2 PORT MAP (i_resetBar, i_Value(31), i_en, i_clock, q_value(31), q_notvalue(31));

	-- Output Driver
	o_Value		<= q_value;

END rtl;
