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

		CPU_Stall 		: out std_logic;
		state_o 			: out integer := 0
	);
END HazardDetectionControl;

ARCHITECTURE behaviour OF HazardDetectionControl IS
signal state : integer range 0 to 3 := 0;
BEGIN

state_o <= state;

with state select CPU_Stall <=
	'1' when 1,
	'1' when 2,
	'1' when 3,
	'0' when others; 

hzrdDetection: process (clk)
begin
	if (rising_edge(clk)) then
		-- check for hazards and stall if any hazard is detected
		case state is 
			when 0 =>
				if (ID_EX_MemRead = '1' or BRANCH = '1') then 
					state <= 2; -- insert 3 delay slots
				elsif (((EX_Rt = ID_Rs) or (EX_Rt = ID_Rt)) and EX_Rt /= "00000" and EX_Rt /= "UUUUU" and (ID_Rs /= "UUUUU" or ID_Rt /= "UUUUU")) then
					state <= 1; -- insert 1 delay slot
				end if;
			-- case 1: 1 delay slot; used for structural hazards
			when 1 =>
				state <= 0;
				if (((EX_Rt = ID_Rs) or (EX_Rt = ID_Rt)) and EX_Rt /= "00000" and EX_Rt /= "UUUUU" and (ID_Rs /= "UUUUU" or ID_Rt /= "UUUUU")) then
					state <= 1; -- insert 1 delay slot
				end if;
			-- case 2: 2 delay slots
			when 2 =>
				state <= 1;
			when others => 
				state <= 0;
		end case;
	end if;
end process;
END behaviour;
