-- ECSE 425 - Comp Organization & Architecture - Final Project
-- Group 5: Andrei Chubarau, Luis Gallet Zambrano, Aidan Petit, Wei Wang
--
-- ID_EX.vhd
-- Instruction Decode/Execution interstage buffer: forwards inputs to output on rising clock edge

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

--Entity declaration
ENTITY ID_EX IS
	PORT (
		clk					: in std_logic;

		--Data inputs
		Addr_in				: in std_logic_vector(31 downto 0);
		RegData0_in			: in std_logic_vector(31 downto 0);
		RegData1_in			: in std_logic_vector(31 downto 0);
		SignExtended_in		: in std_logic_vector(31 downto 0);

		--Register inputs (5 bits each)
		Rs_in				: in std_logic_vector(4 downto 0);
		Rt_in				: in std_logic_vector(4 downto 0);
		Rd_in				: in std_logic_vector(4 downto 0);

		--Control inputs (8 of them?)
		RegWrite_in			: in std_logic;
		MemToReg_in			: in std_logic;
		MemWrite_in			: in std_logic;
		MemRead_in			: in std_logic;
		Branch_in			: in std_logic;
		LUI_in				: in std_logic;
		ALU_op_in			: in std_logic_vector(3 downto 0);
		ALU_src_in			: in std_logic;
		Reg_dest_in			: in std_logic;
		BNE_in         	    : in std_logic;
		Asrt_in           	: in std_logic;
    	Jal_in            	: in std_logic;


		--Data Outputs
		Addr_out			: out std_logic_vector(31 downto 0);
		RegData0_out		: out std_logic_vector(31 downto 0);
		RegData1_out		: out std_logic_vector(31 downto 0);
		SignExtended_out	: out std_logic_vector(31 downto 0);

		--Register outputs
		Rs_out				: out std_logic_vector(4 downto 0);
		Rt_out				: out std_logic_vector(4 downto 0);
		Rd_out				: out std_logic_vector(4 downto 0);

		--Control outputs
		RegWrite_out		: out std_logic;
		MemToReg_out		: out std_logic;
		MemWrite_out		: out std_logic;
		MemRead_out			: out std_logic;
		Branch_out			: out std_logic;
		LUI_out				: out std_logic;
		ALU_op_out			: out std_logic_vector(3 downto 0);
		ALU_src_out			: out std_logic;
		Reg_dest_out		: out std_logic;
		BNE_out             : out std_logic;
		Asrt_out           	: out std_logic;
    	Jal_out            	: out std_logic
	);
END ID_EX;

--Architecture Declaration
ARCHITECTURE id_ex OF ID_EX IS

--Temporary signal assignments 
--data
signal temp_Addr			: std_logic_vector(31 downto 0);
signal temp_RegData0		: std_logic_vector(31 downto 0);
signal temp_RegData1		: std_logic_vector(31 downto 0);
signal temp_SignExtended	: std_logic_vector(31 downto 0);

--registers		
signal temp_Rs				: std_logic_vector(4 downto 0);
signal temp_Rt				: std_logic_vector(4 downto 0);
signal temp_Rd				: std_logic_vector(4 downto 0);

--control
signal temp_RegWrite		: std_logic;
signal temp_MemToReg		: std_logic;
signal temp_MemWrite		: std_logic;
signal temp_MemRead			: std_logic;
signal temp_Branch			: std_logic;
signal temp_LUI				: std_logic;
signal temp_ALU_op			: std_logic_vector(3 downto 0);
signal temp_ALU_src			: std_logic;
signal temp_Reg_dest		: std_logic;
signal temp_bne				: std_logic;
signal temp_Jal				: std_logic;
signal temp_Asrt			: std_logic;


BEGIN

--forward inputs to temp signals
	temp_Addr 				<= Addr_in;
	temp_RegData0			<= RegData0_in;
	temp_RegData1			<= RegData1_in;
	temp_SignExtended		<= SignExtended_in;
	temp_Rs					<= Rs_in;
	temp_Rt					<= Rt_in;
	temp_Rd					<= Rd_in;
	temp_RegWrite			<= RegWrite_in;
	temp_MemToReg			<= MemToReg_in;
	temp_MemWrite			<= MemWrite_in;
	temp_MemRead			<= MemRead_in;
	temp_Branch				<= Branch_in;
	temp_LUI				<= LUI_in;
	temp_ALU_op				<= ALU_op_in;
	temp_ALU_src			<= ALU_src_in;
	temp_Reg_dest			<= Reg_dest_in;
	temp_bne 				<= BNE_in;
	temp_Asrt				<= Asrt_in;
	temp_Jal 				<= Jal_in;

--Process Block
process (clk)
	begin
	--forward signals to output on rising edge
	if rising_edge(clk) then
		--data		
		Addr_out			<= temp_Addr;
		RegData0_out		<= temp_RegData0;
		RegData1_out		<= temp_RegData1;
		SignExtended_out	<= temp_SignExtended;

		--registers
		Rs_out				<= temp_Rs;
		Rt_out				<= temp_Rt;
		Rd_out				<= temp_Rd;

		--control
		RegWrite_out		<= temp_RegWrite;
		MemToReg_out		<= temp_MemToReg;
		MemWrite_out		<= temp_MemWrite;
		MemRead_out			<= temp_MemRead;
		Branch_out			<= temp_Branch;
		LUI_out				<= temp_LUI;
		ALU_op_out			<= temp_ALU_op;
		ALU_src_out			<= temp_ALU_src;
		Reg_dest_out		<= temp_Reg_dest;
		BNE_out 			<= temp_bne;
		Asrt_out			<= temp_Asrt;
		Jal_out 			<= temp_Jal;

	end if;

end process;

END id_ex;
