-- This file is a CPU skeleton
--
-- entity name: cpu

--Last edited: 25/03/2016
--TODO: Finish conecting the signals to ID_EX stage. Create ALUsrc output for HazardControl mux. This signal needs to be an output from the 
-- Control module because it is use for I-type signals. Check sandobx.vhd on github line 732. Also, ID_EX stage contains signals 
-- that are meant to be used for fowarding and early branch resolution. 
library ieee;

use ieee.std_logic_1164.all; -- allows use of the std_logic_vector type
use ieee.numeric_std.all; -- allows use of the unsigned type
use STD.textio.all;


--Basic CPU interface.
--You may add your own signals, but do not remove the ones that are already there.
ENTITY cpu IS
   
   GENERIC (
      File_Address_Read    : STRING    := "Init.dat";
      File_Address_Write   : STRING    := "MemCon.dat";
      Mem_Size_in_Word     : INTEGER   := 256;
      Read_Delay           : INTEGER   := 1; 
      Write_Delay          : INTEGER   := 1
   );
   PORT (
      clk                  : IN    STD_LOGIC;
      clk_mem              : IN    STD_LOGIC;

      reset                : IN    STD_LOGIC := '0';
      
      --Signals required by the MIKA testing suite
      finished_prog        : OUT   STD_LOGIC; --Set this to '1' when program execution is over
      assertion            : OUT   STD_LOGIC; --Set this to '1' when an assertion occurs 
      assertion_pc         : OUT   NATURAL;   --Set the assertion's program counter location
      
      mem_dump:         IN    STD_LOGIC := '0'
   );
   
END cpu;

ARCHITECTURE rtl OF cpu IS
     -- COMPONENTS 
   
   COMPONENT memory IS
   GENERIC 
   (
      File_Address_Read   : string    := "Init.dat";
      File_Address_Write  : string    := "MemCon.dat";
      Mem_Size_in_Word    : integer   := 2048;
      Num_Bytes_in_Word   : integer   := NUM_BYTES_IN_WORD;
      Num_Bits_in_Byte    : integer   := NUM_BITS_IN_BYTE;
      Read_Delay          : integer   := 0;
      Write_Delay         : integer   := 0
   );
   PORT
   (
      clk       : in STD_LOGIC;
      addr      : in NATURAL;
      wordbyte  : in STD_LOGIC               := '1';
      re        : in STD_LOGIC;
      we        : in STD_LOGIC;
      dump      : in STD_LOGIC               := '0';
      data      : inout STD_LOGIC_VECTOR(MEM_DATA_WIDTH-1 downto 0);
      busy      : out STD_LOGIC
   );
   END COMPONENT;

   COMPONENT HazardDetectionControl
      PORT (
        IDEX_RegRt     : in std_logic_vector(4 downto 0);
        IFID_RegRs     : in std_logic_vector(4 downto 0);
        IFID_RegRt     : in std_logic_vector(4 downto 0);
        IDEX_MemRead   : in std_logic;
        BRANCH         : in std_logic;
   
        IFID_Write     : out std_logic;
        PC_Update      : out std_logic;
        CPU_Stall      : out std_logic
      );
   END COMPONENT;

   COMPONENT ALU
      PORT( 
        opcode         : in std_logic_vector(3 downto 0);
        data0, data1   : in std_logic_vector(31 downto 0);
        shamt          : in std_logic_vector (4 downto 0);
        data_out       : out std_logic_vector(31 downto 0); 
        HI             : out std_logic_vector (31 downto 0);
        LO             : out std_logic_vector (31 downto 0);
        zero           : out std_logic
      );
   END COMPONENT;

   COMPONENT EX_MEM
      PORT(
        clk 		: in std_logic;

        --Control Unit
        MemWrite_in   : in STD_LOGIC;
        MemRead_in    : in STD_LOGIC;
        MemtoReg_in   : in STD_LOGIC;
        --ALU
        ALU_Result_in  : in std_logic_vector(31 downto 0);
        ALU_HI_in      : in std_logic_vector (31 downto 0);
        ALU_LO_in      : in std_logic_vector (31 downto 0);
        ALU_zero_in    : in std_logic;
        --Read Data
        Data1_in        : in std_logic_vector(31 downto 0);
        --Register
        Rd_in          : in std_logic_vector(4 downto 0);

        --Control Unit
        MemWrite_out  : out STD_LOGIC;
        MemRead_out   : out STD_LOGIC;
        MemtoReg_out  : out STD_LOGIC;

        --ALU
        ALU_Result_out : out std_logic_vector(31 downto 0);
        ALU_HI_out     : out std_logic_vector (31 downto 0);
        ALU_LO_out     : out std_logic_vector (31 downto 0);
        ALU_zero_out   : out std_logic;
        --Read Data
        Data1_out       : out std_logic_vector(31 downto 0);
        --Register
        Rd_out         : out std_logic_vector(4 downto 0)
      );
   END COMPONENT;

   COMPONENT ID_EX
      PORT(
        clk               : in std_logic;

        --Data inputs
        Addr_in           : in std_logic_vector(31 downto 0);
        RegData1_in       : in std_logic_vector(31 downto 0);
        RegData2_in       : in std_logic_vector(31 downto 0);
        SignExtended_in   : in std_logic_vector(31 downto 0);
        --Register inputs (5 bits each)
        Rs_in             : in std_logic_vector(4 downto 0);
        Rt_in             : in std_logic_vector(4 downto 0);
        Rd_in             : in std_logic_vector(4 downto 0);
         --Control inputs (8 of them?)
        RegWrite_in       : in std_logic;
        MemToReg_in       : in std_logic;
        MemWrite_in       : in std_logic;
        MemRead_in        : in std_logic;
        Branch_in         : in std_logic;
        ALU_op_in         : in std_logic_vector(2 downto 0);
        ALU_src_in        : in std_logic;
        Reg_dest_in       : in std_logic;

        --Data Outputs
        Addr_out          : out std_logic_vector(31 downto 0);
        RegData1_out      : out std_logic_vector(31 downto 0);
        RegData2_out      : out std_logic_vector(31 downto 0);
        SignExtended_out  : out std_logic_vector(31 downto 0);
        --Register outputs
        Rs_out            : out std_logic_vector(4 downto 0);
        Rt_out            : out std_logic_vector(4 downto 0);
        Rd_out            : out std_logic_vector(4 downto 0);
        --Control outputs
        RegWrite_out      : out std_logic;
        MemToReg_out      : out std_logic;
        MemWrite_out      : out std_logic;
        MemRead_out       : out std_logic;
        Branch_out        : out std_logic;  
        ALU_op_out        : out std_logic_vector(2 downto 0);
        ALU_src_out       : out std_logic;
        Reg_dest_out      : out std_logic
      );
   END COMPONENT;

   COMPONENT IF_ID
      PORT(
        clk         : in std_logic;
        inst_in     : in std_logic_vector(31 downto 0);
        addr_in     : in std_logic_vector(31 downto 0);
        IF_ID_write : in std_logic :='1'; --For hazard dectection. Always 1 unless hazard detecttion    unit changes it.
        inst_out    : out std_logic_vector(31 downto 0);
        addr_out    : out std_logic_vector(31 downto 0)
      );
   END COMPONENT;

   COMPONENT MEM_WB
      port(
        clk            : in std_logic;

        --Control Unit
        MemtoReg_in   : in std_logic;
        --Data Memory
        busy_in        : in std_logic;
        Data_in        : in std_logic_vector(31 downto 0);
        --ALU
        ALU_Result_in  : in std_logic_vector(31 downto 0);
        ALU_HI_in      : in std_logic_vector (31 downto 0);
        ALU_LO_in      : in std_logic_vector (31 downto 0);
        ALU_zero_in    : in std_logic;
        --Register
        Rd_in          : in std_logic;

        --Control Unit
        MemtoReg_out  : out std_logic;
        --Data Memory
        busy_out       : out std_logic;
        Data_out       : out std_logic_vector(31 downto 0);
        --ALU
        ALU_Result_out : out std_logic_vector(31 downto 0);
        ALU_HI_out     : out std_logic_vector (31 downto 0);
        ALU_LO_out     : out std_logic_vector (31 downto 0);
        ALU_zero_out   : out std_logic;
         --Register
        Rd_out         : out std_logic
      );
   END COMPONENT;

   COMPONENT Mux_2to1
      Port(
        --select line
        sel      : in std_logic;

        --data inputs
        in1      : in std_logic_vector(31 downto 0);
        in2      : in std_logic_vector(31 downto 0);

        --output
        dataOout : out std_logic_vector(31 downto 0)
      );
   END COMPONENT;

   COMPONENT Mux_3to1
      Port (
        --select line
        sel      : in std_logic_vector(1 downto 0);

        --data inputs
        in1      : in std_logic_vector(31 downto 0);
        in2      : in std_logic_vector(31 downto 0);
        in3      : in std_logic_vector(31 downto 0);

        --output
        dataOout : out std_logic_vector(31 downto 0)
      );
   END COMPONENT;

   COMPONENT PC
      PORT(
        clk         : in std_logic;
        addr_in     : in std_logic_vector(31 downto 0);
        PC_write    : in std_logic := '1'; --For hazard dectection, always 1 unless hazard detection    unit changes it
        addr_out    : out std_logic_vector(31 downto 0)
      );
   END COMPONENT;

   COMPONENT Registers
      PORT(
        clk            : in std_logic;
	      --control
	      regWrite       : in std_logic;
	      ALU_LOHI_Write : in std_logic;
        --Register file inputs
	      readReg_1      : in std_logic_vector(4 downto 0);
	      readReg_2      : in std_logic_vector(4 downto 0);
	      writeReg       :  in std_logic_vector(4 downto 0);
	      writeData      : in std_logic_vector(31 downto 0);
	      ALU_LO_in      : in std_logic_vector(31 downto 0);
	      ALU_HI_in      : in std_logic_vector(31 downto 0);

        --Register file outputs
	      readData_1     : out std_logic_vector(31 downto 0);
	      readData_2     : out std_logic_vector(31 downto 0);
	      ALU_LO_out     : out std_logic_vector(31 downto 0);
	      ALU_HI_out     : out std_logic_vector(31 downto 0)
      );
   END COMPONENT;

  COMPONENT Control_Unit is
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


----------Memory module default signals----------------
SIGNAL InstMem_address	  : integer   := 0;
SIGNAL InstMem_re 		    : std_logic := '0';
SIGNAL InstMem_init 		  : std_logic	:= '0';
SIGNAL InstMem_dump 		  : std_logic	:= '0';

SIGNAL DataMem_addr       : integer    := 0;
SIGNAL DataMem_re         : std_logic  := '1';
SIGNAL DataMem_we         : std_logic  := '0';
SIGNAL DataMem_dump       : std_logic  := '0';
SIGNAL DataMem_data       : std_logic  := '0';
 
SIGNAL InstMem_busy       : std_logic  := '0';
SIGNAL DataMem_busy       : std_logic  := '0';
-------------------------------------------------------

signal PC_addr_out : std_logic_vector(31 downto 0);

signal Imem_inst_in, Imem_addr_in : std_logic_vector(31 downto 0);
  
signal IFID_inst_out, IFID_addr_out : std_logic_vector(31 downto 0); 
signal haz_IF_ID_write, haz_PC_write : std_logic;

signal regWrite: std_logic;
signal ALUOpcode: std_logic_vector(3 downto 0);
signal RegDest, Branch, BNE, Jump, LUI, ALU_LOHI_Write : std_logic;
signal ALU_LOHI_Read: std_logic_vector(1 downto 0);
signal MemWrite, MemRead, MemtoReg: std_logic;

--signals from last pipeline stage
signal temp_MEM/WB_RD : std_logic_vector (4 downto 0);
signal temp_WB_data : std_logic_vector(31 downto 0);

signal ALU_LO, ALU_HI : std_logic_vector(31 downto 0) :=(others => '0');
signal data0, data1 : std_logic_vector(31 downto 0);
signal ALU_LO_out, ALU_HI_out : std_logic_vector(31 downto 0);

signal IDEX_RegRt : std_logic_vector(4 downto 0);
signal IDEX_MemRead : std_logic

--hazard detection signal
signal CPU_stall : std_logic;

--for EX_MEM stage to MEM_WB stage
signal ID_EX_MemWrite, EX_MEM_MemWrite : std_logic;
signal ID_EX_MemRead, EX_MEM_MemRead : std_logic;
signal ID_EX_MemtoReg, EX_MEM_MemtoReg, MEM_WB_MemtoReg : std_logic;
signal EX_MEM_ALU_result, EX_MEM_ALU_HI, EX_MEM_ALU_LO, EX_MEM_ALU_zero : std_logic;
signal MEM_WB_ALU_result, MEM_WB_ALU_HI, MEM_WB_ALU_LO, MEM_WB_ALU_zero : std_logic;
signal ID_EX_Rd, EX_MEM_Rd, MEM_WB_Rd : std_logic_vector(4 downto 0);
signal ID_EX_Data1, EX_MEM_Data1 : std_logic_vector(31 downto 0);
signal MEM_WB_data, WB_data : std_logic_vector(31 downto 0);

BEGIN

Program_counter: PC
	PORT MAP( 
         	clk         => clk,
         	addr_in     => Imem_addr_in,
         	PC_write    => haz_PC_write,-- from hazard detection
         	addr_out    => PC_addr_out
      );

InstMem_address <= to_integer(unsigned(PC_addr_out));

--Instantiation of the main memory component
Instruction_Memory : memory
GENERIC MAP
(
    File_Address_Read   => "Init.dat";
    File_Address_Write  => "InstDump.dat";
    Mem_Size_in_Word    => 2048;
    Num_Bytes_in_Word   => 4;
    Num_Bits_in_Byte    => 8;
    Read_Delay          => 0;
    Write_Delay         => 0
);
PORT MAP
(
    clk           => clk_mem,
    addr          => InstMem_address,
    wordbyte      => '1',
    re            => InstMem_re,
    we            => '0', -- instMem never writes
    dump          => InstMem_dump,
    data          => InstMem_data,
    busy          => InstMem_busy
);

Data_Memory : memory
GENERIC MAP
(
    File_Address_Read   => "InitData.dat";
    File_Address_Write  => "DataDump.dat";
    Mem_Size_in_Word    => 2048;
    Num_Bytes_in_Word   => 4;
    Num_Bits_in_Byte    => 8;
    Read_Delay          => 0;
    Write_Delay         => 0
);
PORT MAP
(
    clk           => clk_mem,
    addr          => DataMem_address,
    wordbyte      => '1',
    re            => DataMem_re,
    we            => DataMem_we,
    dump          => DataMem_dump,
    data          => DataMem_data,
    busy          => DataMem_busy
);

IF_ID_stage: IF_ID
	PORT MAP(
		clk 		      => clk,
    inst_in 	    => Imem_inst_in,
    addr_in 	    => PC_addr_out,
    IF_ID_write 	=> haz_IF_ID_write,
    inst_out 	    => IFID_inst_out,
    addr_out 	    => IFID_addr_out
		);

Control: Control_Unit
	PORT MAP(
		clk 		  => clk;
		opCode 		=> IFID_inst_out(31 downto 26);
		funct 		=> IFID_inst_out(5 downto 0);

		--ID (Registers)
		RegWrite	=> regWrite;

		--EX
		--ALUSrc =>
		ALUOpCode       => ALUOpcode, --goes to alu
		RegDest 	      => RegDest, --todo
		Branch 		      => Branch, --if theres a branch, signal
		BNE 		        => BNE,--signal
		Jump            => Jump,--signal
		LUI 		        => LUI, --signal
		ALU_LOHI_Write 	=> ALU_LOHI_Write, --input for register
		ALU_LOHI_Read 	=> ALU_LOHI_Read, --mux somewhere, signal
		--MEM (data mem)
		MemWrite 	      => MemWrite, --signal
		MemRead 	      => MemRead,--signal
		--WB
		MemtoReg      	=> MemtoReg --signal, for mux
		);

Register_bank: Registers 
	PORT MAP(
		clk 		=> clk,

    regWrite 	=> regWrite,
    ALU_LOHI_Write	=> ALU_LOHI_Write, --control

    readReg_1 	=> IFID_inst_out(25 downto 21),--rs 
    readReg_2 	=> IFID_inst_out(20 downto 16),--rt
    writeReg 	  => temp_MEM/WB_RD, --mem/wb rd
    writeData 	=> WB_data,--wb(mux) rd

	 	ALU_LO_in 	=> ALU_LO, --from alu
	 	ALU_HI_in 	=> ALU_HI, --from alu

    readData_1 	=> data0, --data0 for alu
    readData_2 	=> data1, --data1 for alu

	 	ALU_LO_out 	=> ALU_LO_out, --simple signal
	 	ALU_HI_out 	=> ALU_HI_out --simple signal
		);
----------------------------------
--add mux for mflo and mfhi logic
----------------------------------

HazardDetectionControl: HazardDetectionControl
	PORT MAP (
    IDEX_RegRt     	=> IDEX_RegRt,
    IFID_RegRs     	=> IFID_inst_out(25 downto 21),
    IFID_RegRt     	=> IFID_inst_out(20 downto 16),
    IDEX_MemRead   	=> IDEX_MemRead, --create
    BRANCH         	=> Branch,

    IFID_Write     	=> haz_IFID_write,
    PC_Update      	=> haz_PC_write,
    CPU_Stall      	=> CPU_stall
	);

Hazard_Control: Mux_2to1
	GENERIC MAP(WIDTH_IN <= 10)
	PORT MAP(
		sel => stall,
		in1 => (RegWrite & MemtoReg & Branch & MemRead & MemWrite & ALUOpcode & RegDest & AluSrc),
		in2 => (others => '0'),
		dataOut => haz_output
		);

ID_EX_stage: ID_EX
	PORT MAP(
    clk               => clk,

    --Data inputs
    Addr_in           => IDID_addr_out,
    RegData1_in       => t_RegData1_in, --
    RegData2_in       => t_RegData2_in,
    SignExtended_in   => t_SignExtended_in,
   
    --Register inputs (5 bits each)
    Rs_in             => t_Rs_in,
    Rt_in             => t_Rt_in,
    Rd_in             => t_Rd_in,
   
    --Control inputs (8 of them?)
    RegWrite_in       => t_RegWrite_in,
    MemToReg_in       => t_MemToReg_in,
    MemWrite_in       => t_MemWrite_in,
    MemRead_in        => t_MemRead_in
    Branch_in         => t_Branch_in,
    ALU_op_in         => t_ALU_op_in,
    ALU_src_in        => t_ALU_src_in,
    Reg_dest_in       => t_Reg_dest_in,
   
    --Data Outputs
    Addr_out          => t_Addr_out,
    RegData1_out      => t_RegData1_out,
    RegData2_out      => t_RegData2_out,
    SignExtended_out  => t_SignExtended_out,
    --Register outputs
    Rs_out            => t_Rs_out,
    Rt_out            => t_Rt_out,
    Rd_out            => t_Rd_out,
    --Control outputs
    RegWrite_out      => t_RegWrite_out,
    MemToReg_out      => t_MemToReg_out,
    MemWrite_out      => t_MemWrite_out,
    MemRead_out       => t_MemRead_out,
    Branch_out        => t_Branch_out,
    ALU_op_out        => t_ALU_op_out,
    ALU_src_out       => t_ALU_src_out,
    Reg_dest_out      => t_Reg_dest_out
	);
   
ALU: ALU
	PORT MAP( 
    opcode      => t_opcode, --from control
    data0			  => t_data0, --from reg
	  data1   	  => t_data1, --from reg
    shamt       => t_shamt, --from insttruction
    data_out    => t_data_out, --signal
    HI          => t_HI, --signal
    LO          => t_LO, --signal
    zero        => t_zero --signal
	);


-----------------------------------------------------------
----   LINK BETWEEN ID_EX stage and EX_MEM stage MISSING
-----------------------------------------------------------
EX_MEM_stage: EX_MEM
  PORT MAP(
    clk            => clk,

    --Control Unit
    MemWrite_in    => ID_EX_MemWrite,
    MemRead_in     => ID_EX_MemRead,
    MemtoReg_in    => ID_EX_MemtoReg,

    --ALU
    ALU_Result_in  => t_data_out,-- from ALU t_data_out
    ALU_HI_in      => ALU_HI,
    ALU_LO_in      => ALU_LO,
    ALU_zero_in    => ALU_zero,

    --Read Data
    Data1_in       => ID_EX_Data1,

    --Register
    Rd_in          => ID_EX_Rd,

    --Control Unit
    MemWrite_out   =>EX_MEM_MemWrite,
    MemRead_out    => EX_MEM_MemRead,
    MemtoReg_out   => EX_MEM_MemtoReg,

    --ALU
    ALU_Result_out => EX_MEM_ALU_result,--from ALU t_data_out
    ALU_HI_out     => EX_MEM_ALU_HI,
    ALU_LO_out     => EX_MEM_ALU_LO,
    ALU_zero_out   => EX_MEM_ALU_zero,

    --Read Data
    Data1_out      => EX_MEM_Data1,
    --Register
    Rd_out         => EX_MEM_Rd
  );

  --Link to Data Memory
  ---------------------------------------
  -- Need to be fix
  ---------------------------------------
  if (EX_MEM_MemWrite = '1') then
    DataMem_data <= EX_MEM_Data1;
  end if;


MEM_WB_stage: MEM_WB
  PORT MAP(
    clk            => clk,
    --Control Unit
    MemtoReg_in    => EX_MEM_MemtoReg,
    --Data Memory
    busy_in        => DataMem_busy,
    Data_in        => DataMem_data,
    --ALU
    ALU_Result_in  => EX_MEM_ALU_result,
    ALU_HI_in      => EX_MEM_ALU_HI,
    ALU_LO_in      => EX_MEM_ALU_LO,
    ALU_zero_in    => EX_MEM_ALU_zero,
    --Register
    Rd_in          => EX_MEM_Rd,
    --Control Unit
    MemtoReg_in    => MEM_WB_MemtoReg,
    --Data Memory
    busy_out       => MEM_WB_busy,
    Data_out       => MEM_WB_data,
    --ALU
    ALU_Result_out => MEM_WB_ALU_result,
    ALU_HI_out     => MEM_WB_ALU_HI,
    ALU_LO_out     => MEM_WB_ALU_LO,
    ALU_zero_out   => MEM_WB_ALU_zero,
    --Register
    Rd_out         => MEM_WB_Rd
  );

Mem_to_Reg_Mux : Mux_2to1
  PORT MAP(
    sel      => MEM_WB_MemtoReg,
    in1      => MEM_WB_ALU_result,
    in2      => MEM_WB_data,
    dataOout => WB_data,
  );

END rtl;