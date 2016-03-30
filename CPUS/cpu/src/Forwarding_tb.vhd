library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity forwarding_tb is

end Forwarding_tb;

architecture behavioral of Forwarding_tb is

COMPONENT Forwarding
  port(
    EX_MEM_RegWrite : in std_logic;
    MEM_WB_RegWrite : in std_logic;
    EX_Rs        : in std_logic_vector(4 downto 0);
    EX_Rt        : in std_logic_vector(4 downto 0);
    MEM_Rd       : in std_logic_vector(4 downto 0);
    WB_Rd       : in std_logic_vector(4 downto 0);

    Forward0_EX     : out std_logic_vector(1 downto 0) := "00";
    Forward1_EX     : out std_logic_vector(1 downto 0) := "00"
    );
END COMPONENT;

SIGNAL t_EX_MEM_RegWrite : std_logic;
SIGNAL t_MEM_WB_RegWrite : std_logic;
SIGNAL t_ID_EX_Rs        : std_logic_vector(4 downto 0);
SIGNAL t_ID_EX_Rt        : std_logic_vector(4 downto 0);
SIGNAL t_EX_MEM_Rd       : std_logic_vector(4 downto 0);
SIGNAL t_MEM_WB_Rd	 : std_logic_vector(4 downto 0);
SIGNAL t_F0_EX         	 : std_logic_vector(1 downto 0);
SIGNAL t_F1_EX           : std_logic_vector(1 downto 0);

begin

forward : Forwarding
  PORT MAP
  (
    EX_MEM_RegWrite => t_EX_MEM_RegWrite,
    MEM_WB_RegWrite => t_MEM_WB_RegWrite,
    EX_Rs        => t_ID_EX_Rs,
    EX_Rt        => t_ID_EX_Rt,
    MEM_Rd       => t_EX_MEM_Rd,
    WB_Rd       => t_MEM_WB_Rd,

    Forward0_EX     => t_F0_EX,
    Forward1_EX     => t_F1_EX
  );

test : process
begin

  wait for 20 ns;

  t_EX_MEM_RegWrite <= '1';
  t_MEM_WB_RegWrite <= '1';
  t_ID_EX_Rs <= "00011";
  t_ID_EX_Rt <= "00010";
  t_EX_MEM_Rd <= "00011";
  t_MEM_WB_Rd <= "00001";

  wait for 20 ns;
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

  wait for 20 ns;
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

  wait for 20 ns;
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

  wait for 20 ns;
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

  wait for 20 ns;
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

  wait for 20 ns;
  -- example assert statement
  REPORT "Testing - 6";
  ASSERT (t_F0_EX = "00") REPORT "Forward0_EX is not correct." SEVERITY ERROR;
  ASSERT (t_F1_EX = "10") REPORT "Forward1_EX is not correct." SEVERITY ERROR;

  t_EX_MEM_RegWrite <= '1';
  t_MEM_WB_RegWrite <= '0';
  t_ID_EX_Rs <= "00011";
  t_ID_EX_Rt <= "00010";
  t_EX_MEM_Rd <= "00001";
  t_MEM_WB_Rd <= "00011";

  wait for 20 ns;
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

  wait for 20 ns;
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

  wait for 20 ns;
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

  wait for 20 ns;
  -- example assert statement
  REPORT "Testing - 10";
  ASSERT (t_F0_EX = "10") REPORT "Forward0_EX is not correct." SEVERITY ERROR;
  ASSERT (t_F1_EX = "01") REPORT "Forward1_EX is not correct." SEVERITY ERROR;

  WAIT;
end process;

end behavioral;
