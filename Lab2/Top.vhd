library ieee;
use ieee.std_logic_1164.all;

entity singleCycleProcessor is
	port (CLOCK_50, CLOCK2_50 : in std_logic;
			KEY : in std_logic_vector(1 downto 0) := "-1"
			--SW : in std_logic_vector(17 downto 0);
			--LEDR : out std_logic_vector(17 downto 0);
			--LEDG : out std_logic_vector(7 downto 0)	
	);
end singleCycleProcessor;

architecture processorArch of singleCycleProcessor is

component reg8bitEdge is
	port (CLK, RST, EN: in std_logic;
			D: in std_logic_vector(7 downto 0);
			Q: out std_logic_vector(7 downto 0)
	);
end component;

component CLA is
	port (Cin : in std_logic;	
			A, B : in std_logic_vector(7 downto 0); 
			result: out std_logic_vector(7 downto 0);	
			Cout : out std_logic
	);
end component;

component InstructionMem is
	port (clock1, clock2 : in std_logic;
			address : in std_logic_vector(7 downto 0);
			instruction : out std_logic_vector(31 downto 0)
	);
end component;

component controllerUnit is
	port (opcode : in std_logic_vector(5 downto 0);
			RegDst, ALUSrc, MemToReg, RegWrite, MemRead,
			MemWrite,Branch, Jump : out std_logic;
			ALUOp : out std_logic_vector(1 downto 0)
			);
end component;

component Mux2x1bit5 is
	port (A, B: in std_logic_vector(4 downto 0);
			s: in std_logic; 								
			O: out std_logic_vector(4 downto 0)		
	);
end component;

component RegFile is
	port (clock, reset, RegWrite : in std_logic;
			ReadReg1, ReadReg2, WriteReg : in std_logic_vector(4 downto 0);
			WriteData : in std_logic_vector(7 downto 0);
			ReadData1, ReadData2 : out std_logic_vector(7 downto 0)
	);
end component;

component ALUController is
	port(functCode : in std_logic_vector(5 downto 0);
		  ALUOpCode : in std_logic_vector(1 downto 0);
		  ALUControl : out std_logic_vector(3 downto 0)
	);
end component;

component ALU is
	port (ALUContol : in std_logic_vector(3 downto 0);
			A, B : in std_logic_vector(7 downto 0);
			ALUresult : out std_logic_vector(7 downto 0);
			zero : out std_logic
	);
end component;

component Mux2x1bit8 is
	port (A, B: in std_logic_vector(7 downto 0);	
			s: in std_logic; 								
			O: out std_logic_vector(7 downto 0)		
	);
end component;

component DataMem2 is
	port (clock, MemWrite, MemRead : in std_logic; --MemRead not used, RAM reading every clock2 cycle
			address, WriteData : in std_logic_vector(7 downto 0);
			ReadData: out std_logic_vector(7 downto 0)
	);
end component;

signal PCwrite : std_logic := '1';
signal PCin, PCout, PCadderIn, PCadderOut,
			PCorBranchMuxOut, PCmux, BranchMux: std_logic_vector(7 downto 0) := (others => '0');
signal CinPC : std_logic := '0';
constant one : std_logic_vector(7 downto 0) := "00000001";

signal CoutPC : std_logic;
signal instruction : std_logic_vector(31 downto 0);

signal RegDst, ALUSrc, MemToReg, RegWrite, MemRead,
			MemWrite,Branch, Jump : std_logic := '0';
			
signal ALUOp : std_logic_vector(1 downto 0);

signal WriteReg :	std_logic_vector(4 downto 0);		
signal WriteData, ReadData1, ReadData2 : std_logic_vector(7 downto 0) := (others => '0');

signal ALUControl : std_logic_vector(3 downto 0);

signal ALUsrcB, ALUresult, dataMemOut : std_logic_vector(7 downto 0) := (others => '0');
signal zero : std_logic := '1';

signal branchAdderOut : std_logic_vector(7 downto 0) := (others => '0');
signal PCorBranchSelect : std_logic := '0';
signal PCorBranchOut, JumpMuxOut : std_logic_vector(7 downto 0) := (others => '0');
signal jumpAddress : std_logic_vector(7 downto 0) := (others => '0');--instruction(7 downto 0);

signal CinBranchAdder : std_logic := '0';

begin


		PCin <= JumpMuxOut;
	PC: reg8bitEdge port map (CLOCK_50, KEY(0), PCwrite, PCin, PCout);

	PCadder : CLA port map (CinPC, PCadderIn, one, PCadderOut, CoutPC);
		--PCin <= PCadderOut;
		PCadderIn <= PCout;
		
		
		PCorBranchSelect <= (zero AND Branch);
	--Branch
	PCorBranchMux: Mux2x1bit8 port map (PCmux, BranchMux, PCorBranchSelect, PCorBranchOut);
	PCmux <= PCadderOut;
	BranchMux <= branchAdderOut;

	
	jumpAddress <= instruction(7 downto 0);
	--Jump
	JumporPCBranchMux: Mux2x1bit8 port map (PCorBranchMuxOut, jumpAddress, Jump, JumpMuxOut);
	PCorBranchMuxOut <= PCorBranchOut;

	--Branch Adder
	BranchAdder : CLA port map(CinBranchAdder, PCadderOut, instruction(7 downto 0), branchAdderOut); 
	
		
		
	InstMem: InstructionMem port map (CLOCK2_50, CLOCK2_50, PCout, instruction);
	
	ControlUnit: controllerUnit port map (instruction(31 downto 26), RegDst, ALUSrc, 
				MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp);
				
	WriteRegMux: Mux2x1bit5 port map (instruction(20 downto 16), instruction(15 downto 11), RegDst, WriteReg);
	
	RegisterFile: RegFile port map (CLOCK_50, KEY(0), RegWrite,
					instruction(25 downto 21), instruction(20 downto 16), WriteReg,
					WriteData, ReadData1, ReadData2);
					
	ALUControllerUnit: ALUController port map (instruction(5 downto 0), ALUOp, ALUControl);
	
	ALUsrcMux: Mux2x1bit8 port map (ReadData2, instruction(7 downto 0), ALUSrc, ALUsrcB);
															
	ALUunit: ALU port map (ALUControl, ReadData1, ALUsrcB, ALUresult, zero);
			
	DataMemory: DataMem2 port map (CLOCK2_50, MemWrite, MemRead, ALUresult, ReadData2, dataMemOut);
		
	ALUorDataMux: Mux2x1bit8 port map (ALUresult, dataMemOut, MemToReg, WriteData);

	
end processorArch;
