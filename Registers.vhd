LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity Registers is
	port(
		clk : in std_logic;
		regWrite : in std_logic;
		readReg_1 : in std_logic_vector(4 downto 0);
		readReg_2 : in std_logic_vector(4 downto 0);
		writeReg :  in std_logic_vector(4 downto 0);
		writeData : in std_logic_vector(31 downto 0);

		readData_1 : out std_logic_vector(31 downto 0);
		readData_2 : out std_logic_vector(31 downto 0)
		);
end Registers;

architecture Behavioural of Registers is

type reg_mem is array (0 to 31) of std_logic_vector(31 downto 0);
signal regArray : reg_mem := (others => (others => '0'));

begin

	process(clk, regWrite, readReg_1, readReg_2, writeReg, writeData)
	variable addr_1, addr_2, addr_w : integer;
	begin
		addr_1 := TO_INTEGER(UNSIGNED(readReg_1));
		addr_2 := TO_INTEGER(UNSIGNED(readReg_2));
		addr_w := TO_INTEGER(UNSIGNED(writeReg));
		--wait for active clock edge
		if (clk'event and clk = '1') then
			--register 0 is hardwires to 0
			regArray(0) <= x"00000000";

			readData_1 <= regArray(addr_1);
			readData_2 <= regArray(addr_2);
			--check whether write signal is active
			if (regWrite = '1') then
				--write the data
				regArray(addr_w) <= writeData;
			end if;
		end if;
	end process;

end Behavioural;