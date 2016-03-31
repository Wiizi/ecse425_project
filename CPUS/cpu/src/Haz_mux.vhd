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

	with sel select out1 <= 
		'0' when '1',
		in1 when others;

	with sel select out2 <= 
		'0' when '1',
		in2 when others;

	with sel select out3 <= 
		'0' when '1',
		in3 when others;

	with sel select out4 <= 
		'0' when '1',
		in4 when others;

	with sel select out5 <= 
		'0' when '1',
		in5 when others;

	with sel select out6 <= 
		'0' when '1',
		in6 when others;

	with sel select out7 <= 
		'0' when '1',
		in7 when others;

	with sel select out8 <= 
		'0' when '1',
		in8 when others;

end behavior;
