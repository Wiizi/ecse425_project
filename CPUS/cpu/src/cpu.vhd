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