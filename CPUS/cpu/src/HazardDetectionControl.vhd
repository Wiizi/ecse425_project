LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY HazardDetectionControl IS
	PORT (
		IDEX_RegRt 		: in std_logic_vector(4 downto 0);
		IFID_RegRs 		: in std_logic_vector(4 downto 0);
		IFID_RegRt 		: in std_logic_vector(4 downto 0);
		IDEX_MemRead 	: in std_logic;
		BRANCH			: in std_logic;

		IFID_Write 		: out std_logic;
		PC_Update 		: out std_logic;
		CPU_Stall 		: out std_logic
	);
END HazardDetectionControl;

ARCHITECTURE behaviour OF HazardDetectionControl IS

BEGIN

hzrdDetection: process (IDEX_MemRead, IDEX_RegRt, IFID_RegRs, IFID_RegRt)
begin
	-- reset to defaults
	CPU_Stall <= '0';
	IFID_Write <= '1';
	PC_Update <= '1';

	-- check for hazards and stall if hazard is detected
	if ((BRANCH = '1' or IDEX_MemRead = '1') and 
	 	((IDEX_RegRt = IFID_RegRs) or (IDEX_RegRt = IFID_RegRt)) and
	 	(not (IDEX_RegRt = "00000")))
	 	then
	 		CPU_Stall <= '1';
			IFID_Write <= '0';
			PC_Update <= '0';
	end if;

end process;

END behaviour;