library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.memory_arbiter_lib.all;

Entity memory_arbiter_tb is

end memory_arbiter_tb;

architecture behavioral of memory_arbiter_tb is

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
    data        : inout STD_LOGIC_VECTOR(MEM_DATA_WIDTH-1 downto 0);
    busy        : out STD_LOGIC
);
END COMPONENT;

SIGNAL clk      : std_logic                                        := '0';
SIGNAL t_addr   : NATURAL                                          := 0;
SIGNAL t_wb     : STD_LOGIC                                        := '1';
SIGNAL t_re     : STD_LOGIC                                        := '0';
SIGNAL t_we     : STD_LOGIC                                        := '0';
SIGNAL t_dump   : STD_LOGIC                                        := '0';
SIGNAL t_data   : STD_LOGIC_VECTOR(MEM_DATA_WIDTH-1 downto 0)      := (OTHERS => '0');
SIGNAL t_busy   : STD_LOGIC                                        := '0';

begin

mem : memory
GENERIC MAP
(
    File_Address_Read   => "Init.dat",
    File_Address_Write  => "MemCon.dat",
    Mem_Size_in_Word    => 2048,
    Num_Bytes_in_Word   => 4,
    Num_Bits_in_Byte    => 8,
    Read_Delay          => 0,
    Write_Delay         => 0
)
PORT MAP
(
    clk         => clk,
    addr        => t_addr,
    wordbyte    => t_wb,
    re          => t_re,
    we          => t_we,
    dump        => t_dump,
    data        => t_data,
    busy        => t_busy
);

clk_process : process
begin
  clk <= '0';
  wait for 10ns;
  clk <= '1';
  wait for 10ns;
end process;

test : process
begin
  t_data <= (0 => '1' , others => '0');
  wait for 200ns;
  t_addr <= 0;
  t_we <= '1';
  wait for 80ns;
  t_we <= '0';
  t_data <= ( others => 'Z');
  wait for 20ns;
  t_re <= '1';
  wait for 80ns;
  t_re <= '0';
  wait for 40ns;
  REPORT "Testing memory: read after write data."
  ASSERT (to_integer(unsigned(t_data)) = 1) REPORT "t_data must be equal to 1." SEVERITY ERROR;
  WAIT;
end process;

end behavioral;
