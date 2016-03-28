-- This file is a CPU testbench for PC and memory components
--
-- entity name: cpu_test

--Last edited: 25/03/2016
--TODO: Finish conecting the signals to ID_EX stage. Create ALUsrc output for HazardControl mux. This signal needs to be an output from the
-- Control module because it is use for I-type signals. Check sandobx.vhd on github line 732. Also, ID_EX stage contains signals
-- that are meant to be used for fowarding and early branch resolution.

--2016-03-27
--TODO: JUMP ADDRESS, BRANCH ADDRESS

library ieee;

use ieee.std_logic_1164.all; -- allows use of the std_logic_vector type
use ieee.numeric_std.all; -- allows use of the unsigned type
use STD.textio.all;

use work.memory_arbiter_lib.all;

--Basic CPU interface.
--You may add your own signals, but do not remove the ones that are already there.
ENTITY cpu_test IS
   
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
   
END cpu_test;

ARCHITECTURE rtl OF cpu_test IS
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
    clk         : in STD_LOGIC;
    addr        : in NATURAL;
    wordbyte    : in STD_LOGIC;
    re          : in STD_LOGIC;
    we          : in STD_LOGIC;
    dump        : in STD_LOGIC;
    dataIn      : in STD_LOGIC_VECTOR(MEM_DATA_WIDTH-1 downto 0);
    dataOut     : out STD_LOGIC_VECTOR(MEM_DATA_WIDTH-1 downto 0);
    busy        : out STD_LOGIC
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
        clk 		       : in std_logic;

        --Control Unit
        MemWrite_in    : in STD_LOGIC;
        MemRead_in     : in STD_LOGIC;
        MemtoReg_in    : in STD_LOGIC;
        RegWrite_in    : in std_logic;
        --ALU
        ALU_Result_in  : in std_logic_vector(31 downto 0);
        ALU_HI_in      : in std_logic_vector (31 downto 0);
        ALU_LO_in      : in std_logic_vector (31 downto 0);
        ALU_zero_in    : in std_logic;
        --Read Data
        Data1_in       : in std_logic_vector(31 downto 0);
        --Register
        Rd_in          : in std_logic_vector(4 downto 0);

        --Control Unit
        MemWrite_out   : out STD_LOGIC;
        MemRead_out    : out STD_LOGIC;
        MemtoReg_out   : out STD_LOGIC;
        RegWrite_out   : out std_logic;
        --ALU
        ALU_Result_out : out std_logic_vector(31 downto 0);
        ALU_HI_out     : out std_logic_vector (31 downto 0);
        ALU_LO_out     : out std_logic_vector (31 downto 0);
        ALU_zero_out   : out std_logic;
        --Read Data
        Data1_out      : out std_logic_vector(31 downto 0);
        --Register
        Rd_out         : out std_logic_vector(4 downto 0)
      );
   END COMPONENT;

   COMPONENT ID_EX
      PORT(
        clk               : in std_logic;

        --Data inputs
        Addr_in           : in std_logic_vector(31 downto 0);
        RegData0_in       : in std_logic_vector(31 downto 0);
        RegData1_in       : in std_logic_vector(31 downto 0);
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
	      LUI_in		        : in std_logic;
        ALU_op_in         : in std_logic_vector(2 downto 0);
        ALU_src_in        : in std_logic;
        Reg_dest_in       : in std_logic;

        --Data Outputs
        Addr_out          : out std_logic_vector(31 downto 0);
        RegData0_out      : out std_logic_vector(31 downto 0);
        RegData1_out      : out std_logic_vector(31 downto 0);
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
	      LUI_out		        : out std_logic;
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
        MemtoReg_in    : in std_logic;
        RegWrite_in    : in std_logic;
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
        MemtoReg_out   : out std_logic;
        RegWrite_out   : out std_logic;
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

COMPONENT Haz_mux is

PORT( 
	sel : in std_logic;

	in1 : in std_logic;
	in2 : in std_logic;
	in3 : in std_logic;
	in4 : in std_logic;
	in5 : in std_logic;
	in6 : in std_logic;
	in7 : in std_logic;
	in8 : in std_logic_vector(3 downto 0);

	out1 : out std_logic;
	out2 : out std_logic;
	out3 : out std_logic;
	out4 : out std_logic;
	out5 : out std_logic;
	out6 : out std_logic;
	out7 : out std_logic;
	out8 : out std_logic_vector(3 downto 0)
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
	      RegWrite       : in std_logic;
	      ALU_LOHI_Write : in std_logic;
        --Register file inputs
	      readReg_0      : in std_logic_vector(4 downto 0);
	      readReg_1      : in std_logic_vector(4 downto 0);
	      writeReg       :  in std_logic_vector(4 downto 0);
	      writeData      : in std_logic_vector(31 downto 0);
	      ALU_LO_in      : in std_logic_vector(31 downto 0);
	      ALU_HI_in      : in std_logic_vector(31 downto 0);

        --Register file outputs
	      readData_0     : out std_logic_vector(31 downto 0);
	      readData_1     : out std_logic_vector(31 downto 0);
	      ALU_LO_out     : out std_logic_vector(31 downto 0);
	      ALU_HI_out     : out std_logic_vector(31 downto 0)
      );
   END COMPONENT;

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

COMPONENT Forwarding IS
	PORT(
		EX_MEM_RegWrite : in std_logic;
		MEM_WB_RegWrite	: in std_logic;
		ID_EX_Rs		: in std_logic_vector(4 downto 0);
		ID_EX_Rt		: in std_logic_vector(4 downto 0);
		EX_MEM_Rd		: in std_logic_vector(4 downto 0);
		MEM_WB_Rd		: in std_logic_vector(4 downto 0);

		Forward0_EX 	: out std_logic_vector(1 downto 0) := "00";
		Forward1_EX		: out std_logic_vector(1 downto 0) := "00"
		);
END COMPONENT;


----------Memory module default signals----------------
SIGNAL InstMem_address	  : integer   := 0;
SIGNAL InstMem_re 		    : std_logic := '0';
SIGNAL InstMem_init 		  : std_logic	:= '0';

SIGNAL DataMem_addr       : integer    := 0;
SIGNAL DataMem_re         : std_logic  := '1';
SIGNAL DataMem_we         : std_logic  := '0';
SIGNAL DataMem_data       : std_logic_vector (31 downto 0)  := (others => 'Z');
 
SIGNAL InstMem_busy       : std_logic  := '0';
SIGNAL DataMem_busy       : std_logic  := '0';
-------------------------------------------------------

signal PC_addr_out : std_logic_vector(31 downto 0);

signal Imem_inst_in, Imem_addr_in : std_logic_vector(31 downto 0) := (others => '0');
  
signal IF_ID_inst_out, IF_ID_addr_out : std_logic_vector(31 downto 0); 
signal haz_IF_ID_write, haz_PC_write : std_logic;

signal regWrite: std_logic;
signal ALUOpcode: std_logic_vector(3 downto 0);
signal RegDest, Branch, BNE, Jump, LUI, ALU_LOHI_Write, ALUSrc : std_logic;
signal ALU_LOHI_Read: std_logic_vector(1 downto 0);
signal MemWrite, MemRead, MemtoReg: std_logic;

--signals from last pipeline stage
signal temp_MEM_WB_RD : std_logic_vector (4 downto 0);
signal temp_Result_W : std_logic_vector(31 downto 0);

signal ALU_LO, ALU_HI : std_logic_vector(31 downto 0) :=(others => '0');
signal data0, data1 : std_logic_vector(31 downto 0);
signal ALU_LO_out, ALU_HI_out : std_logic_vector(31 downto 0);

signal ID_EX_RegRt : std_logic_vector(4 downto 0);
signal ID_EX_MemRead : std_logic;
signal ID_SignExtend, ID_EX_SignExtend, EX_SignExtend : std_logic_vector(31 downto 0);

--hazard detection signal
signal CPU_stall : std_logic;
signal IF_ID_regWrite,IF_ID_RegDest,IF_ID_Branch,IF_ID_BNE,IF_ID_Jump,IF_ID_MemWrite,IF_ID_MemRead,IF_ID_MemtoReg : std_logic;

--ID_EX output signals
signal ID_EX_data0_out, ID_EX_data1_out : std_logic_vector(31 downto 0);
signal ID_EX_Rs_out, ID_EX_Rt_out : std_logic_vector(4 downto 0);
signal ID_EX_addr_out : std_logic_vector(31 downto 0); 

signal ID_EX_ALU_op_out : std_logic_vector(3 downto 0);
signal ID_EX_ALU_src_out : std_logic;
signal ID_EX_Branch_out : std_logic;
signal ID_EX_LUI : std_logic;
signal ID_EX_RegDest_out : std_logic;

--Signals for ALU
signal ALU_data0, t_ALU_data1, ALU_data1, ALU_data_out : std_logic_vector(31 downto 0);
signal EX_ALU_result : std_logic_vector(31 downto 0);

--for EX_MEM stage to MEM_WB stage
signal ID_EX_MemWrite, EX_MEM_MemWrite : std_logic;
signal EX_MEM_MemRead : std_logic;
signal ID_EX_MemtoReg, EX_MEM_MemtoReg, MEM_WB_MemtoReg : std_logic;
signal EX_MEM_ALU_result, EX_MEM_ALU_HI, EX_MEM_ALU_LO : std_logic_vector(31 downto 0);
signal EX_MEM_ALU_zero : std_logic;
signal MEM_WB_ALU_zero : std_logic;
signal MEM_WB_ALU_result, MEM_WB_ALU_HI, MEM_WB_ALU_LO : std_logic_vector(31 downto 0);
signal ID_EX_Rd, EX_MEM_Rd, MEM_WB_Rd : std_logic_vector(4 downto 0);
signal EX_MEM_Data1, EX_MEM_data: std_logic_vector(31 downto 0);
signal MEM_WB_data, Result_W: std_logic_vector(31 downto 0);

--Signals for Forwarding
signal Forward0_EX, Forward1_EX : std_logic_vector(1 downto 0);

BEGIN

Program_counter: PC
PORT MAP
( 
  clk         => clk,
  addr_in     => Imem_addr_in,
  PC_write    => '1',-- from hazard detection
  addr_out    => PC_addr_out
);

process (clk)
begin
  -- increment address
  if (rising_edge(clk)) then
    Imem_addr_in <= std_logic_vector(to_unsigned((to_integer(unsigned(Imem_addr_in)) + 4), 32));
  end if;
end process;

InstMem_address <= to_integer(unsigned(PC_addr_out));

InstMem_re <= '1';

--Instantiation of the main memory component
Instruction_Memory : memory
GENERIC MAP
(
    File_Address_Read   => "Init.dat",
    File_Address_Write  => "InstDump.dat",
    Mem_Size_in_Word    => 2048,
    Num_Bytes_in_Word   => 4,
    Num_Bits_in_Byte    => 8,
    Read_Delay          => 0,
    Write_Delay         => 0
)
PORT MAP
(
    clk           => clk_mem,
    addr          => InstMem_address,
    wordbyte      => '1',
    re            => InstMem_re,
    we            => '0', -- instMem never writes
    dump          => mem_dump,
    dataIn        => (others => '0'),
    dataOut       => Imem_inst_in,
    busy          => InstMem_busy
);

END rtl;
