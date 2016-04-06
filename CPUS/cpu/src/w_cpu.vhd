--2016-03-27

library ieee;

use ieee.std_logic_1164.all; -- allows use of the std_logic_vector type
use ieee.numeric_std.all; -- allows use of the unsigned type
use STD.textio.all;

use work.memory_arbiter_lib.all;

ENTITY w_cpu IS
   
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
      
      mem_dump             : IN    STD_LOGIC := '0';

      -- for testing purposes only (register inspection)
      r0        : out std_logic_vector(31 downto 0);
      r1        : out std_logic_vector(31 downto 0);
      r2        : out std_logic_vector(31 downto 0);
      r3        : out std_logic_vector(31 downto 0);
      r4        : out std_logic_vector(31 downto 0);
      r5        : out std_logic_vector(31 downto 0);
      r6        : out std_logic_vector(31 downto 0);
      r7        : out std_logic_vector(31 downto 0);
      r8        : out std_logic_vector(31 downto 0);
      r9        : out std_logic_vector(31 downto 0);
      r10       : out std_logic_vector(31 downto 0);
      r11       : out std_logic_vector(31 downto 0);
      r12       : out std_logic_vector(31 downto 0);
      r13       : out std_logic_vector(31 downto 0);
      r14       : out std_logic_vector(31 downto 0);
      r15       : out std_logic_vector(31 downto 0);
      r16       : out std_logic_vector(31 downto 0);
      r17       : out std_logic_vector(31 downto 0);
      r18       : out std_logic_vector(31 downto 0);
      r19       : out std_logic_vector(31 downto 0);
      r20       : out std_logic_vector(31 downto 0);
      r21       : out std_logic_vector(31 downto 0);
      r22       : out std_logic_vector(31 downto 0);
      r23       : out std_logic_vector(31 downto 0);
      r24       : out std_logic_vector(31 downto 0);
      r25       : out std_logic_vector(31 downto 0);
      r26       : out std_logic_vector(31 downto 0);
      r27       : out std_logic_vector(31 downto 0);
      r28       : out std_logic_vector(31 downto 0);
      r29       : out std_logic_vector(31 downto 0);
      r30       : out std_logic_vector(31 downto 0);
      r31       : out std_logic_vector(31 downto 0);
      rLo       : out std_logic_vector(31 downto 0);
      rHi       : out std_logic_vector(31 downto 0)
   );
   
END w_cpu;

ARCHITECTURE rtl OF w_cpu IS

-- COMPONENTS 

COMPONENT memory IS
GENERIC 
(
    File_Address_Read   : string    := "Init.dat";
    File_Address_Read0  : string    := "Init0.dat";
    File_Address_Read1  : string    := "Init1.dat";
    File_Address_Read2  : string    := "Init2.dat";
    File_Address_Read3  : string    := "Init3.dat";
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

  -- detects if a stall must be inserted in the execution
  COMPONENT HazardDetectionControl
      PORT (
        clk           : in std_logic;
        ID_Rs         : in std_logic_vector(4 downto 0);
        ID_Rt         : in std_logic_vector(4 downto 0);
        EX_Rt         : in std_logic_vector(4 downto 0);
        ID_EX_MemRead   : in std_logic;
        BRANCH         : in std_logic;
   
        CPU_Stall      : out std_logic;
        state_o       : out integer
      );
  END COMPONENT;

  -- ALU
  COMPONENT ALU
      PORT( 
        clk            : in std_logic;
        opcode         : in std_logic_vector(3 downto 0);
        data0, data1   : in std_logic_vector(31 downto 0);
        shamt          : in std_logic_vector (4 downto 0);
        data_out       : out std_logic_vector(31 downto 0); 
        HI             : out std_logic_vector (31 downto 0);
        LO             : out std_logic_vector (31 downto 0);
        zero           : out std_logic
      );
  END COMPONENT;

  -- register between IF and ID stages
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

  -- register between ID and EX stages
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
        LUI_in            : in std_logic;
        ALU_op_in         : in std_logic_vector(3 downto 0);
        ALU_src_in        : in std_logic;
        Reg_dest_in       : in std_logic;
        BNE_in            : in std_logic;

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
        LUI_out           : out std_logic;
        ALU_op_out        : out std_logic_vector(3 downto 0);
        ALU_src_out       : out std_logic;
        Reg_dest_out      : out std_logic;
        BNE_out            : out std_logic
      );
  END COMPONENT;

  -- register between Execution and Memory stages
  COMPONENT EX_MEM
      PORT(
        clk            : in std_logic;

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

  -- register between MEM and WB stages
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
        Rd_in          : in std_logic_vector (4 downto 0);

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
        Rd_out         : out std_logic_vector (4 downto 0)
      );
   END COMPONENT;

   -- 2 to 1 multiplexer 
   COMPONENT Mux_2to1
      Port(
        --select line
        sel      : in std_logic;

        --data inputs
        in1      : in std_logic_vector(31 downto 0);
        in2      : in std_logic_vector(31 downto 0);

        --output
        dataOut : out std_logic_vector(31 downto 0)
      );
   END COMPONENT;

   -- 3 to 1 multiplexer 
   COMPONENT Mux_3to1
      Port (
        --select line
        sel      : in std_logic_vector(1 downto 0);

        --data inputs
        in1      : in std_logic_vector(31 downto 0);
        in2      : in std_logic_vector(31 downto 0);
        in3      : in std_logic_vector(31 downto 0);

        --output
        dataOut : out std_logic_vector(31 downto 0)
      );
   END COMPONENT;

  -- Program Counter 
  COMPONENT PC
     PORT(
       clk         : in std_logic;
       addr_in     : in std_logic_vector(31 downto 0);
       PC_write    : in std_logic := '1';
       addr_out    : out std_logic_vector(31 downto 0) := (others => '0')
     );
  END COMPONENT;

  -- Registers
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
      ALU_HI_out     : out std_logic_vector(31 downto 0);

      -- for testing purposes only (inspection)
      r0        : out std_logic_vector(31 downto 0);
      r1        : out std_logic_vector(31 downto 0);
      r2        : out std_logic_vector(31 downto 0);
      r3        : out std_logic_vector(31 downto 0);
      r4        : out std_logic_vector(31 downto 0);
      r5        : out std_logic_vector(31 downto 0);
      r6        : out std_logic_vector(31 downto 0);
      r7        : out std_logic_vector(31 downto 0);
      r8        : out std_logic_vector(31 downto 0);
      r9        : out std_logic_vector(31 downto 0);
      r10       : out std_logic_vector(31 downto 0);
      r11       : out std_logic_vector(31 downto 0);
      r12       : out std_logic_vector(31 downto 0);
      r13       : out std_logic_vector(31 downto 0);
      r14       : out std_logic_vector(31 downto 0);
      r15       : out std_logic_vector(31 downto 0);
      r16       : out std_logic_vector(31 downto 0);
      r17       : out std_logic_vector(31 downto 0);
      r18       : out std_logic_vector(31 downto 0);
      r19       : out std_logic_vector(31 downto 0);
      r20       : out std_logic_vector(31 downto 0);
      r21       : out std_logic_vector(31 downto 0);
      r22       : out std_logic_vector(31 downto 0);
      r23       : out std_logic_vector(31 downto 0);
      r24       : out std_logic_vector(31 downto 0);
      r25       : out std_logic_vector(31 downto 0);
      r26       : out std_logic_vector(31 downto 0);
      r27       : out std_logic_vector(31 downto 0);
      r28       : out std_logic_vector(31 downto 0);
      r29       : out std_logic_vector(31 downto 0);
      r30       : out std_logic_vector(31 downto 0);
      r31       : out std_logic_vector(31 downto 0);
      rLo       : out std_logic_vector(31 downto 0);
      rHi       : out std_logic_vector(31 downto 0)
    );
  END COMPONENT;

  -- Control Unit of the circuit is used to set the relevant control signals
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

-- used to forward relevant signals to avoid data hazards
COMPONENT Forwarding is
  port(
    EX_MEM_RegWrite : in std_logic;
    MEM_WB_RegWrite : in std_logic;
    EX_Rs     : in std_logic_vector(4 downto 0);
    EX_Rt     : in std_logic_vector(4 downto 0);
    MEM_Rd      : in std_logic_vector(4 downto 0);
    WB_Rd     : in std_logic_vector(4 downto 0);

    Forward0_EX   : out std_logic_vector(1 downto 0);
    Forward1_EX   : out std_logic_vector(1 downto 0)
    );
end COMPONENT;

COMPONENT EarlyBranching is
  port(
    Branch      : in std_logic;
    EX_MEM_RegWrite : in std_logic;
    MEM_WB_RegWrite : in std_logic;
    ID_Rs     : in std_logic_vector(4 downto 0);
    ID_Rt     : in std_logic_vector(4 downto 0);
    MEM_Rd      : in std_logic_vector(4 downto 0);
    WB_Rd     : in std_logic_vector(4 downto 0);

    Forward0_Branch : out std_logic_vector(1 downto 0);
    Forward1_Branch : out std_logic_vector(1 downto 0)
    );
end COMPONENT;

-- a delay buffer (delays the signal by 1 clock cycle)
COMPONENT Sync IS
  GENERIC(
    width : integer := 32
    );
  PORT(
    clk     : in std_logic;
    Rd      : in std_logic_vector(width downto 0);

    Rd_W    : out std_logic_vector(width downto 0)
    );
END COMPONENT;

------------------------SIGNALS----------------------

-- MEMORY
SIGNAL pc_in, InstMem_address    : integer   := 0;
SIGNAL InstMem_re         : std_logic := '0';
SIGNAL DataMem_addr       : integer    := 0;
SIGNAL DataMem_re         : std_logic  := '1';
SIGNAL DataMem_we         : std_logic  := '0';
SIGNAL DataMem_data       : std_logic_vector (31 downto 0)  := (others => 'Z');
SIGNAL InstMem_counterVector : std_logic_vector (31 downto 0)  := (others => '0'); 
SIGNAL InstMem_busy       : std_logic  := '0';
SIGNAL DataMem_busy       : std_logic  := '0';

-- PC AND memory
signal PC_addr_out : std_logic_vector(31 downto 0);
signal Imem_inst_in, Imem_addr_in, IF_ID_Imem_inst_in : std_logic_vector(31 downto 0);
signal IF_ID_inst_out, IF_ID_addr_out : std_logic_vector(31 downto 0) := (others => '0');

-- CONTROL signals
signal regWrite: std_logic;
signal ALUOpcode: std_logic_vector(3 downto 0);
signal RegDest, Branch, BNE, Jump, LUI, ALU_LOHI_Write, ALUSrc : std_logic;
signal ALU_LOHI_Read: std_logic_vector(1 downto 0);
signal MemWrite, MemRead, MemtoReg: std_logic;
signal rs, rt, Imem_rs, Imem_rt, IF_ID_rt : std_logic_vector ( 4 downto 0);

--For Branch and Jump
signal PC_Branch, Early_Zero : std_logic;
signal Branch_addr, Branch_addr_out, after_Branch : std_logic_vector(31 downto 0) := (others => '0');
signal Jump_addr, Jump_addr_out, after_Jump : std_logic_vector(31 downto 0) := (others => '0');
signal Equal : boolean;

--signals from last pipeline stage
signal ID_SignExtend, ID_EX_SignExtend, EX_SignExtend : std_logic_vector(31 downto 0);

--hazard detection signal
signal CPU_stall : std_logic;
signal IF_ID_regWrite,IF_ID_RegDest,IF_ID_Branch,IF_ID_BNE, ID_EX_BNE, IF_ID_Jump,IF_ID_MemWrite,IF_ID_MemRead,IF_ID_MemtoReg : std_logic;
signal IF_ID_opCode, IF_ID_funct : std_logic_vector (5 downto 0);
signal IF_ID_ALUsrc : std_logic;
signal IF_ID_ALUOpcode : std_logic_vector(3 downto 0);
signal haz_instruction : std_logic_vector(31 downto 0);
signal hazard_state : integer range 0 to 7;

--Signals for Forwarding
signal Forward0_EX, Forward1_EX : std_logic_vector(1 downto 0);
signal Forward0_Branch, Forward1_Branch : std_logic_vector(1 downto 0);
signal Branch_data0, Branch_data1: std_logic_vector(31 downto 0);

--ID_EX output signals
signal ID_EX_RegRt : std_logic_vector(4 downto 0);
signal ID_EX_MemRead : std_logic;
signal ID_EX_data0_out, ID_EX_data1_out : std_logic_vector(31 downto 0);
signal ID_EX_Rs_out, ID_EX_Rt_out : std_logic_vector(4 downto 0);
signal ID_EX_addr_out : std_logic_vector(31 downto 0);
signal ID_EX_RegWrite : std_logic;
signal ID_EX_ALU_op_out : std_logic_vector(3 downto 0);
signal ID_EX_ALU_src_out : std_logic;
signal ID_EX_Branch_out : std_logic;
signal ID_EX_LUI : std_logic;
signal ID_EX_RegDest_out : std_logic;
signal low_ID_EX_SignExtend: std_logic_vector(31 downto 0);
signal ID_Extend: std_logic_vector(15 downto 0);

--Signals for ALU
signal ALU_LO, ALU_HI : std_logic_vector(31 downto 0) := (others => '0');
signal data0, data1 : std_logic_vector(31 downto 0);
signal ALU_LO_out, ALU_HI_out : std_logic_vector(31 downto 0);

-- multiplexer output signals
signal ALU_data0, t_ALU_data1, ALU_data1, ALU_data_out : std_logic_vector(31 downto 0);
signal EX_ALU_result : std_logic_vector(31 downto 0);
signal zero : std_logic;
signal ALU_shamt : std_logic_vector (4 downto 0);

-- EX_MEM sgianls stage to MEM_WB stage
signal ID_EX_MemWrite, EX_MEM_MemWrite : std_logic;
signal EX_MEM_MemRead : std_logic;
signal EX_MEM_RegWrite, MEM_WB_RegWrite : std_logic;
signal ID_EX_MemtoReg, EX_MEM_MemtoReg, MEM_WB_MemtoReg : std_logic;
signal EX_MEM_ALU_result, EX_MEM_ALU_HI, EX_MEM_ALU_LO : std_logic_vector(31 downto 0);
signal EX_MEM_ALU_zero : std_logic;
signal MEM_WB_ALU_zero, MEM_WB_busy : std_logic;
signal MEM_WB_ALU_result, MEM_WB_ALU_HI, MEM_WB_ALU_LO : std_logic_vector(31 downto 0);
signal ID_EX_Rd, EX_MEM_Rd, MEM_WB_Rd, EX_rd, Rd_W : std_logic_vector(4 downto 0);
signal EX_MEM_Data1, EX_MEM_data: std_logic_vector(31 downto 0);
signal MEM_WB_data, Result_W: std_logic_vector(31 downto 0);

BEGIN

Program_counter: PC
  PORT MAP( 
          clk         => clk,
          addr_in     => after_Jump, --should be jump_mux_out
          PC_write    => '1',-- from hazard detection
          addr_out    => PC_addr_out
      );

-- increments the pc by 4 on every clock cycle
pc_increment : process (clk)
begin
  if (falling_edge(clk)) then
    if (CPU_stall /= '1' or ID_EX_Branch_out = '1') then
      pc_in <= to_integer(unsigned(PC_addr_out)) + 4;
    end if;
  end if;
end process;
InstMem_counterVector <= std_logic_vector(to_unsigned(pc_in,32));
InstMem_address <= to_integer(unsigned(PC_addr_out));

read_instruction_mem : process (clk)
begin
  if (falling_edge(clk)) then
    if (CPU_stall /= '1' or ID_EX_Branch_out = '1') then
      InstMem_re <= '1';
    else
      InstMem_re <= '0';
    end if;
  end if;
end process;
-- Instruction memory component
Instruction_Memory : memory
GENERIC MAP
(
    File_Address_Read   => "Init.dat",
    File_Address_Read0  => "Init0.dat",
    File_Address_Read1  => "Init1.dat",
    File_Address_Read2  => "Init2.dat",
    File_Address_Read3  => "Init3.dat",
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

-----------------------------
-- BRANCH LOGIC
-----------------------------
PC_Branch <= Branch and (Early_Zero xor BNE);
Branch_addr <= (ID_SignExtend(29 downto 0) & "00");

--delay branch address
branch_delay : Sync
  PORT MAP(
    clk     => clk,
    Rd      => Branch_addr,
    Rd_W    => Branch_addr_out
    );

with PC_Branch select after_Branch <=
  Branch_addr_out when '1',
  InstMem_counterVector when others;

BRANCH_ID : EarlyBranching
  PORT MAP(
    Branch          => Branch,
    EX_MEM_RegWrite => ID_EX_RegWrite,
    MEM_WB_RegWrite => EX_MEM_RegWrite,
    ID_Rs           => rs,
    ID_Rt           => rt,
    MEM_Rd          => EX_MEM_Rd,
    WB_Rd           => MEM_WB_Rd,

    Forward0_Branch => Forward0_Branch,
    Forward1_Branch => Forward1_Branch
    );

with Forward0_Branch select Branch_data0 <=
  EX_ALU_result when "01",
  Result_W when "10",
  data0     when others;

with Forward1_Branch select Branch_data1 <=
  EX_ALU_result when "01",
  Result_W when "10",
  data1     when others;

Equal <= (Branch_data0 = Branch_data1);

with Equal select Early_Zero <=
  '1' when TRUE,
  '0' when others;

----------------------------
-- JUMP LOGIC
----------------------------
Jump_addr <= "0000" & IF_ID_inst_out(25 downto 0) & "00";

jump_delay : Sync
  PORT MAP(
    clk     => clk,
    Rd      => Jump_addr,
    Rd_W    => Jump_addr_out
    );

with Jump select after_Jump <=
  Jump_addr_out when '1',
  after_Branch when others;

with RegDest select EX_rd <=
  ID_EX_Rd when '1',
  ID_EX_Rt_out when others;

----------------------
-- Data memory 
----------------------
Data_Memory : memory
GENERIC MAP
(
    File_Address_Read   => "InitData.dat",
    File_Address_Read0  => "Init4.dat",
    File_Address_Read1  => "Init5.dat",
    File_Address_Read2  => "Init6.dat",
    File_Address_Read3  => "Init7.dat",
    File_Address_Write  => "DataDump.dat",
    Mem_Size_in_Word    => 2048,
    Num_Bytes_in_Word   => 4,
    Num_Bits_in_Byte    => 8,
    Read_Delay          => 0,
    Write_Delay         => 0
)
PORT MAP
(
    clk           => clk_mem,
    addr          => DataMem_addr, 
    wordbyte      => '1',
    re            => DataMem_re,
    we            => DataMem_we,
    dump          => mem_dump,
    dataIn        => EX_MEM_Data1, -- TODO: ADD CORRECT DATAIN HERE
    dataOut       => DataMem_data,
    busy          => DataMem_busy
);
DataMem_addr <= to_integer(unsigned(EX_MEM_data));

process (clk)
begin
  if (falling_edge(clk)) then
    case CPU_stall is
      when '1' =>
        IF_ID_Imem_inst_in <= "00100000000000000000000000000000";
      when others =>
        IF_ID_Imem_inst_in <= Imem_inst_in;
    end case;
  end if;
end process;

process (clk)
begin
  if (rising_edge(clk)) then
    haz_instruction <= IF_ID_Imem_inst_in;
  end if;
end process;

-- IF_ID stage
IF_ID_stage: IF_ID
  PORT MAP(
    clk           => clk,
    inst_in       => IF_ID_Imem_inst_in,
    addr_in       => PC_addr_out,
    IF_ID_write   => '1',
    inst_out      => IF_ID_inst_out,
    addr_out      => IF_ID_addr_out
    );
IF_ID_opCode <= IF_ID_inst_out(31 downto 26);
IF_ID_funct <= IF_ID_inst_out(5 downto 0);

-- Control unit declaration
Control: Control_Unit
  PORT MAP(
    -- inputs
    clk       => clk,
    opCode    => IF_ID_opCode,
    funct     => IF_ID_funct,

    -- outputs
    --ID (Registers)
    RegWrite  => regWrite,

    --EX
    ALUOpCode       => ALUOpcode,
    RegDest         => RegDest,
    Branch          => Branch,
    ALUSrc          => ALUSrc,
    BNE             => BNE,
    Jump            => Jump,
    LUI             => LUI,
    ALU_LOHI_Write  => ALU_LOHI_Write,
    ALU_LOHI_Read   => ALU_LOHI_Read,
    --MEM (data mem)
    MemWrite        => MemWrite,
    MemRead         => MemRead,
    --WB
    MemtoReg        => MemtoReg
    );

rs <= IF_ID_inst_out(25 downto 21);
rt <= IF_ID_inst_out(20 downto 16);

Register_bank: Registers
  PORT MAP(
    clk     => clk,

    RegWrite  => MEM_WB_RegWrite,
    ALU_LOHI_Write  => ALU_LOHI_Write,

    readReg_0   => rs,
    readReg_1   => rt,
    writeReg    => Rd_W,
    writeData   => Result_W,

    ALU_LO_in   => ALU_LO,
    ALU_HI_in   => ALU_HI,

    readData_0  => data0,
    readData_1  => data1,

    ALU_LO_out  => ALU_LO_out,
    ALU_HI_out  => ALU_HI_out,

    r0              => r0 ,
    r1              => r1 ,
    r2              => r2 ,
    r3              => r3 ,
    r4              => r4 ,
    r5              => r5 ,
    r6              => r6 ,
    r7              => r7 ,
    r8              => r8 ,
    r9              => r9 ,
    r10             => r10,
    r11             => r11,
    r12             => r12,
    r13             => r13,
    r14             => r14,
    r15             => r15,
    r16             => r16,
    r17             => r17,
    r18             => r18,
    r19             => r19,
    r20             => r20,
    r21             => r21,
    r22             => r22,
    r23             => r23,
    r24             => r24,
    r25             => r25,
    r26             => r26,
    r27             => r27,
    r28             => r28,
    r29             => r29,
    r30             => r30,
    r31             => r31,
    rLo             => rLo,
    rHi             => rHi
    );

----------------------------------
-- MFLO and MFHI LOGIC
----------------------------------
MFLO_MFHI : Mux_3to1
  GENERIC MAP(WIDTH_IN =>  32)
  PORT MAP(
    sel      => ALU_LOHI_Read,
    in1      => ALU_data_out,
    in2      => ALU_LO,
    in3      => ALU_HI,
    dataOut  => EX_ALU_result
    );

--------------------------------
-- Sign Extend
--------------------------------
  ID_Extend <= (others => IF_ID_inst_out(15));
  ID_SignExtend <= (ID_Extend & IF_ID_inst_out(15 downto 0));

Imem_rs <= haz_instruction(25 downto 21);
Imem_rt <= haz_instruction(20 downto 16);
IF_ID_rt <= ID_EX_Rt_out;

-- Hazard detection
Hazard : HazardDetectionControl
  PORT MAP (
    clk             => clk,
    EX_Rt           => IF_ID_rt,
    ID_Rs           => Imem_rs,
    ID_Rt           => Imem_rt,
    ID_EX_MemRead   => MemRead,
    BRANCH          => Branch,

    CPU_Stall       => CPU_stall,
    state_o         => hazard_state
  );

IF_ID_regWrite       <=     regWrite;
IF_ID_RegDest        <=     RegDest;
IF_ID_Branch         <=     Branch;
IF_ID_BNE            <=     BNE;
IF_ID_Jump           <=     Jump;
IF_ID_MemWrite       <=     MemWrite;
IF_ID_MemRead        <=     MemRead;
IF_ID_MemtoReg       <=     MemtoReg;
IF_ID_ALUsrc         <=     ALUSrc;
IF_ID_ALUOpcode      <=     ALUOpcode;

-- ID_EX stage register
ID_EX_stage: ID_EX
  PORT MAP(
    clk               => clk,

    --Data inputs
    Addr_in           => IF_ID_addr_out,
    RegData0_in       => data0,
    RegData1_in       => data1,
    SignExtended_in   => ID_SignExtend,

    --Register inputs (5 bits each)
    Rs_in             => IF_ID_inst_out(25 downto 21),--rs
    Rt_in             => IF_ID_inst_out(20 downto 16),--rt
    Rd_in             => IF_ID_inst_out(15 downto 11),--rd

    --Control inputs (8 of them?)
    RegWrite_in       => IF_ID_regWrite,
    MemToReg_in       => IF_ID_MemtoReg,
    MemWrite_in       => IF_ID_MemWrite,
    MemRead_in        => IF_ID_MemRead,
    Branch_in         => IF_ID_Branch,
    LUI_in            => LUI,
    ALU_op_in         => IF_ID_ALUOpcode,
    ALU_src_in        => IF_ID_ALUsrc,
    Reg_dest_in       => IF_ID_RegDest,
    BNE_in            => IF_ID_BNE,

    --Data Outputs
    Addr_out          => ID_EX_addr_out,
    RegData0_out      => ID_EX_data0_out,
    RegData1_out      => ID_EX_data1_out,
    SignExtended_out  => ID_EX_SignExtend,
    --Register outputs
    Rs_out            => ID_EX_Rs_out,
    Rt_out            => ID_EX_Rt_out,
    Rd_out            => ID_EX_Rd,
    --Control outputs
    RegWrite_out      => ID_EX_RegWrite,
    MemToReg_out      => ID_EX_MemtoReg,
    MemWrite_out      => ID_EX_MemWrite,
    MemRead_out       => ID_EX_MemRead,
    Branch_out        => ID_EX_Branch_out,
    LUI_out           => ID_EX_LUI,
    ALU_op_out        => ID_EX_ALU_op_out,
    ALU_src_out       => ID_EX_ALU_src_out,
    Reg_dest_out      => ID_EX_RegDest_out,
    BNE_out           => ID_EX_BNE
  );

LUI_mux: Mux_2to1
  GENERIC MAP(
    WIDTH_IN => 32
  )
  PORT MAP(
    sel      => LUI,
    in1      => ID_EX_SignExtend,
    in2      => low_ID_EX_SignExtend,
    dataOut  => EX_SignExtend
  );
  -- sign extend
low_ID_EX_SignExtend <= ID_EX_SignExtend(15 downto 0) & "0000000000000000";

Forwarding_unit: Forwarding
  PORT MAP(
    EX_MEM_RegWrite => ID_EX_RegWrite,
    MEM_WB_RegWrite => EX_MEM_RegWrite,
    EX_Rs           => ID_EX_Rs_out,
    EX_Rt           => ID_EX_Rt_out,
    MEM_Rd          => EX_MEM_Rd,
    WB_Rd           => MEM_WB_Rd,

    Forward0_EX     => Forward0_EX,
    Forward1_EX     => Forward1_EX
  );

-- select DATA0 input for main ALU
with Forward0_EX select ALU_data0 <=
  EX_ALU_result when "01",
  Result_W when "10",
  ID_EX_data0_out when others;

-- select DATA1 input for main ALU
with Forward1_EX select t_ALU_data1 <=
  EX_ALU_result when "01",
  Result_W when "10",
  ID_EX_data1_out when others;

-- immediate value or data2 for main ALU data1 input
with ALUSrc select ALU_data1 <=
  EX_SignExtend when '1',
  t_ALU_data1 when others;

-- main ALU component
main_ALU: ALU
  PORT MAP(
    clk       => clk,
    opcode    => ALUOpcode,
    data0     => ALU_data0,
    data1     => ALU_data1,
    shamt     => ALU_shamt,
    data_out  => ALU_data_out,
    HI        => ALU_HI,
    LO        => ALU_LO,
    zero      => zero
  );
ALU_shamt <= EX_SignExtend(10 downto 6);

-- EX_MEM stage
EX_MEM_stage: EX_MEM
  PORT MAP(
    clk            => clk,

    --Control Unit
    MemWrite_in    => ID_EX_MemWrite,
    MemRead_in     => ID_EX_MemRead,
    MemtoReg_in    => ID_EX_MemtoReg,
    RegWrite_in    => ID_EX_RegWrite,
    --ALU
    ALU_Result_in  => EX_ALU_result,
    ALU_HI_in      => ALU_HI,
    ALU_LO_in      => ALU_LO,
    ALU_zero_in    => zero,
    --Read Data
    Data1_in       => ID_EX_data1_out,
    --Register
    Rd_in          => EX_rd,

    --Control Unit
    MemWrite_out   => DataMem_we,
    MemRead_out    => DataMem_re,
    MemtoReg_out   => EX_MEM_MemtoReg,
    RegWrite_out   => EX_MEM_RegWrite,
    --ALU
    ALU_Result_out => EX_MEM_data,
    ALU_HI_out     => EX_MEM_ALU_HI,
    ALU_LO_out     => EX_MEM_ALU_LO,
    ALU_zero_out   => EX_MEM_ALU_zero,
    --Read Data
    Data1_out      => EX_MEM_Data1,
    --Register
    Rd_out         => EX_MEM_Rd
  );

-- MEM_WB stage register
MEM_WB_stage: MEM_WB
  PORT MAP(
    clk            => clk,
    --Control Unit
    MemtoReg_in    => EX_MEM_MemtoReg,
    RegWrite_in    => EX_MEM_RegWrite,
    --Data Memory
    busy_in        => DataMem_busy,
    Data_in        => DataMem_data,
    --ALU
    ALU_Result_in  => EX_MEM_data,
    ALU_HI_in      => EX_MEM_ALU_HI,
    ALU_LO_in      => EX_MEM_ALU_LO,
    ALU_zero_in    => EX_MEM_ALU_zero,
    --Register
    Rd_in          => EX_MEM_Rd,
    --Control Unit
    MemtoReg_out   => MEM_WB_MemtoReg,
    RegWrite_out   => MEM_WB_RegWrite,
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

-- delay write enable for registers
Rd_Delay : Sync
  generic map(
    width => 5
    )
  PORT MAP(
    clk     => clk,
    Rd      => MEM_WB_Rd,
    Rd_W    => Rd_W
    );

with MEM_WB_MemtoReg select Result_W <=
  MEM_WB_data when '1',
  MEM_WB_ALU_result when others;

END rtl;
