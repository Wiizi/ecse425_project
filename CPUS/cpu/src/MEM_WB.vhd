--ECSE 425 - Computer Organization and Architecture
--Author: Wei Wang
--Date: 2016-03-20
--
-- MEM_WB.vhd
-- Memory Access/Writeback interstage buffer. Forwards inputs to the output on a rising clock edge.
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

signal temp_MemtoReg, temp_RegWrite, temp_busy, temp_ALU_zero 	: std_logic;
signal temp_Data, temp_ALUResult, temp_ALU_HI, temp_ALU_LO 				: std_logic_vector (31 downto 0);
signal temp_Rd : std_logic_vector(4 downto 0);

begin

	-- really
	process (clk)
	begin
	if (rising_edge(clk)) then
		temp_MemtoReg 	<= MemtoReg_in;
		temp_RegWrite	<= RegWrite_in;
	
		temp_busy 		<= busy_in;
		temp_Data 		<= Data_in;
	
		temp_ALUResult 	<= ALU_Result_in;
		temp_ALU_HI 	<= ALU_HI_in;
		temp_ALU_LO 	<= ALU_LO_in;
		temp_ALU_zero 	<= ALU_zero_in;
	
		temp_Rd 		<= Rd_in;
	end if;
	end process;

	MemtoReg_out 	<= MemtoReg_in;
	RegWrite_out	<= RegWrite_in;

	busy_out		<= busy_in;
	Data_out 		<= Data_in;

	ALU_Result_out 	<= ALU_Result_in;
	ALU_HI_out 		<= ALU_HI_in;
	ALU_LO_out 		<= ALU_LO_in;
	ALU_zero_out 	<= ALU_zero_in;

	Rd_out 			<= Rd_in;

end Behavioural;
