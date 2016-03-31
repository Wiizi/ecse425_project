-- Entity name: ALU.vhd
-- Author: Luis Gallet
-- Contact: luis.galletzambrano@mail.mcgill.ca
-- Date: March 21th, 2016
--
-- Description: ALU.vhd is a MIPS instruction based Arithmetic Logic Unit that supports the following operations: AND, OR, sub, add, 
-- slt, XOR, NOR, sll, srl, sra, mult, and div.
-- The operation to be performed is determined by opCode, an input to the ALU. 
-- The output will be data0 op data1
-- 



LIBRARY ieee;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY ALU IS
	PORT(	clk : in std_logic;
		opcode: in std_logic_vector(3 downto 0); --Specified the ALU which operation to perform
		data0, data1: in std_logic_vector(31 downto 0);
		shamt	: in std_logic_vector (4 downto 0);
		data_out: out std_logic_vector(31 downto 0); 
		HI 	: out std_logic_vector (31 downto 0);
		LO 	: out std_logic_vector (31 downto 0);
		zero	: out std_logic
	
	);
END ENTITY;

ARCHITECTURE BEHAVIOR OF ALU IS

signal temp_data_out : std_logic_vector (31 downto 0);
signal temp_zero : std_logic;
signal hilo : std_logic_vector (63 downto 0);

BEGIN

HI <= hilo (63 downto 32);
LO <= hilo (31 downto 0);
data_out <= temp_data_out;
zero <= temp_zero;

alu: process(clk)

begin


if(rising_edge(clk))then
temp_zero <= 'X';

	case opcode is
		when "0000" =>
			temp_data_out <= data0 AND data1;
		when "0001" =>
			temp_data_out <= data0 OR data1;
		when "0110" =>
			if(data0 >= data1)then		
				if(to_integer(unsigned(data0) - unsigned(data1)) = 0)then
					temp_zero <= '1';
					temp_data_out <= std_logic_vector(unsigned(data0) - unsigned(data1));
				else
					temp_zero <= '0';
					temp_data_out <= std_logic_vector(unsigned(data0) - unsigned(data1));
				end if;
			else
				temp_data_out <= (others => '0');
			end if;

		when "0010" =>
			temp_data_out <= std_logic_vector(unsigned(data0) + unsigned(data1));
		when "0111" => --set less than
			if(to_integer(unsigned(data0)) < to_integer(unsigned(data1)))then
				temp_data_out <= (31 downto 1 => '0') & '1';
			else
				temp_data_out <= (others => '0');
			end if;
		when "1100" =>
			temp_data_out <= data0 NOR data1;
		when "1101" =>
			temp_data_out <= data0 XOR data1;
		when "1000" => --shift left logical
			temp_data_out <= std_logic_vector(unsigned(shift_left(unsigned(data0),
										to_integer(unsigned(shamt))))); 
		when "1001" => --shift right logical
			temp_data_out <= std_logic_vector(unsigned(shift_right(unsigned(data0),
										to_integer(unsigned(shamt))))); 
		when "1010" => --shift right arithmetical
			temp_data_out <= std_logic_vector(shift_right(signed(data0),
										to_integer(unsigned(shamt))));
		when "0011" =>
			hilo <= (std_logic_vector(unsigned(data0) * unsigned(data1)));
		when "0100" =>
			hilo <= std_logic_vector(unsigned(data0) mod unsigned(data1)) & std_logic_vector(unsigned(data0) / unsigned(data1));
		when others =>
			temp_data_out <= (others => 'X');
	end case;


end if;
end process alu;

END BEHAVIOR;
