library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.memory_arbiter_lib.all;

ENTITY memory IS
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
    clk       : in STD_LOGIC;
    addr      : in NATURAL;
    wordbyte  : in STD_LOGIC := '1';
    re        : in STD_LOGIC;
    we        : in STD_LOGIC;
    dump      : in STD_LOGIC := '0';
    dataIn    : in STD_LOGIC_VECTOR(MEM_DATA_WIDTH-1 downto 0);
    dataOut   : out STD_LOGIC_VECTOR(MEM_DATA_WIDTH-1 downto 0);
    busy      : out STD_LOGIC;
    state_o   : out STD_LOGIC_VECTOR(2 downto 0);
    wrd       : out STD_LOGIC;
    rdr       : out STD_LOGIC
);
END memory;

ARCHITECTURE behavioral OF memory IS

  --Main memory signals
  --Use these internal signals to interact with the main memory
  SIGNAL mm_address       : NATURAL                                       := 0;
  SIGNAL mm_we            : STD_LOGIC                                     := '0';
  SIGNAL mm_wr_done       : STD_LOGIC                                     := '0';
  SIGNAL mm_re            : STD_LOGIC                                     := '0';
  SIGNAL mm_rd_ready      : STD_LOGIC                                     := '0';
  SIGNAL mm_data          : STD_LOGIC_VECTOR(MEM_DATA_WIDTH-1 downto 0)   := (others => 'Z');

  SIGNAL mm_initialize    : STD_LOGIC                                     := '0';
  SIGNAL mm_word_byte     : STD_LOGIC                                     := '0';
  SIGNAL mm_dump          : STD_LOGIC                                     := '0';

  -- control signals
  SIGNAL mem_port         : BIT                                           := '0'; --0 for port 1, 1 for port 2
  SIGNAL mem_busy         : BIT                                           := '0'; --0 for idle, 1 for busy
  SIGNAL mem_op           : BIT                                           := '0'; --0 for read, 1 for write

  type state_type is (init, start, read1, read2, write1, write2);
  SIGNAL state            :  state_type:=init;

begin

  with state select state_o <= 
    "000" when init,
    "001" when start,
    "010" when read1,
    "011" when read2,
    "100" when write1,
    "101" when write2,
    "ZZZ" when others;

  rdr <= mm_rd_ready;
  wrd <= mm_wr_done;

  mm_dump <= dump;
  mm_word_byte <= wordbyte;

  --Instantiation of the main memory component
  main_memory : ENTITY work.Main_Memory
      GENERIC MAP (
        File_Address_Read   => File_Address_Read,
        File_Address_Read0  => File_Address_Read0,
        File_Address_Read1  => File_Address_Read1,
        File_Address_Read2  => File_Address_Read2,
        File_Address_Read3  => File_Address_Read3,
        File_Address_Write  => File_Address_Write,
        Mem_Size_in_Word    => Mem_Size_in_Word,
        Num_Bytes_in_Word   => Num_Bytes_in_Word,
        Num_Bits_in_Byte    => Num_Bits_in_Byte,
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
        dump        => mm_dump
      );    

  -- implement a memory arbiter 
  mem_control : process (clk)
  begin
    if (rising_edge(clk)) then
   
      if (re = '1' or we = '1') then
        busy <= '1';
        if (mem_busy = '0') then
          mem_busy <= '1';
          if (re = '1') then
            mem_op <= '0';
          elsif (we = '1') then
            mem_op <= '1';
          end if;
        end if;
      end if;
   
      if (mem_busy = '1' and (mm_wr_done = '1' or mm_rd_ready = '1')) then
        mem_busy <= '0';
        busy <= '0';
      end if;
    end if;
  end process;

  -- implement read/write FSM
  read_write : process (clk)
  begin
    if(rising_edge(clk)) then
      case state is
        when init => 
          if (mm_initialize = '0') then
            mm_initialize <= '1';
            state <= start;
            dataOut <= (others=>'Z');
          end if;
        when start =>
          if (mem_busy = '1') then
            mm_address <= addr;
            if (mem_op = '1') then
              state <= write1;
            elsif (mem_op = '0') then
              state <= read1;
            end if;
          end if;
        when write1 =>
          -- set address and data to write, and enable mm_we for memory
          mm_data <= dataIn;
          mm_we <= '1';
          state <= write2;
        when write2 =>
          if (mm_wr_done = '1') then
            mm_we <= '0';
            state <= start;
          end if;
        when read1 =>
          mm_data <= (others => 'Z');
          -- set address to read, and enable mm_re for memory
          mm_re <= '1';
          state <= read2;
        when read2 =>
          if (mm_rd_ready = '1') then
            dataOut <= mm_data;
            mm_re <= '0';
            state <= start;
          end if;
        when others =>
      end case;
    end if; 
  end process;
end behavioral;