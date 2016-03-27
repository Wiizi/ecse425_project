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
SIGNAL t_F0_EX         : std_logic_vector(1 downto 0);
SIGNAL t_F1_EX         : std_logic_vector(1 downto 0);

begin

forwarding : Forwarding
  PORT MAP
  (
    EX_MEM_RegWrite <= EX_MEM_RegWrite,
    MEM_WB_RegWrite <= MEM_WB_RegWrite,
    ID_EX_Rs        <= ID_EX_Rs,
    ID_EX_Rt        <= ID_EX_Rt,
    EX_MEM_Rd       <= EX_MEM_Rd,
    MEM_WB_Rd       <= MEM_WB_Rd,

    Forward0_EX     <= t_F0_EX,
    Forward1_EX     <= t_F1_EX
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

  EX_MEM_RegWrite <= '1';
  MEM_WB_RegWrite <= '1';
  ID_EX_Rs <= "00011";
  ID_EX_Rt <= "00010";
  EX_MEM_Rd <= "00011";
  MEM_WB_Rd <= "00001";

  -- example assert statement
  REPORT "Testing!";
  ASSERT (t_F0_EX = "01") REPORT "Forward0_EX is not correct." SEVERITY ERROR;
  ASSERT (t_F1_EX = "00") REPORT "Forward1_EX is not correct." SEVERITY ERROR;
  WAIT;
end process;

end behavioral;
