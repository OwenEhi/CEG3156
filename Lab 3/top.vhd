library ieee;
use ieee.std_logic_1164.all;

entity top is
	port (
			gclock, greset : in std_logic;
			valueselect, instrselect : in std_logic_vector(2 downto 0);
			muxout : out std_logic_vector(7 downto 0);
			instructionout : out std_logic_vector(31 downto 0);
			branchout, zeroout, memwriteout, regwriteout : out std_logic
		);
end top;

architecture arch_top of top is

component eightbitregister IS
	PORT(
		i_resetBar, i_en	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
END component;

component rom is
port(
	address : in std_logic_vector(7 downto 0);
	instruction : out std_logic_vector(31 downto 0));
end component;

component eightbitfulladder is
	port(
		M : in std_logic_vector (7 downto 0);
		N : in std_logic_vector (7 downto 0);
		Cin : in std_logic;
		Cout : out std_logic;
		Sum : out std_logic_vector (7 downto 0)
	);
end component;

component thirtytwobitregister IS
	PORT(
		i_resetBar, i_en	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(31 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(31 downto 0));
END component;

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

component controlLogic is
port (
	OP: in std_logic_vector(5 downto 0);
	RegDst, Jump, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0 : out std_logic
);
end component;

component fivebitregister IS
	PORT(
		i_resetBar, i_en	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(4 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(4 downto 0)
	);
END component;

component alu is
port (
	A, B: in std_logic_vector(7 downto 0);
	ALUOP: in std_logic_vector(2 downto 0);
	zero: out std_logic;
	result: out std_logic_vector(7 downto 0)
);
end component;

component ALUcontroller is
port (
	F: in std_logic_vector(5 downto 0);
	ALUOP: in std_logic_vector(1 downto 0);
	Operation: out std_logic_vector(2 downto 0)
);
end component;

component ram is
port (
	 clk: in std_logic;
	 mem_access_addr: in std_logic_Vector(7 downto 0);
	 mem_write_data: in std_logic_Vector(7 downto 0);
	 mem_write_en,mem_read:in std_logic;
	 mem_read_data: out std_logic_Vector(7 downto 0)
);
end component;

component mux_8_2 is
	port(
		a, b : in std_logic_vector(7 downto 0);
		sel : in std_logic;
		y : out std_logic_vector(7 downto 0));
end component;

component enARdFF_2 IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END component;

component mux_5_2 is
	port(
		a, b : in std_logic_vector(4 downto 0);
		sel : in std_logic;
		y : out std_logic_vector(4 downto 0));
end component;

component mux8_3 is
	port (
		a, b, c, d, e, f: in std_logic_vector(7 downto 0);
		s : in std_logic_vector(2 downto 0);
		y : out std_logic_vector(7 downto 0));
end component;

component mux32_3 is
	port (
		a, b, c, d, e, f: in std_logic_vector(31 downto 0);
		s : in std_logic_vector(2 downto 0);
		y : out std_logic_vector(31 downto 0));
end component;

component mux_8_4 is
	port(
		a, b, c, d : in std_logic_vector(7 downto 0);
		sel : in std_logic_vector(1 downto 0);
		y : out std_logic_vector(7 downto 0));
end component;

component ForwardingUnit is
port (
	EXMEMRegWrite, MEMWBRegWrite: in std_logic;
	EXMEMRD, IDEXRS, IDEXRT, MEMWBRD: in std_logic_vector(4 downto 0);
	forwardA, forwardB: out std_logic_vector(1 downto 0)
);
end component;

component HazardUnit is
port (
	IDEXreadMEM: in std_logic;
	IDEXrt, IFIDrs, IFIDrt: in std_logic_vector(4 downto 0);
	stall: out std_logic
);
end component;

component mux_1_2 is
	port(
		a, b : in std_logic;
		sel : in std_logic;
		y : out std_logic
	);
end component;

-- IF 
signal PCin, PCout, Pcplusfourout : std_logic_vector(7 downto 0);
signal InstructionOut1 : std_logic_vector(31 downto 0);
signal PCWrite : std_logic;

-- IF/ID (datapath)
signal IFIDPCplusfourout : std_logic_vector(7 downto 0);
signal InstructionOut2 : std_logic_vector(31 downto 0);
signal IFIDWrite : std_logic;

-- ID (datapath)
signal readdata1out, readdata2out : std_logic_vector(7 downto 0);
signal MuxControlRegWrite, MuxControlMemWrite : std_logic; 

-- ID (control)
signal RegDst, Jump, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0 : std_logic;
signal stall : std_logic;

-- ID/EX (datapath)
signal IDEXPCplusfourout, IDEXreaddata1out, IDEXreaddata2out, IFIDaddressout : std_logic_vector(7 downto 0);
signal IDEXrdout, IDEXrtout, IDEXrsout : std_logic_vector(4 downto 0);
signal InstructionOut3 : std_logic_vector(31 downto 0);

-- ID/EX (control)
signal IDEXAluSrcout, IDEXRegdstout, IDEXALUOp1out, IDEXAluOp0out, IDEXBranchout, IDEXMemReadout, IDEXMemWriteout, IDEXRegWriteout, IDEXMemtoRegout : std_logic;

-- IDEXAluSrcout,

-- EX (datapath)
signal EXPCplusfourout, EXALUSrcout, aluresultout: std_logic_vector(7 downto 0);
signal EXWriteRegisterout : std_logic_vector(4 downto 0);
signal alucontrolout : std_logic_vector(2 downto 0);
signal EXALUOP : std_logic_vector(1 downto 0);
signal zero : std_logic;
signal forwardA, forwardB : std_logic_vector(1 downto 0);
signal AluSrcMuxAOut, AluSrcMuxBOut : std_logic_vector(7 downto 0);

-- EX (control)

-- EX/MEM (datapath)
signal EXMEMPCplusfourout, EXMEMaluresultout : std_logic_vector(7 downto 0);
signal EXMEMWriteRegisterout : std_logic_vector(4 downto 0);
signal EXMEMzero : std_logic;
signal InstructionOut4 : std_logic_vector(31 downto 0);
signal EXMEMRdout : std_logic_vector(4 downto 0);
signal EXMEMWriteDataOut : std_logic_vector(7 downto 0);

-- EX/MEM (control)
signal EXMEMBranchout, EXMEMMemReadout, EXMEMMemWriteout, EXMEMRegWriteout, EXMEMMemtoRegout : std_logic;

-- MEM (datapath)
signal MEMRAMout : std_logic_vector(7 downto 0);
signal MEMBranch : std_logic;

-- MEM (control)

-- MEM/WB (datapath)
signal MEMWBRAMout, MEMWBaluresultout : std_logic_vector(7 downto 0);
signal MEMWBWriteRegisterout : std_logic_vector(4 downto 0);
signal InstructionOut5 : std_logic_vector(31 downto 0);
signal MEMWBRdout : std_logic_vector(4 downto 0);

-- MEM/WB (control)
signal MEMWBRegWriteout, MEMWBMemtoRegout : std_logic;

-- WB
signal WBWriteDataOut : std_logic_vector(7 downto 0);

-- output
signal flags : std_logic_vector(7 downto 0);

begin

-- IF stage
IF_Pcplusfour : mux_8_2 port map (PCplusfourout, EXMEMPCplusfourout, MEMBranch, PCin);
PCWrite <= not stall;
programcounter: eightbitregister port map (greset, PCWrite, gclock, PCin, PCout);
instructionmemory: rom port map (PCout, InstructionOut1);
pcplusfouradder: eightbitfulladder port map (PCout, "00000100", '0', open, PCplusfourout);

-- IF/ID pipeline register (datapath)
IFIDWrite <= not stall;
IF_ID_PCplusfour: eightbitregister port map (greset, IFIDWrite, gclock, PCplusfourout, IFIDPCplusfourout);
IF_ID_ROM: thirtytwobitregister port map (greset, IFIDWrite, gclock, InstructionOut1, InstructionOut2);

-- ID stage
ID_registerfile : registerfile port map (gclock, greset, InstructionOut2(25 downto 21), InstructionOut2(20 downto 16), MEMWBWriteRegisterout, WBWriteDataOut, RegWrite, readdata1out, readdata2out);
ID_controllogic : controlLogic port map (InstructionOut2(31 downto 26), RegDst, Jump, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0);
ID_Hazard_Unit : HazardUnit port map (IDEXMemReadout, IDEXRtout, InstructionOut2(25 downto 21), InstructionOut2(20 downto 16), stall);
ID_Mux_Control_RegWrite : mux_1_2 port map (RegWrite, '0', stall, MuxControlRegWrite);
ID_Mux_Control_MemWrite : mux_1_2 port map (MemWrite, '0', stall, MuxControlMemWrite);

-- ID/EX pipeline register (datapath)
ID_EX_PCplusfour : eightbitregister port map (greset, '1', gclock, IFIDPCplusfourout, IDEXPCplusfourout);
ID_EX_readdata1 : eightbitregister port map (greset, '1', gclock, readdata1out, IDEXreaddata1out);
ID_EX_readdata2 : eightbitregister port map (greset, '1', gclock, readdata2out, IDEXreaddata2out);
ID_EX_rs : fivebitregister port map (greset, '1', gclock, InstructionOut2(25 downto 21), IDEXRsout);
ID_EX_rd : fivebitregister port map (greset, '1', gclock, InstructionOut2(15 downto 11), IDEXRdout);
ID_EX_rt : fivebitregister port map (greset, '1', gclock, InstructionOut2(20 downto 16), IDEXRtout);
ID_EX_address : eightbitregister port map (greset, '1', gclock, InstructionOut2(7 downto 0), IFIDaddressout);
ID_EX_ROM: thirtytwobitregister port map (greset, '1', gclock, InstructionOut2, InstructionOut3);

-- ID/EX pipeline register (control)
ID_EX_RegDst : enARdFF_2 port map (greset, regDst, '1', gclock, IDEXRegdstout);
ID_EX_ALUOP1 : enARdFF_2 port map (greset, ALUOp1, '1', gclock, IDEXALUOp1out);
ID_EX_ALUOP0 : enARdFF_2 port map (greset, AluOp0, '1', gclock, IDEXAluOp0out);
ID_EX_ALUSrc : enARdFF_2 port map (greset, AluSrc, '1', gclock, IDEXAluSrcout);
ID_EX_Branch : enARdFF_2 port map (greset, Branch, '1', gclock, IDEXBranchout);
ID_EX_MemRead : enARdFF_2 port map (greset, MemRead, '1', gclock, IDEXMemReadout);
ID_EX_MemWrite : enARdFF_2 port map (greset, MuxControlMemWrite, '1', gclock, IDEXMemWriteout);
ID_EX_RegWrite : enARdFF_2 port map (greset, MuxControlRegWrite, '1', gclock, IDEXRegWriteout);
ID_EX_MemtoReg :  enARdFF_2 port map (greset, MemToReg, '1', gclock, IDEXMemtoRegout);

-- EX stage
EXALUOP <= IDEXALUOp1out & IDEXAluOp0out;
EX_PCplusfour : eightbitfulladder port map (IDEXPCplusfourout, IFIDaddressout, '0', open, EXPCplusfourout);
EX_alusrc : mux_8_2 port map (AluSrcMuxBOut, IFIDaddressout, IDEXAluSrcout, EXALUSrcout);
EX_alucontroller : alucontroller port map (IFIDaddressout(5 downto 0), EXALUOP, alucontrolout);
EX_alu : alu port map (AluSrcMuxAOut, EXALUSrcout, alucontrolout, zero, aluresultout);
EX_WriteRegister : mux_5_2 port map (IDEXRdout, IDEXRtout, IDEXRegdstout, EXWriteRegisterout);
ALUSrcAMux : mux_8_4 port map (IDEXreaddata1out, WBWriteDataOut, EXMEMaluresultout, "00000000", forwardA, AluSrcMuxAOut);
ALUSrcBMux : mux_8_4 port map (IDEXreaddata2out, WBWriteDataOut, EXMEMaluresultout, "00000000", forwardB, AluSrcMuxBOut);
EX_fowarding_unit : ForwardingUnit port map (EXMEMRegWriteout, MEMWBRegWriteout, EXMEMRdout, IDEXRsout, IDEXRtout, MEMWBRdout, forwardA, forwardB);

-- EX/MEM pipeline register (datapath)
EX_MEM_PCplusfour : eightbitregister port map (greset, '1', gclock, EXPCplusfourout, EXMEMPCplusfourout);
EX_MEM_aluresult : eightbitregister port map (greset, '1', gclock, aluresultout, EXMEMaluresultout);
EX_MEM_zero : enARdFF_2 port map (greset, zero, '1', gclock, EXMEMzero);
EX_MEM_EXMEMWrite : eightbitregister port map (greset, '1', gclock, AluSrcMuxBOut, EXMEMWriteDataOut);
EX_MEM_WriteRegister : fivebitregister port map (greset, '1', gclock, EXWriteRegisterout, EXMEMWriteRegisterout);
EX_MEM_ROM: thirtytwobitregister port map (greset, '1', gclock, InstructionOut3, InstructionOut4);
EX_MEM_rd : fivebitregister port map (greset, '1', gclock, IDEXRdout, EXMEMRdout);

-- EX/MEM pipeline register (control)
EX_MEM_Branch : enARdFF_2 port map (greset, IDEXBranchout, '1', gclock, EXMEMBranchout);
EX_MEM_MemRead : enARdFF_2 port map (greset, IDEXMemReadout, '1', gclock, EXMEMMemReadout);
EX_MEM_MemWrite : enARdFF_2 port map (greset, IDEXMemWriteout, '1', gclock, EXMEMMemWriteout);
EX_MEM_RegWrite : enARdFF_2 port map (greset, IDEXRegWriteout, '1', gclock, EXMEMRegWriteout);
EX_MEM_MemtoReg :  enARdFF_2 port map (greset, IDEXMemtoRegout, '1', gclock, EXMEMMemtoRegout);

-- MEM stage
MEMBranch <= EXMEMBranchout and EXMEMzero;
MEM_RAM : ram port map (gclock, EXMEMaluresultout, EXMEMWriteDataOut, EXMEMMemWriteout, EXMEMMemReadout, MEMRAMout);

-- MEM/WB pipeline register (datapath)
MEM_WB_RAMout : eightbitregister port map (greset, '1', gclock, MEMRAMout, MEMWBRAMout);
MEM_WB_aluresult : eightbitregister port map (greset, '1', gclock, EXMEMaluresultout, MEMWBaluresultout);
MEM_WB_WriteRegister : fivebitregister port map (greset, '1', gclock, EXMEMWriteRegisterout, MEMWBWriteRegisterout);
MEM_WB_ROM: thirtytwobitregister port map (greset, '1', gclock, InstructionOut4, InstructionOut5);
MEM_WB_rd : fivebitregister port map (greset, '1', gclock, EXMEMRdout, MEMWBRdout);

-- MEM/WB pipeline register (control)
MEM_WB_RegWrite : enARdFF_2 port map (greset, EXMEMRegWriteout, '1', gclock, MEMWBRegWriteout);
MEM_WB_MemtoReg : enARdFF_2 port map (greset, EXMEMMemtoRegout, '1', gclock, MEMWBMemtoRegout);

-- WB stage
WBWriteData : mux_8_2 port map (MEMWBaluresultout, MEMWBRAMout, MEMWBMemtoRegout, WBWriteDataOut);


-- output

flags <= '0' & RegDst & Jump & MemRead & MemtoReg & AluOp1 & AluOp0 & alusrc;

muxoutput : mux8_3 port map (PCout, aluresultout, readdata1out, readdata2out, WBWriteDataOut, flags, valueselect, muxout);
instructionoutput : mux32_3 port map (InstructionOut1, InstructionOut2, InstructionOut3, InstructionOut4, InstructionOut5, "00000000000000000000000000000000", instrselect, instructionout);
branchout <= branch;
zeroout <= zero;
memwriteout <= memWrite;
regwriteout <= regWrite;

end architecture arch_top;