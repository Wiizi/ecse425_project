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
		clk 			: in std_logic;
		--control
		RegWrite 		: in std_logic;
		ALU_LOHI_Write 	: in std_logic;

		--Register file inputs
		readReg_0 		: in std_logic_vector(4 downto 0);
		readReg_1 		: in std_logic_vector(4 downto 0);
		writeReg  		:  in std_logic_vector(4 downto 0);
		writeData 		: in std_logic_vector(31 downto 0);
		ALU_LO_in 		: in std_logic_vector(31 downto 0);
		ALU_HI_in 		: in std_logic_vector(31 downto 0);

		--Register file outputs
		readData_0 		: out std_logic_vector(31 downto 0);
		readData_1 		: out std_logic_vector(31 downto 0);
		ALU_LO_out 		: out std_logic_vector(31 downto 0);
		ALU_HI_out 		: out std_logic_vector(31 downto 0);

		-- these signals are for inspection only (testing purposes)
		r0 				: out std_logic_vector(31 downto 0);
		r1 				: out std_logic_vector(31 downto 0);
		r2 				: out std_logic_vector(31 downto 0);
		r3 				: out std_logic_vector(31 downto 0);
		r4 				: out std_logic_vector(31 downto 0);
		r5 				: out std_logic_vector(31 downto 0);
		r6 				: out std_logic_vector(31 downto 0);
		r7 				: out std_logic_vector(31 downto 0);
		r8 				: out std_logic_vector(31 downto 0);
		r9 				: out std_logic_vector(31 downto 0);
		r10 			: out std_logic_vector(31 downto 0);
		r11 			: out std_logic_vector(31 downto 0);
		r12 			: out std_logic_vector(31 downto 0);
		r13 			: out std_logic_vector(31 downto 0);
		r14 			: out std_logic_vector(31 downto 0);
		r15 			: out std_logic_vector(31 downto 0);
		r16 			: out std_logic_vector(31 downto 0);
		r17 			: out std_logic_vector(31 downto 0);
		r18 			: out std_logic_vector(31 downto 0);
		r19 			: out std_logic_vector(31 downto 0);
		r20 			: out std_logic_vector(31 downto 0);
		r21 			: out std_logic_vector(31 downto 0);
		r22 			: out std_logic_vector(31 downto 0);
		r23 			: out std_logic_vector(31 downto 0);
		r24 			: out std_logic_vector(31 downto 0);
		r25 			: out std_logic_vector(31 downto 0);
		r26 			: out std_logic_vector(31 downto 0);
		r27 			: out std_logic_vector(31 downto 0);
		r28 			: out std_logic_vector(31 downto 0);
		r29 			: out std_logic_vector(31 downto 0);
		r30 			: out std_logic_vector(31 downto 0);
		r31 			: out std_logic_vector(31 downto 0);
		rLo 			: out std_logic_vector(31 downto 0);
		rHi 			: out std_logic_vector(31 downto 0)
		);
end Registers;

architecture Behavioural of Registers is

type reg_mem is array (0 to 33) of std_logic_vector(31 downto 0);
signal regArray : reg_mem := (others => (others => '0'));

signal temp_readData_0, temp_readData_1, temp_ALU_LO_out, temp_ALU_HI_out : std_logic_vector(31 downto 0);

begin

	-- for inspection only (testing purposes)
	r0 		<= regArray(0 );
	r1 		<= regArray(1 );
	r2 		<= regArray(2 );
	r3 		<= regArray(3 );
	r4 		<= regArray(4 );
	r5 		<= regArray(5 );
	r6 		<= regArray(6 );
	r7 		<= regArray(7 );
	r8 		<= regArray(8 );
	r9 		<= regArray(9 );
	r10 	<= regArray(10);
	r11 	<= regArray(11);
	r12 	<= regArray(12);
	r13 	<= regArray(13);
	r14 	<= regArray(14);
	r15 	<= regArray(15);
	r16 	<= regArray(16);
	r17 	<= regArray(17);
	r18 	<= regArray(18);
	r19 	<= regArray(19);
	r20 	<= regArray(20);
	r21 	<= regArray(21);
	r22 	<= regArray(22);
	r23 	<= regArray(23);
	r24 	<= regArray(24);
	r25 	<= regArray(25);
	r26 	<= regArray(26);
	r27 	<= regArray(27);
	r28 	<= regArray(28);
	r29 	<= regArray(29);
	r30 	<= regArray(30);
	r31 	<= regArray(31);
	rLo 	<= regArray(32);
	rHi 	<= regArray(33);

	readData_0 <= regArray(TO_INTEGER(UNSIGNED(readReg_0)));
	readData_1 <= regArray(TO_INTEGER(UNSIGNED(readReg_1)));
	ALU_LO_out <= regArray(32);
	ALU_HI_out <= regArray(33);

	process(RegWrite, ALU_LOHI_Write, readReg_0, readReg_1, writeReg, writeData, ALU_LO_in, ALU_HI_in )
	begin
		--check whether write signal is active
		if (RegWrite = '1') then
			--write the data
			regArray(TO_INTEGER(UNSIGNED(writeReg))) <= writeData;
		end if;
		if (ALU_LOHI_Write = '1') then
			regArray(32) <= ALU_LO_in;
			regArray(33) <= ALU_HI_in;
		end if;
		--register 0 is hardwired to 0
		regArray(0) <= (others => '0');
	end process;

end Behavioural;
