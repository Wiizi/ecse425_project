-- ECSE 425 - Comp Organization & Architecture - Final Project
-- Group 5: Andrei Chubarau, Luis Gallet Zambrano, Aidan Petit, Wei Wang
--
-- Haz_mux.vhd
-- This module is used to insert stalls (bubbles) into the pipeline. Depending on the value of `sel` the unit will either 
-- forward its input signal to the output or will assrt zeros on its output to insert a stall in the IF_ID interstage buffer.
library ieee;
use ieee.std_logic_1164.all;

entity Haz_mux is

port( 
	sel : in std_logic;

	in1 : in std_logic;
	in2 : in std_logic;
	in3 : in std_logic;
	in4 : in std_logic;
	in5 : in std_logic;
	in6 : in std_logic;
	in7 : in std_logic;
	in8 : in std_logic;

	out1 : out std_logic;
	out2 : out std_logic;
	out3 : out std_logic;
	out4 : out std_logic;
	out5 : out std_logic;
	out6 : out std_logic;
	out7 : out std_logic;
	out8 : out std_logic
	);

		
end Haz_mux;

architecture behavior of Haz_mux is

begin

	process(sel)
		begin
			case sel is
				
				when '1' =>
				
		out1 <= '0';
		out2 <= '0';
		out3 <= '0';
		out4 <= '0';
		out5 <= '0';
		out6 <= '0';
		out7 <= '0';
		out8 <= '0';

				
				when '0' =>
		out1 <= in1;
		out2 <= in2;
		out3 <= in3;
		out4 <= in4;
		out5 <= in5;
		out6 <= in6;
		out7 <= in7;
		out8 <= in8;		
			
				when others =>
			
			end case;
	end process;
			
end behavior;
