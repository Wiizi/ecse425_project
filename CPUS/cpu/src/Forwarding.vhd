--ECSE 425 - Computer Organization and Architecture
--File: Forwarding.vhd
--Author: Wei Wang
--Date: 2016-03-18
--Version 1.0

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity Forwarding is
	port(
		EX_MEM_RegWrite : in std_logic;
		MEM_WB_RegWrite	: in std_logic;
		ID_EX_Rs		: in std_logic_vector(4 downto 0);
		ID_EX_Rt		: in std_logic_vector(4 downto 0);
		EX_MEM_Rd		: in std_logic_vector(4 downto 0);
		MEM_WB_Rd		: in std_logic_vector(4 downto 0);

		Forward0_EX 	: out std_logic_vector(1 downto 0) := "00";
		Forward1_EX		: out std_logic_vector(1 downto 0) := "00"
		);
end Forwarding;

architecture Behavioural of Forwarding is

begin

	process(EX_MEM_RegWrite, MEM_WB_RegWrite, ID_EX_Rs, ID_EX_Rt, EX_MEM_Rd, MEM_WB_Rd)
	begin

	Forward0_EX <= "00";
	Forward1_EX <= "00";

	if ((EX_MEM_RegWrite = '1') and (not(EX_MEM_Rd = "00000"))) then
		if (EX_MEM_Rd = ID_EX_Rs) then
			Forward0_EX <= "01";
		end if;
		if (EX_MEM_Rd = ID_EX_Rt) then
			Forward1_EX <= "01";
		end if;

	elsif ((MEM_WB_RegWrite = '1') and (not(MEM_WB_Rd = "00000"))) then --and (not((EX_MEM_RegWrite = '1') and (not(EX_MEM_Rd = "00000"))))) then
		if ((EX_MEM_Rd = ID_EX_Rs) and (MEM_WB_Rd = ID_EX_Rs)) then
			Forward0_EX <= "10";
		end if;
		if ((EX_MEM_Rd = ID_EX_Rt) and (MEM_WB_Rd = ID_EX_Rt)) then
			Forward1_EX <= "10";
		end if;
	end if;
	end process;

end Behavioural;
