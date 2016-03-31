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

	wait for 20 ns;

--write to many registers including HI and LO
--MIPS convention says r8-r15 and r24-r25 for temporaries and r16-r23 for saved temporaries

	REPORT "Testing Register.vhd to write to many registers";
	
	t_writeReg	<= "00000";	--r0
	t_writeData	<= "10001000100010001000100010001000";	--this should have no effect since r0 is hadwired to 0
	t_regWrite	<= '1';
	wait for 20 ns;

	t_writeReg	<= "00001";	--register 1 is 'assemble temporary' unsure about the effect of this
	t_writeData	<= "11111111111111111111111111111111";
	t_regWrite	<= '1';
	wait for 20 ns;

	t_writeReg	<= "01000";	--register 8
	t_writeData	<= "00000000000000000000000000001000";	--8
	t_regWrite	<= '1';
	wait for 20 ns;

	t_writeReg	<= "01001";	--register 9
	t_writeData	<= "00000000000000000000000000001001";	--9
	t_regWrite	<= '1';
	wait for 20 ns;

	t_writeReg	<= "01010";	--register 10
	t_writeData	<= "00000000000000000000000000001010";	--10
	t_regWrite	<= '1';
	wait for 20 ns;

	t_writeReg	<= "01011";	--register 11
	t_writeData	<= "00000000000000000000000000001011";	--11
	t_regWrite	<= '1';
	wait for 20 ns;

	t_writeReg	<= "01100";	--register 12
	t_writeData	<= "00000000000000000000000000001100";	--12
	t_regWrite	<= '1';
	wait for 20 ns;

	t_writeReg	<= "01101";	--register 13
	t_writeData	<= "00000000000000000000000000001101";	--13
	t_regWrite	<= '1';
	wait for 20 ns;

	t_writeReg	<= "01110";	--register 14
	t_writeData	<= "00000000000000000000000000001110";	--14
	t_regWrite	<= '1';
	wait for 20 ns;

	t_writeReg	<= "01111";	--register 15
	t_writeData	<= "00000000000000000000000000001111";	--15
	t_regWrite	<= '1';
	wait for 20 ns;

	t_writeReg	<= "11000";	--register 24
	t_writeData	<= "00000000000000000000000000011000";	--24
	t_regWrite	<= '1';
	wait for 20 ns;

	t_writeReg	<= "11001";	--register 25
	t_writeData	<= "00000000000000000000000000011001";	--25
	t_regWrite	<= '1';
	wait for 20 ns;

	--HI reg
	t_ALU_HI_in	<= "11111111111111111111111111111111";	
	t_ALU_LOHI_Write	<= '1';
	wait for 20 ns;

	--LO reg
	t_ALU_LO_in	<= "11111111111111111111111111110000";	
	t_ALU_LOHI_Write	<= '1';
	wait for 20 ns;

		


	REPORT "Testing Register.vhd to read many registers";

	t_readReg_0	<= "00000"; --r0
	t_readReg_1	<= "00001"; --r1
	wait for 20 ns;

	ASSERT (t_readData_0 = "00000000000000000000000000000000")	REPORT "Error in r0"	SEVERITY ERROR;
	ASSERT (t_readData_1 = "11111111111111111111111111111111")	REPORT "Error in r1"	SEVERITY ERROR;
	wait for 20 ns;
	
	t_readReg_0	<= "01000"; --r8
	t_readReg_1	<= "01001"; --r9
	wait for 20 ns;

	ASSERT (t_readData_0 = "00000000000000000000000000001000")	REPORT "Error in r8"	SEVERITY ERROR;
	ASSERT (t_readData_1 = "00000000000000000000000000001001")	REPORT "Error in r9"	SEVERITY ERROR;
	wait for 20 ns;

	t_readReg_0	<= "01010"; --r10
	t_readReg_1	<= "01011"; --r11
	wait for 20 ns;

	ASSERT (t_readData_0 = "00000000000000000000000000001010")	REPORT "Error in r10"	SEVERITY ERROR;
	ASSERT (t_readData_1 = "00000000000000000000000000001011")	REPORT "Error in r11"	SEVERITY ERROR;
	wait for 20 ns;

	t_readReg_0	<= "01100"; --r12
	t_readReg_1	<= "01101"; --r13
	wait for 20 ns;

	ASSERT (t_readData_0 = "00000000000000000000000000001100")	REPORT "Error in r12"	SEVERITY ERROR;
	ASSERT (t_readData_1 = "00000000000000000000000000001101")	REPORT "Error in r13"	SEVERITY ERROR;
	wait for 20 ns;

	t_readReg_0	<= "01110"; --r14
	t_readReg_1	<= "01111"; --r15
	wait for 20 ns;

	ASSERT (t_readData_0 = "00000000000000000000000000001110")	REPORT "Error in r14"	SEVERITY ERROR;
	ASSERT (t_readData_1 = "00000000000000000000000000001111")	REPORT "Error in r15"	SEVERITY ERROR;
	wait for 20 ns;

	t_readReg_0	<= "11000"; --r24
	t_readReg_1	<= "11001"; --r25
	wait for 20 ns;

	ASSERT (t_readData_0 = "00000000000000000000000000011000")	REPORT "Error in r24"	SEVERITY ERROR;
	ASSERT (t_readData_1 = "00000000000000000000000000011001")	REPORT "Error in r25"	SEVERITY ERROR;
	wait for 20 ns;

	ASSERT (t_ALU_LO_out = "11111111111111111111111111110000")	REPORT "Error in LO"	SEVERITY ERROR;
	ASSERT (t_ALU_HI_out = "11111111111111111111111111111111")	REPORT "Error in HI"	SEVERITY ERROR;
	wait for 20 ns;

WAIT;

end process Registers_test;

END testing;
