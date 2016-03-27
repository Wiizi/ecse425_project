--ECSE 425 - Computer Organization and Architecture
--File: Control_Unit.vhd
--Author: Wei Wang
--Date: 2016-03-25
--Version 1.0

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity Control_Unit is
	port(
		clk 			: in std_logic;
		opCode 			: in std_logic_vector(5 downto 0);
		funct 			: in std_logic_vector(5 downto 0);

		--ID
		RegWrite 		: out std_logic;

		--EX
		ALUSrc 			: out std_logic;
		ALUOpCode 		: out std_logic_vector(3 downto 0);
		RegDest 		: out std_logic;
		Branch 			: out std_logic;
		BNE 			: out std_logic;
		Jump 			: out std_logic;
		LUI 			: out std_logic;
		ALU_LOHI_Write 		: out std_logic;
		ALU_LOHI_Read 		: out std_logic_vector(1 downto 0);

		--MEM
		MemWrite 		: out std_logic;
		MemRead 		: out std_logic;

		--WB
		MemtoReg 		: out std_logic
		);
end Control_Unit;

architecture Behavioural of Control_Unit is

signal temp_RegWrite, temp_ALUSrc, temp_RegDest 		: std_logic;
signal temp_Branch, temp_BNE, temp_Jump, temp_LUI		: std_logic;
signal temp_MemWrite, temp_MemRead, temp_MemtoReg 		: std_logic;
-- 0 for inactive, 1 for active write
signal temp_ALU_LOHI_Write 								: std_logic := '0';
-- 00 for result, 01 for low, 10 for high
signal temp_ALU_LOHI_Read 								: std_logic_vector(1 downto 0) := "00";
signal temp_ALUOpCode 									: std_logic_vector(3 downto 0);

begin

RegWrite 		<= temp_RegWrite;
ALUSrc 			<= temp_ALUSrc;
ALUOpCode 		<= temp_ALUOpCode;
RegDest 		<= temp_RegDest;
Branch 			<= temp_Branch;
BNE 			<= temp_BNE;
Jump 			<= temp_Jump;
LUI 			<= temp_LUI;
ALU_LOHI_Write 	<= temp_ALU_LOHI_Write;
ALU_LOHI_Read 	<= temp_ALU_LOHI_Read;
MemWrite 		<= temp_MemWrite;
MemRead 		<= temp_MemRead;
MemtoReg 		<= temp_MemtoReg;

	process(clk, opCode, funct)
	begin
	if (clk'event and clk = '1') then
		case opCode is
			--R-type
			when "000000" =>
				temp_RegWrite 	<= '1';
				temp_RegDest 	<= '1';
				temp_MemtoReg 	<= '0';

				case funct is
					--mult
					when "011000" =>
						temp_ALUOpCode		<= "0011";
						temp_ALU_LOHI_Write <= '1';
					--mflo
					when "010010" =>
						temp_ALUOpCode 		<= "0010";
						temp_ALU_LOHI_Read 	<= "01";
					--jr
					when "001000" =>
						temp_ALUOpCode 		<= "0010";
					--mfhi
					when "010000" =>
						temp_ALUOpCode 		<= "0010";
						temp_ALU_LOHI_Read 	<= "10";
					--add
					when "100000" =>
						temp_ALUOpCode 		<= "0010";
					--sub
					when "100010" =>
						temp_ALUOpCode 		<= "0110";
					--and
					when "100100" =>
						temp_ALUOpCode 		<= "0000";
					--div
					when "011010" =>
						temp_ALUOpCode 		<= "0100";
						temp_ALU_LOHI_Write <= '1';
					--slt
					when "101010" =>
						temp_ALUOpCode 		<= "0111";
					--or
					when "100101" =>
						temp_ALUOpCode 		<= "0001";
					--nor
					when "100111" =>
						temp_ALUOpCode 		<= "1100";
					--xor
					when "101000" =>
						temp_ALUOpCode 		<= "1101";
					--sra
					when "000011" =>
						temp_ALUOpCode 		<= "1010";
					--srl
					when "000010" =>
						temp_ALUOpCode 		<= "1010";
					--sll
					when "000000" =>
						temp_ALUOpCode 		<= "1000";
					when others => null;
				end case;
			--I-Type
			--addi
			when "001000" =>
				temp_RegWrite 	<= '1';
				temp_ALUSrc		<= '1';
				temp_ALUOpCode 	<= "0010";
				temp_RegDest 	<= '0';
				temp_MemtoReg 	<= '0';
			--slti
			when "001010" =>
				temp_RegWrite 	<= '1';
				temp_ALUSrc 	<= '1';
				temp_ALUOpCode 	<= "0111";
				temp_RegDest 	<= '0';
				temp_MemtoReg 	<= '0';
			--bne
			when "000101" =>
				temp_ALUOpCode 	<= "0110";
				temp_Branch 	<= '1';
				temp_BNE 		<= '1';
			--sw
			when "101011" =>
				temp_ALUSrc 	<= '1';
				temp_ALUOpCode 	<= "0010";
				temp_MemWrite 	<= '1';
			--beq
			when "000100" =>
				temp_ALUOpCode 	<= "0110";
				temp_Branch 	<= '1';
			--lw
			when "100011" =>
				temp_RegWrite 	<= '1';
				temp_ALUSrc 	<= '1';
				temp_ALUOpCode 	<= "0010";
				temp_RegDest 	<= '0';
				temp_MemRead 	<= '1';
				temp_MemtoReg 	<= '1';
			--lb
			when "100000" =>
				temp_RegWrite 	<= '1';
				temp_ALUSrc 	<= '1';
				temp_ALUOpCode 	<= "0010";
				temp_RegDest 	<= '0';
				temp_MemRead 	<= '1';
				temp_MemtoReg 	<= '1';
			--sb
			when "101000" =>
				temp_ALUSrc 	<= '1';
				temp_ALUOpCode 	<= "0010";
				temp_MemWrite 	<= '1';
			--lui
			when "001111" =>
				temp_RegWrite 	<= '1';
				temp_ALUSrc 	<= '1';
				temp_ALUOpCode 	<= "0010";
				temp_RegDest 	<= '0';
				temp_LUI 		<= '1';
				temp_MemtoReg 	<= '0';
			--andi
			when "001100" =>
				temp_RegWrite 	<= '1';
				temp_ALUSrc 	<= '1';
				temp_ALUOpCode 	<= "0000";
				temp_RegDest 	<= '0';
				temp_MemtoReg 	<= '0';
			--ori
			when "001101" =>
				temp_RegWrite 	<= '1';
				temp_ALUSrc 	<= '1';
				temp_ALUOpCode 	<= "0001";
				temp_RegDest 	<= '0';
				temp_MemtoReg 	<= '0';
			--xori
			when "001110" =>
				temp_RegWrite 	<= '1';
				temp_ALUSrc 	<= '1';
				temp_ALUOpCode 	<= "1101";
				temp_RegDest 	<= '0';
				temp_MemtoReg 	<= '0';
			--J-Type
			--jal
			when "000011" =>
				temp_ALUOpCode 	<= "0010";
				temp_Jump 		<= '1';
			--j
			when "000010" =>
				temp_ALUOpCode 	<= "0010";
				temp_Jump 		<= '1';
			--asrt
			when "010100" =>
				temp_ALUOpCode 	<= "0110";
			--asrti
			when "010101" =>
				temp_ALUOpCode 	<= "0110";
			--halt
			when "010110" =>
				temp_ALUOpCode 	<= "ZZZZ";
			when others => null;
		end case;
	end if;
	end process;
end Behavioural;
