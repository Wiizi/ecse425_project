LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ForwardUnit IS
	PORT
	(
		Forward0_EX : out std_logic_vector(1 downto 0);
		Forward1_EX : out std_logic_vector(1 downto 0);
		EX_MEM_RegWrite : in std_logic;
		EX_MEM_Rd : std_logic_vector(4 downto 0);
		ID_EX_Rs : std_logic_vector(4 downto 0);
		ID_EX_Rt : std_logic_vector(4 downto 0);
		MEM_WB_RegWrite : in std_logic;
		MEM_WB_Rd : std_logic_vector(4 downto 0)
		
	);
END ForwardUnit;

ARCHITECTURE ARCH OF ForwardUnit IS
BEGIN

Forward: process (EX_MEM_RegWrite,EX_MEM_Rd,ID_EX_Rs,ID_EX_Rt,MEM_WB_RegWrite,MEM_WB_Rd)
begin
	Forward0_EX <= "00";
	Forward1_EX <= "00";
	
	-- EX Hazard
	if(EX_MEM_RegWrite = '1' 
		and(EX_MEM_Rd /= "00000") 
		and (EX_MEM_Rd = IDEX_Rs)) then
			Forward0_EX <= "10";
	end if;
	if(EX_MEM_RegWrite = '1' 
		and(EX_MEM_Rd /= "00000") 
		and (EX_MEM_Rd = ID_EX_Rt)) then
			Forward1_EX <= "10";
	end if;
	
	-- MEM Hazard
	if(     (MEM_WB_RegWrite = '1')
	    and (MEM_WB_Rd /= "00000") 
	    and (not(EX_MEM_RegWrite = '1' and (EX_MEM_Rd /= "00000") and (EX_MEM_Rd = ID_EX_Rs) ))
		  and (MEM_WB_Rd = ID_EX_Rs)) 
		  then
			     Forward0_EX <= "01";
	end if;
	if(MEMWB_RegWrite = '1'
		and(MEMWB_RegRd /= "00000")
		and(not(EXMEM_RegWrite = '1' and (EX_MEM_Rd /= "00000")		and (EX_MEM_Rd = ID_EX_Rt)))
		and (MEM_WB_Rd = ID_EX_Rt)) 
		then
			Forward1_EX <= "01";
	end if;
		
end process;
