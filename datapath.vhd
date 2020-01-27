LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY Datapath IS
	PORT
	(
		valueselect: in STD_LOGIC_VECTOR(2 DOWNTO 0);
		gclock, greset: in STD_LOGIC;
		muxout: out std_logic_vector(7 downto 0);
		instructionout: out std_logic_vector(31 downto 0);
		branchout, zeroout, memwriteout, regwriteout : out std_logic);
END Datapath;


ARCHITECTURE RTL OF Datapath IS
	Signal branchresult : std_logic_vector(7 downto 0);
	Signal readdata1, readdata2, writedata, selectB, selectPC : std_logic_vector(7 DOWNTO 0);
	Signal PCtemp, PC, newPC : std_logic_vector(7 DOWNTO 0);
	signal IRSHL2 : std_logic_vector(7 downto 0);
	Signal IR : std_logic_vector(31 DOWNTO 0);
	Signal ZEROsignal: std_logic;
	signal writeregout : std_logic_vector(4 downto 0);
	Signal ALUOPERATION : std_logic_vector(2 DOWNTO 0);
	signal DMEMresult: std_logic_vector(7 DOWNTO 0);
	Signal ALUOp: std_logic_vector(1 DOWNTO 0);
	Signal ALUresult: std_logic_vector(7 DOWNTO 0);
	Signal RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump : STD_LOGIC;
	Signal flags : std_logic_vector(7 downto 0);
	signal s0	 : std_logic;
	
--component LPM_ROM
--	PORT
--	(
--		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
--		clock		: IN STD_LOGIC  := '1';
--		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
--	);
--END component;	

--component instructionmemory
--port(
--	address : in std_logic_vector(7 downto 0);
--	instruction : out std_logic_vector(31 downto 0));
--end component;

component rom is
port(
	address : in std_logic_vector(7 downto 0);
	instruction : out std_logic_vector(31 downto 0));
end component;


component ram
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END component;

--component LPM_RAM
--	PORT
--	(
--		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
--		clock		: IN STD_LOGIC  := '1';
--		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
--		rden		: IN STD_LOGIC  := '1';
--		wren		: IN STD_LOGIC ;
--		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
--	);
--END component;

component controlunit
PORT ( 
	Op: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp1, ALUOp0 : OUT STD_LOGIC);
END component;

component mux_8_2 is
	port(
		a, b : in std_logic_vector(7 downto 0);
		sel : in std_logic;
		y : out std_logic_vector(7 downto 0));
end component;

component registerfile IS
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
END component;

component eightbitfulladder is
	port(
		M : in std_logic_vector (7 downto 0);
		N : in std_logic_vector (7 downto 0);
		Cin : in std_logic;
		Cout : out std_logic;
		Sum : out std_logic_vector (7 downto 0)
	);
end component;

component ALUcontrol
PORT (
	f:IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	ALUop:IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	Operation:OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
end component;

component smallAlu is 
port (
		selec :in std_logic_vector(2 downto 0);
		ValA, ValB: in std_logic_vector(7 downto 0);
		ValO : out std_logic_vector(7 downto 0);
		zero : out std_logic);
end component;

component mux3x8
	port (
		a, b, c, d, e, f: in std_logic_vector(7 downto 0);
		s : in std_logic_vector(2 downto 0);
		y : out std_logic_vector(7 downto 0));
end component;

component mux21_5bit
PORT (A, B : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		s : IN STD_LOGIC;
		R : OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
end component;

component eightbitregister
	PORT(
		i_resetBar, i_en	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
END component;

component shiftleft2 is
port(
	x : in std_logic_vector(7 downto 0);
	y : out std_logic_vector(7 downto 0));
end component;

BEGIN

--PC <= "00000000";

ProgramCounter: eightbitregister port map (greset, '1', gclock, newPC, PC);

PCplus4: eightbitfulladder port map(PC, "00000100",'0', open, PCtemp);

INSTRUCTION: rom port map(PC,IR);

CONTROL: controlunit port map(IR(31 downto 26), RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp(1), ALUOp(0));

WRITEreg: mux21_5bit port map(IR(20 downto 16), IR(15 downto 11), RegDst, writeregout);

REGISTERS: registerfile port map(gclock, greset, IR(25 downto 21),IR(20 downto 16), writeregout, writedata, RegWrite, readdata1, readdata2);

SELECTread2: mux_8_2 port map(readdata2, IR(7 downto 0), ALUSrc, selectB);

ALUCON: ALUcontrol port map(IR(5 downto 0), ALUOp, ALUOPERATION);

ALU: smallAlu port map(ALUOPERATION, readdata1, selectB, ALUresult, ZEROsignal);

DATAMEM: ram port map(ALUresult, gclock, readdata2, MemWrite, DMEMresult); -- MemRead

SelECTwrite: mux_8_2 port map (ALUresult, DMEMresult, MEMtoReg, writedata);

ADDNEXTPC: eightbitfulladder port map(PCtemp, IR(7 downto 0), '0', open, branchresult);

s0 <= ZEROsignal AND Branch;

BRANCHSELECT: mux_8_2 port map(PCtemp, branchresult, s0, selectPC);

SL2 : shiftleft2 port map (IR(7 downto 0), IRSHL2);

JUMPSELECT: mux_8_2 port map(selectPC, IRSHL2, Jump, newPC);

flags <= '0' & REgDst & Jump & MemRead & MemtoReg & AluOp & alusrc;

muxww: mux3x8 port map(PC, ALUresult, readdata1, readdata2, writedata, flags, valueselect, muxout);

instructionout <= IR;
branchout <= Branch;
zeroout <= ZEROsignal;
memwriteout <= MemWrite;
RegWriteOut <= regWrite;

end RTL;
