-- Entity name: ALU.vhd
-- Author: Luis Gallet
-- Contact: luis.galletzambrano@mail.mcgill.ca
-- Date: March 21th, 2016
-- Description:

--TODO: not sure if needs to cast signals to integers when adding or substracting. Implemented it for I-type instructions
-- Not sure if LUI operation logic must be in here or outside as the example.
-- Not sure if overflow and carryout logic detection needs to be implemented.

LIBRARY ieee;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY ALU IS
	PORT(	opcode: in std_logic_vector(3 downto 0); --Specified the ALU which operation to perform
		data0, data1: in std_logic_vector(31 downto 0);
		shamt	: in std_logic_vector (4 downto 0);
		data_out: out std_logic_vector(31 downto 0); 
		HI 	: out std_logic_vector (31 downto 0);
		LO 	: out std_logic_vector (31 downto 0);
		zero	: out std_logic
		--overflow: out std_logic;
		--carryout: out std_logic
	);
END ENTITY;

ARCHITECTURE BEHAVIOR OF ALU IS

signal temp_data_out : std_logic_vector (32 downto 0);
signal mult : std_logic_vector (63 downto 0);
signal div, remainder : std_logic_vector (31 downto 0);

BEGIN

alu: process(opcode)
begin
	case opcode is
		when "0000" =>
			temp_data_out <= data0 AND data1;
		when "0001" =>
			temp_data_out <= data0 OR data1;
		when "0110" =>
			temp_data_out <= std_logic_vector(signed(data0) - signed(data1));
		when "0010" =>
			temp_data_out <= std_logic_vector(signed(data0) + signed(data1));
		when "0111" => --set less than
			if(to_integer(signed(data0)) < to_integer(signed(data1)))then
				temp_data_out <= (31 downto 1 => '0') & '1';
			else
				temp_data_out <= (others => '0');
			end if;
		when "1100" =>
			temp_data_out <= data0 NOR data1;
		when "1101" =>
			temp_data_out <= data0 XOR data1;
		when "1000" => --shift left logical
			temp_data_out <= std_logic_vector(signed(shift_left(unsigned(data0),
										to_integer(unsigned(shamt))))); 
		when "1001" => --shift right logical
			temp_data_out <= std_logic_vector(signed(shift_right(unsigned(data0),
										to_integer(unsigned(shamt))))); 
		when "1010" => --shift right arithmetical
			temp_data_out <= std_logic_vector(shift_right(signed(data0),
										to_integer(unsigned(shamt))));
		when "0011" =>
			mult <= std_logic_vector(signed(data0) * signed(data1));
			HI <= mult(63 downto 32);
			LO <= mult(31 downto 0);
		when "0100" =>
			div <= std_logic_vector(signed(data0) / signed(data1));
			remainder <= std_logic_vector(signed(data0) mod signed(data1));
			HI <= remainder;
			LO <= div;
		when others =>
			temp_data_out <= (others => 'X');
	end case;

		if(to_integer(signed(temp_data_out)) = 0)then
			zero <= '1';
		else
			zero <= '0';
		end if;

data_out <= temp_data_out(31 downto 0);

end process alu;

END BEHAVIOR;