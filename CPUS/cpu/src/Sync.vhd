LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity Sync is
	generic(
		width : integer := 32
		);
	port(
		clk			: in std_logic;
		Rd 			: in std_logic_vector((width-1) downto 0);

		Rd_W 		: out std_logic_vector((width-1) downto 0)
		);
end Sync;

architecture Behavioural of Sync is
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			Rd_W <= Rd;
		end if;
	end process;

end Behavioural;