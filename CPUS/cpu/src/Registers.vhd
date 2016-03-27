--ECSE 425 - Computer Organization and Architecture
--File: Register.vhd
--Author: Wei Wang
--Date: 2016-03-18
--Version 1.0

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity Registers is
	port(
		clk : in std_logic;
		--control
		regWrite : in std_logic;
		ALU_LOHI_Write : in std_logic;

		--Register file inputs
		readReg_1 : in std_logic_vector(4 downto 0);
		readReg_2 : in std_logic_vector(4 downto 0);
		writeReg :  in std_logic_vector(4 downto 0);
		writeData : in std_logic_vector(31 downto 0);
		ALU_LO_in : in std_logic_vector(31 downto 0);
		ALU_HI_in : in std_logic_vector(31 downto 0);

		--Register file outputs
		readData_1 : out std_logic_vector(31 downto 0);
		readData_2 : out std_logic_vector(31 downto 0);
		ALU_LO_out : out std_logic_vector(31 downto 0);
		ALU_HI_out : out std_logic_vector(31 downto 0)
		);
end Registers;

architecture Behavioural of Registers is

type reg_mem is array (0 to 33) of std_logic_vector(31 downto 0);
signal regArray : reg_mem := (others => (others => '0'));

signal temp_readData_1, temp_readData_2, temp_ALU_LO_out, temp_ALU_HI_out : std_logic_vector(31 downto 0);

begin

--register 0 is hardwires to 0
regArray(0) <= (others => '0');

readData_1 <= temp_readData_1;
readData_2 <= temp_readData_2;
ALU_LO_out <= temp_ALU_LO_out;
ALU_HI_out <= temp_ALU_HI_out;

	process(clk, regWrite, readReg_1, readReg_2, writeReg, writeData)
	begin
		--wait for active clock edge
		if (clk'event and clk = '1') then

			temp_readData_1 <= regArray(TO_INTEGER(UNSIGNED(readReg_1)));
			temp_readData_2 <= regArray(TO_INTEGER(UNSIGNED(readReg_2)));
			temp_ALU_LO_out <= regArray(32);
			temp_ALU_HI_out <= regArray(33);
			--check whether write signal is active
			if (regWrite = '1') then
				--write the data
				regArray(TO_INTEGER(UNSIGNED(writeReg))) <= writeData;
			end if;
			if (ALU_LOHI_Write = '1') then
				regArray(32) <= ALU_LO_in;
				regArray(33) <= ALU_HI_in;
			end if;
		end if;
	end process;

end Behavioural;
