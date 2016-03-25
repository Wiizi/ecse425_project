-- Entity name: IF_ID.vhd
-- Author: Luis Gallet
-- Contact: luis.galletzambrano@mail.mcgill.ca
-- Date: March 18th, 2016
-- Description:

LIBRARY ieee;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY IF_ID IS
	PORT(	clk : in std_logic;
		inst_in : in std_logic_vector(31 downto 0);
		addr_in : in std_logic_vector(31 downto 0);
		IF_ID_write : in std_logic :='1'; --For hazard dectection. Always 1 unless hazard detecttion unit changes it.
		inst_out : out std_logic_vector(31 downto 0);
		addr_out : out std_logic_vector(31 downto 0)
	);
END ENTITY;

ARCHITECTURE BEHAVIOR OF IF_ID IS
signal temp_inst_in, temp_addr_in : std_logic_vector(31 downto 0);

BEGIN

fetch: process(addr_in, inst_in)
begin
	temp_inst_in <= inst_in;
	temp_addr_in <= addr_in;
end process fetch;

latch: process(clk)
begin
	if(rising_edge(clk) AND IF_ID_write = '1' )then
		inst_out <= temp_inst_in;
		addr_out <= temp_addr_in;
	end if;
end process latch;

END BEHAVIOR;