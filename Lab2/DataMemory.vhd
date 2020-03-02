library ieee;
use ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

entity DataMem2 is
	port (clock, MemWrite, MemRead : in std_logic;
	address, WriteData : in std_logic_vector(7 downto 0) := (others => '0');
	ReadData: out std_logic_vector(7 downto 0) := (others => '0')
	);
end DataMem2;

architecture dataArch of DataMem2 is

constant MIFfile : string := "dataMem.mif";

begin
	
	RAM0: altsyncram generic map (OPERATION_MODE => "SINGLE_PORT",
					WIDTH_A => 8,
					WIDTHAD_A => 8,
					INIT_FILE => MIFfile)
			port map (wren_a => MemWrite,
				rden_a => MemRead,
				address_a => address,
				data_a => WriteData,
				q_a => ReadData,
				clock0 => clock);
	
end dataArch;
