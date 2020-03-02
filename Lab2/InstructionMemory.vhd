library ieee;
use ieee.std_logic_1164.all;

LIBRARY lpm;
USE lpm.lpm_components.all;

entity InstructionMem is
	port (clock1, clock2 : in std_logic;
			address : in std_logic_vector(7 downto 0);
			instruction : out std_logic_vector(31 downto 0)
	);
end InstructionMem;

architecture InstructionArch of InstructionMem is

component LPM_ROM
        generic (LPM_WIDTH : natural;    -- MUST be greater than 0
                 LPM_WIDTHAD : natural;    -- MUST be greater than 0
				 LPM_NUMWORDS : natural := 0;
				 LPM_ADDRESS_CONTROL : string := "REGISTERED";
				 LPM_OUTDATA : string := "REGISTERED";
				 LPM_FILE : string;
				 LPM_TYPE : string := L_ROM;--"LPM_ROM"; 
				 INTENDED_DEVICE_FAMILY  : string := "UNUSED";
				 LPM_HINT : string := "UNUSED");
		port (ADDRESS : in STD_LOGIC_VECTOR(LPM_WIDTHAD-1 downto 0);
			  INCLOCK : in STD_LOGIC := '0';
			  OUTCLOCK : in STD_LOGIC := '0';
			  MEMENAB : in STD_LOGIC := '1';
			  Q : out STD_LOGIC_VECTOR(LPM_WIDTH-1 downto 0));
end component;

constant instructionFile : string := "instruction.mif";

begin
	
	ROM0: LPM_ROM 
			generic map (LPM_WIDTH => 32,
							LPM_WIDTHAD => 8,
							LPM_NUMWORDS => 256,
							LPM_FILE => instructionFile,
							LPM_TYPE => L_ROM)--"LPM_ROM")
			port map (address, clock1, clock2, '1', instruction);
								
end InstructionArch;
