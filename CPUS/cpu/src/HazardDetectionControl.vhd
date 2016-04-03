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
		clk 		: in std_logic;
		ID_Rs 		: in std_logic_vector(4 downto 0);
		ID_Rt 		: in std_logic_vector(4 downto 0);
		EX_Rt 		: in std_logic_vector(4 downto 0);
		ID_EX_MemRead 	: in std_logic;
		BRANCH			: in std_logic;

		IF_ID_Write 	: out std_logic;
		PC_Update 		: out std_logic;
		CPU_Stall 		: out std_logic
	);
END HazardDetectionControl;

ARCHITECTURE behaviour OF HazardDetectionControl IS
signal state : integer range 0 to 1 := 0;
BEGIN

with state select CPU_Stall <=
	'1' when 1,
	'0' when others; 

with state select IF_ID_Write <=
	'0' when 1,
	'1' when others; 

with state select PC_Update <=
	'0' when 1,
	'1' when others; 

hzrdDetection: process (clk)
begin
	if (rising_edge(clk)) then
		-- check for hazards and stall if hazard is detected
		case state is 
			when 0 =>
				if (BRANCH = '1' or ID_EX_MemRead = '1' or (((EX_Rt = ID_Rs) or (EX_Rt = ID_Rt)) and EX_Rt /="00000") ) then
					state <= 1;
				end if;
			when 1 =>
				state <= 0;
			when others => 
				null;
		end case;
	end if;
end process;
END behaviour;
