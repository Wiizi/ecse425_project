-- This file is a CPU skeleton
--
-- entity name: cpu


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
      Read_Delay           : INTEGER   := 0; 
      Write_Delay          : INTEGER   := 0
   );
   PORT (
      clk:      	      IN    STD_LOGIC;
      reset:            IN    STD_LOGIC := '0';
      
      --Signals required by the MIKA testing suite
      finished_prog:    OUT   STD_LOGIC; --Set this to '1' when program execution is over
      assertion:        OUT   STD_LOGIC; --Set this to '1' when an assertion occurs 
      assertion_pc:     OUT   NATURAL;   --Set the assertion's program counter location
      
      mem_dump:         IN    STD_LOGIC := '0'
   );
   
END cpu;

ARCHITECTURE rtl OF cpu IS
   
   --Main memory signals
   
   SIGNAL mm_address       : NATURAL                                       := 0;
   SIGNAL mm_word_byte     : std_logic                                     := '0';
   SIGNAL mm_we            : STD_LOGIC                                     := '0';
   SIGNAL mm_wr_done       : STD_LOGIC                                     := '0';
   SIGNAL mm_re            : STD_LOGIC                                     := '0';
   SIGNAL mm_rd_ready      : STD_LOGIC                                     := '0';
   SIGNAL mm_data          : STD_LOGIC_VECTOR(31 downto 0)   := (others => 'Z');
   SIGNAL mm_initialize    : STD_LOGIC                                     := '0';

   -- COMPONENTS 
   
   COMPONENT Main_Memory
      generic (
         File_Address_Read    : string :="Init.dat";
         File_Address_Write   : string :="MemCon.dat";
         Mem_Size_in_Word     : integer:=2048;  
         Num_Bytes_in_Word    : integer:=4;
         Num_Bits_in_Byte     : integer := 8; 
         Read_Delay           : integer:=0; 
         Write_Delay          : integer:=0
       );
      PORT(
         clk         : IN  std_logic;
         address     : IN  integer;
         Word_Byte   : in std_logic;
         we          : IN  std_logic;
         wr_done     : OUT  std_logic;
         re          : IN  std_logic;
         rd_ready    : OUT  std_logic;
         data        : INOUT  std_logic_vector(Num_Bytes_in_Word*Num_Bits_in_Byte-1 downto 0);
         initialize  : IN  std_logic;
         dump        : IN  std_logic
        );
    END COMPONENT;

   COMPONENT ALU
      PORT( 
         opcode      : in std_logic_vector(3 downto 0); --Specified the ALU which operation to perform
         data0, data1: in std_logic_vector(31 downto 0);
         shamt       : in std_logic_vector (4 downto 0);
         data_out: out std_logic_vector(31 downto 0); 
         HI          : out std_logic_vector (31 downto 0);
         LO          : out std_logic_vector (31 downto 0);
         zero        : out std_logic
      );
   END COMPONENT;

   COMPONENT EX_MEM
      port(
         clk : in std_logic;

         Addr_in        : in std_logic_vector(31 downto 0);
         --ALU
         ALU_Result_in  : in std_logic_vector(31 downto 0);
         ALU_HI_in      : in std_logic_vector (31 downto 0);
         ALU_LO_in      : in std_logic_vector (31 downto 0);
         ALU_zero_in    : in std_logic;
         --Read Data
         Data_in        : in std_logic_vector(31 downto 0);
         --Register
         Rd_in          : in std_logic(4 downto 0);


         Addr_out    : out std_logic_vector(31 downto 0);
         --ALU
         ALU_Result_out : out std_logic_vector(31 downto 0);
         ALU_HI_out     : out std_logic_vector (31 downto 0);
         ALU_LO_out     : out std_logic_vector (31 downto 0);
         ALU_zero_out   : out std_logic;
         --Read Data
         Data_out    : out std_logic_vector(31 downto 0);
         --Register
         Rd_out         : out std_logic(4 downto 0)
      );
   END COMPONENT;

   COMPONENT ID_EX
      PORT(
         clk      : in std_logic;
   
         --Data inputs
         Addr_in        : in std_logic_vector(31 downto 0);
         RegData1_in    : in std_logic_vector(31 downto 0);
         RedData2_in    : in std_logic_vector(31 downto 0);
         SignExtended_in      : in std_logic_vector(31 downto 0);
   
         --Register inputs (5 bits each)
         Rs_in          : in std_logic_vector(4 downto 0);
         Rt_in          : in std_logic_vector(4 downto 0);
         Rd_in          : in std_logic_vector(4 downto 0);
   
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
         RedData2_out      : out std_logic_vector(31 downto 0);
         SignExtended_out  : out std_logic_vector(31 downto 0);
   
         --Register outputs
         Rs_out         : out std_logic_vector(4 downto 0);
         Rt_out         : out std_logic_vector(4 downto 0);
         Rd_out         : out std_logic_vector(4 downto 0);
   
         --Control outputs
         RegWrite_out   : out std_logic;
         MemToReg_out   : out std_logic;
         MemWrite_out   : out std_logic;
         MemRead_out    : out std_logic;
         Branch_out     : out std_logic;  
         ALU_op_out     : out std_logic_vector(2 downto 0);
         ALU_src_out    : out std_logic;
         Reg_dest_out
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

   COMPONENTS MEM_WB
      port(
         clk            : in std_logic;

         --Data Memory
         wr_done_in     : in std_logic;
         rd_ready_in    : in std_logic;
         Data_in        : in std_logic_vector(31 downto 0);

         --ALU
         ALU_Result_in  : in std_logic_vector(31 downto 0);
         ALU_HI_in      : in std_logic_vector (31 downto 0);
         ALU_LO_in      : in std_logic_vector (31 downto 0);
         ALU_zero_in    : in std_logic;

         --Register
         Rd_in          : in std_logic;

         --Data Memory
         wr_done_out    : out std_logic;
         rd_ready_out   : out std_logic;
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

BEGIN
   
   --Instantiation of the main memory component
   main_memory : ENTITY work.Main_Memory
      GENERIC MAP (
         File_Address_Read   => File_Address_Read,
         File_Address_Write  => File_Address_Write,
         Mem_Size_in_Word    => Mem_Size_in_Word,
         Read_Delay          => Read_Delay, 
         Write_Delay         => Write_Delay
      )
      PORT MAP (
         clk         => clk,
         address     => mm_address,
         Word_Byte   => mm_word_byte,
         we          => mm_we,
         wr_done     => mm_wr_done,
         re          => mm_re,
         rd_ready    => mm_rd_ready,
         data        => mm_data,
         initialize  => mm_initialize,
         dump        => mem_dump
      );
   
END rtl;