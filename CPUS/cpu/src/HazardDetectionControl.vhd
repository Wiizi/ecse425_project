-- ECSE 425 - Comp Organization & Architecture - Final Project
-- Group 5: Andrei Chubarau, Luis Gallet Zambrano, Aidan Petit, Wei Wang
--
-- HazardDetectionControl.vhd
-- This module is used to detect read after writing (RAW) and Branch hazards in our MIPS pipelined processor.
-- The module outputs control signals to the PC, the IF_ID buffer, and Haz_mux to insert bubbles in the pipeline.
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY HazardDetectionControl IS
	PORT (
		ID_Rs 		: in std_logic_vector(4 downto 0);
		ID_Rt 		: in std_logic_vector(4 downto 0);
		EX_Rt 		: in std_logic_vector(4 downto 0);
		ID_EX_MemRead 	: in std_logic;
		BRANCH			: in std_logic;

		IF_ID_Write 	: out std_logic := '1';
		PC_Update 		: out std_logic := '1';
		CPU_Stall 		: out std_logic := '0'
	);
END HazardDetectionControl;

ARCHITECTURE behaviour OF HazardDetectionControl IS

BEGIN

hzrdDetection: process (ID_EX_MemRead, EX_Rt, ID_Rs, ID_Rt)
begin
	-- check for hazards and stall if hazard is detected
	if ((BRANCH = '1' or ID_EX_MemRead = '1') and ((EX_Rt = ID_Rs) or (EX_Rt = ID_Rt))) then
		if (not(EX_Rt = "00000")) then
	 		CPU_Stall <= '1';
			IF_ID_Write <= '0';
			PC_Update <= '0';
		end if;
	else
	-- set to defaults
	CPU_Stall <= '0';
	IF_ID_Write <= '1';
	PC_Update <= '1';

	end if;

end process;

END behaviour;
