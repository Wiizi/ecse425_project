-- ECSE 425 - Comp Organization & Architecture - Final Project
-- Group 5: Andrei Chubarau, Luis Gallet Zambrano, Aidan Petit, Wei Wang
-- Author: Aidan Petit
--
-- Mux_2to1.vhd
-- Generic 2 to 1 multipler. Select between in1 or in2 becased on sel

library ieee;
use ieee.std_logic_1164.all;

--Entity declaration
Entity Mux_2to1 is
	Port 
	(	
		--select line
		sel			: in std_logic;
		--data inputs
		in1			: in std_logic_vector(31 downto 0);
		in2			: in std_logic_vector(31 downto 0);
		--output
        dataOut		: out std_logic_vector(31 downto 0)
	);
End Mux_2to1;

--Architecture 
Architecture mux of Mux_2to1 is
	signal highZ	: std_logic_vector(31 downto 0) := (others => 'Z');
begin
	--indicates sel was set to '11' which shouldn't happen
	with sel select dataOut <=
  		in1 when '0',
  		in2 when '1',
  		highZ when others;
END mux;
