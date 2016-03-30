-- ECSE 425 - Comp Organization & Architecture - Final Project
-- Group 5: Andrei Chubarau, Luis Gallet Zambrano, Aidan Petit, Wei Wang
-- Author: Aidan Petit
-- ALU_tb.vhd
-- Contains tests for all input possibilities to ALU

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY ALU_tb is

END ALU_tb;

architecture testing of ALU_tb is

COMPONENT ALU IS
	PORT(		clk : in std_logic;
			opcode			: in std_logic_vector(3 downto 0); --Specified the ALU which operation to perform
			data0, data1	: in std_logic_vector(31 downto 0);
			shamt			: in std_logic_vector (4 downto 0);
			data_out		: out std_logic_vector(31 downto 0); 
			HI 		 		: out std_logic_vector(31 downto 0);
			LO 				: out std_logic_vector(31 downto 0);
			zero			: out std_logic
		--overflow: out std_logic;
		--carryout: out std_logic
	);
END COMPONENT;

--signals
SIGNAL clk		: std_logic 				:='0';
SIGNAL t_opcode		: std_logic_vector(3 downto 0)		:=(OTHERS => '0');
SIGNAL t_data0		: std_logic_vector(31 downto 0)		:=(OTHERS => '0');
SIGNAL t_data1		: std_logic_vector(31 downto 0)		:=(OTHERS => '0');
SIGNAL t_shamt		: std_logic_vector (4 downto 0)		:=(OTHERS => '0');
SIGNAL t_data_out	: std_logic_vector(31 downto 0)		:=(OTHERS => '0'); 
SIGNAL t_HI 		: std_logic_vector(31 downto 0)		:=(OTHERS => '0');
SIGNAL t_LO 		: std_logic_vector(31 downto 0)		:=(OTHERS => '0');
SIGNAL t_zero		: std_logic							:='0';

begin

test_ALU: ALU
	PORT MAP(
    clk 	=> clk,
    opcode    => t_opcode, 
    data0     => t_data0, 
    data1     => t_data1, 
    shamt     => t_shamt, 
    data_out  => t_data_out, 
    HI        => t_HI, 
    LO        => t_LO, 
    zero      => t_zero 
	);

	
clk_process : process
begin
  clk <= '0';
  wait for 10 ns;
  clk <= '1';
  wait for 10 ns;
end process clk_process;


ALU_test : process
BEGIN
--AND
		t_opCode	<= "0000" ; 
		t_data0		<= "00001111010101011111111100000101";
		t_data1		<= "00001111010101011111111100000100";
		wait for 20 ns;	

		REPORT "Testing ALU - AND";
		ASSERT (t_data_out = "00001111010101011111111100000100")		REPORT "ERROR with AND"	SEVERITY ERROR;

		wait for 200 ns;	
		
--OR
		t_opCode	<= "0001" ; 
		t_data0		<= "00001111010101011111111100000101";
		t_data1		<= "00001111010101011111111100000100";
		wait for 20 ns;	

		REPORT "Testing ALU - OR";
		ASSERT (t_data_out = "00001111010101011111111100000101")		REPORT "ERROR with OR"	SEVERITY ERROR;

		wait for 200 ns;	
		
--sub
		t_opCode	<= "0110" ; 
		t_data0		<= "00000000000000000000000000001000";	--8
		t_data1		<= "00000000000000000000000000000101";  --5
		wait for 20 ns;	

		REPORT "Testing ALU - SUB";
		ASSERT (t_data_out = "00000000000000000000000000000011") 		REPORT "ERROR with SUB"	SEVERITY ERROR; --3

		wait for 200 ns;
		
--sub 2
		t_opCode	<= "0110" ; 
		t_data0		<= "00000000000000000000000000001000";	--8
		t_data1		<= "00000000000000000000000000001001";  --9
		wait for 20 ns;	

		REPORT "Testing ALU - SUB 2";
		ASSERT (t_data_out = "11111111111111111111111111111111") 		REPORT "ERROR with SUB 2"	SEVERITY ERROR; 

		wait for 200 ns;

--add
		t_opCode	<= "0010" ; 
		t_data0		<= "00000000000000000000000000001000";	--8
		t_data1		<= "00000000000000000000000000000101";  --5
		wait for 20 ns;	

		REPORT "Testing ALU - ADD";
		ASSERT (t_data_out = "00000000000000000000000000001101") 		REPORT "ERROR with ADD"	SEVERITY ERROR; --13

		wait for 200 ns;
		
--add 2
		t_opCode	<= "0010" ; 
		t_data0		<= "01111111111111111111111111111111";	--2147483647
		t_data1		<= "00000000000000000000000000000001";  --1
		wait for 20 ns;	

		REPORT "Testing ALU - ADD 2";
		ASSERT (t_data_out = "10000000000000000000000000000000") 		REPORT "ERROR with ADD 2"	SEVERITY ERROR;

		wait for 200 ns;

--set less than
		t_opCode	<= "0111" ; 
		t_data0		<= "00000000000000000000000000001000";	--8
		t_data1		<= "00000000000000000000000000010000";  --16
		wait for 20 ns;	

		REPORT "Testing ALU - SLT";
		ASSERT (t_data_out = "00000000000000000000000000000001") 		REPORT "ERROR with SLT"	SEVERITY ERROR; --13

		wait for 200 ns;

--NOR
		t_opCode	<= "1100" ; 
		t_data0		<= "00000000000000000000000000000101";
		t_data1		<= "11111111111111111111111111111100";
		wait for 20 ns;	

		REPORT "Testing ALU - NOR";
		ASSERT (t_data_out = "00000000000000000000000000000010")		REPORT "ERROR with NOR"	SEVERITY ERROR;

		wait for 200 ns;

--XOR
		t_opCode	<= "1101" ; 
		t_data0		<= "00000000000000000000000000000101";
		t_data1		<= "11111111111111111111111111111100";
		wait for 20 ns;	

		REPORT "Testing ALU - XOR";
		ASSERT (t_data_out = "11111111111111111111111111111001")		REPORT "ERROR with XOR"	SEVERITY ERROR;

		wait for 200 ns;

--sll
		t_opCode	<= "1000" ; 
		t_shamt		<= "00001";
		t_data0		<= "00000000000000000000000000000101";
		wait for 20 ns;	

		REPORT "Testing ALU - SLL";
		ASSERT (t_data_out = "00000000000000000000000000001010")		REPORT "ERROR with SLL"	SEVERITY ERROR;

		wait for 200 ns;

--srl
		t_opCode	<= "1001" ; 
		t_shamt		<= "00001";
		t_data0		<= "00000000000000000000000000000101";
		wait for 20 ns;	

		REPORT "Testing ALU - SRL";
		ASSERT (t_data_out = "00000000000000000000000000000010")		REPORT "ERROR with SRL"	SEVERITY ERROR;

		wait for 200 ns;

--sra
		t_opCode	<= "1010" ; 
		t_shamt		<= "00001";
		t_data0		<= "00000000000000000000000000000101";	
		wait for 20 ns;	
		
		REPORT "Testing ALU - SRA";
		ASSERT (t_data_out = "00000000000000000000000000000010")		REPORT "ERROR with SRA"	SEVERITY ERROR;

		wait for 200 ns;

--mult
		t_opCode	<= "0011" ; 
		t_data0		<= "00000000000000000000000000001000";	--8
		t_data1		<= "00000000000000000000000000000101";  --5
		wait for 20 ns;	
		
		REPORT "Testing ALU - MULT";
		ASSERT (t_HI = "00000000000000000000000000000000")		REPORT "ERROR with MULT (HI)"	SEVERITY ERROR;
		ASSERT (t_LO = "00000000000000000000000000101000")		REPORT "ERROR with MULT (LO)"	SEVERITY ERROR;

		wait for 200 ns;

--div
		t_opCode	<= "0100" ; 
		t_data0		<= "00000000000000000000000000101001";	--41
		t_data1		<= "00000000000000000000000000000101";  --5
		wait for 20 ns;	
		
		REPORT "Testing ALU - DIV";
		ASSERT (t_HI = "00000000000000000000000000000001")		REPORT "ERROR with DIV (rem)"	SEVERITY ERROR;
		ASSERT (t_LO = "00000000000000000000000000001000")		REPORT "ERROR with DIV (div)"	SEVERITY ERROR;

		wait for 200 ns;

	--end, wait forever
	WAIT;

end process ALU_test;


end testing;
