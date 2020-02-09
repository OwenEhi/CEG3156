entity ShiftReg4bits_Struct is
	Port ( Din,clk,reset : in STD_LOGIC;
 	       Q : out STD_LOGIC_VECTOR (3 downto 0));
end ShiftReg4bits_Struct;

architecture Structural of ShiftReg4bits_Struct is
component D_FFP is
port( clk, reset,D: in std_logic;
      Q: out std_logic);
end component;

signal Q_temp: std_logic_vector(3 downto 1);
begin
DFF3: D_FFP port map (clk, reset, Din, Q_temp(3));
DFF2: D_FFP port map (clk, reset, Q_temp(3), Q_temp(2));
DFF1: D_FFP port map (clk, reset, Q_temp(2), Q_temp(1));
DFF0: D_FFP port map (clk, reset, Q_temp(1), Q(0));

Q(3 downto 1)<= Q_temp;
end Structural;
