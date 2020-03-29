LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity ForwardingUnit is
port (
	EXMEMRegWrite, MEMWBRegWrite: in std_logic;
	EXMEMRD, IDEXRS, IDEXRT, MEMWBRD: in std_logic_vector(4 downto 0);
	forwardA, forwardB: out std_logic_vector(1 downto 0)
);
end ForwardingUnit;

architecture arch_ForwardingUnit of ForwardingUnit is

signal t0, t1, t2, t3, eqRS_EXMEM, eq2, eqRT_EXMEM, eqRS_MEMWB, eqRT_MEMWB: std_logic;

begin

eqRS_EXMEM <= (EXMEMRD(4) xnor IDEXRS(4)) and (EXMEMRD(3) xnor IDEXRS(3)) and (EXMEMRD(2) xnor IDEXRS(2)) and (EXMEMRD(1) xnor IDEXRS(1)) and (EXMEMRD(0) xnor IDEXRS(0));
eqRT_EXMEM <= (EXMEMRD(4) xnor IDEXRT(4)) and (EXMEMRD(3) xnor IDEXRT(3)) and (EXMEMRD(2) xnor IDEXRT(2)) and (EXMEMRD(1) xnor IDEXRT(1)) and (EXMEMRD(0) xnor IDEXRT(0));
eqRS_MEMWB <= (MEMWBRD(4) xnor IDEXRS(4)) and (MEMWBRD(3) xnor IDEXRS(3)) and (MEMWBRD(2) xnor IDEXRS(2)) and (MEMWBRD(1) xnor IDEXRS(1)) and (MEMWBRD(0) xnor IDEXRS(0));
eqRT_MEMWB <= (MEMWBRD(4) xnor IDEXRT(4)) and (MEMWBRD(3) xnor IDEXRT(3)) and (MEMWBRD(2) xnor IDEXRT(2)) and (MEMWBRD(1) xnor IDEXRT(1)) and (MEMWBRD(0) xnor IDEXRT(0));

t0 <= EXMEMRegWrite and (EXMEMRD(4) or EXMEMRD(3) or EXMEMRD(2) or EXMEMRD(1) or EXMEMRD(0)) and eqRS_EXMEM;
t1 <= EXMEMRegWrite and (EXMEMRD(4) or EXMEMRD(3) or EXMEMRD(2) or EXMEMRD(1) or EXMEMRD(0)) and eqRT_EXMEM;
t2 <= MEMWBRegWrite and (MEMWBRD(4) or MEMWBRD(3) or MEMWBRD(2) or MEMWBRD(1) or MEMWBRD(0)) and eqRS_MEMWB;
t3 <= MEMWBRegWrite and (MEMWBRD(4) or MEMWBRD(3) or MEMWBRD(2) or MEMWBRD(1) or MEMWBRD(0)) and eqRT_MEMWB;

forwardA <= ((not t0) and t2) & t0;
forwardB <= ((not t1) and t3) & t1;

end arch_ForwardingUnit;