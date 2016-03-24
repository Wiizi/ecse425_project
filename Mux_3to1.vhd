-- ECSE 425 - Comp Organization & Architecture - Final Project
-- Group 5: Andrei Chubarau, Luis Gallet Zambrano, Aidan Petit, Wei Wang
-- Author: Aidan Petit
--
-- Mux_3to1.vhd
-- Generic 3 to 1 multipler. Select between in1, in 2, or in3 becased on select line. 

library ieee;
use ieee.std_logic_1164.all;

--Entity declaration
Entity Mux_2to1 is
	Port 
	(	
		--select line
		sel		: in std_logic_vector(1 downto 0);
		--data inputs
		in1		: in std_logic_vector(31 downto 0);
		in2		: in std_logic_vector(31 downto 0);
		in3		: in std_logic_vector(31 downto 0);
		--output
          	dataOout	: out std_logic_vector(31 downto 0)
	);
End Mux_2to1;

--Architecture 
Architecture mux of Mux_2to1 is

signal highZ	: std_logic_vector(31 downto 0);

BEGIN

	highZ	<= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";	--indicates sel was set to '11' which shouldn't happen

	case sel is
  		when "00" =>	dataOut	<= in1;
		when "01" =>	dataOut <= in2;
		when "10" =>	dataOut <= in3;
  		when "11" =>	dataOut <= highZ;
	end case;
    end;
END mux;
