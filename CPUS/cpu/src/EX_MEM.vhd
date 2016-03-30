--ECSE 425 - Computer Organization and Architecture
--File: EX_MEM.vhd
--Author: Wei Wang
--Date: 2016-03-23
--
-- Decription: EX_MEM.vhd is an interstage buffer between the execution and memory access stages in our MIPS pipeline. 
-- EX_MEM takes several inputs from the ALU and the previous stage (EX) and forwards them to the outputs on the next rising clock edge.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity EX_MEM is
	port(
			clk : in std_logic;

			--Control Unit
			MemWrite_in		: in std_logic;
			MemRead_in		: in std_logic;
			MemtoReg_in		: in std_logic;
			RegWrite_in		: in std_logic;

			--ALU
			ALU_Result_in	: in std_logic_vector(31 downto 0);
			ALU_HI_in 		: in std_logic_vector (31 downto 0);
			ALU_LO_in 		: in std_logic_vector (31 downto 0);
			ALU_zero_in		: in std_logic;
			--Read Data
			Data1_in		: in std_logic_vector(31 downto 0);
			--Register
			Rd_in 			: in std_logic_vector(4 downto 0);

			--Control Unitnit
			MemWrite_out	: out std_logic;
			MemRead_out		: out std_logic;
			MemtoReg_out	: out std_logic;
			RegWrite_out	: out std_logic;

			--ALU
			ALU_Result_out	: out std_logic_vector(31 downto 0);
			ALU_HI_out 		: out std_logic_vector (31 downto 0);
			ALU_LO_out 		: out std_logic_vector (31 downto 0);
			ALU_zero_out	: out std_logic;
			--Read Data
			Data1_out		: out std_logic_vector(31 downto 0);
			--Register
			Rd_out			: out std_logic_vector(4 downto 0)
		);
end EX_MEM;

architecture Behavioural of EX_MEM is

signal temp_ALU_zero, temp_MemWrite, temp_MemRead, temp_MemtoReg, temp_RegWrite		: std_logic;
signal temp_ALU_Result, temp_ALU_HI, temp_ALU_LO, temp_Data1						: std_logic_vector(31 downto 0);
signal temp_Rd 																		: std_logic_vector(4 downto 0);

begin

	temp_MemWrite 	<= MemWrite_in;
	temp_MemRead	<= MemRead_in;
	temp_MemtoReg 	<= MemtoReg_in;
	temp_RegWrite 	<= RegWrite_in;

	temp_ALU_Result <= ALU_Result_in;
	temp_ALU_HI 	<= ALU_HI_in;
	temp_ALU_LO 	<= ALU_LO_in;
	temp_ALU_zero 	<= ALU_zero_in;

	temp_Data1		<= Data1_in;
	temp_Rd 		<= Rd_in;

	process(clk)
	begin
		if (clk'event and clk = '1') then
			MemWrite_out 	<= temp_MemWrite;
			MemRead_out 	<= temp_MemRead;
			MemtoReg_out 	<= temp_MemtoReg;
			RegWrite_out 	<= temp_RegWrite;

			ALU_Result_out 	<= temp_ALU_Result;
			ALU_HI_out 		<= temp_ALU_HI;
			ALU_LO_out		<= temp_ALU_LO;
			ALU_zero_out 	<= temp_ALU_zero;

			Data1_out 		<= temp_Data1;
			Rd_out 			<= temp_Rd;
		end if;
	end process;

end Behavioural;
