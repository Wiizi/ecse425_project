-- ECSE 425 - Comp Organization & Architecture - Final Project
-- Group 5: Andrei Chubarau, Luis Gallet Zambrano, Aidan Petit, Wei Wang
-- Author: Aidan Petit
-- Control_Unit_tb.vhd
-- Contains 33 tests for all input possibilities to Control_Unit

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity Control_Unit_tb is

end Control_Unit_tb;

architecture testing of Control_Unit_tb is

COMPONENT Control_Unit IS
	    PORT(
		    clk             : in std_logic;

		    opCode          : in std_logic_vector(5 downto 0);
		    funct           : in std_logic_vector(5 downto 0);

		    --ID
		    RegWrite        : out std_logic;
		    
			--EX
		    ALUSrc          : out std_logic;
		    ALUOpCode       : out std_logic_vector(3 downto 0);
		    RegDest         : out std_logic;
		    Branch          : out std_logic;
		    BNE             : out std_logic;
		    Jump            : out std_logic;
		    LUI             : out std_logic;
		    ALU_LOHI_Write  : out std_logic;
		    ALU_LOHI_Read   : out std_logic_vector(1 downto 0);
		    
			--MEM
		    MemWrite        : out std_logic;
		    MemRead         : out std_logic;
		    
			--WB
		    MemtoReg        : out std_logic
		 );
END COMPONENT;

--inputs
SIGNAL clk				: std_logic							:= '0';
SIGNAL t_opCode			: std_logic_vector(5 downto 0)		:= (OTHERS => '0');
SIGNAL t_funct			: std_logic_vector(5 downto 0)		:= (OTHERS => '0');

--outputs
SIGNAL t_RegWrite        : std_logic						:= '0';    
SIGNAL t_ALUSrc          : std_logic						:= '0';
SIGNAL t_ALUOpCode       : std_logic_vector(3 downto 0)		:= (OTHERS => '0');
SIGNAL t_RegDest         : std_logic						:= '0';
SIGNAL t_Branch          : std_logic						:= '0';
SIGNAL t_BNE             : std_logic						:= '0';
SIGNAL t_Jump            : std_logic						:= '0';
SIGNAL t_LUI             : std_logic						:= '0';
SIGNAL t_ALU_LOHI_Write  : std_logic						:= '0';
SIGNAL t_ALU_LOHI_Read   : std_logic_vector(1 downto 0)		:= (OTHERS => '0');
SIGNAL t_MemWrite        : std_logic						:= '0';
SIGNAL t_MemRead         : std_logic						:= '0';
SIGNAL t_MemtoReg        : std_logic						:= '0';

begin

control : Control_Unit
PORT MAP
(
    	clk 			=> clk,
		opCode 			=> t_opCode,
		funct 			=> t_funct,

		RegWrite		=> t_RegWrite,

		ALUSrc			=> t_ALUSrc,
		ALUOpCode       => t_ALUOpCode, 
		RegDest			=> t_RegDest,
		Branch 			=> t_Branch,
		BNE				=> t_BNE,
		Jump            => t_Jump,
		LUI				=> t_LUI, 
		ALU_LOHI_Write 	=> t_ALU_LOHI_Write, 
		ALU_LOHI_Read 	=> t_ALU_LOHI_Read,

		MemWrite		=> t_MemWrite,
		MemRead			=> t_MemRead,
		MemtoReg      	=> t_MemtoReg 
);

clk_process : process
begin
  clk <= '0';
  wait for 10 ns;
  clk <= '1';
  wait for 10 ns;
end process clk_process;

control_test : process
begin
--R-type tests
	--********************************************NEW TEST***************************************************
	--R-type test
		t_opCode	<= "000000" ; --indicates R-type instruction

		wait for 20 ns;	--unsure about this
		
		REPORT "Testing Control Unit for R-type instruction.";

		ASSERT (t_RegWrite = '1')				REPORT "t_RegWrite must be equal to 1."	SEVERITY ERROR;
		ASSERT (t_RegDest = '1')				REPORT "t_RegDest must be equal to 1."	SEVERITY ERROR;
		ASSERT (t_MemtoReg = '0')				REPORT "t_MemtoReg must be equal to 0."	SEVERITY ERROR;		

		wait for 200 ns;	

		
		
	--********************************************NEW TEST***************************************************
	--MULT test
		t_opCode	<= "000000" ;
		t_funct		<= "011000" ;
	
		wait for 20 ns;	--unsure about this

		REPORT "Testing Control Unit for 'mult' instruction.";

		ASSERT (t_ALUOpCode = "0011")			REPORT "t_ALUOpCode must be '0011'."	SEVERITY ERROR;
		ASSERT (t_ALU_LOHI_Write = '1')			REPORT "t_MemtoReg must be equal to 0."	SEVERITY ERROR;

		wait for 200 ns;
		
		
		
	--********************************************NEW TEST***************************************************
	--MFLO test
		t_opCode	<= "000000" ;
		t_funct		<= "010010" ;
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'mflo' instruction.";

		ASSERT (t_ALUOpCode = "0010")			REPORT "t_ALUOpCode must be '0010'."	SEVERITY ERROR;
		ASSERT (t_ALU_LOHI_Read = "01")			REPORT "t_ALU_LOHI_Read must be '01'."	SEVERITY ERROR;

		wait for 200 ns;
		
		
		
	--********************************************NEW TEST***************************************************
	--jr test
		t_opCode	<= "000000" ;
		t_funct		<= "001000" ;
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'jr' instruction.";

		ASSERT (t_ALUOpCode = "0010")			REPORT "t_ALUOpCode must be '0010'."	SEVERITY ERROR;

		wait for 200 ns;	

	
	--********************************************NEW TEST***************************************************
	--mfhi test
		t_opCode	<= "000000" ;
		t_funct		<= "010000" ;
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'mfhi' instruction.";

		ASSERT (t_ALUOpCode = "0010")			REPORT "t_ALUOpCode must be '0010'."	SEVERITY ERROR;
		ASSERT (t_ALU_LOHI_Read = "10")			REPORT "t_ALU_LOHI_Read must be '10'."	SEVERITY ERROR;

		wait for 200 ns;	

		
		
	--********************************************NEW TEST***************************************************
	--add test
		t_opCode	<= "000000" ;
		t_funct		<= "100000" ;
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'add' instruction.";

		ASSERT (t_ALUOpCode = "0010")			REPORT "t_ALUOpCode must be '0010'."	SEVERITY ERROR;

		wait for 200 ns;		
		
		
--********************************************NEW TEST***************************************************
	--sub test
		t_opCode	<= "000000" ;
		t_funct		<= "100010" ;
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'sub' instruction.";

		ASSERT (t_ALUOpCode = "0110")			REPORT "t_ALUOpCode must be '0110'."	SEVERITY ERROR;

		wait for 200 ns;		
		
		
			
--********************************************NEW TEST***************************************************
	--and test
		t_opCode	<= "000000" ;
		t_funct		<= "100100" ;
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'and' instruction.";

		ASSERT (t_ALUOpCode = "0000")			REPORT "t_ALUOpCode must be '0000'."	SEVERITY ERROR;

		wait for 200 ns;		
		
		
		
--********************************************NEW TEST***************************************************
	--div test
		t_opCode	<= "000000" ;
		t_funct		<= "011010" ;
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'div' instruction.";

		ASSERT (t_ALUOpCode = "0100")			REPORT "t_ALUOpCode must be '0100'."			SEVERITY ERROR;
		ASSERT (t_ALU_LOHI_Write = '1')			REPORT "t_ALU_LOHI_Write must be equal to 1."	SEVERITY ERROR;

		wait for 200 ns;	

		

--********************************************NEW TEST***************************************************
	--slt test
		t_opCode	<= "000000" ;
		t_funct		<= "101010" ;
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'slt' instruction.";

		ASSERT (t_ALUOpCode = "0111")			REPORT "t_ALUOpCode must be '0111'."	SEVERITY ERROR;

		wait for 200 ns;		
		
		
			
--********************************************NEW TEST***************************************************
	--or test
		t_opCode	<= "000000" ;
		t_funct		<= "100101" ;
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'or' instruction.";

		ASSERT (t_ALUOpCode = "0001")			REPORT "t_ALUOpCode must be '0001'."	SEVERITY ERROR;

		wait for 200 ns;		
		
		
		
--********************************************NEW TEST***************************************************
	--nor test
		t_opCode	<= "000000" ;
		t_funct		<= "100111" ;
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'nor' instruction.";

		ASSERT (t_ALUOpCode = "1100")			REPORT "t_ALUOpCode must be '1100'."	SEVERITY ERROR;

		wait for 200 ns;		
		
		
--********************************************NEW TEST***************************************************
	--xor test
		t_opCode	<= "000000" ;
		t_funct		<= "101000" ;
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'xor' instruction.";

		ASSERT (t_ALUOpCode = "1101")			REPORT "t_ALUOpCode must be '1101'."	SEVERITY ERROR;

		wait for 200 ns;
		
		
--********************************************NEW TEST***************************************************
	--sra test
		t_opCode	<= "000000" ;
		t_funct		<= "000011" ;
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'sra' instruction.";

		ASSERT (t_ALUOpCode = "1010")			REPORT "t_ALUOpCode must be '1010'."	SEVERITY ERROR;

		wait for 200 ns;
		
		
--********************************************NEW TEST***************************************************
	--srl test
		t_opCode	<= "000000" ;
		t_funct		<= "000010" ;
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'srl' instruction.";

		ASSERT (t_ALUOpCode = "1010")			REPORT "t_ALUOpCode must be '1010'."	SEVERITY ERROR;

		wait for 200 ns;
		
		
--********************************************NEW TEST***************************************************
	--sll test
		t_opCode	<= "000000" ;
		t_funct		<= "000000" ;
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'sll' instruction.";

		ASSERT (t_ALUOpCode = "1000")			REPORT "t_ALUOpCode must be '1000'."	SEVERITY ERROR;

		wait for 200 ns;		
--End of R-type tests		

--I-type tests
--********************************************NEW TEST***************************************************
	--addi test
		t_opCode	<= "001000"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'addi' instruction.";

		ASSERT (t_RegWrite = '1')				REPORT "t_RegWrite must be equal to 1."	SEVERITY ERROR;
		ASSERT (t_ALUSrc = '1')					REPORT "t_ALUSrc must be equal to 1"	SEVERITY ERROR;
		ASSERT (t_ALUOpCode = "0010")			REPORT "t_ALUOpCode must be '0010'."	SEVERITY ERROR;
		ASSERT (t_RegDest = '0')				REPORT "t_RegDest must be equal to 0."	SEVERITY ERROR;
		ASSERT (t_MemtoReg = '0')				REPORT "t_MemtoReg must be equal to 0."	SEVERITY ERROR;	

		wait for 200 ns;	
		
		
		
--********************************************NEW TEST***************************************************
	--slti test
		t_opCode	<= "001010"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'slti' instruction.";

		ASSERT (t_RegWrite = '1')			REPORT "t_RegWrite must be equal to 1."	SEVERITY ERROR;
		ASSERT (t_ALUSrc = '1')				REPORT "t_ALUSrc must be equal to 1"	SEVERITY ERROR;
		ASSERT (t_ALUOpCode = "0111")		REPORT "t_ALUOpCode must be '0111'."	SEVERITY ERROR;
		ASSERT (t_RegDest = '0')			REPORT "t_RegDest must be equal to 0."	SEVERITY ERROR;
		ASSERT (t_MemtoReg = '0')			REPORT "t_MemtoReg must be equal to 0."	SEVERITY ERROR;	

		wait for 200 ns;	
		
		
		
--********************************************NEW TEST***************************************************
	--bne test
		t_opCode	<= "000101"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'bne' instruction.";

		ASSERT (t_ALUOpCode = "0110")		REPORT "t_ALUOpCode must be '0110'."	SEVERITY ERROR;
		ASSERT (t_Branch = '1')				REPORT "t_Branch must be equal to 1."	SEVERITY ERROR;
		ASSERT (t_BNE = '1')				REPORT "t_BNE must be equal to 1."		SEVERITY ERROR;	

		wait for 200 ns;	
		
		
--********************************************NEW TEST***************************************************
	--sw test
		t_opCode	<= "101011"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'sw' instruction.";

		ASSERT (t_ALUSrc = '1')				REPORT "t_ALUSrc must be equal to 1"	SEVERITY ERROR;
		ASSERT (t_ALUOpCode = "0010")		REPORT "t_ALUOpCode must be '0010'."	SEVERITY ERROR;
		ASSERT (t_MemWrite = '1')			REPORT "t_MemWrite must be equal to 1."	SEVERITY ERROR;

		wait for 200 ns;	
		
		
--********************************************NEW TEST***************************************************
	--beq test
		t_opCode	<= "000100"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'beq' instruction.";

		ASSERT (t_ALUOpCode = "0110")		REPORT "t_ALUOpCode must be '0110'."	SEVERITY ERROR;
		ASSERT (t_Branch = '1')				REPORT "t_Branch must be equal to 1."	SEVERITY ERROR;

		wait for 200 ns;	
		
--********************************************NEW TEST***************************************************
	--lw test
		t_opCode	<= "100011"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'lw' instruction.";

		ASSERT (t_RegWrite = '1')			REPORT "t_RegWrite must be equal to 1."	SEVERITY ERROR;
		ASSERT (t_ALUSrc = '1')				REPORT "t_ALUSrc must be equal to 1"	SEVERITY ERROR;
		ASSERT (t_ALUOpCode = "0010")		REPORT "t_ALUOpCode must be '0010'."	SEVERITY ERROR;
		ASSERT (t_RegDest = '0')			REPORT "t_RegDest must be equal to 0."	SEVERITY ERROR;
		ASSERT (t_MemRead = '1')			REPORT "t_MemRead must be equal to 1."	SEVERITY ERROR;
		ASSERT (t_MemtoReg = '1')			REPORT "t_MemtoReg must be equal to 1."	SEVERITY ERROR;	

		wait for 200 ns;	
		
	
--********************************************NEW TEST***************************************************
	--lb test
		t_opCode	<= "100000"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'lb' instruction.";

		ASSERT (t_RegWrite = '1')			REPORT "t_RegWrite must be equal to 1."	SEVERITY ERROR;
		ASSERT (t_ALUSrc = '1')				REPORT "t_ALUSrc must be equal to 1"	SEVERITY ERROR;
		ASSERT (t_ALUOpCode = "0010")		REPORT "t_ALUOpCode must be '0010'."	SEVERITY ERROR;
		ASSERT (t_RegDest = '0')			REPORT "t_RegDest must be equal to 0."	SEVERITY ERROR;
		ASSERT (t_MemRead = '1')			REPORT "t_MemRead must be equal to 1."	SEVERITY ERROR;
		ASSERT (t_MemtoReg = '1')			REPORT "t_MemtoReg must be equal to 1."	SEVERITY ERROR;	

		wait for 200 ns;	
		
		
--********************************************NEW TEST***************************************************
	--sb test
		t_opCode	<= "101000"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'lb' instruction.";

		ASSERT (t_ALUSrc = '1')				REPORT "t_ALUSrc must be equal to 1"	SEVERITY ERROR;
		ASSERT (t_ALUOpCode = "0010")		REPORT "t_ALUOpCode must be '0010'."	SEVERITY ERROR;
		ASSERT (t_MemWrite = '1')			REPORT "t_MemWrite must be equal to 1."	SEVERITY ERROR;

		wait for 200 ns;							
	
--********************************************NEW TEST***************************************************
	--lui test
		t_opCode	<= "001111"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'lui' instruction.";

		ASSERT (t_RegWrite = '1')			REPORT "t_RegWrite must be equal to 1."	SEVERITY ERROR;
		ASSERT (t_ALUSrc = '1')				REPORT "t_ALUSrc must be equal to 1"	SEVERITY ERROR;
		ASSERT (t_ALUOpCode = "0010")		REPORT "t_ALUOpCode must be '0010'."	SEVERITY ERROR;
		ASSERT (t_RegDest = '0')			REPORT "t_RegDest must be equal to 0."	SEVERITY ERROR;
		ASSERT (t_LUI = '1')				REPORT "t_LUI must be equal to 1."		SEVERITY ERROR;
		ASSERT (t_MemtoReg = '0')			REPORT "t_MemtoReg must be equal to 0."	SEVERITY ERROR;	

		wait for 200 ns;	
	
	
--********************************************NEW TEST***************************************************
	--andi test
		t_opCode	<= "001100"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'andi' instruction.";

		ASSERT (t_RegWrite = '1')			REPORT "t_RegWrite must be equal to 1."	SEVERITY ERROR;
		ASSERT (t_ALUSrc = '1')				REPORT "t_ALUSrc must be equal to 1"	SEVERITY ERROR;
		ASSERT (t_ALUOpCode = "0000")		REPORT "t_ALUOpCode must be '0000'."	SEVERITY ERROR;
		ASSERT (t_RegDest = '0')			REPORT "t_RegDest must be equal to 0."	SEVERITY ERROR;
		ASSERT (t_MemtoReg = '0')			REPORT "t_MemtoReg must be equal to 0."	SEVERITY ERROR;	

		wait for 200 ns;	
		
		
--********************************************NEW TEST***************************************************
	--ori test
		t_opCode	<= "001101"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'ori' instruction.";

		ASSERT (t_RegWrite = '1')			REPORT "t_RegWrite must be equal to 1."	SEVERITY ERROR;
		ASSERT (t_ALUSrc = '1')				REPORT "t_ALUSrc must be equal to 1"	SEVERITY ERROR;
		ASSERT (t_ALUOpCode = "0001")		REPORT "t_ALUOpCode must be '0001'."	SEVERITY ERROR;
		ASSERT (t_RegDest = '0')			REPORT "t_RegDest must be equal to 0."	SEVERITY ERROR;
		ASSERT (t_MemtoReg = '0')			REPORT "t_MemtoReg must be equal to 0."	SEVERITY ERROR;	

		wait for 200 ns;	
		
		
--********************************************NEW TEST***************************************************
	--xori test
		t_opCode	<= "001110"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'xori' instruction.";

		ASSERT (t_RegWrite = '1')			REPORT "t_RegWrite must be equal to 1."	SEVERITY ERROR;
		ASSERT (t_ALUSrc = '1')				REPORT "t_ALUSrc must be equal to 1"	SEVERITY ERROR;
		ASSERT (t_ALUOpCode = "1101")		REPORT "t_ALUOpCode must be '1101'."	SEVERITY ERROR;
		ASSERT (t_RegDest = '0')			REPORT "t_RegDest must be equal to 0."	SEVERITY ERROR;
		ASSERT (t_MemtoReg = '0')			REPORT "t_MemtoReg must be equal to 0."	SEVERITY ERROR;	

		wait for 200 ns;	
--End of I-type tests



--J-type tests
--********************************************NEW TEST***************************************************
	--jal test
		t_opCode	<= "000011"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'jal' instruction.";

		ASSERT (t_ALUOpCode = "0010")		REPORT "t_ALUOpCode must be '0010'."	SEVERITY ERROR;
		ASSERT (t_Jump = '1')				REPORT "t_Jump must be equal to 1."		SEVERITY ERROR;

		wait for 200 ns;	

		
--********************************************NEW TEST***************************************************
	--j test
		t_opCode	<= "000010"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'j' instruction.";

		ASSERT (t_ALUOpCode = "0010")		REPORT "t_ALUOpCode must be '0010'."	SEVERITY ERROR;
		ASSERT (t_Jump = '1')				REPORT "t_Jump must be equal to 1."		SEVERITY ERROR;

		wait for 200 ns;	
		
		
--********************************************NEW TEST***************************************************
	--asrt test
		t_opCode	<= "010100"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'asrt' instruction.";

		ASSERT (t_ALUOpCode = "0110")		REPORT "t_ALUOpCode must be '0110'."	SEVERITY ERROR;

		wait for 200 ns;	

		
--********************************************NEW TEST***************************************************
	--asrti test
		t_opCode	<= "010101"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'asrti' instruction.";

		ASSERT (t_ALUOpCode = "0110")		REPORT "t_ALUOpCode must be '0110'."	SEVERITY ERROR;

		wait for 200 ns;
	
	
--********************************************NEW TEST***************************************************
	--halt test
		t_opCode	<= "010110"; 
	
		wait for 20 ns;	

		REPORT "Testing Control Unit for 'halt' instruction.";

		ASSERT (t_ALUOpCode = "ZZZZ")		REPORT "t_ALUOpCode must be 'ZZZZ'."	SEVERITY ERROR;

		wait for 200 ns;
		
--End of J-type tests
		
	--wait forever, and ever 	
	WAIT;

end process control_test;

end testing;