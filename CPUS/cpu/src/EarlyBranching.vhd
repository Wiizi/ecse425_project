--Date: 2016-04-01
--
-- Description: EarlyBranching.vhd is the forwarding unit responcible for comparing branch data inputs. 
-- Each input required for comparison come from a multiplexer which selects whether the data should come from the execution stage, 
-- the Memory Access stage, or the Writeback stage. This is determined by examining the register Rs, Rt, and Rd to detect Read after Write (RAW) hazards.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity EarlyBranching is
	port(
		Branch 			: in std_logic;
		EX_MEM_RegWrite : in std_logic;
		MEM_WB_RegWrite	: in std_logic;
		ID_Rs			: in std_logic_vector(4 downto 0);
		ID_Rt			: in std_logic_vector(4 downto 0);
		MEM_Rd			: in std_logic_vector(4 downto 0);
		WB_Rd			: in std_logic_vector(4 downto 0);

		Forward0_Branch	: out std_logic_vector(1 downto 0);
		Forward1_Branch	: out std_logic_vector(1 downto 0)
		);
end EarlyBranching;

architecture Behavioural of EarlyBranching is

begin

	process(Branch, EX_MEM_RegWrite, MEM_WB_RegWrite, ID_Rs, ID_Rt, MEM_Rd, WB_Rd)
	begin

	Forward0_Branch <= "00";
	Forward1_Branch <= "00";

	if (Branch = '1') then
		if (EX_MEM_RegWrite = '1' and (MEM_Rd /= "00000") and (MEM_Rd = ID_Rs)) then
			Forward0_Branch <= "01";
		end if;

		if (EX_MEM_RegWrite = '1' and (MEM_Rd /= "00000") and (MEM_Rd = ID_Rt)) then
			Forward1_Branch <= "01";
		end if;

		if (MEM_WB_RegWrite = '1' and (WB_Rd /= "00000") and (not(EX_MEM_RegWrite = '1' and (MEM_Rd /= "00000") and (MEM_Rd = ID_Rs))) and (WB_Rd = ID_Rs)) then
			Forward0_Branch <= "10";
		end if;

		if (MEM_WB_RegWrite = '1' and (WB_Rd /= "00000") and (not(EX_MEM_RegWrite = '1' and (MEM_Rd /= "00000") and (MEM_Rd = ID_Rt))) and (WB_Rd = ID_Rt)) then
			Forward1_Branch <= "10";
		end if;
	end if;

	end process;

end Behavioural;
