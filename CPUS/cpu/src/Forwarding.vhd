--ECSE 425 - Computer Organization and Architecture
--File: Forwarding.vhd
--Author: Wei Wang
--Date: 2016-03-27
--Version 1.0

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity Forwarding is
	port(
		EX_MEM_RegWrite : in std_logic;
		MEM_WB_RegWrite	: in std_logic;
		EX_Rs		: in std_logic_vector(4 downto 0);
		EX_Rt		: in std_logic_vector(4 downto 0);
		MEM_Rd		: in std_logic_vector(4 downto 0);
		WB_Rd		: in std_logic_vector(4 downto 0);

		Forward0_EX 	: out std_logic_vector(1 downto 0) := "00";
		Forward1_EX		: out std_logic_vector(1 downto 0) := "00"
		);
end Forwarding;

architecture Behavioural of Forwarding is

begin

	process(EX_MEM_RegWrite, MEM_WB_RegWrite, EX_Rs, EX_Rt, MEM_Rd, WB_Rd)
	begin

	Forward0_EX <= "00";
	Forward1_EX <= "00";

	if (EX_MEM_RegWrite = '1' and (not(MEM_Rd = "00000"))) then
		if (MEM_Rd = EX_Rs) then
			Forward0_EX <= "01";
		end if;

		if (MEM_Rd = EX_Rt) then
			Forward1_EX <= "01";
		end if;
	end if;

	if (MEM_WB_RegWrite = '1' and (not(WB_Rd = "00000")) and (not(EX_MEM_RegWrite = '1' and (not(MEM_Rd = "00000")) and (MEM_Rd = EX_Rs)))) then
		if (WB_Rd = EX_Rs) then
			Forward0_EX <= "10";
		end if;
	end if;

	if (MEM_WB_RegWrite = '1' and (not(WB_Rd = "00000")) and (not(EX_MEM_RegWrite = '1' and (not(MEM_Rd = "00000")) and (MEM_Rd = EX_Rt)))) then
		if (WB_Rd = EX_Rt) then
			Forward1_EX <= "10";
		end if;
	end if;
	end process;

end Behavioural;
