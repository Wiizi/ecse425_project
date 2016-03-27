library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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

SIGNAL t_EX_MEM_RegWrite : std_logic;
SIGNAL t_MEM_WB_RegWrite : std_logic;
SIGNAL t_ID_EX_Rs        : std_logic_vector(4 downto 0);
SIGNAL t_ID_EX_Rt        : std_logic_vector(4 downto 0);
SIGNAL t_EX_MEM_Rd       : std_logic_vector(4 downto 0);
SIGNAL t_MEM_WB_Rd       : std_logic_vector(4 downto 0);
SIGNAL t_F0_EX         : std_logic_vector(1 downto 0);
SIGNAL t_F1_EX         : std_logic_vector(1 downto 0);
SIGNAL clk : std_logic;

begin

forward : Forwarding
  PORT MAP
  (
    EX_MEM_RegWrite => t_EX_MEM_RegWrite,
    MEM_WB_RegWrite => t_MEM_WB_RegWrite,
    ID_EX_Rs        => t_ID_EX_Rs,
    ID_EX_Rt        => t_ID_EX_Rt,
    EX_MEM_Rd       => t_EX_MEM_Rd,
    MEM_WB_Rd       => t_MEM_WB_Rd,

    Forward0_EX     => t_F0_EX,
    Forward1_EX     => t_F1_EX
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

  t_EX_MEM_RegWrite <= '1';
  t_MEM_WB_RegWrite <= '1';
  t_ID_EX_Rs <= "00011";
  t_ID_EX_Rt <= "00010";
  t_EX_MEM_Rd <= "00011";
  t_MEM_WB_Rd <= "00001";

  wait for 20ns;
  -- example assert statement
  REPORT "Testing - 1";
  ASSERT (t_F0_EX = "01") REPORT "Forward0_EX is not correct." SEVERITY ERROR;
  ASSERT (t_F1_EX = "00") REPORT "Forward1_EX is not correct." SEVERITY ERROR;

  t_EX_MEM_RegWrite <= '1';
  t_MEM_WB_RegWrite <= '1';
  t_ID_EX_Rs <= "00011";
  t_ID_EX_Rt <= "00010";
  t_EX_MEM_Rd <= "00001";
  t_MEM_WB_Rd <= "00011";

  wait for 20ns;
  -- example assert statement
  REPORT "Testing - 2";
  ASSERT (t_F0_EX = "10") REPORT "Forward0_EX is not correct." SEVERITY ERROR;
  ASSERT (t_F1_EX = "00") REPORT "Forward1_EX is not correct." SEVERITY ERROR;

  t_EX_MEM_RegWrite <= '0';
  t_MEM_WB_RegWrite <= '1';
  t_ID_EX_Rs <= "00011";
  t_ID_EX_Rt <= "00010";
  t_EX_MEM_Rd <= "00011";
  t_MEM_WB_Rd <= "00001";

  wait for 20ns;
  -- example assert statement
  REPORT "Testing - 3";
  ASSERT (t_F0_EX = "00") REPORT "Forward0_EX is not correct." SEVERITY ERROR;
  ASSERT (t_F1_EX = "00") REPORT "Forward1_EX is not correct." SEVERITY ERROR;

  t_EX_MEM_RegWrite <= '0';
  t_MEM_WB_RegWrite <= '1';
  t_ID_EX_Rs <= "00011";
  t_ID_EX_Rt <= "00010";
  t_EX_MEM_Rd <= "00010";
  t_MEM_WB_Rd <= "00001";

  wait for 20ns;
  -- example assert statement
  REPORT "Testing - 4";
  ASSERT (t_F0_EX = "00") REPORT "Forward0_EX is not correct." SEVERITY ERROR;
  ASSERT (t_F1_EX = "00") REPORT "Forward1_EX is not correct." SEVERITY ERROR;

  t_EX_MEM_RegWrite <= '1';
  t_MEM_WB_RegWrite <= '1';
  t_ID_EX_Rs <= "00011";
  t_ID_EX_Rt <= "00010";
  t_EX_MEM_Rd <= "00001";
  t_MEM_WB_Rd <= "00011";

  wait for 20ns;
  -- example assert statement
  REPORT "Testing - 5";
  ASSERT (t_F0_EX = "10") REPORT "Forward0_EX is not correct." SEVERITY ERROR;
  ASSERT (t_F1_EX = "00") REPORT "Forward1_EX is not correct." SEVERITY ERROR;

  t_EX_MEM_RegWrite <= '1';
  t_MEM_WB_RegWrite <= '1';
  t_ID_EX_Rs <= "00011";
  t_ID_EX_Rt <= "00010";
  t_EX_MEM_Rd <= "00001";
  t_MEM_WB_Rd <= "00010";

  wait for 20ns;
  -- example assert statement
  REPORT "Testing - 6";
  ASSERT (t_F0_EX = "00") REPORT "Forward0_EX is not correct." SEVERITY ERROR;
  ASSERT (t_F1_EX = "00") REPORT "Forward1_EX is not correct." SEVERITY ERROR;

  t_EX_MEM_RegWrite <= '1';
  t_MEM_WB_RegWrite <= '0';
  t_ID_EX_Rs <= "00011";
  t_ID_EX_Rt <= "00010";
  t_EX_MEM_Rd <= "00001";
  t_MEM_WB_Rd <= "00011";

  wait for 20ns;
  -- example assert statement
  REPORT "Testing - 7";
  ASSERT (t_F0_EX = "00") REPORT "Forward0_EX is not correct." SEVERITY ERROR;
  ASSERT (t_F1_EX = "00") REPORT "Forward1_EX is not correct." SEVERITY ERROR;

  t_EX_MEM_RegWrite <= '1';
  t_MEM_WB_RegWrite <= '0';
  t_ID_EX_Rs <= "00011";
  t_ID_EX_Rt <= "00010";
  t_EX_MEM_Rd <= "00001";
  t_MEM_WB_Rd <= "00010";

  wait for 20ns;
  -- example assert statement
  REPORT "Testing - 8";
  ASSERT (t_F0_EX = "00") REPORT "Forward0_EX is not correct." SEVERITY ERROR;
  ASSERT (t_F1_EX = "00") REPORT "Forward1_EX is not correct." SEVERITY ERROR;

  t_EX_MEM_RegWrite <= '1';
  t_MEM_WB_RegWrite <= '1';
  t_ID_EX_Rs <= "00011";
  t_ID_EX_Rt <= "00010";
  t_EX_MEM_Rd <= "00011";
  t_MEM_WB_Rd <= "00010";

  wait for 20ns;
  -- example assert statement
  REPORT "Testing - 9";
  ASSERT (t_F0_EX = "01") REPORT "Forward0_EX is not correct." SEVERITY ERROR;
  ASSERT (t_F1_EX = "10") REPORT "Forward1_EX is not correct." SEVERITY ERROR;

  t_EX_MEM_RegWrite <= '1';
  t_MEM_WB_RegWrite <= '1';
  t_ID_EX_Rs <= "00101";
  t_ID_EX_Rt <= "00110";
  t_EX_MEM_Rd <= "00110";
  t_MEM_WB_Rd <= "00101";

  wait for 20ns;
  -- example assert statement
  REPORT "Testing - 10";
  ASSERT (t_F0_EX = "10") REPORT "Forward0_EX is not correct." SEVERITY ERROR;
  ASSERT (t_F1_EX = "01") REPORT "Forward1_EX is not correct." SEVERITY ERROR;

  WAIT;
end process;

end behavioral;
