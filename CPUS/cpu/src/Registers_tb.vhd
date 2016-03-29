-- ECSE 425 - Comp Organization & Architecture - Final Project
-- Group 5: Andrei Chubarau, Luis Gallet Zambrano, Aidan Petit, Wei Wang
-- Author: Aidan Petit
-- Registers_tb.vhd
-- Contains tests for Registers.vhd

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY Registers_tb is

END Registers_tb;

ARCHITECTURE testing OF Registers_tb IS


COMPONENT Registers is
	PORT(
		clk        	: in std_logic;
		--control
		RegWrite 	: in std_logic;
		ALU_LOHI_Write 	: in std_logic;

		--Register file inputs
		readReg_0 		: in std_logic_vector(4 downto 0);
		readReg_1 		: in std_logic_vector(4 downto 0);
		writeReg  		: in std_logic_vector(4 downto 0);
		writeData 		: in std_logic_vector(31 downto 0);
		ALU_LO_in 		: in std_logic_vector(31 downto 0);
		ALU_HI_in 		: in std_logic_vector(31 downto 0);

		--Register file outputs
		readData_0 		: out std_logic_vector(31 downto 0);
		readData_1 		: out std_logic_vector(31 downto 0);
		ALU_LO_out 		: out std_logic_vector(31 downto 0);
		ALU_HI_out 		: out std_logic_vector(31 downto 0)
		);
end COMPONENT Registers;

--signals
SIGNAL clk			: std_logic				:='0';
SIGNAL t_RegWrite		: std_logic				:='0';
SIGNAL t_ALU_LOHI_Write		: std_logic				:='0';		
SIGNAL t_readReg_0		: std_logic_vector(4 downto 0)	:=(OTHERS => '0');
SIGNAL t_readReg_1		: std_logic_vector(4 downto 0)	:=(OTHERS => '0');
SIGNAL t_writeReg		: std_logic_vector(4 downto 0)	:=(OTHERS => '0');
SIGNAL t_writeData		: std_logic_vector(31 downto 0)	:=(OTHERS => '0');
SIGNAL t_ALU_LO_in		: std_logic_vector(31 downto 0)	:=(OTHERS => '0');
SIGNAL t_ALU_HI_in		: std_logic_vector(31 downto 0)	:=(OTHERS => '0');
SIGNAL t_readData_0		: std_logic_vector(31 downto 0)	:=(OTHERS => '0');
SIGNAL t_readData_1		: std_logic_vector(31 downto 0)	:=(OTHERS => '0');
SIGNAL t_ALU_LO_out		: std_logic_vector(31 downto 0)	:=(OTHERS => '0');
SIGNAL t_ALU_HI_out 		: std_logic_vector(31 downto 0)	:=(OTHERS => '0');

BEGIN

test_Registers: Registers
	PORT MAP
	(
		clk		=> clk,

		RegWrite 	=> t_RegWrite,
		ALU_LOHI_Write 	=> t_ALU_LOHI_Write,


		readReg_0 	=> t_readReg_0,
		readReg_1 	=> t_readReg_1,
		writeReg  	=> t_writeReg,
		writeData 	=> t_writeData,
		ALU_LO_in 	=> t_ALU_LO_in,
		ALU_HI_in 	=> t_ALU_HI_in,

		readData_0 	=> t_readData_0,
		readData_1 	=> t_readData_1,
		ALU_LO_out 	=> t_ALU_LO_out,
		ALU_HI_out 	=> t_ALU_HI_out
	);


clk_process : process
begin
  clk <= '0';
  wait for 10 ns;
  clk <= '1';
  wait for 10 ns;
end process clk_process;


Registers_test: process
begin
-- write to 2 registers
	REPORT "Testing Register.vhd to write to two registers";
	
	t_writeReg	<= "01000";	--register 8
	t_writeData	<= "10001000100010001000100010001000";
	t_regWrite	<= '1';

	wait for 20 ns;

	t_writeReg	<= "01010";	--register 10
	t_writeData	<= "11101110111011101110111011101110";
	t_regWrite	<= '1';

	wait for 20 ns;

--read registers and check they are correct

	t_readReg_0	<= "01000"; --reg 8
	t_readReg_1	<= "01010"; --reg 10

	wait for 20 ns;

	REPORT "Testing Register.vhd to read two registers";

	ASSERT (t_readData_0 = "10001000100010001000100010001000")	REPORT "Error in reg 8"		SEVERITY ERROR;
	ASSERT (t_readData_1 = "11101110111011101110111011101110")	REPORT "Error in reg 10"	SEVERITY ERROR;

	wait for 200 ns;

WAIT;

end process Registers_test;

END testing;
