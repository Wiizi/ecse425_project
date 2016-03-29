--ECSE 425 - Computer Organization and Architecture
--File: MEM_WB.vhd
--Author: Wei Wang
--Date: 2016-03-20
--Version 1.0


library ieee;
use ieee.std_logic_1164.all; -- allows use of the std_logic_vector type
use ieee.numeric_std.all; -- allows use of the unsigned type

entity MEM_WB is
	port(
			clk 			: in std_logic;

			--Control Unit
			MemtoReg_in		: in std_logic;
			RegWrite_in		: in std_logic;
			--Data Memory
			busy_in			: in std_logic;
			Data_in 		: in std_logic_vector(31 downto 0);
			--ALU
			ALU_Result_in	: in std_logic_vector(31 downto 0);
			ALU_HI_in 		: in std_logic_vector (31 downto 0);
			ALU_LO_in 		: in std_logic_vector (31 downto 0);
			ALU_zero_in		: in std_logic;
			--Register
			Rd_in 			: in std_logic_vector (4 downto 0);

			--Control Unit
			MemtoReg_out	: out std_logic;
			RegWrite_out	: out std_logic;
			--Data Memory
			busy_out		: out std_logic;
			Data_out		: out std_logic_vector(31 downto 0);
			--ALU
			ALU_Result_out	: out std_logic_vector(31 downto 0);
			ALU_HI_out 		: out std_logic_vector (31 downto 0);
			ALU_LO_out 		: out std_logic_vector (31 downto 0);
			ALU_zero_out	: out std_logic;
			--Register
			Rd_out			: out std_logic_vector (4 downto 0)
		);
end MEM_WB;

architecture Behavioural of MEM_WB is

signal temp_MemtoReg, temp_RegWrite, temp_busy, temp_ALU_zero, temp_Rd 	: std_logic;
signal temp_Data, temp_ALUResult, temp_ALU_HI, temp_ALU_LO 				: std_logic_vector (31 downto 0);

begin

	temp_MemtoReg 	<= MemtoReg_in;
	temp_RegWrite	<= RegWrite_in;

	temp_busy 		<= busy_in;
	temp_Data 		<= Data_in;

	temp_ALUResult 	<= ALU_Result_in;
	temp_ALU_HI 	<= ALU_HI_in;
	temp_ALU_LO 	<= ALU_LO_in;
	temp_ALU_zero 	<= ALU_zero_in;

	temp_Rd 		<= Rd_in;

	process(clk)
	begin
		if (clk'event and clk = '1') then
			MemtoReg_out 	<= temp_MemtoReg;
			RegWrite_out	<= temp_RegWrite;

			busy_out		<= temp_busy;
			Data_out 		<= temp_Data;

			ALU_Result_out 	<= temp_ALUResult;
			ALU_HI_out 		<= temp_ALU_HI;
			ALU_LO_out 		<= temp_ALU_LO;
			ALU_zero_out 	<= temp_ALU_zero;

			Rd_out 			<= temp_Rd;
		end if;
	end process;

end Behavioural;
