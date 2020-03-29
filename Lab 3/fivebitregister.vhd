library ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fivebitregister IS
	PORT(
		i_resetBar, i_en	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(4 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(4 downto 0)
	);
END fivebitregister;

ARCHITECTURE rtl OF fivebitregister IS
	SIGNAL q_value, q_notvalue : STD_LOGIC_VECTOR(4 downto 0);

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

	-- Output Driver
	o_Value		<= q_value;

END rtl;