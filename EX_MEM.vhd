--ECSE 425 - Computer Organization and Architecture
--File: EX_MEM.vhd
--Author: Wei Wang
--Date: 2016-03-23
--Version 1.0

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numberic_std.all;

entity EX_MEM is
	port(
			clk : in std_logic;

			Addr_in			: in std_logic_vector(31 downto 0);
			--ALU
			ALU_Result_in	: in std_logic_vector(31 downto 0);
			ALU_HI_in 		: in std_logic_vector (31 downto 0);
			ALU_LO_in 		: in std_logic_vector (31 downto 0);
			ALU_zero_in		: in std_logic;
			--Read Data
			Data_in			: in std_logic_vector(31 downto 0);
			--Register
			Rd_in 			: in std_logic(4 downto 0);


			Addr_out		: out std_logic_vector(31 downto 0);
			--ALU
			ALU_Result_out	: out std_logic_vector(31 downto 0);
			ALU_HI_out 		: out std_logic_vector (31 downto 0);
			ALU_LO_out 		: out std_logic_vector (31 downto 0);
			ALU_zero_out	: out std_logic;
			--Read Data
			Data_out		: out std_logic_vector(31 downto 0);
			--Register
			Rd_out			: out std_logic(4 downto 0)
		);
end EX_MEM;

architecture Behavioural of EX_MEM is

signal temp_ALU_zero : std_logic;
signal temp_Addr, temp_ALU_Result, temp_ALU_HI, temp_ALU_LO, temp_Data : std_logic_vector(31 downto 0);
signal temp_Rd : std_logic_vector(4 downto 0);

begin

	temp_Addr <= Addr_in;

	temp_ALU_Result <= ALU_Result_in;
	temp_ALU_HI <= ALU_HI_in;
	temp_ALU_LO <= ALU_LO_in;
	temp_ALU_zero <= ALU_zero_in;

	temp_Data <= Data_in;
	temp_Rd <= Rd_in;

	process(clk)
	begin
		if (clk'event and clk = '1') then
			Addr_out <= temp_Addr;

			ALU_Result_out <= temp_ALU_Result;
			ALU_HI_out <= temp_ALU_HI;
			ALU_LO_out <= temp_ALU_LO;
			ALU_zero_out <= temp_ALU_zero;

			Data_out <= temp_Data;
			Rd_out <= temp_Rd;
		end if;
	end process;

end Behavioural;
