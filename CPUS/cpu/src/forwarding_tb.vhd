library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.memory_arbiter_lib.all;

Entity memory_arbiter_tb is

end memory_arbiter_tb;

architecture behavioral of memory_arbiter_tb is

COMPONENT Forwarding
  port(
    EX_MEM_RegWrite : in std_logic;
    MEM_WB_RegWrite : in std_logic;
    ID_EX_Rs        : in std_logic_vector(4 downto 0);
    ID_EX_Rt        : in std_logic_vector(4 downto 0);
    EX_MEM_Rd       : in std_logic_vector(4 downto 0);
    MEM_WB_Rd       : in std_logic_vector(4 downto 0);

    Forward0_EX     : out std_logic_vector(1 downto 0) := "00";
    Forward1_EX     : out std_logic_vector(1 downto 0) := "00"
    );
END COMPONENT;

SIGNAL EX_MEM_RegWrite : std_logic;
SIGNAL MEM_WB_RegWrite : std_logic;
SIGNAL ID_EX_Rs        : std_logic_vector(4 downto 0);
SIGNAL ID_EX_Rt        : std_logic_vector(4 downto 0);
SIGNAL EX_MEM_Rd       : std_logic_vector(4 downto 0);
SIGNAL MEM_WB_Rd       : std_logic_vector(4 downto 0);

begin

forwarding : Forwarding
  PORT MAP
  (
    EX_MEM_RegWrite <= EX_MEM_RegWrite;
    MEM_WB_RegWrite <= MEM_WB_RegWrite;
    ID_EX_Rs        <= ID_EX_Rs;
    ID_EX_Rt        <= ID_EX_Rt;
    EX_MEM_Rd       <= EX_MEM_Rd;
    MEM_WB_Rd       <= MEM_WB_Rd;
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
  
  wait for 20ns;

  EX_MEM_RegWrite <= ;
  MEM_WB_RegWrite <= ;
  ID_EX_Rs <= ;
  ID_EX_Rt <= ;
  EX_MEM_Rd <= ;
  MEM_WB_Rd <= ;

  -- example assert statement
  REPORT "Testing!";
  ASSERT (1 = 2) REPORT "OH NO ITS BAD!!!." SEVERITY ERROR;
  WAIT;
end process;

end behavioral;
