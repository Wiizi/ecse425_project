-- Entity name: PC.vhd
-- Author: Luis Gallet
-- Contact: luis.galletzambrano@mail.mcgill.ca
-- Date: March 21th, 2016
-- Description:


LIBRARY ieee;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY PC IS
	PORT(	clk : in std_logic;
		addr_in : in std_logic_vector(31 downto 0);
		PC_write : in std_logic := '1'; --For hazard dectection, always 1 unless hazard detection unit changes it
		addr_out : out std_logic_vector(31 downto 0)
	);
END ENTITY;

ARCHITECTURE BEHAVIOR OF PC IS

signal temp_addr_in : std_logic_vector(31 downto 0);

BEGIN

fetch: process(addr_in)
begin
	temp_addr_in <= addr_in;
end process fetch;

latch: process(clk)
begin
	if(rising_edge(clk) AND PC_write = '1')then
		addr_out <= temp_addr_in;
	end if;
end process latch;

END BEHAVIOR;